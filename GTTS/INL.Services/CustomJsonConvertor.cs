using Newtonsoft.Json;
using System.Collections.Generic;

namespace INL.Services
{
    public abstract class CustomJsonConvertor
    {
        private List<JsonConverter> jsonConverters;
        public List<JsonConverter> JsonConverters
        {
            get
            {
                if (jsonConverters == null)
                {
                    jsonConverters = new List<JsonConverter>();
                    AddJsonConvertors();
                }

                return jsonConverters;
            }
        }

        public abstract void AddJsonConvertors();
    }
}
