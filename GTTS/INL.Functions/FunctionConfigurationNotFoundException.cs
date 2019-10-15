using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Functions
{
    public class FunctionConfigurationNotFoundException : Exception
    {
		public FunctionConfigurationNotFoundException(string fieldName) 
			: base($"Failed to load configuration key {fieldName}.")
		{

		}
    }
}
