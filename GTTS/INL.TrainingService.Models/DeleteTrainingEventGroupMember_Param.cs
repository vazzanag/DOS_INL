namespace INL.TrainingService.Models
{
    public class DeleteTrainingEventGroupMember_Param : IDeleteTrainingEventGroupMember_Param
    {
        public long TrainingEventGroupID { get; set; }
        public long PersonID { get; set; }
    }
}
