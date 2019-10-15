"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var ParticipantOverview = /** @class */ (function () {
    function ParticipantOverview() {
        /* Participants */
        this.StudentCount = 0;
        this.InstructorCount = 0;
        this.AlternateCount = 0;
        this.ParticipantCount = 0;
        this.PlannedParticipantCount = 0;
        /* Vetting */
        this.LeahyCount = 0;
        this.CourtesyCount = 0;
        this.NACount = 0;
        this.ApprovedCount = 0;
        this.ApprovedPercentage = 0;
        this.InProgressCount = 0;
        this.InProgressPercentage = 0;
        this.SuspendedCount = 0;
        this.SuspendedPercentage = 0;
        this.CanceledCount = 0;
        this.CanceledPercentage = 0;
        this.RejectedCount = 0;
        this.RejectedPercentage = 0;
        /*  Vetting Chart */
        this.ApprovedDashArray = '';
        this.ApprovedDashOffset = 0;
        this.ApprovedSeperatorDashOffset = 0;
        this.InProgressDashArray = '';
        this.InProgressDashOffset = 0;
        this.InProgressSeperatorDashOffset = 0;
        this.SuspendedDashArray = '';
        this.SuspendedDashOffset = 0;
        this.SuspendedSeperatorDashOffset = 0;
        this.CanceledDashArray = '';
        this.CanceledDashOffset = 0;
        this.CanceledSeperatorDashOffset = 0;
        this.RejectedDashArray = '';
        this.RejectedDashOffset = 0;
        this.RejectedSeperatorDashOffset = 0;
        /* Performance */
        this.AverageFinalGradePercentage = 0;
        this.CompleteCertificatePercentage = 0;
        this.StudentsInRosterCount = 0;
        this.KeyParticipantsCount = 0;
        this.UnsatisfactoryCount = 0;
        this.HasUploadedRoster = false;
    }
    return ParticipantOverview;
}());
exports.ParticipantOverview = ParticipantOverview;
//# sourceMappingURL=participant-overview.js.map