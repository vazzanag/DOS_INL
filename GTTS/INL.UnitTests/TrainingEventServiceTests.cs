using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json;
using System.IO;

using INL.TrainingService.Data;
using INL.DocumentService.Data;
using System.Data.SqlClient;
using INL.TrainingService;
using INL.TrainingService.Models;
using System;

namespace INL.UnitTests
{
    [TestClass]
    public class TrainingEventServiceTests
    {
        private ITrainingRepository trainingRepository = null;
        private IDocumentRepository documentRepository = null;
        private ITrainingService trainingService = null;

        public TrainingEventServiceTests()
        {
            dynamic config = JsonConvert.DeserializeObject(File.ReadAllText("local.settings.json"));

            var sqlConnectionString = new SqlConnection(config["SQLConnectionString"].Value);

            trainingRepository = new TrainingRepository(sqlConnectionString);
            documentRepository = new DocumentRepository(sqlConnectionString);
        }


    }
}
