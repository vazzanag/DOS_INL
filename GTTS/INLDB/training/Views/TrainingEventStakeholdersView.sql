CREATE VIEW training.TrainingEventStakeholdersView
AS
    SELECT s.TrainingEventID, s.AppUserID,
           u.[First], u.[Middle], u.[Last], FullName,
		   u.PositionTitle, u.EmailAddress, u.PhoneNumber
      FROM training.TrainingEventStakeholders s
INNER JOIN users.AppUsersView u 
		ON s.AppUserID = u.AppUserID;