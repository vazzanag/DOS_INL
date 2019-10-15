using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventUSPartnerAgency_Item : ISaveTrainingEventUSPartnerAgency_Item
    {
		public int AgencyID { get; set; }
		public string Name { get; set; }
	}
}
