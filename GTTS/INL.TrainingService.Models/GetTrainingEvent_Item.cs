using System;
using System.Collections.Generic;

namespace INL.TrainingService.Models
{
    public class GetTrainingEvent_Item : IGetTrainingEvent_Item
    {
        public long TrainingEventID { get; set; }
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
        public string KeyActivityName { get; set; }
        public long? TrainingUnitID { get; set; }
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
        public decimal? ActualBudget { get; set; }
        public int? EstimatedStudents { get; set; }
        public int? FundingSourceID { get; set; }
        public int? AuthorizingLawID { get; set; }
        public string Comments { get; set; }
        public int? ModifiedByAppUserID { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? TravelStartDate { get; set; }
        public DateTime? TravelEndDate { get; set; }
        public DateTime? EventStartDate { get; set; }
        public DateTime? EventEndDate { get; set; }
        public List<ParticipantCount_Item> ParticipantCounts { get; set; }
        public int? TrainingEventStatusID { get; set; }
        public string TrainingEventStatus { get; set; }
        public GetTrainingEventAppUser_Item Organizer { get; set; }
        public GetTrainingEventAppUser_Item ModifiedBy { get; set; }

        public List<GetTrainingEventLocation_Item> TrainingEventLocations { get; set; }
        public List<GetTrainingEventUSPartnerAgency_Item> TrainingEventUSPartnerAgencies { get; set; }
        public List<GetTrainingEventProjectCode_Item> TrainingEventProjectCodes { get; set; }
        public List<GetTrainingEventStakeholder_Item> TrainingEventStakeholders { get; set; }
        public List<GetTrainingEventAttachment_Item> TrainingEventAttachments { get; set; }
        public List<GetTrainingCourseDefinitionProgram_Item> TrainingEventCourseDefinitionPrograms { get; set; }
        public List<GetTrainingEventKeyActivity_Item> TrainingEventKeyActivities { get; set; }
        public List<IAA_Item> IAAs { get; set; }
    }
}
