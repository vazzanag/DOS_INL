using INL.Services.Models;
using System.Collections.Generic;

namespace INL.UserService.Models
{
    public interface IGetAppUsers_Result : IBaseResult
    {
        List<IAppUser_Item> AppUsers { get; set; }
    }
}
