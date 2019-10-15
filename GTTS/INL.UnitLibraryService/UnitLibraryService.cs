using INL.LocationService.Client;
using INL.LocationService.Client.Models;
using INL.PersonService.Client;
using INL.PersonService.Models;
using INL.UnitLibraryService.Data;
using INL.UnitLibraryService.Models;
using INL.VettingService.Models;
using iText.Kernel.Events;
using iText.Kernel.Geom;
using iText.Kernel.Pdf;
using iText.Layout;
using iText.Layout.Element;
using iText.Layout.Properties;
using Mapster;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Text.RegularExpressions;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using INL.Services;
using INL.Services.Utilities;
using iText.Kernel.Pdf.Xobject;
using iText.Kernel.Pdf.Canvas;
using iText.Kernel.Utils;
using NPOIAlias = NPOI.Util;

namespace INL.UnitLibraryService
{
    public class UnitLibraryService : IUnitLibraryService
    {
        private readonly ILogger log;
        private readonly IUnitLibraryRepository unitLibraryRepository;

        public UnitLibraryService(IUnitLibraryRepository unitLibraryRepository, ILogger log = null)
		{
			this.unitLibraryRepository = unitLibraryRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;

			if (!AreMappingsConfigured)
			{
				ConfigureMappings();
			}
		}

        public GetUnitsPaged_Result GetAgenciesPaged(IGetUnitsPaged_Param param)
        {
            // Convert to repo input
            var getAgenciesPagedParam = param.Adapt<IGetUnitsPagedEntity>();

            // Call repo
            var agencies = unitLibraryRepository.GetAgenciesPaged(getAgenciesPagedParam);

            // Convert to result    
            var result = new GetUnitsPaged_Result()
            {
                Collection = agencies.Adapt<List<UnitsViewEntity>, List<IUnit_Item>>()
            };
            return result;
        }

        public GetReportingTypes_Result GetReportingTypes()
        {
            // Call repo
            var items = unitLibraryRepository.GetReportingTypes();

            // Convert to result    
            var result = new GetReportingTypes_Result()
            {
                Items = items.Adapt<List<ReportingType_Item>>()
            };
            return result;
        }

        public GetUnitsPaged_Result GetUnitsPaged(IGetUnitsPaged_Param param)
        {
            // Convert to repo input
            var getAgenciesPagedParam = param.Adapt<IGetUnitsPagedEntity>();

            // Call repo
            var agencies = unitLibraryRepository.GetUnitsPaged(getAgenciesPagedParam);

            // Convert to result
            var result = new GetUnitsPaged_Result()
            {
                Collection = agencies.Adapt<List<UnitsViewEntity>, List<IUnit_Item>>()
            };

            return result;
        }

        public GetUnitsPaged_Result GetChildUnits(long unitID)
        {
            // Call repo
            var units = unitLibraryRepository.GetUnitAndChildren(unitID);

            // Convert to result
            var result = new GetUnitsPaged_Result()
            {
                Collection = units.Adapt<List<UnitsViewEntity>, List<IUnit_Item>>()
            };

            return result;
        }

        public GetNextUnitGenID_Result GetNextUnitGenID(int countryID, long unitID)
        {
            //get unitgenid
            var unitgenid = unitLibraryRepository.GetNextUnitGenID(countryID, unitID);

            //convert to result
            var result = new GetNextUnitGenID_Result();
            result.UnitGenID = unitgenid.UnitGenID;

            return result;
        }

        public GetUnit_Result GetUnit(long UnitID)
        {
            // Call repo
            var unitsViewEntity = unitLibraryRepository.GetUnit(UnitID);

            // Convert to Result
            var result = new GetUnit_Result
            {
                UnitItem = unitsViewEntity.Adapt<IUnitsViewEntity, IUnit_Item>()
            };

            return result;
        }

        public SaveUnit_Result SaveUnit(ISaveUnit_Param param, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient)
        {
			//check if there is existing unit
			if (param.UnitID == null || param.UnitID < 0)
			{
				var matchingUnit = CheckForDuplicateUnit(param.UnitName, param.UnitNameEnglish, param.UnitParentID, param.CountryID, param.UnitGenID);
				if (matchingUnit != null)
				{		
					if (Regex.Replace(matchingUnit.UnitName, @"[^\w\d]", "") == Regex.Replace(param.UnitName, @"[^\w\d]", ""))
					{
						throw new ArgumentException($"Duplicate unit name: {matchingUnit.UnitName}({matchingUnit.UnitGenID})");
					}
					else if (Regex.Replace(matchingUnit.UnitNameEnglish, @"[^\w\d]", "") == Regex.Replace(param.UnitNameEnglish, @"[^\w\d]", ""))
					{
						throw new ArgumentException($"Duplicate unit name: {matchingUnit.UnitNameEnglish} ({matchingUnit.UnitGenID})");
					}
					else if (matchingUnit.UnitGenID == param.UnitGenID)
					{
						throw new ArgumentException($"Duplicate unit ID: {matchingUnit.UnitName} ({matchingUnit.UnitGenID})");
					}
					else if (matchingUnit.UnitGenID == param.UnitGenID)
					{
						throw new ArgumentException($"Duplicate unit: {matchingUnit.UnitName} ({matchingUnit.UnitGenID})");
					}
				}
			}

			// Get Location Information
			if (null != param.UnitLocation && (param.UnitLocation.CityID > 0 || param.UnitLocation.StateID != null || param.UnitLocation.CountryID != null))
			{
				var location = GetLocation(param.UnitLocation, locationServiceClient);

                if (null != location.Result)
                {
                    param.UnitLocationID = location.Result.LocationID;
                    param.HQLocationID = location.Result.LocationID;
                }
                else
                {
                    // throw error
                    throw new NullReferenceException("Location service result is null");
                }
            }

            // Convert to repo input
            var unitParam = param.Adapt<ISaveUnitEntity>();

            if (param.UnitID.HasValue)
            {
                /** UPDATE **/

                // Get Commander Information 
                if (null != param.Commander && !param.Commander.PersonID.HasValue)
                {
                    // Need to add a person
                    var commander = AddPerson(param, personServiceClient);

                    if (null != commander.Result)
                    {
                        unitParam.UnitHeadPersonID = commander.Result.PersonID;
                    }
                }
                else
                {
                    // TODO: Implement update of person when supporting services are ready
                }

                // Call repo
                var unitsViewEntity = unitLibraryRepository.SaveUnit(unitParam);

                // Convert to result
                var result = new SaveUnit_Result
                {
                    UnitItem = unitsViewEntity.Adapt<IUnit_Item>()
                };
                return result;
            }
            else
            {
                /** INSERT **/

                // Call repo
                var unit = unitLibraryRepository.SaveUnit(unitParam);

                // Get Commander Information (must be done after unit save for "Insert" action
                if (null != param.Commander && !param.Commander.PersonID.HasValue)
                {
                    // Capture UnitID for Commander
                    param.Commander.UnitID = unit.UnitID;
                    param.UnitID = unit.UnitID;

                    // Need to add a person
                    var commander = AddPerson(param, personServiceClient);

                    if (null != commander.Result)
                    {
                        param.UnitHeadPersonID = commander.Result.PersonID;
                    }

                    // Convert to repo input
                    var unitParamWithCommander = param.Adapt<ISaveUnitEntity>();

                    // Re-Call repo with commander info
                    var unitWithCommander = unitLibraryRepository.SaveUnit(unitParam);

                    // Convert to result
                    var result = new SaveUnit_Result
                    {
                        UnitItem = unitWithCommander.Adapt<IUnit_Item>()
                    };
                    return result;
                }
                else
                {
                    // Convert to result
                    var result = new SaveUnit_Result
                    {
                        UnitItem = unit.Adapt<IUnit_Item>()
                    };
                    return result;
                }
            }
        }

