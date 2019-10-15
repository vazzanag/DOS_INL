using System;
using System.IO;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Linq;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using INL.Services.Models;
using INL.TrainingService.Data;
using INL.TrainingService.Models;

namespace INL.TrainingService.Logic
{
	public class TrainingEventParticipantXLSX : ITrainingEventParticipantXLSX
	{
		private int FirstDataRow = 6;
		private int MaxSequentialEmptyRows = 5;
		private string SheetName = "Training Event Participants";
		private enum Field
		{
			ParticipantStatus,
			FirstMiddleName,
			LastName,
			NationalID,
			Gender,
			IsUSCitizen,
			DOB,
			POBCity,
			POBState,
			POBCountry,
			ResidenceCity,
			ResidenceState,
			ResidenceCountry,
			ContactEmail,
			ContactPhone,
			HighestEducation,
			EnglishLanguageProficiency,
			UnitGenID,
			UnitBreakdown,
			UnitAlias,
			JobTitle,
			Rank,
			IsUnitCommander,
			YearsInPosition,
			PoliceMilSecID,
			POCName,
			POCEmailAddress,
			VettingType,
			HasLocalGovTrust,
			LocalGovTrustCertDate,
			PassedExternalVetting,
			ExternalVettingDescription,
			ExternalVettingDate,
			DepartureCity,
			PassportNumber,
			PassportExpirationDate,
			Comments
		}

		private readonly ITrainingRepository trainingRepository;
		private readonly ILogger log;


		public TrainingEventParticipantXLSX(ITrainingRepository trainingRepository, ILogger log = null)
		{
			this.trainingRepository = trainingRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;
		}


		public List<TrainingEventParticipantXLSX_Item> Save(Stream stream, long trainingEventID, int modifiedByAppUserID)
		{
			try
			{
				var participants = ExtractTrainingEventParticipants(stream);
				var saveTrainingEventParticipantsXLSXEntity = new SaveTrainingEventParticipantsXLSXEntity()
				{
					TrainingEventID = trainingEventID,
					ModifiedByAppUserID = modifiedByAppUserID,
					Participants = JsonConvert.SerializeObject(participants.Select(p => new
					{
						p.ParticipantXLSXID,
						p.EventXLSXID,
						p.TrainingEventID,
						p.PersonID,
						p.ParticipantStatus,
						p.FirstMiddleName,
						p.LastName,
						p.NationalID,
						p.Gender,
						p.IsUSCitizen,
						p.DOB,
						p.POBCity,
						p.POBState,
						p.POBCountry,
						p.ResidenceCity,
						p.ResidenceState,
						p.ResidenceCountry,
						p.ContactEmail,
						p.ContactPhone,
						p.HighestEducation,
						p.EnglishLanguageProficiency,
						p.PassportNumber,
						p.PassportExpirationDate,
						p.JobTitle,
						p.IsUnitCommander,
						p.YearsInPosition,
						p.POCName,
						p.POCEmailAddress,
						p.Rank,
						p.PoliceMilSecID,
						p.VettingType,
						p.HasLocalGovTrust,
						p.LocalGovTrustCertDate,
						p.PassedExternalVetting,
						p.ExternalVettingDescription,
						p.ExternalVettingDate,
						p.DepartureCity,
						p.UnitGenID,
						p.UnitBreakdown,
						p.UnitAlias,
						p.Comments,
						p.ModifiedByAppUserID
					}).ToList())
				};

				var savedTrainingEventParticipantsXLSXEntity = trainingRepository.TrainingEventParticipantsXLSXRepository.Save(saveTrainingEventParticipantsXLSXEntity);
				return JsonConvert.DeserializeObject<List<TrainingEventParticipantXLSX_Item>>(savedTrainingEventParticipantsXLSXEntity.ParticipantJSON);
			}
			catch (Exception ex)
			{
				if (ex.Data.Contains("RowErrors"))
				{
					throw new ServiceException(ex.Message, ex.Data["RowErrors"]);
				}
				else 
				{
					throw;
				}
			}
		}


