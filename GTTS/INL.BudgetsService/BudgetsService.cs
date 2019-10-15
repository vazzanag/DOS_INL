using INL.BudgetsService.Data;
using INL.BudgetsService.Models;
using Mapster;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace INL.BudgetsService
{
    public class BudgetsService : IBudgetsService
    {
        private readonly IBudgetsRepository budgetsRepository;

        public BudgetsService(IBudgetsRepository repository)
        {
            this.budgetsRepository = repository;
            if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        public GetBudgetItemTypes_Result GetBudgetItemTypes()
        {
            var repResult = this.budgetsRepository.GetBudgetItemTypes();
            GetBudgetItemTypes_Result result = new GetBudgetItemTypes_Result();
            result.Items = repResult.Adapt<List<BudgetItemType_Item>>();
            return result;
        }

        public GetBudgetItems_Result GetBudgetItemsByTrainingEventID(long trainingEventID)
        {
            var repResult = this.budgetsRepository.GetBudgetItemsByTrainingEventID(trainingEventID);
            GetBudgetItems_Result result = new GetBudgetItems_Result();
            result.Items = repResult.Adapt<List<BudgetItem_Item>>();
            return result;
        }

        public SaveBudgetItems_Result SaveBudgetItems(SaveBudgetItems_Param param)
        {
            var adaptedParam = param.Adapt<SaveBudgetItemsEntity>();
            var result = this.budgetsRepository.SaveBudgetItems(adaptedParam);
            SaveBudgetItems_Result adaptedResult = new SaveBudgetItems_Result();
            adaptedResult.Items = result.Adapt<List<BudgetItem_Item>>();
            return adaptedResult;
        }

        public GetCustomBudgetCategories_Result GetCustomBudgetCategoriesByTrainingEventID(long trainingEventID)
        {
            var repResult = this.budgetsRepository.GetCustomBudgetCategoriesByTrainingEventID(trainingEventID);
            GetCustomBudgetCategories_Result result = new GetCustomBudgetCategories_Result();
            result.Items = repResult.Adapt<List<CustomBudgetCategory_Item>>();
            return result;
        }

        public SaveCustomBudgetCategories_Result SaveCustomBudgetCategories(SaveCustomBudgetCategories_Param param)
        {
            var adaptedParam = param.Adapt<SaveCustomBudgetCategoriesEntity>();
            var result = this.budgetsRepository.SaveCustomBudgetCategories(adaptedParam);
            SaveCustomBudgetCategories_Result adaptedResult = new SaveCustomBudgetCategories_Result();
            adaptedResult.Items = result.Adapt<List<CustomBudgetCategory_Item>>();
            return adaptedResult;
        }

        public GetCustomBudgetItems_Result GetCustomBudgetItemsByTrainingEventID(long trainingEventID)
        {
            var repResult = this.budgetsRepository.GetCustomBudgetItemsByTrainingEventID(trainingEventID);
            GetCustomBudgetItems_Result result = new GetCustomBudgetItems_Result();
            result.Items = repResult.Adapt<List<CustomBudgetItem_Item>>();
            return result;
        }

        public SaveCustomBudgetItems_Result SaveCustomBudgetItems(SaveCustomBudgetItems_Param param)
        {
            var adaptedParam = param.Adapt<SaveCustomBudgetItemsEntity>();
            var result = this.budgetsRepository.SaveCustomBudgetItems(adaptedParam);
            SaveCustomBudgetItems_Result adaptedResult = new SaveCustomBudgetItems_Result();
            adaptedResult.Items = result.Adapt<List<CustomBudgetItem_Item>>();
            return adaptedResult;
        }

        public ExportEstimatedBudgetCalculator_Result ExportEstimatedBudgetCalculator(ExportEstimatedBudgetCalculator_Params parameters, string executionPath)
        {
            using (FileStream file = new FileStream(Path.Combine(executionPath, @"Files\export_budget_calculator_template.xlsx"), FileMode.Open, FileAccess.Read))
            {
                XSSFWorkbook workbook = new XSSFWorkbook(file);
                ISheet sheet = workbook.GetSheetAt(0);
                IRow headerRow = sheet.GetRow(0);
                ICell headerCell = headerRow.GetCell(2);
                headerCell.SetCellValue($"{parameters.TrainingEventName} {parameters.TrainingEventStart.ToShortDateString()} - {parameters.TrainingEventEnd.ToShortDateString()}");
                var model = parameters.EstimatedBudgetModel;
                int currentRowIndex = 1;
                foreach (var category in model.Categories)
                {
                    {
                        currentRowIndex++;
                        IRow categoryHeaderRow = sheet.CreateRow(currentRowIndex);
                        ICell categoryHeaderCell = categoryHeaderRow.CreateCell(1);
                        XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                        style.Alignment = HorizontalAlignment.Center;
                        style.BorderLeft = BorderStyle.Thin;
                        style.BorderTop = BorderStyle.Thin;
                        IFont font = workbook.CreateFont();
                        font.FontHeightInPoints = 11;
                        font.IsBold = true;
                        style.SetFont(font);
                        style.FillPattern = FillPattern.SolidForeground;
                        style.SetFillForegroundColor(new XSSFColor(new byte[] { 153, 204, 255 }));
                        categoryHeaderCell.CellStyle = style;
                        categoryHeaderCell.SetCellValue(category.Name);
                        XSSFCellStyle emptyStyle18 = (XSSFCellStyle)workbook.CreateCellStyle();
                        emptyStyle18.BorderTop = BorderStyle.Thin;
                        ICell emptyCell1 = categoryHeaderRow.CreateCell(2);
                        emptyCell1.CellStyle = emptyStyle18;
                        ICell emptyCell2 = categoryHeaderRow.CreateCell(3);
                        emptyCell2.CellStyle = emptyStyle18;
                        ICell emptyCell3 = categoryHeaderRow.CreateCell(4);
                        emptyCell3.CellStyle = emptyStyle18;
                        ICell emptyCell4 = categoryHeaderRow.CreateCell(5);
                        emptyCell4.CellStyle = emptyStyle18;
                        ICell emptyCell5 = categoryHeaderRow.CreateCell(6);
                        emptyCell5.CellStyle = emptyStyle18;
                        ICell emptyCell6 = categoryHeaderRow.CreateCell(7);
                        emptyCell6.CellStyle = emptyStyle18;
                        ICell emptyCell7 = categoryHeaderRow.CreateCell(8);
                        emptyCell7.CellStyle = emptyStyle18;
                        ICell emptyCellLast = categoryHeaderRow.CreateCell(9);
                        XSSFCellStyle emptyStyleLast = (XSSFCellStyle)workbook.CreateCellStyle();
                        emptyStyleLast.BorderTop = BorderStyle.Thin;
                        emptyStyleLast.BorderRight = BorderStyle.Thin;
                        emptyCellLast.CellStyle = emptyStyleLast;
                        sheet.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(currentRowIndex, currentRowIndex, 1, 9));
                    }
                    {
                        currentRowIndex++;
                        IRow columnHeadersRow = sheet.CreateRow(currentRowIndex);
                        XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                        style.Alignment = HorizontalAlignment.Center;
                        style.FillPattern = FillPattern.SolidForeground;
                        style.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        ICell quantityHeader = columnHeadersRow.CreateCell(1);
                        XSSFCellStyle quantityStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                        quantityStyle.BorderLeft = BorderStyle.Thin;
                        quantityStyle.Alignment = HorizontalAlignment.Center;
                        quantityStyle.FillPattern = FillPattern.SolidForeground;
                        quantityStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        quantityHeader.CellStyle = quantityStyle;
                        quantityHeader.SetCellValue("Qty");
                        ICell descriptionHeader = columnHeadersRow.CreateCell(2);
                        descriptionHeader.CellStyle = style;
                        descriptionHeader.SetCellValue("Description");
                        ICell costHeader = columnHeadersRow.CreateCell(3);
                        costHeader.CellStyle = style;
                        costHeader.SetCellValue("Cost");
                        ICell emptyHeader1 = columnHeadersRow.CreateCell(4);
                        emptyHeader1.CellStyle = style;
                        ICell paxHeader = columnHeadersRow.CreateCell(5);
                        paxHeader.CellStyle = style;
                        paxHeader.SetCellValue("Pax");
                        ICell emptyHeader2 = columnHeadersRow.CreateCell(6);
                        emptyHeader2.CellStyle = style;
                        ICell daysHeader = columnHeadersRow.CreateCell(7);
                        daysHeader.CellStyle = style;
                        daysHeader.SetCellValue("Days");
                        ICell emptyHeader3 = columnHeadersRow.CreateCell(8);
                        emptyHeader3.CellStyle = style;
                        ICell totalHeader = columnHeadersRow.CreateCell(9);
                        XSSFCellStyle totalStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                        totalStyle.BorderRight = BorderStyle.Thin;
                        totalStyle.Alignment = HorizontalAlignment.Center;
                        totalStyle.FillPattern = FillPattern.SolidForeground;
                        totalStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        totalHeader.CellStyle = totalStyle;
                        totalHeader.SetCellValue("Total");
                    }
                    var locations = category.Locations.OrderBy(l => l.Name);
                    foreach (var location in locations)
                    {
                        if (!string.IsNullOrWhiteSpace(location.Name))
                        {
                            currentRowIndex++;
                            IRow locationNameRow = sheet.CreateRow(currentRowIndex);
                            XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                            style.Alignment = HorizontalAlignment.Left;
                            style.BorderLeft = BorderStyle.Thin;
                            style.BorderTop = BorderStyle.None;
                            style.BorderBottom = BorderStyle.None;
                            style.FillPattern = FillPattern.SolidForeground;
                            style.SetFillForegroundColor(new XSSFColor(new byte[] { 242, 242, 242 }));
                            ICell locationNameCell = locationNameRow.CreateCell(1);
                            locationNameCell.CellStyle = style;
                            locationNameCell.SetCellValue(location.Name);
                            XSSFCellStyle emptyStyle18 = (XSSFCellStyle)workbook.CreateCellStyle();
                            emptyStyle18.FillPattern = FillPattern.SolidForeground;
                            emptyStyle18.SetFillForegroundColor(new XSSFColor(new byte[] { 242, 242, 242 }));
                            ICell emptyCell1 = locationNameRow.CreateCell(2);
                            emptyCell1.CellStyle = emptyStyle18;
                            ICell emptyCell2 = locationNameRow.CreateCell(3);
                            emptyCell2.CellStyle = emptyStyle18;
                            ICell emptyCell3 = locationNameRow.CreateCell(4);
                            emptyCell3.CellStyle = emptyStyle18;
                            ICell emptyCell4 = locationNameRow.CreateCell(5);
                            emptyCell4.CellStyle = emptyStyle18;
                            ICell emptyCell5 = locationNameRow.CreateCell(6);
                            emptyCell5.CellStyle = emptyStyle18;
                            ICell emptyCell6 = locationNameRow.CreateCell(7);
                            emptyCell6.CellStyle = emptyStyle18;
                            ICell emptyCell7 = locationNameRow.CreateCell(8);
                            emptyCell7.CellStyle = emptyStyle18;
                            ICell emptyCellLast = locationNameRow.CreateCell(9);
                            XSSFCellStyle emptyStyleLast = (XSSFCellStyle)workbook.CreateCellStyle();
                            emptyStyleLast.BorderRight = BorderStyle.Thin;
                            emptyStyleLast.BorderTop = BorderStyle.None;
                            emptyStyleLast.BorderBottom = BorderStyle.None;
                            emptyStyleLast.FillPattern = FillPattern.SolidForeground;
                            emptyStyleLast.SetFillForegroundColor(new XSSFColor(new byte[] { 242, 242, 242 }));
                            emptyCellLast.CellStyle = emptyStyleLast;
                            sheet.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(currentRowIndex, currentRowIndex, 1, 9));
                        }
                        foreach (var item in location.BudgetItems)
                        {
                            currentRowIndex++;
                            IRow itemRow = sheet.CreateRow(currentRowIndex);
                            XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                            style.Alignment = HorizontalAlignment.Center;
                            ICell quantityCell = itemRow.CreateCell(1);
                            XSSFCellStyle quantityStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                            quantityStyle.Alignment = HorizontalAlignment.Center;
                            quantityStyle.BorderLeft = BorderStyle.Thin;
                            quantityStyle.BorderTop = BorderStyle.None;
                            quantityStyle.BorderBottom = BorderStyle.None;
                            quantityCell.CellStyle = quantityStyle;
                            quantityCell.SetCellValue(item.Quantity ?? 1);
                            ICell descriptionCell = itemRow.CreateCell(2);
                            descriptionCell.CellStyle = style;
                            descriptionCell.SetCellValue(item.Description);
                            ICell costCell = itemRow.CreateCell(3);
                            costCell.CellStyle = style;
                            costCell.SetCellValue(item.Cost.ToString("C"));
                            ICell timesCell1 = itemRow.CreateCell(4);
                            timesCell1.CellStyle = style;
                            timesCell1.SetCellValue("*");
                            ICell paxCell = itemRow.CreateCell(5);
                            paxCell.CellStyle = style;
                            if (item.NumPersons != null)
                                paxCell.SetCellValue(item.NumPersons.Value);
                            ICell timesCell2 = itemRow.CreateCell(6);
                            timesCell2.CellStyle = style;
                            timesCell2.SetCellValue("*");
                            ICell daysCell = itemRow.CreateCell(7);
                            daysCell.CellStyle = style;
                            if (item.NumTimePeriods != null)
                                daysCell.SetCellValue(item.NumTimePeriods.Value);
                            ICell equalsCell = itemRow.CreateCell(8);
                            equalsCell.CellStyle = style;
                            equalsCell.SetCellValue("=");
                            ICell totalCell = itemRow.CreateCell(9);
                            XSSFCellStyle totalStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                            totalStyle.BorderRight = BorderStyle.Thin;
                            totalStyle.Alignment = HorizontalAlignment.Right;
                            totalStyle.BorderTop = BorderStyle.None;
                            totalStyle.BorderBottom = BorderStyle.None;
                            totalCell.CellStyle = totalStyle;
                            totalCell.SetCellValue(item.Total.ToString("C"));
                        }
                    }
                    {
                        currentRowIndex++;
                        IRow totalsRow = sheet.CreateRow(currentRowIndex);
                        XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                        style.FillPattern = FillPattern.SolidForeground;
                        style.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        style.BorderBottom = BorderStyle.Thin;
                        ICell emptyCell1 = totalsRow.CreateCell(1);
                        XSSFCellStyle emptyCell1Style = (XSSFCellStyle)workbook.CreateCellStyle();
                        emptyCell1Style.FillPattern = FillPattern.SolidForeground;
                        emptyCell1Style.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        emptyCell1Style.BorderLeft = BorderStyle.Thin;
                        emptyCell1Style.BorderBottom = BorderStyle.Thin;
                        emptyCell1.CellStyle = emptyCell1Style;
                        ICell emptyCell2 = totalsRow.CreateCell(2);
                        emptyCell2.CellStyle = style;
                        ICell emptyCell3 = totalsRow.CreateCell(3);
                        emptyCell3.CellStyle = style;
                        ICell emptyCell4 = totalsRow.CreateCell(4);
                        emptyCell4.CellStyle = style;
                        IFont font = workbook.CreateFont();
                        font.FontHeightInPoints = 11;
                        font.IsBold = true;
                        ICell totalLabelCell = totalsRow.CreateCell(5);
                        XSSFCellStyle totalLabelStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                        totalLabelStyle.FillPattern = FillPattern.SolidForeground;
                        totalLabelStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        totalLabelStyle.Alignment = HorizontalAlignment.Center;
                        totalLabelStyle.SetFont(font);
                        totalLabelStyle.BorderBottom = BorderStyle.Thin;
                        totalLabelCell.CellStyle = totalLabelStyle;
                        totalLabelCell.SetCellValue("Total (USD)");
                        ICell emptyCell5 = totalsRow.CreateCell(6);
                        emptyCell5.CellStyle = style;
                        ICell emptyCell6 = totalsRow.CreateCell(7);
                        emptyCell6.CellStyle = style;
                        sheet.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(currentRowIndex, currentRowIndex, 5, 7));
                        ICell equalsLabelCell = totalsRow.CreateCell(8);
                        XSSFCellStyle equalsLabelStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                        equalsLabelStyle.FillPattern = FillPattern.SolidForeground;
                        equalsLabelStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        equalsLabelStyle.Alignment = HorizontalAlignment.Center;
                        equalsLabelStyle.SetFont(font);
                        equalsLabelStyle.BorderBottom = BorderStyle.Thin;
                        equalsLabelCell.CellStyle = equalsLabelStyle;
                        equalsLabelCell.SetCellValue("=");
                        ICell totalCell = totalsRow.CreateCell(9);
                        XSSFCellStyle totalStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                        totalStyle.FillPattern = FillPattern.SolidForeground;
                        totalStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                        totalStyle.Alignment = HorizontalAlignment.Right;
                        totalStyle.SetFont(font);
                        totalStyle.BorderRight = BorderStyle.Thin;
                        totalStyle.BorderBottom = BorderStyle.Thin;
                        totalCell.CellStyle = totalStyle;
                        totalCell.SetCellValue(category.Total.ToString("C"));
                    }
                    currentRowIndex++;
                }
                {
                    currentRowIndex++;
                    XSSFCellStyle style = (XSSFCellStyle)workbook.CreateCellStyle();
                    style.Alignment = HorizontalAlignment.Center;
                    XSSFFont font = (XSSFFont)workbook.CreateFont();
                    font.FontHeightInPoints = 11;
                    font.SetColor(new XSSFColor(new byte[] { 255, 0, 0 }));
                    style.SetFont(font);
                    IRow totalsRow = sheet.CreateRow(currentRowIndex);
                    ICell totalLabelCell = totalsRow.CreateCell(3);
                    totalLabelCell.CellStyle = style;
                    totalLabelCell.SetCellValue("Total Estimated Cost (USD)");
                    sheet.AddMergedRegion(new NPOI.SS.Util.CellRangeAddress(currentRowIndex, currentRowIndex, 3, 7));
                    ICell equalsLabelCell = totalsRow.CreateCell(8);
                    equalsLabelCell.CellStyle = style;
                    equalsLabelCell.SetCellValue("=");
                    ICell totalCell = totalsRow.CreateCell(9);
                    XSSFCellStyle totalStyle = (XSSFCellStyle)workbook.CreateCellStyle();
                    totalStyle.Alignment = HorizontalAlignment.Right;
                    XSSFFont totalFont = (XSSFFont)workbook.CreateFont();
                    totalFont.FontHeightInPoints = 11;
                    totalFont.SetColor(new XSSFColor(new byte[] { 255, 0, 0 }));
                    totalFont.IsBold = true;
                    totalStyle.SetFont(totalFont);
                    totalCell.CellStyle = totalStyle;
                    totalCell.SetCellValue(model.Total.ToString("C"));
                }
                sheet.SetActiveCell(0, 0);
                using (MemoryStream memoryStream = new MemoryStream())
                {
                    workbook.Write(memoryStream, false);
                    byte[] content = memoryStream.ToArray();
                    ExportEstimatedBudgetCalculator_Result result = new ExportEstimatedBudgetCalculator_Result();
                    result.FileName = "Budget_Calculator_Export.xlsx";
                    result.FileContent = content;
                    return result;
                }
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
                TypeAdapterConfig<SaveBudgetItems_Param, SaveBudgetItemsEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveBudgetItemsEntity())
                    .IgnoreNullValues(true)
                    .Map(
                        dest => dest.BudgetItemsJson,
                        src => JsonConvert.SerializeObject(
                            src.BudgetItems.Select(i =>
                                new
                                {
                                    BudgetItemID = i.BudgetItemID,
                                    BudgetItemTypeID = i.BudgetItemTypeID,
                                    TrainingEventID = i.TrainingEventID,
                                    LocationID = i.LocationID,
                                    IsIncluded = i.IsIncluded,
                                    Cost = i.Cost,
                                    Quantity = i.Quantity,
                                    PeopleCount = i.PeopleCount,
                                    TimePeriodsCount = i.TimePeriodsCount,
                                    ModifiedByAppUserID = i.ModifiedByAppUserID,
                                    ModifiedDate = i.ModifiedDate
                                }
                            ).ToList()
                        )
                    );
                TypeAdapterConfig<SaveCustomBudgetCategories_Param, SaveCustomBudgetCategoriesEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveCustomBudgetCategoriesEntity())
                    .IgnoreNullValues(true)
                    .Map(
                        dest => dest.CustomBudgetCategoriesJson,
                        src => JsonConvert.SerializeObject(
                            src.CustomBudgetCategories.Select(i =>
                                new
                                {
                                    CustomBudgetCategoryID = i.CustomBudgetCategoryID,
                                    TrainingEventID = i.TrainingEventID,
                                    Name = i.Name,
                                    ModifiedByAppUserID = i.ModifiedByAppUserID,
                                    ModifiedDate = i.ModifiedDate
                                }
                            ).ToList()
                        )
                    );
                TypeAdapterConfig<SaveCustomBudgetItems_Param, SaveCustomBudgetItemsEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveCustomBudgetItemsEntity())
                    .IgnoreNullValues(true)
                    .Map(
                        dest => dest.CustomBudgetItemsJson,
                        src => JsonConvert.SerializeObject(
                            src.CustomBudgetItems.Select(i =>
                                new
                                {
                                    CustomBudgetItemID = i.CustomBudgetItemID,
                                    TrainingEventID = i.TrainingEventID,
                                    LocationID = i.LocationID,
                                    IsIncluded = i.IsIncluded,
                                    BudgetCategoryID = i.BudgetCategoryID,
                                    CustomBudgetCategoryID = i.CustomBudgetCategoryID,
                                    Name = i.Name,
                                    SupportsPeopleCount = i.SupportsPeopleCount,
                                    SupportsQuantity = i.SupportsQuantity,
                                    SupportsTimePeriodsCount = i.SupportsTimePeriodsCount,
                                    Cost = i.Cost,
                                    Quantity = i.Quantity,
                                    PeopleCount = i.PeopleCount,
                                    TimePeriodsCount = i.TimePeriodsCount,
                                    ModifiedByAppUserID = i.ModifiedByAppUserID,
                                    ModifiedDate = i.ModifiedDate
                                }
                            ).ToList()
                        )
                    );
                AreMappingsConfigured = true;
            }
        }
        #endregion
    }
}
