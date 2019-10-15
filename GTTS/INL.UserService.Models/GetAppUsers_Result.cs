using System.Collections.Generic;

namespace INL.UserService.Models
{
    public class GetAppUsers_Result : IGetAppUsers_Result
    {
        public List<IAppUser_Item> AppUsers { get; set; }
    }
}
