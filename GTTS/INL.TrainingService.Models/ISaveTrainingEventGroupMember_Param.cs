namespace INL.TrainingService.Models
{
    public interface ISaveTrainingEventGroupMember_Param
    {
        long TrainingEventGroupID { get; set; }
        long PersonID { get; set; }
        long MemberTypeID { get; set; }
        long ModifiedByAppUserID { get; set; }
    }
}
