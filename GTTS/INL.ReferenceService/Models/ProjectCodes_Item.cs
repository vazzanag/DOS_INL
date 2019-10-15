﻿using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class ProjectCodes_Item
	{
		public int ProjectCodeID { get; set; }
		public string Code { get; set; }
		public string Description { get; set; }
		public bool IsActive { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
