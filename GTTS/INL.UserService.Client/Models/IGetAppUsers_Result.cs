using INL.Services.Models;
using System.Collections.Generic;

namespace INL.UserService.Client.Models
{
    public interface IGetAppUsers_Result : IBaseResult
    {
        List<IAppUser_Item> AppUsers { get; set; }
    }
}
