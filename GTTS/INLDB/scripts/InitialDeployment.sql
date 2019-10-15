/*
Post-Deployment Script Template                            
--------------------------------------------------------------------------------------
This file contains SQL statements that will be appended to the build script.        
Use SQLCMD syntax to include a file in the post-deployment script.            
Example:      :r .\myfile.sql                                
Use SQLCMD syntax to reference a variable in the post-deployment script.        
Example:      :setvar TableName MyTable                            
              SELECT * FROM [$(TableName)]                    
--------------------------------------------------------------------------------------
*/
:r ..\users\PostDeployments\AppUsers_Load.sql
:r ..\users\PostDeployments\AppPermissions_Load.sql
:r ..\users\PostDeployments\AppRoles_Load.sql
:r ..\users\PostDeployments\AppRolePermissions_Load.sql
:r ..\users\PostDeployments\AppUserRoles_Load.sql

:r ..\training\PostDeployments\TrainingEventGroupMemberTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventAttachmentTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventInstructorAttachmentTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventStudentAttachmentTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventStatuses_Load.sql
:r ..\training\PostDeployments\RemovalReasons_Load.sql
:r ..\training\PostDeployments\RemovalCauses_Load.sql
:r ..\training\PostDeployments\CourseDefinitionPrograms_Load.sql
:r ..\training\PostDeployments\NonAttendanceCauses_Load.sql
:r ..\training\PostDeployments\NonAttendanceReasons_Load.sql
:r ..\training\PostDeployments\TrainingEventRosterDistinctions_Load.sql
:r ..\training\PostDeployments\VisaStatuses_Load.sql

:r ..\location\PostDeployments\GeoRegions_Load.sql
:r ..\location\PostDeployments\DOSBureaus_Load.sql
:r ..\location\PostDeployments\MissionTypes_Load.sql
:r ..\location\PostDeployments\Missions_Load.sql
:r ..\location\PostDeployments\NameFormats_Load.sql
:r ..\location\PostDeployments\NationalIDFormats_Load.sql
:r ..\location\PostDeployments\Countries_Load.sql
:r ..\location\PostDeployments\PostTypes_Load.sql
:r ..\location\PostDeployments\Posts_Load.sql
:r ..\location\PostDeployments\LanguageProficiencies_Load.sql
:r ..\location\PostDeployments\Languages_Load.sql

:r ..\messaging\PostDeployments\ThreadContextTypes_Load.sql
:r ..\messaging\PostDeployments\NotificationContextTypes_Load.sql
:r ..\messaging\PostDeployments\NotificationAppRoleContextTypes_Load.sql
:r ..\messaging\PostDeployments\NotificationMessages_Load.sql
:r ..\messaging\PostDeployments\NotificationAppRoleContexts_Load.sql

:r ..\unitlibrary\PostDeployments\USPartnerAgencies_Load.sql
:r ..\unitlibrary\PostDeployments\GovtLevels_Load.sql
:r ..\unitlibrary\PostDeployments\ReportingTypes_Load.sql
:r ..\unitlibrary\PostDeployments\UnitLevels_Load.sql
:r ..\unitlibrary\PostDeployments\UnitTypes_Load.sql

:r ..\files\PostDeployments\FileTypes_Load.sql

:r ..\persons\PostDeployments\EducationLevels_Load.sql
:r ..\persons\PostDeployments\JobTitles_Load.sql
:r ..\persons\PostDeployments\PersonAttachmentTypes_Load.sql

:r ..\vetting\PostDeployments\AuthorizingLaws_Load.sql
:r ..\vetting\PostDeployments\VettingPersonStatuses_Load.sql
:r ..\vetting\PostDeployments\VettingBatchTypes_Load.sql
:r ..\vetting\PostDeployments\VettingTypes_Load.sql
:r ..\vetting\PostDeployments\VettingAttachmentTypes_Load.sql
:r ..\vetting\PostDeployments\VettingActivityTypes_Load.sql
:r ..\vetting\PostDeployments\VettingBatchStatuses_Load.sql
:r ..\vetting\PostDeployments\VettingHitCredibilityLevels_Load.sql
:r ..\vetting\PostDeployments\VettingHitReferenceSites_Load.sql
:r ..\vetting\PostDeployments\VettingHitResults_Load.sql
:r ..\vetting\PostDeployments\VettingHitViolationTypes_Load.sql
:r ..\vetting\PostDeployments\VettingLeahyHitAppliesTo_Load.sql
:r ..\vetting\PostDeployments\VettingLeahyHitResults_Load.sql

:r ..\budgets\PostDeployments\BudgetCategories_Load.sql
:r ..\budgets\PostDeployments\BudgetItemTypes_Load.sql

:r ..\unitlibrary\PostDeployments\US_Government_Units_Load.sql