		private List<TrainingEventParticipantXLSX_Item> ExtractTrainingEventParticipants(Stream stream)
		{
			stream.Position = 0;
			var workbook = new XSSFWorkbook(stream); // This will read 2007 Excel format
			var participants = new List<TrainingEventParticipantXLSX_Item>();
			var sheet = workbook.GetSheet(SheetName);
			var rowErrors = new List<RowError>();
			var sequentialEmptyRowCount = 0;

			for (int i = FirstDataRow; i <= sheet.LastRowNum; i++)
			{
				var row = sheet.GetRow(i);
				if (row == null) continue;

				try
				{
					var participant = ExtractTrainingEventParticipantFromSpreadsheetRow(row);

					// Skip empty rows
					if (participant == null)
					{
						if (sequentialEmptyRowCount++ < MaxSequentialEmptyRows)
							continue;
						else
							break;
					}
					else 
					{
						sequentialEmptyRowCount = 0;
						ValidateTrainingEventParticipantXLSXItem(participant);
					}

					participants.Add(participant);
				}
				catch (Exception ex)
				{
					rowErrors.Add(new RowError() 
						{ 
							RowNumber = i + 1, 
							Errors = ex.Message
						}
					);
				}
			}

			if (rowErrors.Count > 0)
			{
				string exceptionMessage = string.Empty;
				rowErrors.ForEach(r => exceptionMessage += $"{r.RowNumber}: {r.Errors}\n");
				var ex = new Exception(exceptionMessage);
				ex.Data.Add("RowErrors", rowErrors);
				throw ex;
			}

			return participants;
		}


