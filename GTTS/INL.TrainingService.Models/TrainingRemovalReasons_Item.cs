namespace INL.TrainingService.Models
{
    public class TrainingRemovalReasons_Item
    {
        public int RemovalReasonID { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }
        public byte SortControl { get; set; }
    }
}