        public UpdateUnitParent_Result UpdateUnitParent(IUpdateUnitParent_Param param)
        {
            return new UpdateUnitParent_Result { UnitItem = unitLibraryRepository.UpdateUnitParent(param.Adapt<IUpdateUnitParent_Param, UpdateUnitParentEntity>()).Adapt<IUnitsViewEntity, Unit_Item>() };
        }

        public IUpdateUnitActiveFlag_Result UpdateUnitActiveFlag(IUpdateUnitActiveFlag_Param param)
        {
            // Convert param
            var updateUnitActiveFlagEntity = param.Adapt<UpdateUnitActiveFlagEntity>();

            // Call repo
            var unitsViewEntity = unitLibraryRepository.UpdateUnitActiveFlag(updateUnitActiveFlagEntity);

            // Convert to result
            var result = new UpdateUnitActiveFlag_Result
            {
                UnitItem = unitsViewEntity.Adapt<IUnit_Item>()
            };

            return result;
        }

        public IUnit_Item CheckForDuplicateUnit(string unitName, string unitNameEnglish, long? parentID, int countryID, string unitGenID)
        {
            var unitsViewEntity = unitLibraryRepository.CheckForDuplicateUnit(unitName, unitNameEnglish, parentID, countryID, unitGenID);

			if (unitsViewEntity != null && unitsViewEntity.UnitID > 0) {
				return unitsViewEntity.Adapt<IUnit_Item>();
			}
			else {
				return null;
			}
        }

        #region ##generate pdf

        public byte[] GeneratePDF(long unitID, string username)
        {
            var units = unitLibraryRepository.GetUnitAndChildren(unitID).Adapt<List<UnitListNested>>();
            var unitnested = FillRecursive(units, unitID);
            FillUnitNumber(unitnested, "1");

            /* With information retrieved build the PDF */
            var topUnit = units.Find(u => u.UnitID == unitID);

            //local language version
            var ms1 = GetPDFContent(unitnested, topUnit, false, username);

            //english version
            var ms2 = GetPDFContent(unitnested, topUnit, true, username);

            //merge both 
            PdfReader reader1 = new PdfReader(new NPOIAlias.ByteArrayInputStream(ms1));
            PdfDocument doc1 = new PdfDocument(reader1);
            PdfReader reader2 = new PdfReader(new NPOIAlias.ByteArrayInputStream(ms2));
            PdfDocument doc2 = new PdfDocument(reader2);
            MemoryStream ms = new MemoryStream();
            PdfWriter writer = new PdfWriter(ms);
            PdfDocument resultDoc = new PdfDocument(writer);
            doc1.CopyPagesTo(1, doc1.GetNumberOfPages(), resultDoc);
            doc2.CopyPagesTo(1, doc2.GetNumberOfPages(), resultDoc);
            resultDoc.Close();
            doc1.Close();
            doc2.Close();
            return ms.ToArray();
        }

        // convert Unit flat file to hierarchial model
        private static List<UnitListNested> FillRecursive(List<UnitListNested> flatObjects, long parentId)
        {
            List<UnitListNested> recursiveObjects = new List<UnitListNested>();
            foreach (var item in flatObjects.Where(x => x.UnitParentID.Equals(parentId)))
            {
                recursiveObjects.Add(new UnitListNested
                {
                    UnitName = item.UnitName,
                    UnitGenID = item.UnitGenID,
                    UnitNameEnglish = item.UnitNameEnglish,
                    UnitID = item.UnitID,
                    UnitParentID = item.UnitParentID,
                    children = FillRecursive(flatObjects, item.UnitID)
                });
            }
            return recursiveObjects;
        }

        //iText is not able to ordered list, so generated the list number
        private void FillUnitNumber(List<UnitListNested> nestedList, string parentNumber)
        {
            int i = 0;
            foreach (UnitListNested unit in nestedList)
            {
                i++;
                unit.UnitNumber = parentNumber + "." + i.ToString();
                if (unit.children != null && unit.children.Count > 0)
                {
                    FillUnitNumber(unit.children, unit.UnitNumber);
                }
            }
        }

        // Get PDFDocument for English or non ENglish version
        private byte[] GetPDFContent(List<UnitListNested> units, UnitListNested topUnit, bool isEnglish, string username)
        {
            MemoryStream stream = new MemoryStream();
            PdfWriter pdfWriter = new PdfWriter(stream);

            PdfDocument pdfDocument = new PdfDocument(pdfWriter);
            try
            {
                PageNumberFooterHandler footerHandler = new PageNumberFooterHandler(pdfDocument);

                //TO DO:: Change once user service is available

                HeaderHandler handler = new HeaderHandler(pdfDocument);
                handler.AdditionalText = String.Format("Created By: {0} on {1}" , username, DateTime.Now.ToString());
                //pdfDocument.AddEventHandler(PdfDocumentEvent.START_PAGE, footerHandler);
                //PageXofY event = new PageXofY(pdf);
                pdfDocument.AddEventHandler(PdfDocumentEvent.END_PAGE, footerHandler);
                pdfDocument.AddEventHandler(PdfDocumentEvent.END_PAGE, handler);

                Document document = new Document(pdfDocument, PageSize.LETTER, true);

                /* get top level unit */
                List list = new List();
                list.SetListSymbol("\u2025");
                ListItem item1 = new ListItem();
                if (isEnglish)
                {
                    item1.Add(new Paragraph(String.Format("{0} {1} ({2})", 1, topUnit.UnitNameEnglish, topUnit.UnitGenID)));
                }
                else
                {
                    item1.Add(new Paragraph(String.Format("{0} {1} ({2})", 1, topUnit.UnitName, topUnit.UnitGenID)));
                }
                list.Add(item1);
                ListItem item2 = new ListItem();
                item2.Add(CreateTopLevelList(units, false, isEnglish));
                list.Add(item2);
                document.Add(list);
                footerHandler.writeTotal(pdfDocument);
                document.Close();
            }
            catch (Exception de)
            {
                Console.Error.WriteLine(de.Message);
            }
            return stream.ToArray();
        }


