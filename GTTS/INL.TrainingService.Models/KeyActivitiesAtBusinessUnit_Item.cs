using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class KeyActivitiesAtBusinessUnit_Item : IKeyActivitiesAtBusinessUnit_Item
    {
        public int KeyActivityID { get; set; }
        public string Code { get; set; }
        public long BusinessUnitID { get; set; }
        public string Acronym { get; set; }
        public string BusinessUnitName { get; set; }
        public bool BusinessUnitActive { get; set; }
        public bool KeyActivityBusinessUnitActive { get; set; }
    }
}
