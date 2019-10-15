using System;
using System.Collections.Generic;
using System.Text;
using INL.ReferenceService.Data;

namespace INL.ReferenceService.Models
{
    public class TrainingReferences_Item
    {
        public IEnumerable<KeyActivities_Item> KeyActivities { get; set; }
        public IEnumerable<TrainingEventTypes_Item> EventTypes { get; set; }
        public IEnumerable<USPartnerAgencies_Item> PartnerAgencies { get; set; }
        public IEnumerable<ProjectCodes_Item> ProjectCodes { get; set; }
        public IEnumerable<BusinessUnits_Item> BusinessUnits { get; set; }
        public IEnumerable<Countries_Item> Countries { get; set; }
        public IEnumerable<States_Item> States { get; set; }
        public IEnumerable<IAAs_Item> IAAs { get; set; }
        public IEnumerable<AppUsers_Item> AppUsers { get; set; }
        public IEnumerable<VisaStatus_Item> VisaStatuses { get; set; }
    }
}
