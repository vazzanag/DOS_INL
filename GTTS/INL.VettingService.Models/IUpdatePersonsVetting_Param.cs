using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
    public interface IUpdatePersonsVetting_Param
    {
        long PersonsVettingID { get; set; }
        long PersonUnitLibraryInfoID { get; set; }
        long ModifiedAppUserID { get; set; }
    }
}
