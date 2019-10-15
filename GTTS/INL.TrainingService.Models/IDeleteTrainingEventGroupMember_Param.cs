namespace INL.TrainingService.Models
{
    public interface IDeleteTrainingEventGroupMember_Param
    {
        long TrainingEventGroupID { get; set; }
        long PersonID { get; set; }
    }
}
