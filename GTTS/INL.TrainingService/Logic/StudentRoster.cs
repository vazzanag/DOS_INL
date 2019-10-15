using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Mapster;
using Newtonsoft.Json;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using NPOI.SS.Util;
using INL.TrainingService.Models;
using INL.TrainingService.Data;
using INL.ReferenceService.Models;

namespace INL.TrainingService.Logic
{
    public class StudentRoster : IStudentRoster
    {
        #region ### Local Variables
        private long TrainingEventID;
        private XSSFWorkbook Workbook;
        private XSSFSheet Settings;
        private XSSFSheet Roster;
        private XSSFSheet AttendanceList;

        private XSSFCellStyle _DefaultStyle;
        private XSSFCellStyle _TableHeaderStyle;
        private XSSFCellStyle _PageHeaderStyle;
        private XSSFCellStyle _RowStyleGray;
        private XSSFCellStyle _RowStyleRed;
        private XSSFCellStyle _RowStyleBlue;
        private XSSFCellStyle _RowStyleLightBlue;
        private XSSFCellStyle _UnderlineStyle;
        private XSSFCellStyle _BoldStsyle;
        private XSSFCellStyle _PercentageStyle;
        private XSSFCellStyle _AltPercentageStyle;
        private XSSFCellStyle _InstructionsStyle;
        private XSSFCellStyle _WeightValuesStyle;

        private XSSFCellStyle _BorderTopLeft;
        private XSSFCellStyle _BorderTopRight;
        private XSSFCellStyle _BorderBottomLeft;
        private XSSFCellStyle _BorderBottomRight;
        private XSSFCellStyle _BorderLeft;
        private XSSFCellStyle _BorderRight;

        private XSSFFont _DefaultFont;
        private XSSFFont _TableHeaderFont;
        private XSSFFont _StudentFont;
        private XSSFFont _PageHeaderFont;
        private XSSFFont _UnderlineFont;
        private XSSFFont _BoldFont;
        private XSSFFont _InstructionsFont;
        private XSSFFont _WeightValuesFont;

        private XSSFDataFormat _DataFormat;

        private List<dynamic> _TrainingEventRosterDistinctions;
        private List<dynamic> _NonAttencanceCauses;
        private List<dynamic> _NonAttendanceReasons;

        private DateTime ModifiedDate;
        private int Columns;
        private int Rows;
        private int DateDiff;
        private const string FONT_NAME = "Calibri";

        private readonly ITrainingRepository trainingRepository;
        private readonly List<ReferenceTables_Item> referenceTables;
        #endregion

        /// <summary>
        /// Instantiates a <see cref="StudentRoster"/> object
        /// </summary>
        /// <param name="trainingEventID">Training event ID for which the roster will be created</param>
        public StudentRoster(long trainingEventID, params object[] injects)
        {
            TrainingEventID = trainingEventID;
            ModifiedDate = System.DateTime.UtcNow;
            ErrorMessages = new List<string>();
            
            if (injects != null)
            {
                for (var i = 0; i < injects.Length; i++)
                {
                    if (injects[i] is ITrainingRepository) trainingRepository = injects[i] as ITrainingRepository;
                    if (injects[i] is List<ReferenceTables_Item>) referenceTables = injects[i] as List<ReferenceTables_Item>;
                }
            }

            if (!AreMappingsConfigured)
            {
                ConfigureMappings();
            }
        }

        /// <summary>
        /// Generates a Participant Performance Roster shreadsheet
        /// </summary>
        /// <param name="courseDefinitions"><see cref="IGetTrainingEventCourseDefinition_Result"/> containing weights for training event</param>
        /// <param name="trainingEvent"><see cref="GetTrainingEvent_Result"/> containing training event information</param>
        /// <param name="participants"><see cref="List{T}"/> of <see cref="GetTrainingEventParticipant_Item"/> containing participant information for the roster</param>
        /// <param name="references"><see cref="List{T}"/> of <see cref="ReferenceTables_Item"/> containing reference/lookup data used in the roster</param>
        /// <returns><see cref="byte[]"/> of spreadsheet</returns>
        public byte[] Generate(IGetTrainingEventCourseDefinition_Result courseDefinitions, IGetTrainingEvent_Item trainingEvent, 
                                        List<GetTrainingEventParticipant_Item> participants, List<ReferenceTables_Item> references,
                                        IGetTrainingEventRosterInGroups_Result rosterData)
        {
            // Instantiate workbook and worksheet variables
            Workbook = new XSSFWorkbook();
            Settings = (XSSFSheet)Workbook.CreateSheet("Settings");
            Roster = (XSSFSheet)Workbook.CreateSheet("Roster");
            AttendanceList = (XSSFSheet)Workbook.CreateSheet("Attendance List");

            // Verify course definition data
            if (null == courseDefinitions.CourseDefinitionItem)
                throw new ArgumentNullException("CourseDefinition", "Course definition not found");

            // Verify training event data
            if (null == trainingEvent)
                throw new ArgumentNullException("TrainingEvent", "Training event not found");

            // Verify participant data
            if (null == participants || participants.Count == 0)
                throw new ArgumentException("Participants", "Training event has no participants");

            // Verify training event dates
            if (!trainingEvent.EventStartDate.HasValue || !trainingEvent.EventEndDate.HasValue)
                throw new ArgumentException("Event Start and End dates", "Event start or end dates are invalid");

            // Build single list of roster data
            List<GetTrainingEventRoster_Item> rosters = new List<GetTrainingEventRoster_Item>();
            if (null != rosterData.RosterGroups)
            {
                foreach (IGetTrainingEventRosterGroups_Item group in rosterData.RosterGroups)
                    rosters.AddRange(group.Rosters);
            }

            // Set global variables
            DateDiff = (int)(trainingEvent.EventEndDate.Value - trainingEvent.EventStartDate.Value).TotalDays + 1;
            Columns = 3 + DateDiff;
            Rows = 6 + participants.Count;

            // Set active sheet and hide "Settings" sheet
            Workbook.SetActiveSheet(1);
            Workbook.SetSheetHidden(0, SheetState.VeryHidden);

            // Populate sheets
            PopulateSettingsSheet(trainingEvent, courseDefinitions.CourseDefinitionItem);
            PopulateAttendanceSheeet(trainingEvent, courseDefinitions.CourseDefinitionItem, participants, references, rosters);
            PopulateRosterSheet(trainingEvent, courseDefinitions.CourseDefinitionItem, participants, references, rosters);

            // Prepare result
            byte[] buffer = new byte[0];
            using (var stream = new System.IO.MemoryStream())
            {
                Workbook.Write(stream);
                buffer = stream.ToArray();
            }

            return buffer;
        }

