using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEvent_Result : ISaveTrainingEvent_Result
	{
        public Int64 TrainingEventID { get; set; }
        public string Name { get; set; }
        public string NameInLocalLang { get; set; }
        public int TrainingEventTypeID { get; set; }
		public string TrainingEventTypeName { get; set; }
		public string Justification { get; set; }
        public string Objectives { get; set; }
        public string ParticipantProfile { get; set; }
        public string SpecialRequirements { get; set; }
        public int? ProgramID { get; set; }
        public int? KeyActivityID { get; set; }
        public Int64? TrainingUnitID { get; set; }
		public string BusinessUnitAcronym { get; set; }
		public string BusinessUnitName { get; set; }
		public int? CountryID { get; set; }
        public int? PostID { get; set; }
        public int? ConsularDistrictID { get; set; }
        public int? OrganizerAppUserID { get; set; }
        public int? PlannedParticipantCnt { get; set; }
        public int? PlannedMissionDirectHireCnt { get; set; }
        public int? PlannedNonMissionDirectHireCnt { get; set; }
        public int? PlannedMissionOutsourceCnt { get; set; }
        public int? PlannedOtherCnt { get; set; }
        public decimal? EstimatedBudget { get; set; }
        public int? EstimatedStudents { get; set; }
        public int? FundingSourceID { get; set; }
        public int? AuthorizingLawID { get; set; }
        public string Comments { get; set; }

        public List<SaveTrainingEventLocation_Item> TrainingEventLocations { get; set; }
		public List<SaveTrainingEventUSPartnerAgency_Item> TrainingEventUSPartnerAgencies { get; set; }
        public List<SaveTrainingEventProjectCode_Item> TrainingEventProjectCodes { get; set; }
        public List<SaveTrainingEventStakeholder_Item> TrainingEventStakeholders { get; set; }
    }
}
