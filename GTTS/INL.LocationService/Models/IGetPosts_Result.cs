using System.Collections.Generic;

namespace INL.LocationService.Models
{
	public interface IGetPosts_Result
	{
		List<Post_Item> Collection { get; set; }
	}
}