		private TrainingEventParticipantXLSX_Item ExtractTrainingEventParticipantFromSpreadsheetRow(IRow row)
		{
			var errorList = new List<string>();

			TrainingEventParticipantXLSX_Item participantItem = null;
			try
			{
				// Shortcut for empty rows
				if (string.IsNullOrWhiteSpace(GetCellAsString(row, Field.FirstMiddleName)) && string.IsNullOrWhiteSpace(GetCellAsString(row, Field.LastName)))
					return null;

				DateTime dob = DateTime.MinValue;
				DateTime passportExpirationDate = DateTime.MinValue;
				DateTime localGovTrustCertDate = DateTime.MinValue;
				DateTime externalVettingDate = DateTime.MinValue;
				int yearsInPosition = int.MinValue;
				string participantStatus = string.Empty;
				char gender = '\0';

				TextInfo tInfo = new CultureInfo("en-US", false).TextInfo;

				if (!string.IsNullOrWhiteSpace(GetCellAsString(row, Field.DOB)) && !DateTime.TryParse(GetCellAsString(row, Field.DOB), out dob))
				{
					errorList.Add("Date of Birth is not in the correct format.");
				}

				if (!string.IsNullOrWhiteSpace(GetCellAsString(row, Field.PassportExpirationDate)) && !DateTime.TryParse(GetCellAsString(row, Field.PassportExpirationDate), out passportExpirationDate))
				{
					errorList.Add("Passport Expiration Date is not in the correct format.");
				}

				if (!string.IsNullOrWhiteSpace(GetCellAsString(row, Field.LocalGovTrustCertDate)) && !DateTime.TryParse(GetCellAsString(row, Field.LocalGovTrustCertDate), out localGovTrustCertDate))
				{
					errorList.Add("Date of Host Nation Vetting is not in the correct format.");
				}

				if (!string.IsNullOrWhiteSpace(GetCellAsString(row, Field.ExternalVettingDate)) && !DateTime.TryParse(GetCellAsString(row, Field.ExternalVettingDate), out externalVettingDate))
				{
					errorList.Add("Date of Other Vetting is not in the correct format.");
				}

				if (!string.IsNullOrWhiteSpace(GetCellAsString(row, Field.YearsInPosition)) && !int.TryParse(GetCellAsString(row, Field.YearsInPosition), out yearsInPosition))
				{
					errorList.Add("Years in Current Position is not in the correct format.");
				}

				var participantStatusFromSpreadsheet = GetCellAsString(row, Field.ParticipantStatus);
				if (participantStatusFromSpreadsheet?.ToUpper() == "PARTICIPANT")
				{
					participantStatus = "Student";
				}
				else if (participantStatusFromSpreadsheet?.ToUpper() == "ALTERNATE")
				{
					participantStatus = "Alternate";
				}
				else if (participantStatusFromSpreadsheet?.ToUpper() == "INSTRUCTOR")
				{
					participantStatus = "Instructor";
				}

				var genderFromSpreadsheet = GetCellAsString(row, Field.Gender);
				if (genderFromSpreadsheet?.ToUpper() == "MALE")
				{
					gender = 'M';
				}
				else if (genderFromSpreadsheet?.ToUpper() == "FEMALE")
				{
					gender = 'F';
				}

				var vettingType = GetCellAsString(row, Field.VettingType);
				if (("" + vettingType).ToUpper().StartsWith("LEAHY"))
				{
					vettingType = "Leahy";
				}
				else if (("" + vettingType).ToUpper().StartsWith("COURTESY"))
				{
					vettingType = "Courtesy";
				}
				else if (("" + vettingType).ToUpper().StartsWith("NONE"))
				{
					vettingType = "None";
				}
				else
				{
					vettingType = string.Empty;
				}

				participantItem = new TrainingEventParticipantXLSX_Item
				{
					ParticipantStatus = participantStatus,
					FirstMiddleName = tInfo.ToTitleCase(GetCellAsString(row, Field.FirstMiddleName)),
					LastName = tInfo.ToTitleCase(GetCellAsString(row, Field.LastName)),
					NationalID = GetCellAsString(row, Field.NationalID),
					Gender = gender,
					IsUSCitizen = GetCellAsString(row, Field.IsUSCitizen),
					DOB = dob == DateTime.MinValue ? null as DateTime? : dob,
					POBCity = GetCellAsString(row, Field.POBCity),
					POBState = GetCellAsString(row, Field.POBState),
					POBCountry = GetCellAsString(row, Field.POBCountry),
					ResidenceCity = GetCellAsString(row, Field.ResidenceCity),
					ResidenceState = GetCellAsString(row, Field.ResidenceState),
					ResidenceCountry = GetCellAsString(row, Field.ResidenceCountry),
					ContactEmail = GetCellAsString(row, Field.ContactEmail),
					ContactPhone = GetCellAsString(row, Field.ContactPhone),
					HighestEducation = GetCellAsString(row, Field.HighestEducation),
					EnglishLanguageProficiency = GetCellAsString(row, Field.EnglishLanguageProficiency),
					UnitGenID = GetCellAsString(row, Field.UnitGenID),
					UnitBreakdown = GetCellAsString(row, Field.UnitBreakdown),
					UnitAlias = GetCellAsString(row, Field.UnitAlias),
					JobTitle = GetCellAsString(row, Field.JobTitle),
					Rank = GetCellAsString(row, Field.Rank),
					IsUnitCommander = GetCellAsString(row, Field.IsUnitCommander),
					YearsInPosition = yearsInPosition == int.MinValue ? null as int? : yearsInPosition,
					PoliceMilSecID = GetCellAsString(row, Field.PoliceMilSecID),
					POCName = GetCellAsString(row, Field.POCName),
					POCEmailAddress = GetCellAsString(row, Field.POCEmailAddress),
					VettingType = vettingType,
					HasLocalGovTrust = GetCellAsString(row, Field.HasLocalGovTrust),
					LocalGovTrustCertDate = localGovTrustCertDate == DateTime.MinValue ? null as DateTime? : localGovTrustCertDate,
					PassedExternalVetting = GetCellAsString(row, Field.PassedExternalVetting),
					ExternalVettingDescription = GetCellAsString(row, Field.ExternalVettingDescription),
					ExternalVettingDate = externalVettingDate == DateTime.MinValue ? null as DateTime? : externalVettingDate,
					DepartureCity = GetCellAsString(row, Field.DepartureCity),
					Comments = GetCellAsString(row, Field.Comments),
					PassportNumber = GetCellAsString(row, Field.PassportNumber),
					PassportExpirationDate = passportExpirationDate == DateTime.MinValue ? null as DateTime? : passportExpirationDate,
					Validations = "Pending",
					MarkForAction = "Validate"
				};

				// Set State and/or City to "Unknown" if values are null/empty AND Residence Country has a value
				if (!string.IsNullOrEmpty(participantItem.ResidenceCountry))
				{
					if (string.IsNullOrEmpty(participantItem.ResidenceState))
					{
						participantItem.ResidenceState = "Unknown";
					}

					if (string.IsNullOrEmpty(participantItem.ResidenceCity))
					{
						participantItem.ResidenceCity = "Unknown";
					}
				}
			}
			catch (Exception ex)
			{
				errorList.Add(ex.Message);
			}

			// Now is the time to throw an exception if any errors exist
			if (errorList.Count > 0)
			{
				throw new FormatException($"{string.Join("\n", errorList)}");
			}

			return participantItem;
		}


