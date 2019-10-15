using INL.Functions;

namespace INL.PersonService.Functions
{
    public class Configuration : ConfigurationBase
    {
        public string INLPersonServiceConnectionString;
		public string INLPersonServiceAppid;
		public string INLPersonServiceAppkey;

		public string INLLocationServiceURL;
		public string INLLocationServiceAppid;

		public string INLUserServiceURL;
		public string INLUserServiceAppid;

		public string INLTrainingServiceURL;
		public string INLTrainingServiceAppid;

		public string INLVettingServiceURL;
		public string INLVettingServiceAppid;

        public string INLDocumentServiceURL;
        public string INLDocumentServiceAppid;
    }
}
