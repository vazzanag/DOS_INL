using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public class Post_Item : IPost_Item
	{
		public int PostID { get; set; }
		public string PostName { get; set; }
		public int? GMTOffset { get; set; }
		public int CountryID { get; set; }
		public string CountryName { get; set; }
		public bool IsActive { get; set; }
	}
}
