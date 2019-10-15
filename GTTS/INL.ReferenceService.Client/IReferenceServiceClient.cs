using INL.ReferenceService.Models;
using System;
using System.Threading.Tasks;

namespace INL.ReferenceService.Client
{
    public interface IReferenceServiceClient
    {
        Task<ReferenceTables_Results> GetReferences(IGetReferenceTable_Param getReferenceTableParam);
    }
}
