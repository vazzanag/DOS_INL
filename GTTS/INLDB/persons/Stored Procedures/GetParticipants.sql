/* 
-This procedure gets a paged list of event participants based 
on the pageNumber and RowspPage values that are passed
-Created on 09/04/2018
-Updated on 09/04/2018
*/
CREATE PROCEDURE persons.GetParticipants
@trainingEventID int,
@PageNumber int,
@RowspPage int
AS
BEGIN
    SELECT p.[PersonID],
	p.[GivenName],
	p.[MiddleName1], 
	p.[MiddleName2],
	p.[MiddleName3],
	p.[FamilyName],
	p.[Gender],
	u.[Name] AS Agency,
	p.[NationalID],
	p.[DOB],	
	jt.[Name] AS JobTitle,
	p.[Rank]--,	
	--te.DepartureDate,
	--te.ReturnDate,
	--te.DepartureCity,
	--p.Email,
	--pv.Vetting,
	--p.Visa,
	--Documents
	Status
      FROM persons.Persons p
	  --JOIN persons.PersonsTrainingEvents pt
	  --ON p.PersonID = pt.PersonID
	  --JOIN training.TrainingEvents te
	  --ON pt.TrainingEventID = te.TrainingEventID
	  --LEFT JOIN persons.PersonsVetting pv
	  --ON p.PersonID = pv.PersonID
	  LEFT JOIN persons.JobTitles jt
	  ON p.JobTitleID = jt.JobTitleID
	  LEFT JOIN unitlibrary.Units u
	  ON p.UnitID = u.UnitID
  --WHERE pt.TrainingEventID = @trainingEventID
  ORDER BY [GivenName]
  --OFFSET ((@PageNumber - 1) * @RowspPage) ROWS
  --FETCH NEXT @RowspPage ROWS ONLY
  ;
END
