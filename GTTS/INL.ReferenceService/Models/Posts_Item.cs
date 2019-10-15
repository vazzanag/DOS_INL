using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class Posts_Item
	{
		public int PostID { get; set; }
		public string Name { get; set; }
		public string FullName { get; set; }
		public int PostTypeID { get; set; }
		public int CountryID { get; set; }
		public int MissionID { get; set; }
		public int? GMTOffset { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
	}
}
