using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public class UpdatePersonsVetting_Param : IUpdatePersonsVetting_Param
    {
        public long PersonsVettingID { get; set; }
        public long PersonUnitLibraryInfoID { get; set; }
        public long ModifiedAppUserID { get; set; }
    }
}
