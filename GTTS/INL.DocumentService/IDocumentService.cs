using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Text;
using INL.DocumentService.Models;

namespace INL.DocumentService
{
	public interface IDocumentService
	{
		Task<GetDocument_Result> GetDocumentAsync(GetDocument_Param getDocumentParam);
		Task<GetDocumentInfo_Result> GetDocumentInfoAsync(GetDocumentInfo_Param getDocumentParam);
		Task<SaveDocument_Result> SaveDocumentAsync(SaveDocument_Param saveDocumentParam);
		Task<DeleteDocument_Result> DeleteDocumentAsync(DeleteDocument_Param deleteDocumentParam);
    }
}
