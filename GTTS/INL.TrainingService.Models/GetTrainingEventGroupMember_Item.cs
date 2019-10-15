namespace INL.TrainingService.Models
{
    public class GetTrainingEventGroupMember_Item
    {
        public int Ordinal { get; set; }
        public long TrainingEventGroupID { get; set; }
        public string GroupName { get; set; }
        public long PersonID { get; set; }
        public string FirstMiddleNames { get; set; }
        
        public string LastNames { get; set; }
        public long TrainingEventID { get; set; }
        public string TrainingEventName { get; set; }
        public long MemberTypeID { get; set; }
        public string MemberType { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
