using System.Threading.Tasks;
using INL.DocumentService.Client.Models;

namespace INL.DocumentService.Client
{
    public interface IDocumentServiceClient
	{
		Task<GetDocument_Result> GetDocumentAsync(GetDocument_Param getDocumentParam);
		Task<GetDocumentInfo_Result> GetDocumentInfoAsync(GetDocumentInfo_Param getDocumentInfoParam);
		Task<SaveDocument_Result> SaveDocumentAsync(SaveDocument_Param saveDocumentParam);
		Task<DeleteDocument_Result> DeleteDocumentAsync(DeleteDocument_Param deleteDocumentParam);
	}
}
