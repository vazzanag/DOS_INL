using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class GetUSPartnerAgenciesAtBusinessUnit_Item : IGetUSPartnerAgenciesAtBusinessUnit_Item
    {
        public int AgencyID { get; set; }
        public string Name { get; set; }
        public long BusinessUnitID { get; set; }
        public string Acronym { get; set; }
        public string BusinessUnitName { get; set; }
        public bool BusinessUnitActive { get; set; }
        public bool USPartnerAgenciesBusinessUnitActive { get; set; }
    }
}
