CREATE VIEW [dbo].[PROTOTYPE_JSON_Relational_Data_as_JSON]
AS 
select *, 
	(select b.BusinessUnitID, b.BusinessUnitName
	  from users.BusinessUnits b
	  inner join users.[AppUserBusinessUnits] u on b.BusinessUnitID = u.BusinessUnitID
	  where u.AppUserID = usr.AppUserID for json path) BusinessUnits
from users.AppUsers usr;
