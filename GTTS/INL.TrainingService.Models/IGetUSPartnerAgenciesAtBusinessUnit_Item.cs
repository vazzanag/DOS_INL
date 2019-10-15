using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IGetUSPartnerAgenciesAtBusinessUnit_Item
    {
        int AgencyID { get; set; }
        string Name { get; set; }
        long BusinessUnitID { get; set; }
        string Acronym { get; set; }
        string BusinessUnitName { get; set; }
        bool BusinessUnitActive { get; set; }
        bool USPartnerAgenciesBusinessUnitActive { get; set; }
    }
}