        private void PopulateAttendanceSheeet(IGetTrainingEvent_Item trainingEvent, ITrainingEventCourseDefinitions_Item courseDefinition, 
                                        List<GetTrainingEventParticipant_Item> participants, List<ReferenceTables_Item> references,
                                        List<GetTrainingEventRoster_Item> rosters)
        {
            if (!trainingEvent.EventStartDate.HasValue || !trainingEvent.EventEndDate.HasValue)
                throw new ArgumentException("Event start or end dates are invalid");

            AttendanceList.DefaultRowHeight = 300;

            // Attendance particiipant list header row
            AttendanceList.CreateRow(6);
            AttendanceList.GetRow(6).CreateCell(0).SetCellValue("STUDENT ID");
            AttendanceList.GetRow(6).GetCell(0).CellStyle = TableHeaderStyle;
            AttendanceList.GetRow(6).CreateCell(1).SetCellValue("STUDENT NAME");
            AttendanceList.GetRow(6).GetCell(1).CellStyle = TableHeaderStyle;

            for (int i = 0; i < DateDiff; i++)
            {
                AttendanceList.GetRow(6).CreateCell(i + 2).SetCellValue(string.Format("{0:dd-MMM}", trainingEvent.EventStartDate.Value.AddDays(i)));
                AttendanceList.GetRow(6).GetCell(i + 2).CellStyle = TableHeaderStyle;
            }

            AttendanceList.GetRow(6).CreateCell(Columns - 1).SetCellValue("NON-ATTENDANCE REASON");
            AttendanceList.GetRow(6).GetCell(Columns - 1).CellStyle = TableHeaderStyle;
            AttendanceList.GetRow(6).CreateCell(Columns).SetCellValue("NON-ATTENDANCE CAUSE");
            AttendanceList.GetRow(6).GetCell(Columns).CellStyle = TableHeaderStyle;

            // Attendance participants list 
            string[] attendanceValues = new string[] { "A", "P" };
            var validationRange = new CellRangeAddressList(7, Rows, 2, Columns - 2);
            XSSFDataValidationHelper helper = new XSSFDataValidationHelper((XSSFSheet)AttendanceList);
            var dvConstraint = (XSSFDataValidationConstraint)helper.CreateExplicitListConstraint(attendanceValues);
            var validator = (XSSFDataValidation)helper.CreateValidation(dvConstraint, validationRange);
            validator.CreateErrorBox("Invalid Value", "Value must be either \"P\" for present or \"A\" for absent");
            validator.ShowErrorBox = true;
            validator.ErrorStyle = ERRORSTYLE.STOP;
            AttendanceList.AddValidationData(validator);

            int rowIndex = 7;
            foreach (GetTrainingEventParticipant_Item participant in participants)
            {
                var roster = rosters.FirstOrDefault(r => r.PersonID == participant.PersonID);
                AttendanceList.CreateRow(rowIndex);
                AttendanceList.GetRow(rowIndex).CreateCell(0).SetCellValue(participant.PersonID);
                AttendanceList.GetRow(rowIndex).GetCell(0).CellStyle = RowStyleGray;
                AttendanceList.GetRow(rowIndex).CreateCell(1).SetCellValue(GetParticipantName(participant));
                AttendanceList.GetRow(rowIndex).GetCell(1).CellStyle = RowStyleGray;

                //for (int i = 0; i < DateDiff; i++)
                //{
                //    var attendance = roster.Attendance.FirstOrDefault(a => a.AttendanceDate == trainingEvent.EventStartDate.Value.AddDays(i));
                //    AttendanceList.GetRow(rowIndex).CreateCell(i);
                //    AttendanceList.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                //}

                if (null != roster)
                    System.Diagnostics.Debug.WriteLine(string.Format("roster: {0} {1}", roster.FirstMiddleNames, roster.LastNames));

                for (int i = 2; i < Columns + 1; i++)
                {
                    AttendanceList.GetRow(rowIndex).CreateCell(i);
                    AttendanceList.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);

                    if (null != roster && null != roster.Attendance)
                    {
                        var attendance = roster.Attendance.FirstOrDefault(a => a.AttendanceDate == trainingEvent.EventStartDate.Value.AddDays(i - 2));
                        if (null != attendance)
                            AttendanceList.GetRow(rowIndex).GetCell(i).SetCellValue(string.Format("{0}", attendance.AttendanceIndicator ? "A" : "P"));
                    }
                }

                rowIndex++;
            }
            AttendanceList.AutoSizeColumn(0);
            AttendanceList.AutoSizeColumn(1);
            AttendanceList.AutoSizeColumn(Columns - 1);
            AttendanceList.AutoSizeColumn(Columns);
            

            // Non-Attendance Reasons
            if (references.Exists(r => r.Reference == "NonAttendanceReasons"))
            {
                // Get reference table
                var reasonsData = references.Find(r => r.Reference == "NonAttendanceReasons");
                List<dynamic> reasons = JsonConvert.DeserializeObject<List<dynamic>>(reasonsData.ReferenceData);

                // Populate values array
                string[] reasonsValues = new string[reasons.Count];
                for (int i = 0; i < reasons.Count; i++)
                    reasonsValues[i] = reasons[i].Description;

                // Setup validation controls
                var reasonsRange = new CellRangeAddressList(7, Rows, Columns - 1, Columns - 1); 
                var reasonsHelper = new XSSFDataValidationHelper((XSSFSheet)AttendanceList);
                var reasonsConstraint = (XSSFDataValidationConstraint)reasonsHelper.CreateExplicitListConstraint(reasonsValues);
                var reasonsValidator = (XSSFDataValidation)reasonsHelper.CreateValidation(reasonsConstraint, reasonsRange);

                reasonsValidator.CreateErrorBox("Invalid Value", "Plase select from one of the available values in dropdown listbox.");
                reasonsValidator.ShowErrorBox = true;
                reasonsValidator.ErrorStyle = ERRORSTYLE.STOP;
                AttendanceList.AddValidationData(reasonsValidator);
            }

            // Non-Attendance Causes
            if (references.Exists(r => r.Reference == "NonAttendanceCauses"))
            {
                // Get reference table
                var causesData = references.Find(r => r.Reference == "NonAttendanceCauses");
                List<dynamic> causes = JsonConvert.DeserializeObject<List<dynamic>>(causesData.ReferenceData);

                // Populate values array
                string[] causesValues = new string[causes.Count];
                for (int i = 0; i < causes.Count; i++)
                    causesValues[i] = causes[i].Description;

                // Setup validation controls
                var causesRange = new CellRangeAddressList(7, Rows, Columns, Columns);
                var causesHelper = new XSSFDataValidationHelper((XSSFSheet)AttendanceList);
                var causesConstraint = (XSSFDataValidationConstraint)causesHelper.CreateExplicitListConstraint(causesValues);
                var causesValidator = (XSSFDataValidation)causesHelper.CreateValidation(causesConstraint, causesRange);

                causesValidator.CreateErrorBox("Invalid Value", "Plase select from one of the available values in dropdown listbox.");
                causesValidator.ShowErrorBox = true;
                causesValidator.ErrorStyle = ERRORSTYLE.STOP;
                AttendanceList.AddValidationData(causesValidator);
            }

            // Populate Non-Attendance Reasons and Causes
            if (rosters.Count > 0)
            {
                rowIndex = 7;
                foreach (GetTrainingEventParticipant_Item participant in participants)
                {
                    var roster = rosters.FirstOrDefault(r => r.PersonID == participant.PersonID);
                    if (null != roster)
                    {
                        if (null != roster.NonAttendanceCause)
                            AttendanceList.GetRow(rowIndex).GetCell(Columns).SetCellValue(roster.NonAttendanceCause);
                        if (null != roster.NonAttendanceReason)
                            AttendanceList.GetRow(rowIndex).GetCell(Columns - 1).SetCellValue(roster.NonAttendanceReason);
                    }
                    rowIndex++;
                }
            }
            
            // Header
            AttendanceList.AddMergedRegion(new CellRangeAddress(0, 0, 0, Columns)); // Merged cells
            AttendanceList.CreateRow(0);
            AttendanceList.GetRow(0).Height = 460;
            AttendanceList.GetRow(0).CreateCell(0).SetCellValue("EVENT ATTENDANCE LIST");
            AttendanceList.GetRow(0).GetCell(0).CellStyle = PageHeaderStyle;

            AttendanceList.CreateRow(2);
            AttendanceList.GetRow(2).CreateCell(0).SetCellValue("Event ID");
            AttendanceList.GetRow(2).GetCell(0).CellStyle = BoldStsyle;

            AttendanceList.GetRow(2).CreateCell(1).SetCellValue(trainingEvent.TrainingEventID.ToString());

            AttendanceList.CreateRow(3);
            AttendanceList.GetRow(3).CreateCell(0).SetCellValue("Event Name");
            AttendanceList.GetRow(3).GetCell(0).CellStyle = BoldStsyle;

            AttendanceList.GetRow(3).CreateCell(1).SetCellValue(trainingEvent.Name);

            AttendanceList.CreateRow(4);
            AttendanceList.GetRow(4).CreateCell(0).SetCellValue("Dates");
            AttendanceList.GetRow(4).GetCell(0).CellStyle = BoldStsyle;

            AttendanceList.GetRow(4).CreateCell(1).SetCellValue(string.Format("From {0:MM/dd/yyyy} To: {1:MM/dd/yyyy}",
                                                                            trainingEvent.EventStartDate,
                                                                            trainingEvent.EventEndDate));
            AttendanceList.GetRow(4).GetCell(1).CellStyle = UnderlineStyle;


            // Legend
            AttendanceList.GetRow(2).CreateCell(3).SetCellValue("Legend");
            AttendanceList.GetRow(2).GetCell(3).CellStyle = BorderTopLeft;

            AttendanceList.GetRow(2).CreateCell(4);
            AttendanceList.GetRow(2).GetCell(4).CellStyle = BorderTopRight;

