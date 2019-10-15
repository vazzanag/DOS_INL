namespace INL.TrainingService.Models
{
    public class TrainingRemovalCauses_Item
    {
        public int RemovalCauseID { get; set; }
        public int RemovalReasonID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
    }
}
