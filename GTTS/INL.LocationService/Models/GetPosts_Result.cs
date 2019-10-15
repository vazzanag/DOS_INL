using System;
using System.Collections.Generic;
using System.Text;

namespace INL.LocationService.Models
{
	public class GetPosts_Result : IGetPosts_Result
	{
		public List<Post_Item> Collection { get; set; }
	}
}
