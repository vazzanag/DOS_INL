using INL.Services;
using INL.TrainingService.Models;

namespace INL.TrainingService.Client
{
    public class TrainingServiceClientJsonConverter : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            {
                JsonConverters.Add(new GenericJsonConverter<IGetPersonsTrainingEvent_Item, GetPersonsTrainingEvent_Item>());
                JsonConverters.Add(new GenericJsonConverter<IGetPersonsTrainingEvents_Result, GetPersonsTrainingEvents_Result>());
            }
        }
    }
}