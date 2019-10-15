using System;
using System.Collections.Generic;
using System.Text;

namespace INL.DocumentService.Client.Models
{
    public class GetDocument_Result
	{
		public long FileID { get; set; }
		public string FileName { get; set; }
		public int FileSize { get; set; }
		public byte[] FileHash { get; set; }
		public byte[] FileContent { get; set; }
		public int ModifiedByAppUserID { get; set; }
	}
}
