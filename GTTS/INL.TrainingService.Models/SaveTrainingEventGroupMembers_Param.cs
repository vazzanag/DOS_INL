namespace INL.TrainingService.Models
{
    public class SaveTrainingEventGroupMembers_Param
    {
        public long TrainingEventGroupID { get; set; }
        public long[] PersonIDs { get; set; }
        public long MemberTypeID { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
