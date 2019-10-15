using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace INL.Services.Models
{
	public class ServiceException : Exception
	{
		public ServiceException() 
			:base("Unspecified service exception.")
		{

		}

		public ServiceException(string message)
			: base(message)
		{

		}

		public ServiceException(string message, object details)
			: base(message)
		{
			this.Data.Add("ServiceExceptionDetails", details);
		}

		public object GetDetails() 
		{
			if (this.Data.Contains("ServiceExceptionDetails"))
				return this.Data["ServiceExceptionDetails"];
			else
				return null;
		}

	}
}
