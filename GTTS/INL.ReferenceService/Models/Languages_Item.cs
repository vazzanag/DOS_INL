﻿using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class Languages_Item
	{
		public int LanguageID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
