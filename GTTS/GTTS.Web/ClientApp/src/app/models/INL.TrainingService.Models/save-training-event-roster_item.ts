

import { TrainingEventAttendance_Item } from './training-event-attendance_item';

export class SaveTrainingEventRoster_Item  {
  
	public TrainingEventRosterID?: number;
	public TrainingEventID: number = 0;
	public PersonID: number = 0;
	public FirstMiddleNames: string = "";
	public LastNames: string = "";
	public PreTestScore?: number;
	public PostTestScore?: number;
	public PerformanceScore?: number;
	public ProductsScore?: number;
	public AttendanceScore?: number;
	public FinalGradeScore?: number;
	public Certificate?: boolean;
	public MinimumAttendanceMet?: boolean;
	public TrainingEventRosterDistinctionID?: number;
	public TrainingEventRosterDistinction: string = "";
	public NonAttendanceReasonID?: number;
	public NonAttendanceReason: string = "";
	public NonAttendanceCauseID?: number;
	public NonAttendanceCause: string = "";
	public Comments: string = "";
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
	public Attendance?: TrainingEventAttendance_Item[];
  
}






