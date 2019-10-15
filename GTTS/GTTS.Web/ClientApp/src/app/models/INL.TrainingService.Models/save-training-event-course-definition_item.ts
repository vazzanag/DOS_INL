


export class SaveTrainingEventCourseDefinition_Item  {
  
	public TrainingEventCourseDefinitionID: number = 0;
	public TrainingEventID: number = 0;
	public CourseDefinitionID?: number;
	public CourseRosterKey: string = "";
	public TestsWeighting?: number;
	public PerformanceWeighting?: number;
	public ProductsWeighting?: number;
	public MinimumAttendance?: number;
	public MinimumFinalGrade?: number;
	public IsActive: boolean = false;
	public CourseDefinition: string = "";
	public CourseProgram: string = "";
	public PerformanceRosterUploaded: boolean = false;
	public PerformanceRosterUploadedByAppUserID?: number;
	public PerformanceRosterUploadedByFirstName: string = "";
	public PerformanceRosterUploadedByLastName: string = "";
	public PerformanceRosterUploadedDate?: Date;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}






