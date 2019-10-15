

import { ITrainingEventAttendance_Item } from './itraining-event-attendance_item';

export class TrainingEventAttendance_Item implements ITrainingEventAttendance_Item {
  
	public TrainingEventAttendanceID?: number;
	public TrainingEventRosterID?: number;
	public AttendanceDate: Date = new Date(0);
	public AttendanceIndicator: boolean = false;
	public ModifiedByAppUserID: number = 0;
	public ModifiedDate: Date = new Date(0);
  
}






