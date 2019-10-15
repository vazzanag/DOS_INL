using INL.Services;
using INL.VettingService.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.VettingService.Client
{
    public class VettingServiceClientJsonConvertor : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            {
                JsonConverters.Add(new GenericJsonConverter<IPersonVetting_Item, PersonVetting_Item>());
                JsonConverters.Add(new GenericJsonConverter<IPersonVettingHit_Item, PersonVettingHit_Item>());
                JsonConverters.Add(new GenericJsonConverter<IPersonVettingType_Item, PersonVettingType_Item>());
                JsonConverters.Add(new GenericJsonConverter<IVettingBatch_Item, VettingBatch_Item>());
                JsonConverters.Add(new GenericJsonConverter<IGetPersonsVetting_Item, GetPersonsVetting_Item>());
                JsonConverters.Add(new GenericJsonConverter<IGetPersonsVettings_Result, GetPersonsVettings_Result>());
                JsonConverters.Add(new GenericJsonConverter<IVettingBatchComment_Item, VettingBatchComment_Item>());
                JsonConverters.Add(new GenericJsonConverter<IPersonVettingVettingType_Item, PersonVettingVettingType_Item>());
                JsonConverters.Add(new GenericJsonConverter<ICancelVettingBatch_Result, CancelVettingBatch_Result>());
            }
        }
    }
}