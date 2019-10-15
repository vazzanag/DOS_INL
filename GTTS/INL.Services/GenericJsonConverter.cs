using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Services
{
    public class GenericJsonConverter<I, C> : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return (objectType == typeof(I));
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            return serializer.Deserialize(reader, typeof(C));
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            serializer.Serialize(writer, value, typeof(C));
        }
    }
}
