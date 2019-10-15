using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Services.Models
{
    public class BaseParam
    {
        public BaseParam()
        {
            ErrorMessages = new List<string>();
        }
        public List<string> ErrorMessages { get; set; }
        public bool IsValid()
        {
            return ErrorMessages == null || this.ErrorMessages.Count == 0;
        }
    }
}
