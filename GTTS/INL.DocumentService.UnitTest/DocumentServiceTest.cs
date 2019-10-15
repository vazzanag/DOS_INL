// The test methods include in this unit test file requires a TestConfig.json file
// to be placed in the \Repos\Global Training Tracking System\GTTS\INL.DocumentService.UnitTest\bin\Debug folder

using System;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Net;
using System.Security.Cryptography;
using INL.DocumentService;
using INL.DocumentService.Data;
using INL.DocumentService.Models;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json.Linq;
using System.Net.Http;
using System.Collections.Generic;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using Newtonsoft.Json;

namespace INL.DocumentService.UnitTest
{
    [TestClass]
    public class DocumentServiceTest
    {
        private string blobConnectionString = null;
        private string documentConnectionString = null;
        private string containerName = null;
        private string uploadDocumentEndPointUrl = null;
        private string uploadDocumentToEventTrainingEndPointUrl = null;
        private BlobRepository blobRepository = null;
        private DocumentRepository documentRepository = null;
        private DocumentService documentService = null;
        private string testFileURL = null;
        private string firstTestFile = "The pen is mightier than the sword.";
        private string secondTestFile = "Fall seven times, stand up eight.";

        public DocumentServiceTest()
        {
            JObject configObj = JObject.Parse(File.ReadAllText(@"TestConfig.json"));

            blobConnectionString = (string)configObj.GetValue("INLBlobConnectionString");
            documentConnectionString = (string)configObj.GetValue("INLDocumentConnectionString");
            uploadDocumentEndPointUrl = (string)configObj.GetValue("INLUploadDocumentEndPoint");
            uploadDocumentToEventTrainingEndPointUrl = (string)configObj.GetValue("INLUploadDocumentToTrainingEventEndPoint");
            containerName = (string)configObj.GetValue("ContainerName");
            testFileURL = (string)configObj.GetValue("TestFileURL");
            Console.WriteLine("INLBlobConnectionString: " + blobConnectionString);
            Console.WriteLine("INLDocumentConnectionString: " + blobConnectionString);
            Console.WriteLine("INLUploadDocumentEndPoint: " + uploadDocumentEndPointUrl);
            Console.WriteLine("INLUploadDocumentToTrainingEventEndPoint: " + uploadDocumentToEventTrainingEndPointUrl);
            Console.WriteLine("contanerName: " + containerName);

            var sqlConnection = new SqlConnection(documentConnectionString);

            blobRepository = new BlobRepository(blobConnectionString);
            documentRepository = new DocumentRepository(sqlConnection);
            documentService = new DocumentService(documentRepository, blobRepository, null);

        }

        [TestMethod]
        public void TestSaveDocumentService()
        {
            Console.WriteLine("Testing SaveDocumentService ...");
            SaveDocument_Result result = SaveDocument();
            Console.WriteLine("TestSaveDocument returns FileID: {0}; FileVersion: {1}", result.FileID, result.FileVersion);
            Assert.IsTrue(result.FileID > 0, "FileID must be a non-zero integer.");
			Assert.IsTrue(result.FileVersion > 0, "FileVersion must be a non-zero integer.");
		}


        [TestMethod]
        public void TestGetDocumentService()
        {
            Console.WriteLine("Testing GetDocumetService ...");
			SaveDocument_Result result = SaveDocument();
            GetDocument_Result getItem = GetDocument(result.FileID);
            Assert.IsTrue(getItem != null && getItem.FileContent.Length > 0);
        }


        [TestMethod]
        public void TestDeleteDocumentService()
        {
            Console.WriteLine("Testing DeleteDocumetService ...");
			SaveDocument_Result result = SaveDocument();
            bool success = DeleteDocument(result.FileID);
            Assert.IsTrue(success);
        }


        [TestMethod]
        public void TestGenerateSHA265HashUtil()
        {
			Stream httpStream = DownloadPDFFromInternet(testFileURL);
			var content = new byte[httpStream.Length];
			httpStream.ReadAsync(content, 0, content.Length);

			byte[] hash = DocumentService.GenerateSHA256Hash(content);
            Console.WriteLine("TestGenerateSHA256HashUtil - hash size: " + hash.Length);

            Assert.IsTrue(hash.Length == 32);
        }
		

        [TestMethod]
        public void TestVerifyHashUtilMismatch()
		{
			byte[] byteArray1 = Encoding.ASCII.GetBytes(firstTestFile);
			byte[] hash1 = DocumentService.GenerateSHA256Hash(byteArray1);

			byte[] byteArray2 = Encoding.ASCII.GetBytes(secondTestFile);
			byte[] hash2 = DocumentService.GenerateSHA256Hash(byteArray2);

			bool equal1 = DocumentService.VerifySHA256Hash(byteArray1, hash2);

			Assert.IsFalse(equal1);

			bool equal2 = DocumentService.VerifySHA256Hash(byteArray2, hash1);

			Assert.IsFalse(equal2);
        }


        [TestMethod]
        public void TestVerifyHashUtilMatch()
        {
            byte[] byteArray = Encoding.ASCII.GetBytes(firstTestFile);
            byte[] hash = DocumentService.GenerateSHA256Hash(byteArray);
			bool equal = DocumentService.VerifySHA256Hash(byteArray, hash);

			Assert.IsTrue(equal);
        }


        [TestMethod]
        public void TestUploadDocumentFunction()
        {
            int fileID = 0;
            int fileVersion = 0;
            dynamic objResult = MockupForDocumentFunction(uploadDocumentEndPointUrl, false).Result;

            foreach (var item in objResult.Collection)
            {
                    fileID = item.FileID;
                    fileVersion = item.FileVersion;
            }
            Assert.IsTrue(fileID > 0 && fileVersion > 0);
        }


