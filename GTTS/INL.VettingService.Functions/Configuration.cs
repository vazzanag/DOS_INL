using INL.Functions;

namespace INL.VettingService.Functions
{
    public class Configuration : ConfigurationBase
	{
		public string INLVettingServiceConnectionString;
		public string INLVettingServiceAppid;
		public string INLVettingServiceAppkey;

		public string INLUserServiceURL;
		public string INLUserServiceAppid;

        public string INLDocumentServiceURL;
        public string INLDocumentServiceAppid;

        public string INLTrainingServiceURL;
        public string INLTrainingServiceAppid;

		public string INLMessagingServiceURL;
		public string INLMessagingServiceAppid;
	}
}
