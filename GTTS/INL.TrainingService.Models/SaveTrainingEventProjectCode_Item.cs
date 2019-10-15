using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class SaveTrainingEventProjectCode_Item : ISaveTrainingEventProjectCode_Item
    {
		public int ProjectCodeID { get; set; }
		public string Name { get; set; }
		public string Code { get; set; }
	}
}
