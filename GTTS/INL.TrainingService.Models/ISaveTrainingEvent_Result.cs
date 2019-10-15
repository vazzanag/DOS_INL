using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
	public interface ISaveTrainingEvent_Result
	{
		Int64 TrainingEventID { get; set; }
		string Name { get; set; }
		string NameInLocalLang { get; set; }
		int TrainingEventTypeID { get; set; }
		string TrainingEventTypeName { get; set; }
		string Justification { get; set; }
		string Objectives { get; set; }
		string ParticipantProfile { get; set; }
		string SpecialRequirements { get; set; }
		int? ProgramID { get; set; }
		int? KeyActivityID { get; set; }
		Int64? TrainingUnitID { get; set; }
		string BusinessUnitAcronym { get; set; }
		string BusinessUnitName { get; set; }
		int? CountryID { get; set; }
		int? PostID { get; set; }
		int? ConsularDistrictID { get; set; }
		int? OrganizerAppUserID { get; set; }
		int? PlannedParticipantCnt { get; set; }
		int? PlannedMissionDirectHireCnt { get; set; }
		int? PlannedNonMissionDirectHireCnt { get; set; }
		int? PlannedMissionOutsourceCnt { get; set; }
		int? PlannedOtherCnt { get; set; }
		decimal? EstimatedBudget { get; set; }
		int? EstimatedStudents { get; set; }
		int? FundingSourceID { get; set; }
		int? AuthorizingLawID { get; set; }
        string Comments { get; set; }

        List<SaveTrainingEventLocation_Item> TrainingEventLocations { get; set; }
		List<SaveTrainingEventUSPartnerAgency_Item> TrainingEventUSPartnerAgencies { get; set; }
		List<SaveTrainingEventProjectCode_Item> TrainingEventProjectCodes { get; set; }
	}
}