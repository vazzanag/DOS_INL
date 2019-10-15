using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Services.Models
{
    public class BaseResult : IBaseResult
    {
        public List<string> ErrorMessages { get; set; }
        public virtual bool IsValid()
        {
            return ErrorMessages != null && ErrorMessages.Count > 0;
        }
    }
}