            AttendanceList.GetRow(4).CreateCell(3).SetCellValue("P");
            AttendanceList.GetRow(4).GetCell(3).CellStyle = BorderBottomLeft;

            AttendanceList.GetRow(4).CreateCell(4).SetCellValue("Present");
            AttendanceList.GetRow(4).GetCell(4).CellStyle = BorderBottomRight;

            AttendanceList.GetRow(3).CreateCell(3).SetCellValue("A");
            AttendanceList.GetRow(3).GetCell(3).CellStyle = BorderLeft;

            AttendanceList.GetRow(3).CreateCell(4).SetCellValue("Absent");
            AttendanceList.GetRow(3).GetCell(4).CellStyle = BorderRight;

            // Formatting
            AttendanceList.DisplayGridlines = false;
            AttendanceList.DisplayRowColHeadings = false;
            AttendanceList.SetActiveCell(7, 2);

            // Protect sheet
            AttendanceList.ProtectSheet(courseDefinition.CourseRosterKey);
        }

        private void PopulateRosterSheet(IGetTrainingEvent_Item trainingEvent, ITrainingEventCourseDefinitions_Item courseDefinition, 
                                            List<GetTrainingEventParticipant_Item> participants, List<ReferenceTables_Item> references,
                                            List<GetTrainingEventRoster_Item> rosters)
        {
            Roster.DefaultRowHeight = 300;

            // Weights row
            var row = Roster.CreateRow(5);
            row.CreateCell(3).SetCellFormula("IF(Settings!$B$8=\"N/A\",\"Not Applicable\",CONCATENATE(\"Weighted at \",IF(Settings!B8=\"N/A\",0,Settings!B8),\"% \"))");
            row.GetCell(3).CellStyle = WeightValuesStyle;
            row.CreateCell(4).SetCellFormula("IF(Settings!$B$9=\"N/A\",\"Not Applicable\",CONCATENATE(\"Weighted at \",IF(Settings!B9=\"N/A\",0,Settings!B9),\"% \"))");
            row.GetCell(4).CellStyle = WeightValuesStyle;
            row.CreateCell(5).SetCellFormula("IF(Settings!$B$10=\"N/A\",\"Not Applicable\",CONCATENATE(\"Weighted at \",IF(Settings!B10=\"N/A\",0,Settings!B10),\"% \"))");
            row.GetCell(5).CellStyle = WeightValuesStyle;
            row.CreateCell(6).SetCellFormula("IF(Settings!$B$14=\"N/A\",\"Not Required\",CONCATENATE(\"Min. \",Settings!B14,\" % \"))");
            row.GetCell(6).CellStyle = WeightValuesStyle;
            row.CreateCell(7).SetCellFormula("IF(Settings!$B$15=\"N/A\",\"Not Required\",CONCATENATE(\"Min. \",Settings!B15))");
            row.GetCell(7).CellStyle = WeightValuesStyle;

            // Attendance particiipant list header row
            Roster.CreateRow(6);
            Roster.GetRow(6).Height = 500;
            Roster.GetRow(6).CreateCell(0).SetCellValue("STUDENT ID");
            Roster.GetRow(6).GetCell(0).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(1).SetCellValue("STUDENT NAME");
            Roster.GetRow(6).GetCell(1).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(2).SetCellValue("PRE-TEST");
            Roster.GetRow(6).GetCell(2).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(3).SetCellValue("POST-TEST");
            Roster.GetRow(6).GetCell(3).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(4).SetCellValue("PERFORMANCE");
            Roster.GetRow(6).GetCell(4).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(5).SetCellValue("PRODUCT(S)");
            Roster.GetRow(6).GetCell(5).CellStyle = TableHeaderStyle;

            var link = new XSSFHyperlink(HyperlinkType.Document);
            link.Address = "'Attendance List'!$A$1";
            Roster.GetRow(6).CreateCell(6).SetCellValue("ATTENDANCE");
            Roster.GetRow(6).GetCell(6).Hyperlink = link;
            Roster.GetRow(6).GetCell(6).CellStyle = TableHeaderStyle;

            Roster.GetRow(6).CreateCell(7).SetCellValue("FINAL GRADE");
            Roster.GetRow(6).GetCell(7).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(8).SetCellValue("COMPLETE/CERTIFICATE");
            Roster.GetRow(6).GetCell(8).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(9).SetCellValue("DISTINCTION");
            Roster.GetRow(6).GetCell(9).CellStyle = TableHeaderStyle;
            Roster.GetRow(6).CreateCell(10).SetCellValue("COMMENTS");
            Roster.GetRow(6).GetCell(10).CellStyle = TableHeaderStyle;

            // Participant Rows
            int rowIndex = 7;
            foreach (GetTrainingEventParticipant_Item participant in participants)
            {
                var rosterData = rosters.FirstOrDefault(r => r.PersonID == participant.PersonID);
                Roster.CreateRow(rowIndex);
                Roster.GetRow(rowIndex).CreateCell(0).SetCellValue(participant.PersonID);
                Roster.GetRow(rowIndex).GetCell(0).CellStyle = RowStyleGray;
                Roster.GetRow(rowIndex).CreateCell(1).SetCellValue(GetParticipantName(participant));
                Roster.GetRow(rowIndex).GetCell(1).CellStyle = RowStyleGray;

                for (int i = 2; i < 11; i++)
                {
                    Roster.GetRow(rowIndex).CreateCell(i);
                    switch (i)
                    {
                        case 2:     // Pre-Test
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                            if (null != rosterData && rosterData.PreTestScore.HasValue)
                                Roster.GetRow(rowIndex).GetCell(i).SetCellValue(rosterData.PreTestScore.Value);
                            break;
                        case 3:     // Post-Test
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                            if (null != rosterData && rosterData.PostTestScore.HasValue)
                                Roster.GetRow(rowIndex).GetCell(i).SetCellValue(rosterData.PostTestScore.Value);
                            break;
                        case 4:     // Performance
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                            if (null != rosterData && rosterData.PerformanceScore.HasValue)
                                Roster.GetRow(rowIndex).GetCell(i).SetCellValue(rosterData.PerformanceScore.Value);
                            break;
                        case 5:     // Product(s)
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                            if (null != rosterData && rosterData.ProductsScore.HasValue)
                                Roster.GetRow(rowIndex).GetCell(i).SetCellValue(rosterData.ProductsScore.Value);
                            break;
                        case 6:     // Attendance
                            var at1 = new CellReference(AttendanceList.GetRow(rowIndex).GetCell(2));
                            var at2 = new CellReference(AttendanceList.GetRow(rowIndex).GetCell(1 + DateDiff));
                            Roster.GetRow(rowIndex).GetCell(i).SetCellFormula(string.Format("IFERROR((COUNTIF('Attendance List'!{0}{1}:{2}{3},\"P\")/COUNTA('Attendance List'!{0}{1}:{2}{3}))*100,\"\")",
                                                                                            at1.CellRefParts[2], at1.CellRefParts[1], at2.CellRefParts[2], at2.CellRefParts[1]));
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = RowStyleGray;

                            break;
                        case 7:     // Final Grade
                            var fr1 = new CellReference(Roster.GetRow(rowIndex).GetCell(3));
                            var fr2 = new CellReference(Roster.GetRow(rowIndex).GetCell(4));
                            var fr3 = new CellReference(Roster.GetRow(rowIndex).GetCell(5));
                            Roster.GetRow(rowIndex).GetCell(i).SetCellFormula(string.Format("IF(Settings!$B$15=\"N/A\",\"N/A\",IFERROR(({0}{1}*(Settings!$B$8/100)),0)+IFERROR(({2}{3}*(Settings!$B$9/100)),0)+IFERROR(({4}{5}*(Settings!$B$10/100)),0))",
                                                                                                fr1.CellRefParts[2], fr1.CellRefParts[1], fr2.CellRefParts[2],
                                                                                                fr2.CellRefParts[1], fr3.CellRefParts[2], fr3.CellRefParts[1]));
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = RowStyleGray;
                            break;
                        case 8:     // Certificate
                            var c1 = new CellReference(Roster.GetRow(rowIndex).GetCell(6));
                            var c2 = new CellReference(Roster.GetRow(rowIndex).GetCell(7));
                            Roster.GetRow(rowIndex).GetCell(i).SetCellFormula(string.Format("IF(AND(Settings!$B$14=\"N/A\",Settings!$B$15=\"N/A\"),\"N/A\", " +
                                                                                                "IF(OR(AND(Settings!$B$14=\"N/A\",Roster!{0}{1}" +
                                                                                                ">=Settings!$B$15), AND(Roster!{2}{3}>=Settings!$B$14,Settings!$B$15=\"N/A\"), AND({0}{1}" +
                                                                                                ">=Settings!$B$15,{2}{3}>=Settings!$B$14)),\"YES\",\"NO\"))",
                                                                                                c2.CellRefParts[2], c2.CellRefParts[1], c1.CellRefParts[2], c1.CellRefParts[1]));
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = RowStyleGray;

                            // Conditional formatting
                            var c3 = new CellReference(Roster.GetRow(rowIndex).GetCell(i));
                            string cConditionalExpression = string.Format("{0}{1}=\"NO\"", c3.CellRefParts[2], c3.CellRefParts[1]);
                            var sheetConditions = (XSSFSheetConditionalFormatting)((XSSFSheet)Roster).SheetConditionalFormatting;
                            var rule = sheetConditions.CreateConditionalFormattingRule(cConditionalExpression);

                            var condFont = rule.CreateFontFormatting();
                            condFont.FontColorIndex = IndexedColors.DarkRed.Index;

                            var certPattern = rule.CreatePatternFormatting();
                            certPattern.FillBackgroundColor = IndexedColors.Coral.Index;
                            certPattern.FillPattern = FillPattern.SolidForeground;
                            
                            CellRangeAddress[] range = { CellRangeAddress.ValueOf(string.Format("{0}{1}", c3.CellRefParts[2], c3.CellRefParts[1])) };
                            sheetConditions.AddConditionalFormatting(range, rule);
                            
                            break;
                        case 10:    // Comments
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue : RowStyleBlue);
                            if (null != rosterData && !string.IsNullOrEmpty(rosterData.Comments))
                                Roster.GetRow(rowIndex).GetCell(i).SetCellValue(rosterData.Comments);
                            break;
                        default:
                            Roster.GetRow(rowIndex).GetCell(i).CellStyle = (rowIndex % 2 == 0 ? RowStyleLightBlue: RowStyleBlue);
                            break;
                    }
                    Roster.AutoSizeColumn(i);
                }

                rowIndex++;
            }

