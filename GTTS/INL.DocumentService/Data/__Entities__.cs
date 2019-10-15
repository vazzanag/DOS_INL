 
  




using System;


namespace INL.DocumentService.Data
{
  


	public interface IFilesViewEntity
	{
	    long FileID { get; set; }
	    string FileName { get; set; }
	    int FileTypeID { get; set; }
	    string FileLocation { get; set; }
	    byte[] FileHash { get; set; }
	    int FileSize { get; set; }
	    int FileVersion { get; set; }
	    string ThumbnailPath { get; set; }
	    DateTime ModifiedDate { get; set; }
	    int ModifiedByAppUserID { get; set; }
	    string FileTypeName { get; set; }
	    string FileTypeExtension { get; set; }
	    string FileTypeDescription { get; set; }
	    bool IsActive { get; set; }

	}

    public class FilesViewEntity : IFilesViewEntity
    {
		public long FileID { get; set; }
		public string FileName { get; set; }
		public int FileTypeID { get; set; }
		public string FileLocation { get; set; }
		public byte[] FileHash { get; set; }
		public int FileSize { get; set; }
		public int FileVersion { get; set; }
		public string ThumbnailPath { get; set; }
		public DateTime ModifiedDate { get; set; }
		public int ModifiedByAppUserID { get; set; }
		public string FileTypeName { get; set; }
		public string FileTypeExtension { get; set; }
		public string FileTypeDescription { get; set; }
		public bool IsActive { get; set; }

    }
      



	public interface IGetFileEntity
    {
        long? FileID { get; set; }
        int? FileVersion { get; set; }

    }

    public class GetFileEntity : IGetFileEntity
    {
		public long? FileID { get; set; }
		public int? FileVersion { get; set; }

    }
      
	public interface ISaveFileEntity
    {
        long? FileID { get; set; }
        string FileName { get; set; }
        byte[] FileHash { get; set; }
        string FileLocation { get; set; }
        int? FileSize { get; set; }
        string ThumbnailPath { get; set; }
        int? ModifiedByAppUserID { get; set; }

    }

    public class SaveFileEntity : ISaveFileEntity
    {
		public long? FileID { get; set; }
		public string FileName { get; set; }
		public byte[] FileHash { get; set; }
		public string FileLocation { get; set; }
		public int? FileSize { get; set; }
		public string ThumbnailPath { get; set; }
		public int? ModifiedByAppUserID { get; set; }

    }
      





}



