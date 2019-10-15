using System;
using System.Collections.Generic;
using System.Text;

namespace INL.DocumentService.Client.Models
{
    public class GetDocumentInfo_Param
	{
        public long FileID { get; set; }
		public int? FileVersion { get; set; }
	}
}
