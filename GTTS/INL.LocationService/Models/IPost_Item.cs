using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	interface IPost_Item
	{
		int PostID { get; set; }
		string PostName { get; set; }
		int? GMTOffset { get; set; }
		int CountryID { get; set; }
		string CountryName { get; set; }
		bool IsActive { get; set; }
	}
}
