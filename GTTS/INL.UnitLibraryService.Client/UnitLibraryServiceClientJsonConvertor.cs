using INL.Services;
using INL.UnitLibraryService.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace INL.UnitLibraryService.Client
{
    public class UnitLibraryServiceClientJsonConvertor : CustomJsonConvertor
    {
        public override void AddJsonConvertors()
        {
            {
                JsonConverters.Add(new GenericJsonConverter<IUnit_Item, Unit_Item>());
            }
        }
    }
}
