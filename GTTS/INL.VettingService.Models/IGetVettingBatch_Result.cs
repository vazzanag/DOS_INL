using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Models
{
	public interface IGetVettingBatch_Result
	{
		IVettingBatch_Item Batch { get; set; }
	}
}
