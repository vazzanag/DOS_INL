using INL.Functions;

namespace INL.MessagingService.Functions
{
    public class Configuration : ConfigurationBase
    {
        public string INLMessagingServiceConnectionString;
		public string INLMessagingServiceAppid;
		public string INLMessagingServiceAppkey;

		public string INLDocumentServiceURL;
		public string INLDocumentServiceAppid;

		public string INLUserServiceURL;
		public string INLUserServiceAppid;

		public string INLVettingServiceURL;
		public string INLVettingServiceAppid;

		public string GTTSWebsiteURL;
    }
}
