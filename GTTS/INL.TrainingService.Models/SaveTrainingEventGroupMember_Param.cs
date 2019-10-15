namespace INL.TrainingService.Models
{
    public class SaveTrainingEventGroupMember_Param : ISaveTrainingEventGroupMember_Param
    {
        public long TrainingEventGroupID { get; set; }
        public long PersonID { get; set; }
        public long MemberTypeID { get; set; }
        public long ModifiedByAppUserID { get; set; }
    }
}
