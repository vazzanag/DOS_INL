using System;
using System.Collections.Generic;
using System.Text;

namespace INL.DocumentService.Client.Models
{
    public class GetDocumentInfo_Result
	{
		public long FileID { get; set; }
		public string FileName { get; set; }
		public int FileSize { get; set; }
		public byte[] FileHash { get; set; }
		public int ModifiedByAppUserID { get; set; }
	}
}
