using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Services.Models
{
    public interface IBaseResult
    {
        List<string> ErrorMessages { get; set; }
        bool IsValid();
    }
}