        //recursively add listitem for children
        private List CreateTopLevelList(List<UnitListNested> units, bool isIndent, bool isEnglish)
        {
            List list = new List();
            list.SetListSymbol("\u2025");
            if (isIndent)
            {
                list.SetSymbolIndent(20f);
            }
            foreach (UnitListNested unit in units)
            {
                ListItem listItem = new ListItem();
                if (isEnglish)
                {
                    listItem.Add(new Paragraph(String.Format("{0} {1} ({2})", unit.UnitNumber, unit.UnitNameEnglish, unit.UnitGenID)));
                }
                else
                {
                    listItem.Add(new Paragraph(String.Format("{0} {1} ({2})", unit.UnitNumber, unit.UnitName, unit.UnitGenID)));
                }
                if (unit.children != null && unit.children.Count > 0)
                {
                    listItem.Add(CreateTopLevelList(unit.children, true, isEnglish));
                }
                list.Add(listItem);
            }
            return list;
        }

        #endregion
        private async Task<ISavePerson_Result> AddPerson(ISaveUnit_Param saveUnit, IPersonServiceClient personServiceClient)
        {
            SavePerson_Param param = new SavePerson_Param();

            param.FirstMiddleNames = saveUnit.Commander.FirstMiddleNames;
            param.LastNames = saveUnit.Commander.LastNames;
            param.Gender = saveUnit.Commander.Gender;
            param.Languages = new List<IPersonLanguage_Item>();

            param.UnitID = saveUnit.UnitID;
            param.ModifiedByAppUserID = saveUnit.ModifiedByAppUserID;
            param.JobTitle = saveUnit.UnitHeadJobTitle;
            param.RankID = saveUnit.UnitHeadRankID;
            param.IsVettingReq = true;                                                  // Defaulting to true
            param.IsLeahyVettingReq = saveUnit.VettingBatchTypeID == 2 ? true : false;  // 2 is Leahy
            param.IsUSCitizen = saveUnit.CountryID == 2254 ? true : false;              // 2254 is USA

            return await personServiceClient.CreatePerson(param);
        }

        private async Task<IFetchLocationByAddress_Result> GetLocation(SaveUnitLocation_Item location, ILocationServiceClient locationServiceClient)
        {
            FetchLocationByAddress_Param param = new FetchLocationByAddress_Param();
            param.Address1 = location.Address1.Trim();
            param.CityID = location.CityID;
            param.ModifiedByAppUserID = location.ModifiedByAppUserID;
            param.CountryID = location.CountryID;
            param.StateID = location.StateID;

            return await locationServiceClient.FetchLocationByAddress(param);
        }

        public async Task<ImportUnitLibrary_Result> ImportUnitLibrarySpreadsheet(int countryID, int modifiedByAppUserID, byte[] fileData, ILocationServiceClient locationServiceClient, IPersonServiceClient personServiceClient)
        {
            ImportUnitLibrary_Result result = new ImportUnitLibrary_Result();
            result.Items = new List<Unit_Item>();
            try
            {
                using (MemoryStream stream = new MemoryStream(fileData))
                {
                    XSSFWorkbook spreadsheet = new XSSFWorkbook(stream);
                    ISheet agencySheet = spreadsheet.GetSheetAt(0);
                    SpreadsheetUnit agency = await this.GetAgency(agencySheet, countryID, modifiedByAppUserID, locationServiceClient);
                    ISheet unitsSheet = spreadsheet.GetSheetAt(1);
                    SpreadsheetUnit[] units = await this.GetUnits(unitsSheet, countryID, agency.UnitTypeID, agency.GovernmentLevelID, locationServiceClient);
                    this.ThrowIfLocalIDMissmatch(agency.LocalID, units);
                    int genIDNum = 1;
                    // If we made it this far, then the spreadsheet is OK and it's safe to store everything onto the DB
                    {
                        var saveAgency = agency.ToSaveUnitEntity(countryID);
                        saveAgency.IsMainAgency = true;
                        saveAgency.UnitMainAgencyID = saveAgency.UnitParentID;
                        saveAgency.UnitGenID = $"{agency.Acronym}{genIDNum.ToString("D4")}";
                        genIDNum++;
                        saveAgency.HasDutyToInform = false;
                        saveAgency.IsLocked = false;
                        saveAgency.IsActive = true;
                        var savedAgency = await this.SaveUnit(agency, saveAgency, locationServiceClient);
                        agency.ID = savedAgency.UnitID;
                        result.Items.Add(savedAgency);
                    }
                    {
                        int numUnitsToSave = -1;
                        do
                        {
                            int previousNumUnitsToSave = numUnitsToSave;
                            var toSave = units.Where(u => u.ID == null);
                            numUnitsToSave = toSave.Count();
                            if (previousNumUnitsToSave == numUnitsToSave)
                                // We are stuck in the loop for some reason
                                throw new Exception("Unexpected error");
                            foreach (var unit in toSave)
                            {
                                SpreadsheetUnit parent;
                                if (unit.LocalParentID == agency.LocalID)
                                    parent = agency;
                                else
                                    parent = units.Single(u => u.LocalID == unit.LocalParentID);
                                if (parent.ID == null)
                                {
                                    // The parent ha not been saved yet. Skip this unit for now, we'll save it later.
                                    continue;
                                }
                                var saveUnit = unit.ToSaveUnitEntity(countryID);
                                saveUnit.UnitParentID = parent.ID;
                                saveUnit.IsMainAgency = false;
                                saveUnit.UnitMainAgencyID = agency.ID;
                                saveUnit.UnitGenID = $"{agency.Acronym}{genIDNum.ToString("D4")}";
                                genIDNum++;
                                saveUnit.HasDutyToInform = false;
                                saveUnit.IsLocked = false;
                                saveUnit.IsActive = true;
								saveUnit.ModifiedByAppUserID = modifiedByAppUserID;
								var savedUnit = await this.SaveUnit(unit, saveUnit, locationServiceClient);
                                unit.ID = savedUnit.UnitID;
                                result.Items.Add(savedUnit);
                            }
                        } while (numUnitsToSave > 0);
                    }
                }
            }
            catch (ImportException e)
            {
                result.ErrorMessages = new List<string> { e.Message };
            }
            return result;
        }

        private async Task<Unit_Item> SaveUnit(SpreadsheetUnit unit, SaveUnitEntity saveUnit, ILocationServiceClient locationServiceClient)
        {
            if (unit.HeadquartersCityID != null)
            {
                var locationParam = new FetchLocationByAddress_Param()
                {
                    Address1 = unit.HeadquartersStreetAddress1,
                    Address2 = unit.HeadquartersStreetAddress2,
                    Address3 = unit.HeadquartersStreetAddress3,
                    CityID = unit.HeadquartersCityID.Value,
                    ModifiedByAppUserID = saveUnit.ModifiedByAppUserID
				};
                var locationResult = await locationServiceClient.FetchLocationByAddress(locationParam);
                saveUnit.HQLocationID = locationResult.LocationID;
            }
            var saveUnitResult = this.unitLibraryRepository.SaveUnit(saveUnit);
            unit.ID = saveUnitResult.UnitID;
            var result = saveUnitResult.Adapt<Unit_Item>();
            return result;
        }

