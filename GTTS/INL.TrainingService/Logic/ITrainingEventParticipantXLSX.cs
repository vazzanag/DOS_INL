using System.Collections.Generic;
using System.IO;
using INL.TrainingService.Models;

namespace INL.TrainingService.Logic
{
	public interface ITrainingEventParticipantXLSX
	{
		List<TrainingEventParticipantXLSX_Item> Save(Stream stream, long trainingEventID, int modifiedByAppUserID);
	}
}