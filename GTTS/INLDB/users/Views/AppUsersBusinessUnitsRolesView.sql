CREATE VIEW [users].[AppUsersBusinessUnitsRolesView]
AS
SELECT 
apbu.DefaultBusinessUnit, 
bu.BusinessUnitName, bu.Acronym, 
u.AppUserID, u.First, u.Last, u.Middle, 
r.AppRoleID, r.Code, r.Description
FROM            users.AppUserBusinessUnits AS apbu INNER JOIN
                         users.BusinessUnits AS bu ON bu.BusinessUnitID = apbu.BusinessUnitID INNER JOIN
                         users.AppUsers AS u ON u.AppUserID = apbu.AppUserID INNER JOIN
                         users.AppUserRoles AS ur ON ur.AppUserID = u.AppUserID INNER JOIN
                         users.AppRoles AS r ON r.AppRoleID = ur.AppRoleID
GO