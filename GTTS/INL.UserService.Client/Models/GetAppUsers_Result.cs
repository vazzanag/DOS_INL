using INL.Services.Models;
using System.Collections.Generic;

namespace INL.UserService.Client.Models
{
    public class GetAppUsers_Result : BaseResult, IGetAppUsers_Result
    {
        public List<IAppUser_Item> AppUsers { get; set; }
    }
}
