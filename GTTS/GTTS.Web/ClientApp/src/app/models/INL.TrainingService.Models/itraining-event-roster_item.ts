


import { TrainingEventAttendance_Item } from './training-event-attendance_item';

export interface ITrainingEventRoster_Item {
  
	TrainingEventRosterID?: number;
	TrainingEventID: number;
	PersonID: number;
	FirstMiddleNames: string;
	LastNames: string;
	PreTestScore?: number;
	PostTestScore?: number;
	PerformanceScore?: number;
	ProductsScore?: number;
	AttendanceScore?: number;
	FinalGradeScore?: number;
	Certificate?: boolean;
	MinimumAttendanceMet?: boolean;
	TrainingEventRosterDistinctionID?: number;
	TrainingEventRosterDistinction: string;
	NonAttendanceReasonID?: number;
	NonAttendanceReason: string;
	NonAttendanceCauseID?: number;
	NonAttendanceCause: string;
	Comments: string;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	Attendance?: TrainingEventAttendance_Item[];
}





