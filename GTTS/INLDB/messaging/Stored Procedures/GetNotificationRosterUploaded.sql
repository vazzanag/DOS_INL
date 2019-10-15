CREATE PROCEDURE [messaging].[GetNotificationRosterUploaded]
    @TrainingEventID BIGINT,
    @UploadedByAppUserID INT
AS
BEGIN

    SELECT TrainingEventID, [Name], OrganizerAppUserID, StakeholdersJSON, KeyParticipantsJSON, UnsatisfactoryParticipantsJSON,
           (SELECT FullName FROM users.AppUsersView WHERE AppUserID = @UploadedByAppUserID) AS UploadedBy
      FROM messaging.NotificationRosterUploadedView
     WHERE TrainingEventID = @TrainingEventID;

END;
