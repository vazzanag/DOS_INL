using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace INL.DocumentService.Models
{
    public class SaveDocument_Param
	{
		public long FileID { get; set; }
        public string FileName { get; set; }
        public string Context { get; set; }
		public int ModifiedByAppUserID { get; set; }
        public byte[] FileContent { get; set; }
	}
}