        [TestMethod]
        public void TestUploadDocumentToTrainingEventFunction()
        {
            int fileID = 0;
            int fileVersion = 0;
            int trainingEventAttachmentID = 0;
            dynamic objResult = MockupForDocumentFunction(uploadDocumentToEventTrainingEndPointUrl, true).Result;

             fileID = Convert.ToInt16(objResult["FileID"]);
            trainingEventAttachmentID = Convert.ToInt16(objResult["TrainingEventAttachmentID"]);
            fileVersion = Convert.ToInt16(objResult["FileVersion"]);
            
            Assert.IsTrue(fileID > 0 && fileVersion > 0 && trainingEventAttachmentID > 0);
        }


        private async Task<dynamic> MockupForDocumentFunction(string inEndPointUrl, bool forTrainignEvent)
        {
            // Build mock-up data
            Stream fileContentStream = DownloadPDFFromInternet(testFileURL);
            string fileName = "INL_Test_Doc.pdf";
            string context = "TrainingEvent";
            string description = "INL Dev Unit Test";
            int trainingEventAttachmentTypeID = 1;
            int trainingEventID = 1;
            int fileID = 1;
            int modifiedByAppUserID = 100;
            string jsonResult = null;
            string endPointUrl;

            if (forTrainignEvent)
            {
                // The URL includes a query value, ex. http://localhost:7076/api/v1/trainingevents/{trainingEventID}/documents
                endPointUrl = inEndPointUrl.Replace("{trainingEventID}", Convert.ToString(trainingEventID));
            }
            else
            {
                endPointUrl = inEndPointUrl;
            }

            // Call DocumentService Function to upload document to Blob, and return a FileID
            using (var uploadClient = new HttpClient())
            {
                Dictionary<string, string> parameters = new Dictionary<string, string>();
                parameters.Add("Context", context);
                parameters.Add("FileName", fileName);
                //parameters.Add("FileVersion", Convert.ToString(fileVersion));
                parameters.Add("FileID", Convert.ToString(fileID));
                parameters.Add("ModifiedByAppUserID", Convert.ToString(modifiedByAppUserID));
                if (forTrainignEvent)
                {
                    parameters.Add("Description", description);
                    parameters.Add("TrainingEventAttachmentTypeID", Convert.ToString(trainingEventAttachmentTypeID));
                }

                // Build multipart/form-data request
                MultipartFormDataContent form = new MultipartFormDataContent();
                HttpContent docStream = new StringContent("fileToUpload");
                HttpContent dictionaryItems = new FormUrlEncodedContent(parameters);
                form.Add(docStream, "file");
                form.Add(dictionaryItems, "params");

                docStream = new StreamContent(fileContentStream);
                docStream.Headers.ContentDisposition = new ContentDispositionHeaderValue("form-data")
                {
                    Name = "fileToUpload",
                    FileName = fileName
                };
                form.Add(docStream);

                HttpResponseMessage uploadResponse = null;
                uploadResponse = await uploadClient.PostAsync(endPointUrl, form);

                if (uploadResponse.IsSuccessStatusCode)
                {
                    jsonResult = await uploadResponse.Content.ReadAsStringAsync();
                    Console.WriteLine("http response - " + jsonResult);
                }
                else
                {
                    Console.WriteLine("http error - " + uploadResponse.StatusCode);
                }
            }
            dynamic objResult = JsonConvert.DeserializeObject<dynamic>(jsonResult);

            return objResult;
        }


        private SaveDocument_Result SaveDocument()
        {
            Stream httpStream = DownloadPDFFromInternet(testFileURL);
			var content = new byte[httpStream.Length];
			httpStream.ReadAsync(content, 0, content.Length);

			byte[] fileHash = DocumentService.GenerateSHA256Hash(content);
            var saveDocumentParam = new SaveDocument_Param()
            {
                Context = containerName,
                FileName = "GTTS_Test1.pdf",
                ModifiedByAppUserID = 100,
                FileContent = content,
                FileID = 1,
            };
            SaveDocument_Result result = null;

            try
            {
                result = documentService.SaveDocumentAsync(saveDocumentParam).Result;
            }
            catch (ArgumentException argex)
            {
                Console.WriteLine("in SaveDocument(), ArgumentExcpetion exception is thrown - " + argex.Message);
            }

            return result;
        }


        private GetDocument_Result GetDocument(long fileID)
        {
            var getDocumentParam = new GetDocument_Param()
            {
                FileID = fileID
            };
            GetDocument_Result result = null;

            try
            {
                result = documentService.GetDocumentAsync(getDocumentParam).Result;
            }
            catch (ArgumentException argex)
            {
                Console.WriteLine("in GetDocument(), ArgumentExcpetion exception is thrown - " + argex.Message);
                throw;
            }

            if (result != null)
            {
                Console.WriteLine("GetDocument(), download size -" + result.FileContent.Length);

				return result;
            }

            return null;
        }


        private bool DeleteDocument(long fileID)
        {
            var deleteDocumentParam = new DeleteDocument_Param() { FileID = fileID };
            DeleteDocument_Result result = null;

            try
            {
                result = documentService.DeleteDocumentAsync(deleteDocumentParam).Result;
            }
            catch (ArgumentException argex)
            {
                Console.WriteLine("in DeleteDocument(), ArgumentExcpetion exception is thrown - " + argex.Message);
                throw;
            }

            if (result != null)
            {
                return result.Success;
            }
            return false;
        }


        private Stream DownloadPDFFromInternet(string url)
        {
            Stream stream;
            using (var client = new WebClient())
            {
                var content = client.DownloadData(url);
                stream = new MemoryStream(content);
            }
            return stream;
        }
    }
}