        private class SpreadsheetUnit
        {
            public long? ID { get; set; }
            public int LocalID { get; set; }
            public long ParentID { get; set; }
            public int? LocalParentID { get; set; }
            public string Name { get; set; }
            public string EnglishName { get; set; }
            public string[] Aliases { get; set; }
            public string Acronym { get; set; }
            public long UnitTypeID { get; set; }
            public int GovernmentLevelID { get; set; }
            public int VettingTypeID { get; set; }
            public int VettingActivityType { get; set; }
            public int? ReportingType { get; set; }
            public string HeadFirstMiddleNames { get; set; }
            public string HeadLastNames { get; set; }
            public string HeadIDNumber { get; set; }
            public char? HeadGender { get; set; }
            public DateTime? HeadDOB { get; set; }
            public string HeadPositionTitle { get; set; }
            public string HeadRank { get; set; }
            public string HeadOtherID { get; set; }
            public int? HeadPobCityID { get; set; }
            public int? HeadResidenceCityID { get; set; }
            public string HeadEmail { get; set; }
            public string HeadPhone { get; set; }
            public int? HeadEducationLevelID { get; set; }
            public int? HeadLanguageProficiencyID { get; set; }
            public string HeadquartersStreetAddress1 { get; set; }
            public string HeadquartersStreetAddress2 { get; set; }
            public string HeadquartersStreetAddress3 { get; set; }
            public int? HeadquartersCityID { get; set; }
			public int ModfiedByAppUserID { get; set; }

            public SaveUnitEntity ToSaveUnitEntity(long postID)
            {
				var result = new SaveUnitEntity()
				{
					UnitParentID = this.ParentID,
					CountryID = (int?)postID,
					UnitName = this.Name,
					UnitNameEnglish = this.EnglishName,
					UnitAcronym = this.Acronym,
					UnitTypeID = (int?)this.UnitTypeID,
					GovtLevelID = this.GovernmentLevelID,
					VettingBatchTypeID = (byte?)this.VettingTypeID,
					VettingActivityTypeID = this.VettingActivityType,
					ReportingTypeID = this.ReportingType,
					UnitHeadJobTitle = this.HeadPositionTitle,
					UnitHeadRank = this.HeadRank,
					UnitHeadFirstMiddleNames = this.HeadFirstMiddleNames,
					UnitHeadLastNames = this.HeadLastNames,
					UnitHeadIDNumber = this.HeadIDNumber,
					UnitHeadGender = this.HeadGender,
					UnitHeadDOB = this.HeadDOB,
					UnitHeadPoliceMilSecID = this.HeadOtherID,
					UnitHeadPOBCityID = this.HeadPobCityID,
					UnitHeadResidenceCityID = this.HeadResidenceCityID,
					UnitHeadContactEmail = this.HeadEmail,
					UnitHeadContactPhone = this.HeadPhone,
					UnitHeadHighestEducationID = this.HeadEducationLevelID,
					UnitHeadEnglishLanguageProficiencyID = this.HeadLanguageProficiencyID,
					ModifiedByAppUserID = this.ModfiedByAppUserID
				};
                result.UnitAliases =
                    JsonConvert.SerializeObject(
                        this.Aliases.Select(a =>
                        new
                        {
                            UnitAlias = a,
                            LanguageID = 61, // TODO: hardcoded for now to english
                            IsDefault = false,
                            IsActive = true,
                            ModifiedByAppUserID = this.ModfiedByAppUserID
                        }));
                return result;
            }
        }

