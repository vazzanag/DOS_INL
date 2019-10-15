using INL.Services.Models;

namespace INL.PersonService.Models
{
    public interface IGetPersonUnit_Result : IBaseResult
	{
        IPersonUnit_Item Item { get; set; }
	}
}
