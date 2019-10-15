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
:r ..\unitlibrary\PostDeployments\USPartnerAgencies_Load.sql
:r ..\training\PostDeployments\TrainingEventTypes_Load.sql
:r ..\files\PostDeployments\FileTypes_Load.sql
:r ..\persons\PostDeployments\PersonAttachmentTypes_Load.sql
:r ..\training\PostDeployments\TrainingEventParticipantTypes_Load.sql

:r .\stories\GTTS-1615.sql
:r .\stories\GTTS-1477.sql
:r .\stories\GTTS-1573.sql
:r .\stories\GTTS-1860.sql
:r .\stories\GTTS-1861.sql
:r .\stories\GTTS-1329.sql
:r .\stories\GTTS-1677.sql
:r .\stories\GTTS-1759.sql
:r .\stories\GTTS-1879.sql
:r .\stories\GTTS-1923.sql
:r .\stories\GTTS-1917.sql
:r .\stories\GTTS-1920.sql
:r .\stories\GTTS-1922.sql
:r .\stories\GTTS-1929.sql
:r .\stories\GTTS-1919.sql
:r .\stories\GTTS-1921.sql
:r .\stories\GTTS-1936.sql
:r .\stories\GTTS-1165.sql -- merge students and instructors into participants table


-- LEAVE THIS LAST
:r .\RebuildIndexes.sql