            // Participant Distinction values
            if (references.Exists(r => r.Reference == "TrainingEventRosterDistinctions"))
            {
                // Get reference table
                var distinctionData = references.Find(r => r.Reference == "TrainingEventRosterDistinctions");
                List<dynamic> distinctions = JsonConvert.DeserializeObject<List<dynamic>>(distinctionData.ReferenceData);

                // Populate values array
                string[] attendanceValues = new string[distinctions.Count];
                for (int i = 0; i < distinctions.Count; i++)
                    attendanceValues[i] = distinctions[i].Code;

                // Setup validation controls
                var validationRange = new CellRangeAddressList(7, Rows, 9, 9);
                var helper = new XSSFDataValidationHelper((XSSFSheet)Roster);
                var dvConstraint = (XSSFDataValidationConstraint)helper.CreateExplicitListConstraint(attendanceValues);
                var validator = (XSSFDataValidation)helper.CreateValidation(dvConstraint, validationRange);

                validator.CreateErrorBox("Invalid Value", "Choose one of the values listed");
                validator.ShowErrorBox = true;
                validator.ErrorStyle = ERRORSTYLE.STOP;
                validator.CreatePromptBox("Comments", "If option is selected, please provide comment(s). What aspects of this participant’s performance were particularly exceptional or unsatisfactory?");
                validator.ShowPromptBox = true;
                Roster.AddValidationData(validator);
            }

            // Populate Roster Distinction
            if (rosters.Count > 0)
            { 
                rowIndex = 7;
                foreach (GetTrainingEventParticipant_Item participant in participants)
                {
                    var rosterData = rosters.FirstOrDefault(r => r.PersonID == participant.PersonID);
                    if (null != rosterData && !string.IsNullOrEmpty(rosterData.TrainingEventRosterDistinction))
                        Roster.GetRow(rowIndex).GetCell(9).SetCellValue(rosterData.TrainingEventRosterDistinction);

                    rowIndex++;
                }
            }

            // Format sheet (Autosize done prior to header info so that it will be sized to table correctly)
            Roster.AutoSizeColumn(0);
            Roster.AutoSizeColumn(1);
            
            // Header information
            Roster.AddMergedRegion(new CellRangeAddress(0, 0, 0, 11)); // Merged cells
            Roster.CreateRow(0);
            Roster.GetRow(0).Height = 460;
            Roster.GetRow(0).CreateCell(0).SetCellValue("STUDENT ROSTER");
            Roster.GetRow(0).GetCell(0).CellStyle = PageHeaderStyle;

            Roster.AddMergedRegion(new CellRangeAddress(1, 1, 0, 11)); // Merged cells
            Roster.CreateRow(1);
            Roster.GetRow(1).Height = 460;
            Roster.GetRow(1).CreateCell(0).SetCellValue(string.Format("{0} ({1:MMMM dd, yyyy} - {2:MMMM dd, yyyy})",
                                                                        trainingEvent.Name,
                                                                        trainingEvent.EventStartDate.Value,
                                                                        trainingEvent.EventEndDate.Value));
            Roster.GetRow(1).GetCell(0).CellStyle = PageHeaderStyle;

            Roster.CreateRow(2);
            Roster.GetRow(2).CreateCell(0).SetCellValue("Event ID");
            Roster.GetRow(2).GetCell(0).CellStyle = BoldStsyle;

            Roster.GetRow(2).CreateCell(1).SetCellValue(trainingEvent.TrainingEventID);

            // Formatting
            Roster.DisplayRowColHeadings = false;
            Roster.DisplayGridlines = false;
            Roster.SetActiveCell(7, 2);

