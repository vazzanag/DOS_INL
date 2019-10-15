CREATE VIEW [training].[TrainingEventInstructorsView]
AS
    SELECT s.TrainingEventParticipantID, s.PersonID,ds.CountryID AS DepartureCountryID	,dc.StateID AS DepartureStateID,dc.CityID AS DepartureCityID,s.TrainingEventID,
	       s.IsTraveling,dc.CityName AS DepartureCity,s.DepartureDate,ds.StateName AS DepartureState, s.ReturnDate,
           s.VisaStatusID, v.Code AS VisaStatus, s.PersonsVettingID, s.PaperworkStatusID,s.TravelDocumentStatusID,s.RemovedFromEvent,s.RemovalReasonID, rr.[Description] as RemovalReason, s.RemovalCauseID, rc.[Description] as RemovalCause,
           s.DateCanceled,s.Comments,s.ModifiedByAppUserID,s.ModifiedDate
      FROM [training].[TrainingEventParticipants] s
	  INNER JOIN [training].[TrainingEventParticipantTypes] tpt ON tpt.TrainingEventParticipantTypeID = s.TrainingEventParticipantTypeID
 LEFT JOIN training.RemovalReasons rr				 ON s.RemovalReasonID = rr.RemovalReasonID
 LEFT JOIN training.RemovalCauses rc				 ON s.RemovalCauseID = rc.RemovalCauseID
 LEFT JOIN training.VisaStatuses v                   ON s.VisaStatusID = v.VisaStatusID
 LEFT JOIN [location].Cities dc                      ON s.DepartureCityID = dc.CityID
 LEFT JOIN [location].States ds                      ON dc.StateID = ds.StateID
 WHERE s.TrainingEventParticipantTypeID = 2 -- Instructor
GO
