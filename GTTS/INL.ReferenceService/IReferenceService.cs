using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using INL.ReferenceService.Models;

namespace INL.ReferenceService
{
	public interface IReferenceService
    {
        TrainingReference_Result GetTrainingReferences();
        ReferenceTables_Results GetReferences(IGetReferenceTable_Param param);
    }
}
