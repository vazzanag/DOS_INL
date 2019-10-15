using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using INL.TrainingService.Data;
using INL.DocumentService.Data;

namespace INL.UnitTests
{
    public static class MockData
    {
        public static SaveTrainingEventAttachmentEntity TrainingEventAttachmentMock()
        {
            return new SaveTrainingEventAttachmentEntity
            {
                FileID = 1,
                FileVersion = 1,
                TrainingEventAttachmentTypeID = 1,
                Description = "MockAttachment",
                IsDeleted = false,
                ModifiedByAppUserID = 1
            };
        }

        public static SaveTrainingEventEntity TrainingEventMock()
        {
            return new SaveTrainingEventEntity
            {
                Name = "MockEvent",
                NameInLocalLang = "MockNameInLocalLang",
                TrainingEventTypeID = 1,
                TrainingUnitID = 1,
                ModifiedByAppUserID = 1
            };
        }

        public static SaveFileEntity FileMock()
        {
            return new SaveFileEntity
            {
                FileName = "MockFileName",
                FileHash = new byte[] { 0x20 },
                FileLocation = "MockFileLocation",
                ThumbnailPath = "MockThumbnailPath",
                ModifiedByAppUserID = 1
            };
        }
    }
}
