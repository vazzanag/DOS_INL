

import { ISaveTrainingEventCourseDefinition_Param } from './isave-training-event-course-definition_param';

export class SaveTrainingEventCourseDefinition_Param implements ISaveTrainingEventCourseDefinition_Param {
  
	public TrainingEventID: number = 0;
	public CourseDefinitionID?: number;
	public TestsWeighting?: number;
	public PerformanceWeighting?: number;
	public ProductsWeighting?: number;
	public MinimumAttendance?: number;
	public MinimumFinalGrade?: number;
	public IsActive: boolean = false;
  
}






