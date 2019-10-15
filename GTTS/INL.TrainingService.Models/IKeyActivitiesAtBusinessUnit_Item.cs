using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IKeyActivitiesAtBusinessUnit_Item
    {
        int KeyActivityID { get; set; }
        string Code { get; set; }
        long BusinessUnitID { get; set; }
        string Acronym { get; set; }
        string BusinessUnitName { get; set; }
        bool BusinessUnitActive { get; set; }
        bool KeyActivityBusinessUnitActive { get; set; }
    }
}
