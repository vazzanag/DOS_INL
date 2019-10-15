using System;
using System.Text;
using System.Collections.Generic;

namespace INL.DocumentService.Data
{
    public class BlobMetaDataEntity
    {
        public long FileID { get; set; }
		public int FileVersion { get; set; }
		public string FileName { get; set; }
		public int FileSize { get; set; }
		public byte[] FileHash { get; set; }		
		public int ModifiedByAppUserID { get; set; }

        public BlobMetaDataEntity() { }

        public BlobMetaDataEntity(IDictionary<string, string> metadata)
        {
            this.SetProperties(metadata);
        }

        public IDictionary<string, string> GetProperties()
        {
            IDictionary<string, string> result = new Dictionary<string, string>();
            foreach (var property in this.GetType().GetProperties())
            {
				var value = property.GetValue(this);
				if (value == null) result.Add(property.Name, "");
				else if (value is byte[]) result.Add(property.Name, BitConverter.ToString(value as byte[]).Replace("-", ""));
				else result.Add(property.Name, value.ToString());
            }
            return result;
        }

        public void SetProperties(IDictionary<string, string> metadata)
        {
            if (metadata.ContainsKey("FileID")) this.FileID = Int64.Parse(metadata["FileID"]);
			if (metadata.ContainsKey("FileVersion")) this.FileVersion = Int32.Parse(metadata["FileVersion"]);
			if (metadata.ContainsKey("FileName")) this.FileName = metadata["FileName"];
			if (metadata.ContainsKey("FileSize")) this.FileSize = Int32.Parse(metadata["FileSize"]);
			if (metadata.ContainsKey("FileHash")) this.FileHash = Encoding.ASCII.GetBytes(metadata["FileHash"]);
			if (metadata.ContainsKey("ModifiedByAppUserID")) this.ModifiedByAppUserID = Int32.Parse(metadata["ModifiedByAppUserID"]);
        }
    }

}