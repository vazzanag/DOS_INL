using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System.IO;

using INL.TrainingService.Data;
using INL.DocumentService.Data;
using System.Data.SqlClient;

namespace INL.UnitTests
{
    [TestClass]
    public class DatabaseOperationTests
    {
        private ITrainingRepository trainingRepository = null;
        private IDocumentRepository documentRepository = null;

        public DatabaseOperationTests()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));

            var sqlConnectionString = new SqlConnection(config["ConnectionString"].Value);

            trainingRepository = new TrainingRepository(sqlConnectionString);
            documentRepository = new DocumentRepository(sqlConnectionString);
        }

        [TestMethod]
        public void TestSaveAndGet()
        {
            var trainingEventEntityMock = MockData.TrainingEventMock();

            var savedTrainingEntity = trainingRepository.TrainingEventsRepository.Save(trainingEventEntityMock);

            Assert.IsTrue(savedTrainingEntity != null, "Saving Training Event Failed.");

            var fileEntityMock = MockData.FileMock();
            var savedFileEntity = documentRepository.FilesRepository.Save(fileEntityMock);

            Assert.IsTrue(savedFileEntity != null, "Saving File Failed.");

            var getFileByIDAndVersion = documentRepository.GetFileByIDAndVersionAsync(savedFileEntity.FileID, savedFileEntity.FileVersion);

            Assert.IsTrue(getFileByIDAndVersion != null, "Getting File By FileId and FileVerion Failed.");

            var traingEventAttachmentMock = MockData.TrainingEventAttachmentMock();

            traingEventAttachmentMock.TrainingEventID = savedTrainingEntity.TrainingEventID;
            traingEventAttachmentMock.FileID = savedFileEntity.FileID;

            var savedTrainingEventAttachment = trainingRepository.TrainingEventAttachmentsRepository.Save(traingEventAttachmentMock);

            Assert.IsTrue(savedTrainingEventAttachment != null, "Saving Training Event Attachment Failed.");

            var trainingEventAttachmentsByEventId = trainingRepository.TrainingEventAttachmentsRepository.GetByParentId(savedTrainingEntity.TrainingEventID);

            Assert.IsTrue(trainingEventAttachmentsByEventId != null, "There must be Training Event Attachment with TrainingEventID : " + savedTrainingEntity.TrainingEventID.ToString());
        }
    }
}
