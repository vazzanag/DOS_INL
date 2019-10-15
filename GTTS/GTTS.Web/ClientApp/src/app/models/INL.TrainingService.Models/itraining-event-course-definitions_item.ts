



export interface ITrainingEventCourseDefinitions_Item {
  
	TrainingEventCourseDefinitionID: number;
	TrainingEventID: number;
	CourseDefinitionID?: number;
	CourseRosterKey: string;
	TestsWeighting?: number;
	PerformanceWeighting?: number;
	ProductsWeighting?: number;
	MinimumAttendance?: number;
	MinimumFinalGrade?: number;
	IsActive: boolean;
	CourseDefinition: string;
	CourseProgram: string;
	PerformanceRosterUploaded: boolean;
	PerformanceRosterUploadedByAppUserID?: number;
	PerformanceRosterUploadedByFirstName: string;
	PerformanceRosterUploadedByLastName: string;
	PerformanceRosterUploadedDate?: Date;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
}





