CREATE PROCEDURE [dbo].[PROTOTYPE_JSON]
	@json nvarchar(max)
AS
BEGIN
	Declare @BusinessUnits nvarchar(max);
	Declare @userId int;
	--Declare @bu Table (userid int, buid int);

	
	select @BusinessUnits = json.BusinessUnits
	  from openjson(@json)
	  with (BusinessUnits nvarchar(max) as json) json

	select @BusinessUnits as '@BusinessUnits';

	select @userId = json.AppUserID
	  from openjson(@json)
	  with (AppUserID int) json

	select @userId as '@userId';

	--insert into @bu
	--select json.BusinessUnitID, @userid
	--from OPENJSON(@BusinessUnits)
	--with (BusinessUnitID int) json;

	select *, @BusinessUnits AS 'Derrived' from OPENJSON(@json)
	with
	(
		AppUserID int, ADOID nvarchar(100), First nvarchar(33), Middle nvarchar(33), Last nvarchar(33),EmailAddress nvarchar(75)
	) as json

	select * from OPENJSON(@BusinessUnits)
	with ( BusinessUnitID int, BusinessUnit nvarchar(100) ) as json

	Update users.AppUsers set
		   ADOID = json.ADOID,
		   First = json.First,
		   Middle = json.Middle,
		   Last = json.Last,
		   EmailAddress = json.EmailAddress,
		   ModifiedByAppUserID = 3,
		   ModifiedDate = GETDATE()
	from OPENJSON(@json)
	with
	(
		AppUserID int, ADOID nvarchar(100), First nvarchar(33), Middle nvarchar(33), Last nvarchar(33),EmailAddress nvarchar(75)
	) as json
	where users.AppUsers.AppUserID = json.AppUserID

	-- FORCE AN INSERT
	delete from users.[AppUserBusinessUnits] where AppUserID = @userid

	insert into users.[AppUserBusinessUnits]
	(AppUserID, BusinessUnitID, ModifiedByAppUserID, ModifiedDate)
	select @userid, json.BusinessUnitID, @userId, GETDATE()
	  from OPENJSON(@BusinessUnits)
	  with (BusinessUnitID int) json
	 where not exists(select AppUserID from users.[AppUserBusinessUnits] where AppUserID = @userid and BusinessUnitID = json.BusinessUnitID);

	-- SHOW DATA
	select * from users.AppUsers where AppUserID = @userId
	select * from users.[AppUserBusinessUnits] where AppUserID = @userId

END
