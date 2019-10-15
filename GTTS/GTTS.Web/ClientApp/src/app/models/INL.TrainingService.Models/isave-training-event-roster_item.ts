


import { ISaveTrainingEventAttendance_Item } from './isave-training-event-attendance_item';

export interface ISaveTrainingEventRoster_Item {
  
	TrainingEventRosterID?: number;
	TrainingEventID: number;
	PersonID: number;
	PreTestScore?: number;
	PostTestScore?: number;
	PerformanceScore?: number;
	ProductsScore?: number;
	AttendanceScore?: number;
	FinalGradeScore?: number;
	Certificate?: boolean;
	TrainingEventRosterDistinctionID?: number;
	TrainingEventRosterDistinction: string;
	NonAttendanceReasonID?: number;
	NonAttendanceReason: string;
	NonAttendanceCauseID?: number;
	NonAttendanceCause: string;
	Comments: string;
	ModifiedByAppUserID: number;
	ModifiedDate: Date;
	Attendance?: ISaveTrainingEventAttendance_Item[];

}

