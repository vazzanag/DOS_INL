using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public interface IGetTrainingEvent_Item
    {
        long TrainingEventID { get; set; }
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
        string KeyActivityName { get; set; }
        long? TrainingUnitID { get; set; }
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
        decimal? ActualBudget { get; set; }
        int? EstimatedStudents { get; set; }
        int? FundingSourceID { get; set; }
        int? AuthorizingLawID { get; set; }
        string Comments { get; set; }
        int? ModifiedByAppUserID { get; set; }
        DateTime? ModifiedDate { get; set; }
        DateTime? TravelStartDate { get; set; }
        DateTime? TravelEndDate { get; set; }
        DateTime? EventStartDate { get; set; }
        DateTime? EventEndDate { get; set; }
        List<ParticipantCount_Item> ParticipantCounts { get; set; }
        int? TrainingEventStatusID { get; set; }
        string TrainingEventStatus { get; set; }
        GetTrainingEventAppUser_Item Organizer { get; set; }
        GetTrainingEventAppUser_Item ModifiedBy { get; set; }

        List<GetTrainingEventLocation_Item> TrainingEventLocations { get; set; }
        List<GetTrainingEventUSPartnerAgency_Item> TrainingEventUSPartnerAgencies { get; set; }
        List<GetTrainingEventProjectCode_Item> TrainingEventProjectCodes { get; set; }
        List<GetTrainingEventStakeholder_Item> TrainingEventStakeholders { get; set; }
        List<GetTrainingEventAttachment_Item> TrainingEventAttachments { get; set; }
        List<GetTrainingCourseDefinitionProgram_Item> TrainingEventCourseDefinitionPrograms { get; set; }
        List<GetTrainingEventKeyActivity_Item> TrainingEventKeyActivities { get; set; }
        List<IAA_Item> IAAs { get; set; }
    }
}
