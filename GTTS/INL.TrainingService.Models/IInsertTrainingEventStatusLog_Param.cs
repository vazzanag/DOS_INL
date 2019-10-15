using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public interface IInsertTrainingEventStatusLog_Param
	{
		long? TrainingEventID { get; set; }
		string TrainingEventStatus { get; set; }
		string ReasonStatusChanged { get; set; }
		int? ModifiedByAppUserID { get; set; }
	}
}
