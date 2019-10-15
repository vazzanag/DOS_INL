using System;
using System.Collections.Generic;
using System.Text;

namespace INL.ReferenceService.Models
{
    public class BusinessUnits_Item
	{
		public long BusinessUnitID { get; set; }
		public int BusinessUnitTypeID { get; set; }
		public string BusinessUnit { get; set; }
		public string Acronym { get; set; }
		public long? BusinessUnitParentID { get; set; }
		public long? UnitLibraryUnitID { get; set; }
        public int? PostID { get; set; }
        public string Description { get; set; }
		public bool IsActive { get; set; }
		public bool IsDeleted { get; set; }
		public bool HasPrograms { get; set; }
		public string LogoFileName { get; set; }
		public string VettingPrefix { get; set; }
		public bool hasDutyToInform { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public DateTime ModifiedDate { get; set; }
	}
}
