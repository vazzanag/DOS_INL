using INL.Functions;

namespace INL.DocumentService.Functions
{
    public class Configuration : ConfigurationBase
	{
		public string INLDocumentServiceConnectionString;
		public string INLDocumentServiceAppid;
		public string INLDocumentServiceAppkey;

		public string INLDocumentServiceBlobStorageConnectionString;

		public string INLUserServiceURL;
		public string INLUserServiceAppid;
	}
}
