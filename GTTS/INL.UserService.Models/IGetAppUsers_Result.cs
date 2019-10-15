using System.Collections.Generic;

namespace INL.UserService.Models
{
    public interface IGetAppUsers_Result
    {
        List<IAppUser_Item> AppUsers { get; set; }
    }
}