		private string GetCellAsString(IRow row, Field field)
		{
			try
			{
				return row.GetCell((int)field)?.ToString().Trim();
			}
			catch
			{
				throw new Exception($"Failed to read {Enum.GetName(typeof(Field), field)}");
			}
		}


		private void ValidateTrainingEventParticipantXLSXItem(TrainingEventParticipantXLSX_Item participant)
		{
			var errorList = new List<string>();

			if (string.IsNullOrWhiteSpace(participant.ParticipantStatus))
			{
				errorList.Add("Participant status is required.");
			}

			if (string.IsNullOrWhiteSpace(participant.FirstMiddleName))
			{
				errorList.Add("First/Middle name is required.");
			}

			if (string.IsNullOrWhiteSpace(participant.LastName))
			{
				errorList.Add("Last name is required.");
			}

			if (participant.Gender != 'M' && participant.Gender != 'F')
			{
				errorList.Add("Gender is required.");
			}

			if (participant.IsUSCitizen?.ToUpper() != "YES" && participant.IsUSCitizen?.ToUpper() != "NO")
			{
				errorList.Add("Specify if this is a US Citizen.");
			}

			if (participant.IsUSCitizen?.ToUpper() == "NO" && !participant.DOB.HasValue)
			{
				errorList.Add("If person is not a US Citizen, Date of Birth is required.");
			}

			if (string.IsNullOrWhiteSpace(participant.UnitGenID) && string.IsNullOrWhiteSpace(participant.UnitBreakdown) && string.IsNullOrWhiteSpace(participant.UnitAlias))
			{
				errorList.Add("Unit is required.");
			}

			if (string.IsNullOrWhiteSpace(participant.JobTitle))
			{
				errorList.Add("Position is required.");
			}

			if (participant.VettingType?.ToUpper() == "LEAHY")
			{
				if (string.IsNullOrEmpty(participant.NationalID))
				{
					errorList.Add("If person is to be submitted for Leahy Vetting, National ID is required.");
				}

				if (string.IsNullOrEmpty(participant.POBCity))
				{
					errorList.Add("If person is to be submitted for Leahy Vetting, Place of Birth City is required.");
				}

				if (string.IsNullOrEmpty(participant.POBState))
				{
					errorList.Add("If person is to be submitted for Leahy Vetting, Place of Birth State is required.");
				}

				if (string.IsNullOrEmpty(participant.POBCountry))
				{
					errorList.Add("If person is to be submitted for Leahy Vetting, Place of Birth Country is required.");
				}
			}

			// Now is the time to throw an exception if any errors exist
			if (errorList.Count > 0)
			{
				throw new ArgumentException($"{string.Join("\n", errorList)}");
			}
		}


		private class RowError
		{
			public int RowNumber;
			public string Errors;
		}
	}

}