        private async Task<SpreadsheetUnit> GetAgency(ISheet agencySheet, long countryID, int modifiedByAppUserID, ILocationServiceClient locationServiceClient)
        {
            SpreadsheetUnit result = new SpreadsheetUnit();
            {
                IRow row = agencySheet.GetRow(3);
                ICell cell = row.GetCell(2);
                result.LocalID = (int)cell.NumericCellValue;
				result.ModfiedByAppUserID = modifiedByAppUserID;
			}
            {
                IRow row = agencySheet.GetRow(4);
                ICell cell = row.GetCell(2);
                string parentAgencyName = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(parentAgencyName))
                    throw new ImportException("Missing Parent Agency Name");
                var findParentEntity = new FindUnitByNameAndCountryIDEntity()
                {
                    Name = parentAgencyName,
                    CountryID = countryID
                };
                var parentResult = this.unitLibraryRepository.FindUnitByNameAndCountryID(findParentEntity);
                if (parentResult == null)
                    throw new ImportException($"Could not find parent agency name: {parentAgencyName}");
                result.ParentID = parentResult.UnitID;
            }
            {
                IRow row = agencySheet.GetRow(5);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                var findAgencyParam = new FindUnitByNameAndCountryIDEntity()
                {
                    Name = cellValue,
                    CountryID = countryID
                };
                var findAgencyResult = this.unitLibraryRepository.FindUnitByNameAndCountryID(findAgencyParam);
                if (findAgencyResult != null)
                    throw new ImportException($"Agency with name {cellValue} already exists");
                result.Name = cellValue;
            }
            {
                IRow row = agencySheet.GetRow(6);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                result.EnglishName = cellValue;
            }
            {
                IRow row = agencySheet.GetRow(7);
                ICell cell = row.GetCell(2);
                string aliasesValues = cell.StringCellValue ?? string.Empty;
                string[] untrimmedValues = aliasesValues.Split(';');
                List<string> aliasesResult = new List<string>();
                foreach (string untrimmedValue in untrimmedValues)
                {
                    if (!string.IsNullOrWhiteSpace(untrimmedValue))
                        aliasesResult.Add(untrimmedValue.Trim());
                }
                result.Aliases = aliasesResult.ToArray();
            }
            {
                IRow row = agencySheet.GetRow(8);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                result.Acronym = cellValue;

                // Validate that acronym is unique
                var finalAcronym = $"{result.Acronym}{1.ToString("D4")}";
                var findAgencyResult = this.unitLibraryRepository.CheckForDuplicateUnit(result.Name, result.EnglishName, result.ParentID, (int)countryID, finalAcronym); 
                if (findAgencyResult != null)
                    throw new ImportException($"Agency with Acronym {result.Acronym} already exists");
            }
            {
                IRow row = agencySheet.GetRow(9);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                UnitType agencyType;
                if (string.Equals(cellValue, "Academia", StringComparison.CurrentCultureIgnoreCase))
                    agencyType = UnitType.Academia;
                else if (string.Equals(cellValue, "Government", StringComparison.CurrentCultureIgnoreCase))
                    agencyType = UnitType.Government;
                else if (string.Equals(cellValue, "NGO", StringComparison.CurrentCultureIgnoreCase))
                    agencyType = UnitType.NGO;
                else if (string.Equals(cellValue, "Press", StringComparison.CurrentCultureIgnoreCase))
                    agencyType = UnitType.Press;
                else if (string.Equals(cellValue, "Private Sector", StringComparison.CurrentCultureIgnoreCase))
                    agencyType = UnitType.PrivateSector;
                else
                    throw new ImportException($"Invalid agency type: {cellValue}");
                result.UnitTypeID = (int)agencyType;
            }
            {
                IRow row = agencySheet.GetRow(10);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                GovernmentLevel governmentLevel;
                if (string.Equals(cellValue, "Country", StringComparison.CurrentCultureIgnoreCase))
                    governmentLevel = GovernmentLevel.Country;
                else if (string.Equals(cellValue, "Federal", StringComparison.CurrentCultureIgnoreCase))
                    governmentLevel = GovernmentLevel.Federal;
                else if (string.Equals(cellValue, "State", StringComparison.CurrentCultureIgnoreCase))
                    governmentLevel = GovernmentLevel.State;
                else if (string.Equals(cellValue, "City/Municipal", StringComparison.CurrentCultureIgnoreCase))
                    governmentLevel = GovernmentLevel.CityMunicipal;
                else if (string.Equals(cellValue, "N/A", StringComparison.CurrentCultureIgnoreCase))
                    governmentLevel = GovernmentLevel.NA;
                else
                    throw new ImportException($"Invalid government level: {cellValue}");
                result.GovernmentLevelID = (int)governmentLevel;
            }
            {
                IRow row = agencySheet.GetRow(11);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                VettingBatchType vettingBatchType;
                if (string.Equals("Courtesy Vetting - local checks (Political, Consular, DEA, etc.) only", cellValue, StringComparison.InvariantCultureIgnoreCase))
                    vettingBatchType = VettingBatchType.Courtesy;
                else if (string.Equals("Leahy Vetting (includes Courtesy Vetting)", cellValue, StringComparison.InvariantCultureIgnoreCase))
                    vettingBatchType = VettingBatchType.Leahy;
                else if (string.Equals("None", cellValue, StringComparison.InvariantCultureIgnoreCase))
                    vettingBatchType = VettingBatchType.None;
                else
                    throw new ImportException($"Invalid vetting batch type: {cellValue}");
                result.VettingTypeID = (int)vettingBatchType;
            }
            {
                IRow row = agencySheet.GetRow(12);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (string.IsNullOrWhiteSpace(cellValue))
                    throw new ImportException("Agency missing required field");
                VettingActivityType vettingActivityType;
                if (string.Equals(cellValue, "Military", StringComparison.CurrentCultureIgnoreCase))
                    vettingActivityType = VettingActivityType.Military;
                else if (string.Equals(cellValue, "Police", StringComparison.CurrentCultureIgnoreCase))
                    vettingActivityType = VettingActivityType.Police;
                else if (string.Equals(cellValue, "Other", StringComparison.CurrentCultureIgnoreCase))
                    vettingActivityType = VettingActivityType.Other;
                else if (string.Equals(cellValue, "N/A", StringComparison.CurrentCultureIgnoreCase))
                    vettingActivityType = VettingActivityType.NA;
                else
                    throw new ImportException($"Invalid vetting activity type: {cellValue}");
                result.VettingActivityType = (int)vettingActivityType;
            }
            {
                IRow row = agencySheet.GetRow(13);
                ICell cell = row.GetCell(2);
                int? reportingType = null;
                string reportingTypeString = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(reportingTypeString))
                {
                    var reportingTypes = this.GetReportingTypes();
                    var reportingTypeValue = reportingTypes.Items.SingleOrDefault(i => string.Equals(i.Name, reportingTypeString, StringComparison.InvariantCultureIgnoreCase));
                    if (reportingTypeValue != null)
                        reportingType = reportingTypeValue.ReportingTypeID;
                    else
                        throw new ImportException($"Invalid reporting type: {reportingTypeString}");
                }
                result.ReportingType = (int?)reportingType;
            }
            {
                IRow row = agencySheet.GetRow(16);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(cellValue))
                {
                    result.HeadFirstMiddleNames = cellValue;
                }
            }
            {
                IRow row = agencySheet.GetRow(17);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(cellValue))
                    result.HeadLastNames = cellValue;
            }
            {
                IRow row = agencySheet.GetRow(18);
                ICell cell = row.GetCell(2);
                string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(cellValue))
                {
                    result.HeadIDNumber = cellValue;
                }
            }
            {
                IRow row = agencySheet.GetRow(19);
                ICell cell = row.GetCell(2);
                string cellValue = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(cellValue))
                {
                    char? agencyHeadGender = null;
                    if (string.Equals(cellValue, "Male", StringComparison.InvariantCultureIgnoreCase))
                        agencyHeadGender = 'M';
                    else if (string.Equals(cellValue, "Female", StringComparison.InvariantCultureIgnoreCase))
                        agencyHeadGender = 'F';
                    else
                        throw new ImportException($"Invalid gender: {cellValue}");
                    result.HeadGender = agencyHeadGender;
                }
            }
            {
                IRow row = agencySheet.GetRow(20);
                ICell cell = row.GetCell(2);
                DateTime cellValue = cell.DateCellValue;
                if (cellValue != DateTime.MinValue)
                {
                    result.HeadDOB = cellValue;
                }
            }
            {
                IRow row = agencySheet.GetRow(21);
                ICell cell = row.GetCell(2);
                result.HeadPositionTitle = cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(22);
                ICell cell = row.GetCell(2);
                result.HeadRank = cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(23);
                ICell cell = row.GetCell(2);
                result.HeadOtherID = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
            }
            {
                IRow cityRow = agencySheet.GetRow(24);
                ICell cityCell = cityRow.GetCell(2);
                string agencyHeadPobCity = cityCell.StringCellValue;
                IRow stateRow = agencySheet.GetRow(25);
                ICell stateCell = stateRow.GetCell(2);
                string agencyHeadPobState = stateCell.StringCellValue;
                IRow countryRow = agencySheet.GetRow(26);
                ICell countryCell = countryRow.GetCell(2);
                string agencyHeadPobCountry = countryCell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(agencyHeadPobCity) &&
                    !string.IsNullOrWhiteSpace(agencyHeadPobState) &&
                    !string.IsNullOrWhiteSpace(agencyHeadPobCountry))
                {
                    var findParam = new FindCityByCityNameStateNameAndCountryName_Param()
                    {
                        CityName = agencyHeadPobCity,
                        StateName = agencyHeadPobState,
                        CountryName = agencyHeadPobCountry
                    };
                    var cityResult = await locationServiceClient.FindCityByCityNameStateNameAndCountryName(findParam);
                    if (cityResult.Item == null)
                        throw new ImportException($"Could not find city: {agencyHeadPobCity}, {agencyHeadPobState}, {agencyHeadPobCountry}");
                    result.HeadPobCityID = cityResult.Item.CityID;
                }
            }
            {
                IRow cityRow = agencySheet.GetRow(27);
                ICell cityCell = cityRow.GetCell(2);
                string agencyHeadResidenceCity = cityCell.StringCellValue;
                IRow stateRow = agencySheet.GetRow(28);
                ICell stateCell = stateRow.GetCell(2);
                string agencyHeadResidenceState = stateCell.StringCellValue;
                IRow countryRow = agencySheet.GetRow(29);
                ICell countryCell = countryRow.GetCell(2);
                string agencyHeadResidenceCountry = countryCell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(agencyHeadResidenceCity) &&
                    !string.IsNullOrWhiteSpace(agencyHeadResidenceState) &&
                    !string.IsNullOrWhiteSpace(agencyHeadResidenceCountry))
                {
                    var findParam = new FindCityByCityNameStateNameAndCountryName_Param()
                    {
                        CityName = agencyHeadResidenceCity,
                        StateName = agencyHeadResidenceState,
                        CountryName = agencyHeadResidenceCountry
                    };
                    var cityResult = await locationServiceClient.FindCityByCityNameStateNameAndCountryName(findParam);
                    if (cityResult.Item == null)
                        throw new ImportException($"Could not find city: {agencyHeadResidenceCity}, {agencyHeadResidenceState}, {agencyHeadResidenceCountry}");
                    result.HeadResidenceCityID = cityResult.Item.CityID;
                }
            }
            {
                IRow row = agencySheet.GetRow(30);
                ICell cell = row.GetCell(2);
                result.HeadEmail = cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(31);
                ICell cell = row.GetCell(2);
                result.HeadPhone = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(32);
                ICell cell = row.GetCell(2);
                EducationLevel? educationLevel = null;
                string educationLevelString = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(educationLevelString))
                {
                    if (string.Equals(educationLevelString, "Elementary", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.Elementary;
                    else if (string.Equals(educationLevelString, "Middle School", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.MiddleSchool;
                    else if (string.Equals(educationLevelString, "High School", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.HighSchool;
                    else if (string.Equals(educationLevelString, "Technical School", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.TechnicalSchool;
                    else if (string.Equals(educationLevelString, "University", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.University;
                    else if (string.Equals(educationLevelString, "Postgraduate Studies", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.PostgraduateStudies;
                    else if (string.Equals(educationLevelString, "Unknown", StringComparison.InvariantCultureIgnoreCase))
                        educationLevel = EducationLevel.Unknown;
                    else
                        throw new ImportException($"Invalid education level: {educationLevelString}");
                }
                result.HeadEducationLevelID = (int?)educationLevel;
            }
            {
                IRow row = agencySheet.GetRow(33);
                ICell cell = row.GetCell(2);
                EnglishLanguageProficiency? englishLanguageProficiency = null;
                string englishLanguageProficiencyString = cell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(englishLanguageProficiencyString))
                {
                    if (string.Equals(englishLanguageProficiencyString, "Elementary Proficiency", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.ElementaryProficiency;
                    else if (string.Equals(englishLanguageProficiencyString, "Limited Working Proficiency", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.LimitedWorkingProficiency;
                    else if (string.Equals(englishLanguageProficiencyString, "Minimum Professional Proficiency", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.MinimumProfessionalProficiency;
                    else if (string.Equals(englishLanguageProficiencyString, "Full Professional Proficiency", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.FullProfessionalProficiency;
                    else if (string.Equals(englishLanguageProficiencyString, "Native or Bilingual Proficiency", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.NativeOrBilingualProficiency;
                    else if (string.Equals(englishLanguageProficiencyString, "None", StringComparison.InvariantCultureIgnoreCase))
                        englishLanguageProficiency = EnglishLanguageProficiency.None;
                    else
                        throw new ImportException($"Invalid English language proficiency: {englishLanguageProficiencyString}");
                }
                result.HeadLanguageProficiencyID = (int?)englishLanguageProficiency;
            }
            {
                IRow row = agencySheet.GetRow(36);
                ICell cell = row.GetCell(2);
                result.HeadquartersStreetAddress1 = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(37);
                ICell cell = row.GetCell(2);
                result.HeadquartersStreetAddress2 = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
            }
            {
                IRow row = agencySheet.GetRow(38);
                ICell cell = row.GetCell(2);
                result.HeadquartersStreetAddress3 = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
            }
            {
                IRow cityRow = agencySheet.GetRow(39);
                ICell cityCell = cityRow.GetCell(2);
                string agencyHeadQuartersCity = cityCell.StringCellValue;
                IRow stateRow = agencySheet.GetRow(40);
                ICell stateCell = stateRow.GetCell(2);
                string agencyHeadQuartersState = stateCell.StringCellValue;
                if (!string.IsNullOrWhiteSpace(agencyHeadQuartersCity) &&
                    !string.IsNullOrWhiteSpace(agencyHeadQuartersState))
                {
                    var findParam = new FindCityByCityNameStateNameAndCountryID_Param()
                    {
                        CityName = agencyHeadQuartersCity,
                        StateName = agencyHeadQuartersState,
                        CountryID = countryID
                    };
                    var cityResult = await locationServiceClient.FindOrCreateCityByCityNameAndCountryID(findParam);
                    if (cityResult.Item == null)
                        throw new ImportException($"Could not find city: {agencyHeadQuartersCity}, {agencyHeadQuartersState}");
                    result.HeadquartersCityID = cityResult.Item.CityID;
                }
            }
            return result;
        }

        private async Task<SpreadsheetUnit[]> GetUnits(ISheet unitsSheet, long countryID, long unitTypeID, int governmentLevelID, ILocationServiceClient locationServiceClient)
        {
            List<SpreadsheetUnit> result = new List<SpreadsheetUnit>();
            var reportingTypes = this.GetReportingTypes();
            int targetRow = 5;
            while (true)
            {
                targetRow++;
                bool missingRequiredFields = false;
                bool hasFields = false;
                SpreadsheetUnit unit = new SpreadsheetUnit();
                IRow row = unitsSheet.GetRow(targetRow);
                {
                    if (row == null)
                        break;

                    ICell cell = row.GetCell(0);
                    int localID = (int)cell.NumericCellValue;
                    unit.LocalID = localID;
                }
                {
                    ICell cell = row.GetCell(1);
                    int cellValue = (int)cell.NumericCellValue;
                    if (cellValue == 0)
                        missingRequiredFields = true;
                    else
                    {
                        unit.LocalParentID = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(2);
                    string cellValue = cell.StringCellValue;
                    if (string.IsNullOrWhiteSpace(cellValue))
                        missingRequiredFields = true;
                    else
                    {
                        unit.Name = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(3);
                    string cellValue = cell.StringCellValue;
                    if (string.IsNullOrWhiteSpace(cellValue))
                        missingRequiredFields = true;
                    else
                    {
                        unit.EnglishName = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(4);
                    string aliasesValues = cell.StringCellValue ?? string.Empty;
                    if (!string.IsNullOrWhiteSpace(aliasesValues))
                        hasFields = true;
                    string[] untrimmedValues = aliasesValues.Split(';');
                    List<string> aliasesResult = new List<string>();
                    foreach (string untrimmedValue in untrimmedValues)
                    {
                        if (!string.IsNullOrWhiteSpace(untrimmedValue))
                            aliasesResult.Add(untrimmedValue.Trim());
                    }
                    unit.Aliases = aliasesResult.ToArray();
                }
                {
                    unit.UnitTypeID = unitTypeID;
                }
                {
                    unit.GovernmentLevelID = governmentLevelID;
                }
                {
                    ICell cell = row.GetCell(5);
                    string vettingBatchTypeString = cell.StringCellValue;
                    if (string.IsNullOrWhiteSpace(vettingBatchTypeString))
                        missingRequiredFields = true;
                    else
                    {
                        VettingBatchType vettingBatchType;
                        if (string.Equals("Courtesy Vetting - local checks (Political, Consular, DEA, etc.) only", vettingBatchTypeString, StringComparison.InvariantCultureIgnoreCase))
                            vettingBatchType = VettingBatchType.Courtesy;
                        else if (string.Equals("Leahy Vetting (includes Courtesy Vetting)", vettingBatchTypeString, StringComparison.InvariantCultureIgnoreCase))
                            vettingBatchType = VettingBatchType.Leahy;
                        else if (string.Equals("None", vettingBatchTypeString, StringComparison.InvariantCultureIgnoreCase))
                            vettingBatchType = VettingBatchType.None;
                        else
                            throw new ImportException($"Invalid vetting batch type: {vettingBatchTypeString}");
                        unit.VettingTypeID = (int)vettingBatchType;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(6);
                    string vettingActivityTypeString = cell.StringCellValue;
                    if (string.IsNullOrWhiteSpace(vettingActivityTypeString))
                        missingRequiredFields = true;
                    else
                    {
                        VettingActivityType vettingActivityType;
                        if (string.Equals(vettingActivityTypeString, "Military", StringComparison.CurrentCultureIgnoreCase))
                            vettingActivityType = VettingActivityType.Military;
                        else if (string.Equals(vettingActivityTypeString, "Police", StringComparison.CurrentCultureIgnoreCase))
                            vettingActivityType = VettingActivityType.Police;
                        else if (string.Equals(vettingActivityTypeString, "Other", StringComparison.CurrentCultureIgnoreCase))
                            vettingActivityType = VettingActivityType.Other;
                        else if (string.Equals(vettingActivityTypeString, "N/A", StringComparison.CurrentCultureIgnoreCase))
                            vettingActivityType = VettingActivityType.NA;
                        else
                            throw new ImportException($"Invalid vetting activity type: {vettingActivityTypeString}");
                        unit.VettingActivityType = (int)vettingActivityType;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(7);
                    string reportingTypeString = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(reportingTypeString))
                    {
                        int reportingType;
                        var reportingTypeValue = reportingTypes.Items.SingleOrDefault(i => string.Equals(i.Name, reportingTypeString, StringComparison.InvariantCultureIgnoreCase));
                        if (reportingTypeValue != null)
                            reportingType = reportingTypeValue.ReportingTypeID;
                        else
                            throw new ImportException($"Invalid reporting type: {reportingTypeString}");
                        unit.ReportingType = reportingType;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(8);
                    string cellValue = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadFirstMiddleNames = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(9);
                    string cellValue = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadLastNames = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(10);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadIDNumber = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(11);
                    string gender = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(gender))
                    {
                        char? agencyHeadGender = null;
                        if (string.Equals(gender, "Male", StringComparison.InvariantCultureIgnoreCase))
                            agencyHeadGender = 'M';
                        else if (string.Equals(gender, "Female", StringComparison.InvariantCultureIgnoreCase))
                            agencyHeadGender = 'F';
                        else
                            throw new ImportException($"Invalid gender: {gender}");
                        unit.HeadGender = agencyHeadGender;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(12);
                    DateTime dob = cell.DateCellValue;
                    if (dob != DateTime.MinValue)
                    {
                        unit.HeadDOB = dob;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(13);
                    string cellValue = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadPositionTitle = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(14);
                    string cellValue = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadRank = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(15);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadOtherID = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cityCell = row.GetCell(16);
                    string agencyHeadPobCity = cityCell.StringCellValue;
                    ICell stateCell = row.GetCell(17);
                    string agencyHeadPobState = stateCell.StringCellValue;
                    ICell countryCell = row.GetCell(18);
                    string agencyHeadPobCountry = countryCell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(agencyHeadPobCity) &&
                        !string.IsNullOrWhiteSpace(agencyHeadPobState) &&
                        !string.IsNullOrWhiteSpace(agencyHeadPobCountry))
                    {
                        var findParam = new FindCityByCityNameStateNameAndCountryName_Param()
                        {
                            CityName = agencyHeadPobCity,
                            StateName = agencyHeadPobState,
                            CountryName = agencyHeadPobCountry
                        };
                        var cityResult = await locationServiceClient.FindCityByCityNameStateNameAndCountryName(findParam);
                        if (cityResult.Item == null)
                            throw new ImportException($"Could not find city: {agencyHeadPobCity}, {agencyHeadPobState}, {agencyHeadPobCountry}");
                        unit.HeadPobCityID = cityResult.Item.CityID;
                        hasFields = true;
                    }

                }
                {
                    ICell cityCell = row.GetCell(19);
                    string agencyHeadResidenceCity = cityCell.StringCellValue;
                    ICell stateCell = row.GetCell(20);
                    string agencyHeadResidenceState = stateCell.StringCellValue;
                    ICell countryCell = row.GetCell(21);
                    string agencyHeadResidenceCountry = countryCell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(agencyHeadResidenceCity) &&
                        !string.IsNullOrWhiteSpace(agencyHeadResidenceState) &&
                        !string.IsNullOrWhiteSpace(agencyHeadResidenceCountry))
                    {
                        var findParam = new FindCityByCityNameStateNameAndCountryName_Param()
                        {
                            CityName = agencyHeadResidenceCity,
                            StateName = agencyHeadResidenceState,
                            CountryName = agencyHeadResidenceCountry
                        };
                        var cityResult = await locationServiceClient.FindCityByCityNameStateNameAndCountryName(findParam);
                        if (cityResult.Item == null)
                            throw new ImportException($"Could not find city: {agencyHeadResidenceCity}, {agencyHeadResidenceState}, {agencyHeadResidenceCountry}");
                        unit.HeadResidenceCityID = cityResult.Item.CityID;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(22);
                    string cellValue = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadEmail = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(23);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadPhone = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(24);
                    string educationLevelString = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(educationLevelString))
                    {
                        EducationLevel educationLevel;
                        if (string.Equals(educationLevelString, "Elementary", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.Elementary;
                        else if (string.Equals(educationLevelString, "Middle School", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.MiddleSchool;
                        else if (string.Equals(educationLevelString, "High School", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.HighSchool;
                        else if (string.Equals(educationLevelString, "Technical School", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.TechnicalSchool;
                        else if (string.Equals(educationLevelString, "University", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.University;
                        else if (string.Equals(educationLevelString, "Postgraduate Studies", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.PostgraduateStudies;
                        else if (string.Equals(educationLevelString, "Unknown", StringComparison.InvariantCultureIgnoreCase))
                            educationLevel = EducationLevel.Unknown;
                        else
                            throw new ImportException($"Invalid education level: {educationLevelString}");
                        unit.HeadEducationLevelID = (int)educationLevel;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(25);
                    string englishLanguageProficiencyString = cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(englishLanguageProficiencyString))
                    {
                        EnglishLanguageProficiency englishLanguageProficiency;
                        if (string.Equals(englishLanguageProficiencyString, "Elementary Proficiency", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.ElementaryProficiency;
                        else if (string.Equals(englishLanguageProficiencyString, "Limited Working Proficiency", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.LimitedWorkingProficiency;
                        else if (string.Equals(englishLanguageProficiencyString, "Minimum Professional Proficiency", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.MinimumProfessionalProficiency;
                        else if (string.Equals(englishLanguageProficiencyString, "Full Professional Proficiency", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.FullProfessionalProficiency;
                        else if (string.Equals(englishLanguageProficiencyString, "Native or Bilingual Proficiency", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.NativeOrBilingualProficiency;
                        else if (string.Equals(englishLanguageProficiencyString, "None", StringComparison.InvariantCultureIgnoreCase))
                            englishLanguageProficiency = EnglishLanguageProficiency.None;
                        else
                            throw new ImportException($"Invalid English language proficiency: {englishLanguageProficiencyString}");
                        unit.HeadLanguageProficiencyID = (int)englishLanguageProficiency;
                    }
                }
                {
                    ICell cell = row.GetCell(26);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadquartersStreetAddress1 = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(27);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadquartersStreetAddress2 = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cell = row.GetCell(28);
                    string cellValue = cell.CellType == CellType.Numeric ? cell.NumericCellValue.ToString() : cell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(cellValue))
                    {
                        unit.HeadquartersStreetAddress3 = cellValue;
                        hasFields = true;
                    }
                }
                {
                    ICell cityCell = row.GetCell(29);
                    string agencyHeadQuartersCity = cityCell.StringCellValue;
                    ICell stateCell = row.GetCell(30);
                    string agencyHeadQuartersState = stateCell.StringCellValue;
                    if (!string.IsNullOrWhiteSpace(agencyHeadQuartersCity) &&
                        !string.IsNullOrWhiteSpace(agencyHeadQuartersState))
                    {
                        var findParam = new FindCityByCityNameStateNameAndCountryID_Param()
                        {
                            CityName = agencyHeadQuartersCity,
                            StateName = agencyHeadQuartersState,
                            CountryID = countryID
                        };
                        var cityResult = await locationServiceClient.FindOrCreateCityByCityNameAndCountryID(findParam);
                        if (cityResult.Item == null)
                            throw new ImportException($"Could not find city: {agencyHeadQuartersCity}, {agencyHeadQuartersState}");
                        unit.HeadquartersCityID = cityResult.Item.CityID;
                        hasFields = true;
                    }

                }
                if (hasFields && missingRequiredFields)
                    throw new ImportException($"Row {targetRow + 1} in Units Sheet is missing Required fields");
                if (!hasFields)
                    break;
                result.Add(unit);
            }
            return result.ToArray();
        }

        private void ThrowIfLocalIDMissmatch(int localAgencyID, SpreadsheetUnit[] units)
        {
            foreach (var unit in units)
            {
                bool agencyIsParent = unit.LocalParentID == localAgencyID;
                if (!agencyIsParent)
                {
                    var found = units.Where(u => u.LocalID == unit.LocalParentID && u != unit);
                    int numParentsFound = found.Count();
                    if (numParentsFound == 0)
                        throw new ImportException($"Cannot set Parent Unit ID to {unit.LocalParentID} because there's no unit or agency with that ID.");
                    if (numParentsFound > 1)
                        throw new ImportException($"Cannot set Parent Unit ID to {unit.LocalParentID} because there's multiple units with that ID.");
                    // Check for circular references
                    var parent = found.Single();
                    while (parent != null)
                    {
                        if (parent.LocalParentID == unit.LocalID)
                            throw new ImportException("Some units have a circular reference to each other as parents");
                        if (parent.LocalParentID == localAgencyID)
                            parent = null;
                        else
                        {
                            var nextParentsFound = units.Where(u => u.LocalID == parent.LocalParentID && u != parent);
                            int numNextParentsFound = nextParentsFound.Count();
                            if (numNextParentsFound == 0)
                                throw new ImportException($"Cannot set Parent Unit ID to {parent.LocalParentID} because there's no unit or agency with that ID.");
                            if (numNextParentsFound > 1)
                                throw new ImportException($"Cannot set Parent Unit ID to {parent.LocalParentID} because there's multiple units with that ID.");
                            parent = nextParentsFound.Single();
                        }
                    }
                }
            }
        }

        private class ImportException : Exception
        {
            public ImportException(string message) : base(message)
            {
            }
        }

        #region ### Mapping Configuration (Mapster)

        private static bool AreMappingsConfigured { get; set; }
        private static object MappingConfigurationLock = new { };
        private static void ConfigureMappings()
        {
            var deserializationSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };

            lock (MappingConfigurationLock)
            {
                TypeAdapterConfig<IGetUnitsPaged_Param, IGetUnitsPagedEntity>
                    .NewConfig()
                    .ConstructUsing(s => new GetUnitsPagedEntity());

                TypeAdapterConfig<ISaveUnit_Param, ISaveUnitEntity>
                    .NewConfig()
                    .ConstructUsing(s => new SaveUnitEntity())
                    .Map(
                        dest => dest.UnitAliases,
                        src => JsonConvert.SerializeObject(
                            src.UnitAlias.Select(u =>
                                new
                                {
                                    UnitID = u.UnitID,
                                    UnitAliasID = u.UnitAliasID,
                                    UnitAlias = u.UnitAlias,
                                    LanguageID = u.LanguageID,
                                    IsDefault = u.IsDefault,
                                    IsActive = u.IsActive,
                                    ModifiedByAppUserID = u.ModifiedByAppUserID
                                }
                            ).ToList()
                        )
                    );

                TypeAdapterConfig<IUnitsViewEntity, IUnit_Item>
                    .NewConfig()
                    .ConstructUsing(s => new Unit_Item())
                    .Map(
                        dest => dest.UnitAlias,
                        src => string.IsNullOrEmpty(src.UnitAliasJson)
                                ? null
                                : JsonConvert.DeserializeObject(("" + src.UnitAliasJson), typeof(List<GetUnitAlias_Item>), deserializationSettings)
                        );
                    //.Map(
                    //    dest => dest.UnitLocation,
                    //    src => string.IsNullOrEmpty(src.LocationJson)
                    //            ? null
                    //            : JsonConvert.DeserializeObject(("" + src.LocationJson.Replace("[", "").Replace("]", "")), typeof(GetUnitLocation_Item), deserializationSettings)
                    //    )
                    //.Map(
                    //    dest => dest.HQLocation,
                    //    src => string.IsNullOrEmpty(src.HQLocationJson)
                    //            ? null
                    //            : JsonConvert.DeserializeObject(("" + src.HQLocationJson.Replace("[", "").Replace("]", "")), typeof(GetUnitLocation_Item), deserializationSettings)
                    //    )
                    //.Map(
                    //    dest => dest.Commander,
                    //    src => string.IsNullOrEmpty(src.CommanderJson)
                    //            ? null
                    //            : JsonConvert.DeserializeObject(("" + src.CommanderJson.Replace("[", "").Replace("]", "")), typeof(GetUnitCommander_Item), deserializationSettings)
                    //    );
                TypeAdapterConfig<Unit_Item, UnitListNested>
                    .NewConfig()
                    .ConstructUsing(s => new UnitListNested());
            }

            AreMappingsConfigured = true;
        }

        #endregion
    }
}
