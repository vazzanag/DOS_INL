using System;
using System.Collections.Generic;
using System.Text;

namespace INL.Services.Validation
{
    public class ValidationUtility
    {
        public ValidationUtility()
        {
            ErrorMessages = new List<string>();
        }
        public List<string> ErrorMessages { get; set; }
        public void ValidateRequiredNumberic<T>(string propertyName, T propertyValue) where T : System.IComparable
        {
            if (propertyValue.CompareTo(default(T)) <= 0)
            {
                ErrorMessages.Add(propertyName);
            }
        }

        public void ValidateRequiredString(string propertyName, string stringValue)
        {
            if (string.IsNullOrEmpty(stringValue)) ErrorMessages.Add(propertyName);
        }

        public void ValidateRequiredChar(string propertyName, char stringValue)
        {
            if (stringValue == default(char)) ErrorMessages.Add(propertyName);
        }

        public void ValidateRequiredEnumberable<T>(string propertyName, T propertyValue) where T : IEnumerable<object>
        {

        }

        public void Validate()
        {
            if (ErrorMessages.Count > 0)
            {
                throw new System.ArgumentException(
                    "Missing required parameters.",
                    string.Join(", ", ErrorMessages)
                );
            }
        }
    }
}