            // Protect sheet
            Roster.ProtectSheet(courseDefinition.CourseRosterKey);
        }

        private void PopulateSettingsSheet(IGetTrainingEvent_Item trainingEvent, ITrainingEventCourseDefinitions_Item courseDefinition)
        {
            // Instructions
            Settings.CreateRow(0).CreateCell(0).SetCellValue("Instructions:");
            Settings.GetRow(0).GetCell(0).CellStyle = BoldStsyle;

            Settings.AddMergedRegion(new CellRangeAddress(1, 3, 0, 1));
            Settings.CreateRow(1).CreateCell(0).SetCellValue("Select weighted percentage of each element of final grade and certificate critera as " +
                                               "instructed by the program and/or curriculum. Choose N/A if element does not apply. " +
                                              "The sum of the final grade elements must equal 100%. ");
            Settings.GetRow(1).GetCell(0).CellStyle = InstructionsStyle;
            Settings.GetRow(1).Height = -1;

            // Course Roster Key
            Settings.GetRow(0).CreateCell(1).SetCellValue(double.Parse(courseDefinition.CourseRosterKey));

            // Scoring
            Settings.CreateRow(6).CreateCell(0).SetCellValue("Final Grade Elements");
            Settings.GetRow(6).GetCell(0).CellStyle = TableHeaderStyle;

            Settings.GetRow(6).CreateCell(1).SetCellValue("Weight (%)");
            Settings.GetRow(6).GetCell(1).CellStyle = TableHeaderStyle;
            Settings.GetRow(6).GetCell(1).CellStyle.Alignment = HorizontalAlignment.Center;

            Settings.CreateRow(7).CreateCell(0).SetCellValue("Post Test Score");
            Settings.GetRow(7).GetCell(0).CellStyle = RowStyleBlue;

            Settings.GetRow(7).CreateCell(1).SetCellValue(double.Parse(courseDefinition.TestsWeighting.ToString()));
            Settings.GetRow(7).GetCell(1).CellStyle = PercentageStyle;

            Settings.CreateRow(8).CreateCell(0).SetCellValue("Performance");
            Settings.GetRow(8).GetCell(0).CellStyle = RowStyleLightBlue;

            Settings.GetRow(8).CreateCell(1).SetCellValue(double.Parse(courseDefinition.PerformanceWeighting.ToString()));
            Settings.GetRow(8).GetCell(1).CellStyle = AltPercentageStyle;

            Settings.CreateRow(9).CreateCell(0).SetCellValue("Product(s)");
            Settings.GetRow(9).GetCell(0).CellStyle = RowStyleBlue;

            Settings.GetRow(9).CreateCell(1).SetCellValue(double.Parse(courseDefinition.ProductsWeighting.ToString()));
            Settings.GetRow(9).GetCell(1).CellStyle = PercentageStyle;

            // Scoring total cell
            Settings.CreateRow(10).CreateCell(1).SetCellFormula("IF(AND(B8=\"N/A\",B9=\"N/A\",B10=\"N/A\"),\"N/A\",SUM(B8:B10))");
            var style = (XSSFCellStyle)Settings.Workbook.CreateCellStyle();
            style.Alignment = HorizontalAlignment.Right;
            style.FillPattern = FillPattern.SolidForeground;
            style.SetFillForegroundColor(new XSSFColor(new byte[] { 216, 228, 188 }));
            style.DataFormat = PercentageWithDecimalFormat;
            Settings.GetRow(10).GetCell(1).CellStyle = style;

            var patr = Settings.CreateDrawingPatriarch();
            var comment = patr.CreateCellComment(new XSSFClientAnchor(0, 0, 0, 0, 10, 1, 11, 1));
            comment.String = new XSSFRichTextString("If one or more elements apply, the sum of the weighting factors must equal 100%");
            comment.Author = "Review Weighting";
            Settings.GetRow(10).GetCell(1).CellComment = comment;

            // Minimums
            Settings.AddMergedRegion(new CellRangeAddress(12, 12, 0, 1));
            Settings.CreateRow(12).CreateCell(0).SetCellValue("Certificate Criteria");
            Settings.GetRow(12).GetCell(0).CellStyle = TableHeaderStyle;
            Settings.CreateRow(13).CreateCell(0).SetCellValue("Minimum Attendance Required");
            Settings.GetRow(13).GetCell(0).CellStyle = RowStyleBlue;
            Settings.GetRow(13).CreateCell(1).SetCellValue(double.Parse(courseDefinition.MinimumAttendance.ToString()));
            Settings.GetRow(13).GetCell(1).CellStyle = PercentageStyle;
            Settings.CreateRow(14).CreateCell(0).SetCellValue("Minimum Final Grade");
            Settings.GetRow(14).GetCell(0).CellStyle = RowStyleLightBlue;
            Settings.GetRow(14).CreateCell(1).SetCellValue(double.Parse(courseDefinition.MinimumFinalGrade.ToString()));
            Settings.GetRow(14).GetCell(1).CellStyle = AltPercentageStyle;

            // Sheet links
            var link = new XSSFHyperlink(HyperlinkType.Document);
            link.Address = "Roster!$A$1";
            Settings.CreateRow(20).CreateCell(0).SetCellValue("Go to Participant Performance Roster =>");
            Settings.GetRow(20).GetCell(0).Hyperlink = link;
            Settings.GetRow(20).GetCell(0).CellStyle = TableHeaderStyle;

            link = new XSSFHyperlink(HyperlinkType.Document);
            link.Address = "'Attendance List'!$A$1";
            Settings.CreateRow(24).CreateCell(0).SetCellValue("Go to Attendance List =>");
            Settings.GetRow(24).GetCell(0).Hyperlink = link;
            Settings.GetRow(24).GetCell(0).CellStyle = TableHeaderStyle;

            // Format sheet
            Settings.AutoSizeColumn(0);
            Settings.AutoSizeColumn(1);
            Settings.DisplayGridlines = false;
            Settings.DisplayRowColHeadings = false;

            // Protect sheet
            Settings.ProtectSheet(courseDefinition.CourseRosterKey);
            
            //for (int i = 7 + 1; i < 16300; ++i)
            //{
            //    Settings.SetColumnHidden(i, true);
            //}
        }

        /// <summary>
        /// Save grades and attendance data for training event students
        /// </summary>
        /// <param name="param"><see cref="ISaveTrainingEventRoster_Param"/> containing all the user submitted data for processing</param>
        /// <param name="rosterKey">The key used to verify the version of the submitted spreadsheet, if applicable</param>
        /// <param name="trainingEvent"><see cref="GetTrainingEvent_Result"/> containing training event info for associated training event</param>
        /// <returns><see cref="List{T}"/> of <see cref="ISaveTrainingEventRoster_Item"/> containing the results of all the transactions</returns>
        public List<ITrainingEventRoster_Item> SaveGradesAndAttendance(ISaveTrainingEventRoster_Param param, string rosterKey,
                                            IGetTrainingEvent_Item trainingEvent, long[] participants)
        {
            List<ITrainingEventRoster_Item> roster = new List<ITrainingEventRoster_Item>();

            // Determine whether to use uploaded spreadsheet or List<> in parameter
            if (null == param.StudentExcelStream)
            {
                // Use student data from parameter
                roster = param.Participants;
                roster.ForEach(p => p.ModifiedByAppUserID = param.ModifiedByAppUserID.Value);
            }
            else
            {
                // Extract data from spreadsheet
                roster = GetStudentDataFromSpreadsheet(param, rosterKey, trainingEvent.TrainingEventID);
            }

            // Verify all persons in submission are part of training event
            var excludedIDs = new HashSet<long>(participants);
            var missing = roster.Where(p => !excludedIDs.Contains(p.PersonID));

            if (missing.Count() > 0)
                throw new ArgumentException("There are persons in submission that are not part of this training event", "PersonIDs");

            // Save data and get results
            return SaveRosterData(roster, param.ModifiedByAppUserID.Value);
        }

        private List<ITrainingEventRoster_Item> GetStudentDataFromSpreadsheet(ISaveTrainingEventRoster_Param param, 
                                                                                    string rosterKey, long trainingEventID)
        {
            bool attendanceFound = false;
            List<ITrainingEventRoster_Item> roster = new List<ITrainingEventRoster_Item>();
            List<TrainingEventAttendance_Item> attendance = new List<TrainingEventAttendance_Item>();
            List<long> noParticipationData = new List<long>();

            using (var stream = param.StudentExcelStream)
            {
                IRow rosterRow;
                IRow attendanceRow;
                IRow dateRow;
                ITrainingEventRoster_Item rosterItem;
                TrainingEventAttendance_Item attendanceItem;

                // Instantiate workbook
                stream.Position = 0;
                Workbook = new XSSFWorkbook(stream);

                // Verify Course Roster Key
                ISheet settings = Workbook.GetSheet("Settings");
                if (Convert.ToDouble(rosterKey) != settings.GetRow(0).GetCell(1).NumericCellValue)
                    throw new ArgumentException("Course Roster Key does not match", "CourseRosterKey");

                // Instantiate sheets
                Roster = (XSSFSheet)Workbook.GetSheet("Roster");
                AttendanceList = (XSSFSheet)Workbook.GetSheet("Attendance List");

                // Get row for dates
                dateRow = AttendanceList.GetRow(6);

                // Get Minimum Attendance value
                double minimumAttendance = settings.GetRow(13).GetCell(1).NumericCellValue;

                // Set Grades
                for (int i = (Roster.FirstRowNum + 7); i <= Roster.LastRowNum && i <= 100; i++)
                {
                    // Get row for grades
                    rosterRow = Roster.GetRow(i);

                    try
                    {
                        // Get row for attendance data
                        attendanceRow = AttendanceList.GetRow(i);

                        // Verify the person ID from roster matches the person ID from attendance list
                        if (attendanceRow.GetCell(0).NumericCellValue != rosterRow.GetCell(0).NumericCellValue)
                            throw new Exception("Row from Roster sheet do not match row in attenance list sheet");

                        // Loop through days
                        attendanceFound = false;
                        attendance = new List<TrainingEventAttendance_Item>();
                        for (int n = 2; n <= attendanceRow.LastCellNum - 3 && n <= 100; n++) //Read Excel File
                        {
                            // Only capture if cell has data
                            if (!string.IsNullOrEmpty(attendanceRow.GetCell(n).StringCellValue))
                            {
                                if (!string.IsNullOrEmpty(attendanceRow.GetCell(n).StringCellValue))
                                    attendanceFound = true;

                                attendanceItem = new TrainingEventAttendance_Item()
                                {
                                    AttendanceDate = Convert.ToDateTime(dateRow.GetCell(n).StringCellValue),
                                    AttendanceIndicator = attendanceRow.GetCell(n).StringCellValue.Trim().ToUpper() == "P" ? true : false,
                                    ModifiedByAppUserID = param.ModifiedByAppUserID.Value
                                };

                                // Add attendance data to roster's attendance list
                                attendance.Add(attendanceItem);
                            }
                        }

                        // Get roster data from spreadsheet
                        rosterItem = new SaveTrainingEventRoster_Item()
                        {
                            TrainingEventID = trainingEventID,
                            PersonID = (long)rosterRow.GetCell(0).NumericCellValue,
                            PreTestScore = (byte)rosterRow.GetCell(2).NumericCellValue,
                            PostTestScore = (byte)rosterRow.GetCell(3).NumericCellValue,
                            PerformanceScore = (byte)rosterRow.GetCell(4).NumericCellValue,
                            ProductsScore = (byte)rosterRow.GetCell(5).NumericCellValue,
                            AttendanceScore = (byte)rosterRow.GetCell(6).NumericCellValue,
                            FinalGradeScore = (byte)rosterRow.GetCell(7).NumericCellValue,
                            Certificate = rosterRow.GetCell(8).StringCellValue == "YES" ? true : false,
                            MinimumAttendanceMet = rosterRow.GetCell(6).NumericCellValue < minimumAttendance ? false : true,
                            TrainingEventRosterDistinctionID = GetTrainingEventRosterDistinction(rosterRow.GetCell(9).StringCellValue),
                            Comments = rosterRow.GetCell(10).StringCellValue,
                            ModifiedByAppUserID = param.ModifiedByAppUserID.Value
                        };

                        // Only calculate if the participant has attendance information entered
                        //  NOTE: This is so to make the UI correctly reflect the data.  Without this check
                        //        the UI will display false for any rows that are missing data.
                        if (attendanceFound)
                            rosterItem.MinimumAttendanceMet = rosterRow.GetCell(6).NumericCellValue < minimumAttendance ? false : true;
                        else
                            rosterItem.MinimumAttendanceMet = true;

                        // Add attendance
                        rosterItem.Attendance = attendance;

                        // Add Non-Attendance reason/cause to roster item
                        rosterItem.NonAttendanceCauseID = GetNonAttendanceCause(attendanceRow.GetCell(attendanceRow.LastCellNum - 1).StringCellValue.Trim());
                        rosterItem.NonAttendanceReasonID = GetNonAttendanceReason(attendanceRow.GetCell(attendanceRow.LastCellNum - 2).StringCellValue.Trim());

                        roster.Add(rosterItem);
                    }
                    catch (Exception ex)
                    {
                        ErrorMessages.Add(string.Format("Spreadsheet data error for Student ({0}). {1}", rosterRow.GetCell(0).NumericCellValue, ex.Message));
                    }
                }
            }

            return roster;
        }

        private List<ITrainingEventRoster_Item> SaveRosterData(List<ITrainingEventRoster_Item> roster, int modifiedByAppUser)
        {
            List<ITrainingEventRoster_Item> result = new List<ITrainingEventRoster_Item>();

            foreach (ITrainingEventRoster_Item saveRosterItem in roster)
            {
                try
                {
                    // Convert for repo
                    var saveTrainingEventRosterEntity = saveRosterItem.Adapt<ISaveTrainingEventRosterEntity>();

                    // Call repo
                    var rosterEntity = trainingRepository.SaveTrainingEventRoster(saveTrainingEventRosterEntity);

                    // Convert to result
                    var rosterResult = rosterEntity.Adapt<ITrainingEventRoster_Item>();

                    if (null != saveRosterItem.Attendance && saveRosterItem.Attendance.Count > 0)
                    {
                        // Craete JSON of Attendance data
                        var attendanceJSON = JsonConvert.SerializeObject(
                                    saveRosterItem.Attendance.Select(a =>
                                        new TrainingEventAttendance_Item
                                        {
                                            AttendanceDate = a.AttendanceDate,
                                            AttendanceIndicator = a.AttendanceIndicator,
                                            TrainingEventRosterID = rosterEntity.TrainingEventRosterID
                                        }
                                    ).ToList());

                        // Create param for repo
                        var saveTrainingEventAttendance = new SaveTrainingEventAttendanceInBulkEntity()
                        {
                            TrainingEventRosterID = rosterEntity.TrainingEventRosterID,
                            ModifiedByAppUserID = modifiedByAppUser,
                            AttendanceJSON = attendanceJSON
                        };

                        // Call repo
                        var attendanceEntityList = trainingRepository.SaveTrainingEventAttendanceInBulk(saveTrainingEventAttendance);

                        // Convert to result
                        var attendanceResultList = attendanceEntityList.Adapt<List<TrainingEventAttendance_Item>>();
                        rosterResult.Attendance = attendanceResultList;
                    }

                    result.Add(rosterResult);
                }
                catch (Exception ex)
                {
                    ErrorMessages.Add(string.Format("Database error for Student ({0}). {1}", saveRosterItem.PersonID, ex.Message));
                }
            }

            return result;
        }

        private int? GetTrainingEventRosterDistinction(string trainingEventDistinction)
        {
            return TrainingEventRosterDistinction.FirstOrDefault(r => r.Code == trainingEventDistinction.Trim())?.TrainingEventRosterDistinctionID;
        }

        private byte? GetNonAttendanceCause(string nonAttendanceCause)
        {
            return NonAttendanceCause.FirstOrDefault(r => r.Description == nonAttendanceCause.Trim())?.NonAttendanceCauseID;
        }

        private byte? GetNonAttendanceReason(string nonAttendanceReason)
        {
            return NonAttendanceReason.FirstOrDefault(r => r.Description == nonAttendanceReason.Trim())?.NonAttendanceReasonID;
        }

        private string GetParticipantName(GetTrainingEventParticipant_Item participant)
        {
            return string.Format("{0} {1}", participant.FirstMiddleNames, participant.LastNames).Trim();
        }

        #region ### Reference Data
        private List<dynamic> TrainingEventRosterDistinction
        {
            get
            {
                if (null == _TrainingEventRosterDistinctions)
                {
                    if (referenceTables.Exists(r => r.Reference == "TrainingEventRosterDistinctions"))
                    {
                        // Get reference table
                        var distinctionData = referenceTables.Find(r => r.Reference == "TrainingEventRosterDistinctions");
                        _TrainingEventRosterDistinctions = JsonConvert.DeserializeObject<List<dynamic>>(distinctionData.ReferenceData);
                    }
                }

                return _TrainingEventRosterDistinctions;
            }
        }
        private List<dynamic> NonAttendanceCause
        {
            get
            {
                if (null == _NonAttencanceCauses)
                {
                    if (referenceTables.Exists(r => r.Reference == "NonAttendanceCauses"))
                    {
                        // Get reference table
                        var distinctionData = referenceTables.Find(r => r.Reference == "NonAttendanceCauses");
                        _NonAttencanceCauses = JsonConvert.DeserializeObject<List<dynamic>>(distinctionData.ReferenceData);
                    }
                }

                return _NonAttencanceCauses;
            }
        }
        private List<dynamic> NonAttendanceReason
        {
            get
            {
                if (null == _NonAttendanceReasons)
                {
                    if (referenceTables.Exists(r => r.Reference == "NonAttendanceReasons"))
                    {
                        // Get reference table
                        var distinctionData = referenceTables.Find(r => r.Reference == "NonAttendanceReasons");
                        _NonAttendanceReasons = JsonConvert.DeserializeObject<List<dynamic>>(distinctionData.ReferenceData);
                    }
                }

                return _NonAttendanceReasons;
            }
        }
        #endregion  

        #region ### Mapster Config
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
                TypeAdapterConfig<ITrainingEventRoster_Item, ISaveTrainingEventRosterEntity>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventRosterEntity());

                TypeAdapterConfig<TrainingEventAttendanceViewEntity, ITrainingEventAttendance_Item>
                    .ForType()
                    .ConstructUsing(s => new TrainingEventAttendance_Item());

                TypeAdapterConfig<ITrainingEventRosterViewEntity, ITrainingEventRoster_Item>
                    .ForType()
                    .ConstructUsing(s => new SaveTrainingEventRoster_Item())
                    .Map(
                        dest => dest.Attendance,
                        src => JsonConvert.DeserializeObject(("" + src.AttendanceJSON), typeof(List<ITrainingEventAttendance_Item>), deserializationSettings)
                        );

                AreMappingsConfigured = true;
            }

        }
        #endregion

        #region ## Styles
        private XSSFCellStyle DefaultStyle
        {
            get
            {
                if (null == _DefaultStyle)
                {
                    _DefaultStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                }

                return _DefaultStyle;
            }
        }
        private XSSFCellStyle TableHeaderStyle
        {
            get
            {
                if (null == _TableHeaderStyle)
                {
                    _TableHeaderStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _TableHeaderStyle.IsLocked = true;
                    _TableHeaderStyle.Alignment = HorizontalAlignment.Center;
                    _TableHeaderStyle.VerticalAlignment = VerticalAlignment.Center;
                    _TableHeaderStyle.FillPattern = FillPattern.SolidForeground;
                    _TableHeaderStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 79, 129, 189 }));
                    _TableHeaderStyle.BorderTop = BorderStyle.Thick;
                    _TableHeaderStyle.BorderBottom = BorderStyle.Thick;
                    _TableHeaderStyle.BorderLeft = BorderStyle.Thick;
                    _TableHeaderStyle.BorderRight = BorderStyle.Thick;
                    _TableHeaderStyle.BottomBorderColor = IndexedColors.White.Index;
                    _TableHeaderStyle.TopBorderColor = IndexedColors.White.Index;
                    _TableHeaderStyle.LeftBorderColor = IndexedColors.White.Index;
                    _TableHeaderStyle.RightBorderColor = IndexedColors.White.Index;
                    _TableHeaderStyle.SetFont(TableHeaderFont);
                }

                return _TableHeaderStyle;
            }
        }
        private XSSFCellStyle RowStyleGray
        {
            get
            {
                if (null == _RowStyleGray)
                {
                    _RowStyleGray = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _RowStyleGray.FillPattern = FillPattern.SolidForeground;
                    _RowStyleGray.Alignment = HorizontalAlignment.Center;
                    _RowStyleGray.SetFillForegroundColor(new XSSFColor(new byte[] { 217, 217, 217 }));
                    _RowStyleGray.BorderTop = BorderStyle.Thick;
                    _RowStyleGray.BorderBottom = BorderStyle.Thick;
                    _RowStyleGray.BorderLeft = BorderStyle.Thick;
                    _RowStyleGray.BorderRight = BorderStyle.Thick;
                    _RowStyleGray.BottomBorderColor = IndexedColors.White.Index;
                    _RowStyleGray.TopBorderColor = IndexedColors.White.Index;
                    _RowStyleGray.LeftBorderColor = IndexedColors.White.Index;
                    _RowStyleGray.RightBorderColor = IndexedColors.White.Index;
                }

                return _RowStyleGray;
            }
        }
        private XSSFCellStyle PageHeaderStyle
        {
            get
            {
                if (null == _PageHeaderStyle)
                {
                    _PageHeaderStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _PageHeaderStyle.Alignment = HorizontalAlignment.Center;
                    _PageHeaderStyle.SetFont(PageHeaderFont);
                }

                return _PageHeaderStyle;
            }
        }
        private XSSFCellStyle RowStyleBlue
        {
            get
            {
                if (null == _RowStyleBlue)
                {
                    _RowStyleBlue = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _RowStyleBlue.FillPattern = FillPattern.SolidForeground;
                    _RowStyleBlue.SetFillForegroundColor(new XSSFColor(new byte[] { 184, 204, 228 }));
                    _RowStyleBlue.IsLocked = false;
                    _RowStyleBlue.BorderTop = BorderStyle.Thick;
                    _RowStyleBlue.BorderBottom = BorderStyle.Thick;
                    _RowStyleBlue.BorderLeft = BorderStyle.Thick;
                    _RowStyleBlue.BorderRight = BorderStyle.Thick;
                    _RowStyleBlue.BottomBorderColor = IndexedColors.White.Index;
                    _RowStyleBlue.TopBorderColor = IndexedColors.White.Index;
                    _RowStyleBlue.LeftBorderColor = IndexedColors.White.Index;
                    _RowStyleBlue.RightBorderColor = IndexedColors.White.Index;
                }

                return _RowStyleBlue;
            }
        }
        private XSSFCellStyle RowStyleLightBlue
        {
            get
            {
                if (null == _RowStyleLightBlue)
                {
                    _RowStyleLightBlue = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _RowStyleLightBlue.FillPattern = FillPattern.SolidForeground;
                    _RowStyleLightBlue.SetFillForegroundColor(new XSSFColor(new byte[] { 220, 230, 241 }));
                    _RowStyleLightBlue.IsLocked = false;
                    _RowStyleLightBlue.BorderTop = BorderStyle.Thick;
                    _RowStyleLightBlue.BorderBottom = BorderStyle.Thick;
                    _RowStyleLightBlue.BorderLeft = BorderStyle.Thick;
                    _RowStyleLightBlue.BorderRight = BorderStyle.Thick;
                    _RowStyleLightBlue.BottomBorderColor = IndexedColors.White.Index;
                    _RowStyleLightBlue.TopBorderColor = IndexedColors.White.Index;
                    _RowStyleLightBlue.LeftBorderColor = IndexedColors.White.Index;
                    _RowStyleLightBlue.RightBorderColor = IndexedColors.White.Index;
                }

                return _RowStyleLightBlue;
            }
        }
        private XSSFCellStyle RowStyleRed
        {
            get
            {
                if (null == _RowStyleRed)
                {
                    _RowStyleRed = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _RowStyleRed.Alignment = HorizontalAlignment.Center;
                    _RowStyleRed.FillPattern = FillPattern.SolidForeground;
                    _RowStyleRed.SetFillForegroundColor(new XSSFColor(new byte[] { 255, 199, 206 }));
                    _RowStyleRed.BorderTop = BorderStyle.Thick;
                    _RowStyleRed.BorderBottom = BorderStyle.Thick;
                    _RowStyleRed.BorderLeft = BorderStyle.Thick;
                    _RowStyleRed.BorderRight = BorderStyle.Thick;
                    _RowStyleRed.BottomBorderColor = IndexedColors.White.Index;
                    _RowStyleRed.TopBorderColor = IndexedColors.White.Index;
                    _RowStyleRed.LeftBorderColor = IndexedColors.White.Index;
                    _RowStyleRed.RightBorderColor = IndexedColors.White.Index;
                }

                return _RowStyleRed;
            }
        }
        private XSSFCellStyle UnderlineStyle
        {
            get
            {
                if (null == _UnderlineStyle)
                {
                    _UnderlineStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _UnderlineStyle.SetFont(UnderlineFont);
                }

                return _UnderlineStyle;
            }
        }
        private XSSFCellStyle BoldStsyle
        {
            get
            {
                if (null == _BoldStsyle)
                {
                    _BoldStsyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BoldStsyle.SetFont(BoldFont);
                }

                return _BoldStsyle;
            }
        }
        private XSSFCellStyle PercentageStyle
        {
            get
            {
                if (null == _PercentageStyle)
                {
                    _PercentageStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _PercentageStyle.Alignment = HorizontalAlignment.Right;
                    _PercentageStyle.DataFormat = PercentageFormat;
                    _PercentageStyle.FillPattern = FillPattern.SolidForeground;
                    _PercentageStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 184, 204, 228 }));
                    _PercentageStyle.BorderTop = BorderStyle.Thick;
                    _PercentageStyle.BorderBottom = BorderStyle.Thick;
                    _PercentageStyle.BorderLeft = BorderStyle.Thick;
                    _PercentageStyle.BorderRight = BorderStyle.Thick;
                    _PercentageStyle.BottomBorderColor = IndexedColors.White.Index;
                    _PercentageStyle.TopBorderColor = IndexedColors.White.Index;
                    _PercentageStyle.LeftBorderColor = IndexedColors.White.Index;
                    _PercentageStyle.RightBorderColor = IndexedColors.White.Index;
                }

                return _PercentageStyle;
            }
        }
        private XSSFCellStyle AltPercentageStyle
        {
            get
            {
                if (null == _AltPercentageStyle)
                {
                    _AltPercentageStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _AltPercentageStyle.Alignment = HorizontalAlignment.Right;
                    _AltPercentageStyle.DataFormat = PercentageFormat;
                    _AltPercentageStyle.FillPattern = FillPattern.SolidForeground;
                    _AltPercentageStyle.SetFillForegroundColor(new XSSFColor(new byte[] { 220, 230, 241 }));
                    _AltPercentageStyle.BorderTop = BorderStyle.Thick;
                    _AltPercentageStyle.BorderBottom = BorderStyle.Thick;
                    _AltPercentageStyle.BorderLeft = BorderStyle.Thick;
                    _AltPercentageStyle.BorderRight = BorderStyle.Thick;
                    _AltPercentageStyle.BottomBorderColor = IndexedColors.White.Index;
                    _AltPercentageStyle.TopBorderColor = IndexedColors.White.Index;
                    _AltPercentageStyle.LeftBorderColor = IndexedColors.White.Index;
                    _AltPercentageStyle.RightBorderColor = IndexedColors.White.Index;
                }

                return _AltPercentageStyle;
            }
        }
        private XSSFCellStyle InstructionsStyle
        {
            get
            {
                if (null == _InstructionsStyle)
                {
                    _InstructionsStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _InstructionsStyle.WrapText = true;
                    _InstructionsStyle.VerticalAlignment = VerticalAlignment.Center;
                    _InstructionsStyle.SetFont(InstructionsFont);
                }

                return _InstructionsStyle;
            }
        }
        private XSSFCellStyle BorderTopLeft
        {
            get
            {
                if (null == _BorderTopLeft)
                {
                    _BorderTopLeft = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderTopLeft.VerticalAlignment = VerticalAlignment.Justify;
                    _BorderTopLeft.BorderLeft = BorderStyle.Medium;
                    _BorderTopLeft.LeftBorderColor = IndexedColors.Black.Index;
                    _BorderTopLeft.BorderTop = BorderStyle.Medium;
                    _BorderTopLeft.TopBorderColor = IndexedColors.Black.Index;
                    _BorderTopLeft.SetFont(BoldFont);
                }

                return _BorderTopLeft;
            }
        }
        private XSSFCellStyle BorderTopRight
        {
            get
            {
                if (null == _BorderTopRight)
                {
                    _BorderTopRight = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderTopRight.VerticalAlignment = VerticalAlignment.Justify;
                    _BorderTopRight.BorderRight = BorderStyle.Medium;
                    _BorderTopRight.RightBorderColor = IndexedColors.Black.Index;
                    _BorderTopRight.BorderTop = BorderStyle.Medium;
                    _BorderTopRight.TopBorderColor = IndexedColors.Black.Index;
                    _BorderTopRight.SetFont(BoldFont);
                }

                return _BorderTopRight;
            }
        }
        private XSSFCellStyle BorderBottomLeft
        {
            get
            {
                if (null == _BorderBottomLeft)
                {
                    _BorderBottomLeft = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderBottomLeft.BorderLeft = BorderStyle.Medium;
                    _BorderBottomLeft.LeftBorderColor = IndexedColors.Black.Index;
                    _BorderBottomLeft.BorderBottom = BorderStyle.Medium;
                    _BorderBottomLeft.BottomBorderColor = IndexedColors.Black.Index;
                    _BorderBottomLeft.SetFont(BoldFont);
                }

                return _BorderBottomLeft;
            }
        }
        private XSSFCellStyle BorderBottomRight
        {
            get
            {
                if (null == _BorderBottomRight)
                {
                    _BorderBottomRight = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderBottomRight.BorderRight = BorderStyle.Medium;
                    _BorderBottomRight.RightBorderColor = IndexedColors.Black.Index;
                    _BorderBottomRight.BorderBottom = BorderStyle.Medium;
                    _BorderBottomRight.BottomBorderColor = IndexedColors.Black.Index;
                    _BorderBottomRight.SetFont(BoldFont);
                }

                return _BorderBottomRight;
            }
        }
        private XSSFCellStyle BorderLeft
        {
            get
            {
                if (null == _BorderLeft)
                {
                    _BorderLeft = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderLeft.BorderLeft = BorderStyle.Medium;
                    _BorderLeft.LeftBorderColor = IndexedColors.Black.Index;
                    _BorderLeft.SetFont(BoldFont);
                }

                return _BorderLeft;
            }
        }
        private XSSFCellStyle BorderRight
        {
            get
            {
                if (null == _BorderRight)
                {
                    _BorderRight = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _BorderRight.BorderRight = BorderStyle.Medium;
                    _BorderRight.RightBorderColor = IndexedColors.Black.Index;
                    _BorderRight.SetFont(BoldFont);
                }

                return _BorderRight;
            }
        }
        private XSSFCellStyle WeightValuesStyle
        {
            get
            {
                if (null == _WeightValuesStyle)
                {
                    _WeightValuesStyle = (XSSFCellStyle)Workbook.CreateCellStyle();
                    _WeightValuesStyle.Alignment = HorizontalAlignment.Center;
                    _WeightValuesStyle.SetFont(WeightValuesFont);
                }

                return _WeightValuesStyle;
            }
        }

        #endregion

        #region ### Fonts
        private XSSFFont DeafultFont
        {
            get
            {
                if (null == _DefaultFont)
                {
                    _DefaultFont = (XSSFFont)Workbook.CreateFont();
                    _DefaultFont.FontHeightInPoints = 11;
                }

                return _DefaultFont;
            }
        }
        private XSSFFont TableHeaderFont
        {
            get
            {
                if (null == _TableHeaderFont)
                {
                    _TableHeaderFont = (XSSFFont)Workbook.CreateFont();
                    _TableHeaderFont.Color = IndexedColors.White.Index;
                    _TableHeaderFont.IsBold = true;
                    _TableHeaderFont.FontHeightInPoints = 11;
                }

                return _TableHeaderFont;
            }
        }
        private XSSFFont StudentFont
        {
            get
            {
                if (null == _StudentFont)
                {
                    _StudentFont = (XSSFFont)Workbook.CreateFont();
                }

                return _StudentFont;
            }
        }
        private XSSFFont PageHeaderFont
        {
            get
            {
                if (null == _PageHeaderFont)
                {
                    _PageHeaderFont = (XSSFFont)Workbook.CreateFont();
                    _PageHeaderFont.FontHeightInPoints = 18;
                    _PageHeaderFont.IsBold = true;
                }

                return _PageHeaderFont;
            }
        }
        private XSSFFont UnderlineFont
        {
            get
            {
                if (null == _UnderlineFont)
                {
                    _UnderlineFont = (XSSFFont)Workbook.CreateFont();
                    _UnderlineFont.Underline = FontUnderlineType.Single;
                    _UnderlineFont.FontHeightInPoints = 11;
                }

                return _UnderlineFont;
            }
        }
        private XSSFFont BoldFont
        {
            get
            {
                if (null == _BoldFont)
                {
                    _BoldFont = (XSSFFont)Workbook.CreateFont();
                    _BoldFont.IsBold = true;
                    _BoldFont.FontHeightInPoints = 11;
                }

                return _BoldFont;
            }
        }
        private XSSFFont InstructionsFont
        {
            get
            {
                if (null == _InstructionsFont)
                {
                    _InstructionsFont = (XSSFFont)Workbook.CreateFont();
                    _InstructionsFont.Color = IndexedColors.Red.Index;
                    _InstructionsFont.IsItalic = true;
                    _InstructionsFont.FontHeightInPoints = 11;
                }

                return _InstructionsFont;
            }
        }
        private XSSFFont WeightValuesFont
        {
            get
            {
                if (null == _WeightValuesFont)
                {
                    _WeightValuesFont = (XSSFFont)Workbook.CreateFont();
                    _WeightValuesFont.FontHeightInPoints = 9;
                    _WeightValuesFont.Color = IndexedColors.Green.Index;
                }

                return _WeightValuesFont;
            }
        }
        #endregion

        #region ### Data Formats
        private short PercentageFormat
        {
            get
            {
                if (null == _DataFormat)
                {
                    _DataFormat = (XSSFDataFormat)Workbook.CreateDataFormat();
                }
                return _DataFormat.GetFormat("#\\%");
            }
        }
        private short PercentageWithDecimalFormat
        {
            get
            {
                if (null == _DataFormat)
                {
                    _DataFormat = (XSSFDataFormat)Workbook.CreateDataFormat();
                }
                return _DataFormat.GetFormat("#0\\.00%");
            }
        }
        #endregion

        public List<string> ErrorMessages
        {
            get;
        }
    }
}
