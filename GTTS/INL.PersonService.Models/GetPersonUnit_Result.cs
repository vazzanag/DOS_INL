using INL.Services.Models;

namespace INL.PersonService.Models
{
    public class GetPersonUnit_Result : BaseResult, IGetPersonUnit_Result
	{
        public IPersonUnit_Item Item { get; set; }
    }
}
