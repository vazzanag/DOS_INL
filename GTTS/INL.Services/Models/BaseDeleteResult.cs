namespace INL.Services.Models
{
    public class BaseDeleteResult : BaseResult, IBaseDeleteResult
    {
        public bool Deleted { get; set; }
    }
}
