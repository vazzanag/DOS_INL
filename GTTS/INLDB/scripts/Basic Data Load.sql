USE [INLDB]
GO

-- #### 
-- #### APP USERS
-- #### 
PRINT 'INSERT [users].[AppUsers]';
SET IDENTITY_INSERT [users].[AppUsers] ON
GO
INSERT INTO users.AppUsers
	(AppUserID, ADOID, [First], [Middle], [Last], [ModifiedByAppUserID], PhoneNumber, PositionTitle, CountryID, PostID) 
VALUES 
    (101, '00000000-0000-0000-0000-000000000101', 'Jose', ' ', 'User', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (102, '00000000-0000-0000-0000-000000000102', 'Oscar', 'A', 'Galindo', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (103, '00000000-0000-0000-0000-000000000103', 'Antonio', ' ', 'Oviedo', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (104, '00000000-0000-0000-0000-000000000104', 'Emi', ' ', 'Taguchi', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (105, '00000000-0000-0000-0000-000000000105', 'Tobin', ' ', 'Bradley', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (106, '00000000-0000-0000-0000-000000000106', 'Sheila', ' ', 'Carey', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (107, '00000000-0000-0000-0000-000000000107', 'Leo', ' ', 'Navarrete', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (108, '00000000-0000-0000-0000-000000000108', 'Jose', ' ', 'Wall', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (109, '00000000-0000-0000-0000-000000000109', 'Robert', ' ', 'Arce', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2361, '00000000-0000-0000-0000-000000000010', 'Patrick', ' ', 'Wiley', 1, '(202) 555-1212', 'Developer', 2159, 1083),
    (2362, '00000000-0000-0000-0000-000000000020', 'Elizabeth', ' ', 'Williams', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2363, '00000000-0000-0000-0000-000000000030', 'Claudia', 'C', 'Arjona', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2364, '00000000-0000-0000-0000-000000000040', 'Ann', ' ', 'Dandridge', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2365, '00000000-0000-0000-0000-000000000050', 'Leticia', ' ', 'Padilla', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2366, '00000000-0000-0000-0000-000000000060', 'John', ' ', 'Niedzialek', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2367, '00000000-0000-0000-0000-000000000070', 'Juan', ' ', 'Jacob', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2368, '00000000-0000-0000-0000-000000000080', 'David', ' ', 'Diaz', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2369, '00000000-0000-0000-0000-000000000090', 'Carlos', 'A', 'Padilla', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2370, '00000000-0000-0000-0000-000000000100', 'Leslie', ' ', 'Derewonko', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2371, '00000000-0000-0000-0000-000000000200', 'Diana', ' ', 'Gomez', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (2372, '00000000-0000-0000-0000-000000000300', 'Mauricio', ' ', 'Riveros', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (3366, '00000000-0000-0000-0000-000000000400', 'Test', ' ', 'Praxis', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (3367, '00000000-0000-0000-0000-000000000500', 'Carlos', 'A', 'Rossell Trujillo', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (3368, '00000000-0000-0000-0000-000000000600', 'Todd', ' ', 'Christiansen', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (3369, '00000000-0000-0000-0000-000000000700', 'Test', ' ', 'Praxis 2', 1, '+1 123-456-7890', 'Tester', 2159, 1083),
    (3370, '00000000-0000-0000-0000-000000000800', 'Test', ' ', 'Praxis 3', 1, '+1 123-456-7890', 'Tester', 2159, 1083),
    (3371, '00000000-0000-0000-0000-000000000900', 'Test', ' ', 'Praxis 4', 1, '+1 123-456-7890', 'Tester', 2159, 1083),
    (3372, '00000000-0000-0000-0000-000000001000', 'Test', ' ', 'User', 1, '+1 123-456-7890', 'Tester', 2159, 1083),
    (3373, '00000000-0000-0000-0000-000000002000', 'Arnoldo', ' ', 'Mitre', 1, '+1 123-456-7890', 'Specialist', 2159, 1083),
    (3374, '00000000-0000-0000-0000-000000003000', 'Greg', ' ', 'Chakmakian', 1, '(202) 555-1212', 'Muggle', 2159, 1083)
GO
	
SET IDENTITY_INSERT [users].[AppUsers] OFF
GO
	
-- #### 
-- #### APP USER ROLES
-- #### 
PRINT 'INSERT [users].[AppUserRoles]';
INSERT INTO [users].[AppUserRoles]
	([AppUserID], [AppRoleID], [DefaultRole], [ModifiedByAppUserID])
SELECT u.AppUserID, r.AppRoleID, 0, 1
FROM users.AppUsers u
CROSS JOIN users.AppRoles r

UPDATE [users].[AppUserRoles]
SET DefaultRole = 1
WHERE AppRoleID = 2


-- #### 
-- #### BUSINESS UNITS
-- #### 
SET IDENTITY_INSERT users.BusinessUnits ON
GO

/*  INSERT VALUES into the table    */
INSERT INTO users.BusinessUnits
            (BusinessUnitID,
			PostID,
            BusinessUnitName,
            Acronym,
            Description,
            IsActive,
            IsDeleted,
            VettingPrefix,
            HasDutyToInform,
            ModifiedByAppUserID)
VALUES
    (1,  1083, 'Department of State', 'DOS',  null, 1, 0, 'DOS', 1, 1),
    (2,  1083, 'Bureau for International Narcotics and Law Enforcement Affairs', 'INL', null, 1, 0, 'INL', 1, 1),
    (3,  1083, 'Law Enforcement Programs', 'INL-LEP', null, 1, 0, 'INL', 1, 1),
    (4,  1083, 'Justice', 'INL-JUS', null, 1, 0, 'INL', 1, 1),
    (5,  1083, 'Interdiction', 'INL-INT', null, 1, 0, 'INL', 1, 1),
    (6,  1083, 'Department of Justice', 'DOJ', null, 1, 0, '', 1, 1),
    (7,  1083, 'Criminal Division', 'Criminal', null, 1, 0, '', 1, 1),
    (8,  1083, 'Office of Overseas Prosecutorial Development, Assistance and Training', 'OPDAT', null, 1, 0, 'OPDAT', 1, 1),
    (9,  1083, 'International Criminal Investigative Training Assistance Program', 'ICITAP', null, 1, 0, '', 1, 1),
    (10, 1083, 'Department of Defense', 'DOD', null, 1, 0, 'DOD', 1, 1),
    (11, 1083, 'Anti-terrorism Assistance Program', 'ATA', null, 1, 0, 'ATA', 1, 1),
    (12, 1083, 'Bureau of Alcohol, Tobacco, Firearms, and Explosives', 'ATF', null, 1, 0, 'ATF', 1, 1),
    (13, 1083, 'Federal Bureau of Investigation', 'FBI', null, 1, 0, 'FBI', 1, 1),
    (14, 1083, 'Drug Enforcement Administration', 'DEA', null, 1, 0, 'DEA', 1, 1),
    (15, 1083, 'Export Control and Related Border Security Program', 'EXBS', null, 1, 0, 'EXBS', 1, 1),
    (17, 1083, 'Organization of American States', 'OAS', null, 1, 0, 'OAS', 1, 1),
    (18, 1083, 'Homeland Security Investigations', 'HSI', null, 1, 0, '', 1, 1),
    (19, 1083, 'Police Professionalization', 'INL-PP', null, 1, 0, 'INL', 1, 1),
    (20, 1083, 'Criminal Investigations - Intel Units / Analysts', 'INL-CIT-INTEL', null, 1, 0, 'INL', 1, 1),
    (21, 1083, 'Justice - Rule of Law', 'INL-JUS-ROL', null, 1, 0, 'INL', 1, 1),
    (22, 1083, 'Justice - Culture of Lawfulness', 'INL-JUS-COL', null, 1, 0, 'INL', 1, 1),
    (23, 1083, 'Justice - Drug Demand Reduction', 'INL-JUS-DDR', null, 1, 0, 'INL', 1, 1),
    (24, 1083, 'Interdiction - Canine', 'INL-INT-K9', null, 1, 0, 'INL', 1, 1),
    (25, 1083, 'Interdiction - Border Security', 'INL-INT-BS', null, 1, 0, 'INL', 1, 1),
    (26, 1083, 'Criminal Investigations – Investigators', 'INL-CIT-INV', null, 1, 0, 'INL', 1, 1),
    (27, 1083, 'Criminal Investigations – Forensics', 'INL-CIT-FOR', null, 1, 0, 'INL', 1, 1),
    (28, 1083, 'Criminal Investigations – Money Laundering', 'INL-CIT-ML', null, 1, 0, 'INL', 1, 1),
    (29, 1083, 'Interdiction - Aviation ', 'INL-INT-AVI', null, 1, 0, 'INL', 1, 1),
    (30, 1083, 'Justice - Corrections', 'INL-JUS-COR', null, 1, 0, 'INL', 1, 1),
    (31, 1083, 'Interdiction - IT', 'INL-INT-IT', null, 1, 0, 'INL', 1, 1),
    (32, 1083, 'Public Affairs Section', 'PAS', null, 1, 0, 'PAS', 1, 1),
    (33, 1083, 'Department of Commerce', 'DOC', null, 0, 0, '', 1, 1),
    (34, 1083, 'United States Patent and Trademark Office', 'USPTO',  null, 1, 0, 'USPTO', 1, 1),
    (35, 1083, 'Office to Monitor and Combat Trafficking in Persons', 'J/TIP', null, 1, 0, 'JTIP', 1, 1),
    (36, 1083, 'Policy Unit', 'INL-POL', null, 1, 0, 'INL', 1, 1),
    (37, 1083, 'United States Agency for International Development', 'USAID', null, 1, 0, 'USAID', 1, 1),
    (38, 1083, 'International Criminal Police Organization', 'INTERPOL', null, 1, 0, 'INTERPOL', 1, 1),
    (40, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - USMS', 'OPDAT - USMS', null, 1, 0, 'OPDAT', 1, 1),
    (41, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - Specialized Training', 'OPDAT - SPT', null, 1, 0, 'OPDAT', 1, 1),
    (42, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - TAS', 'OPDAT - TAS', null, 1, 0, 'OPDAT', 1, 1),
    (43, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - AML', 'OPDAT - AML', null, 1, 0, 'OPDAT', 1, 1),
    (44, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - AK', 'OPDAT - AK', null, 1, 0, 'OPDAT', 1, 1),
    (45, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - TIP', 'OPDAT - TIP', null, 1, 0, 'OPDAT', 1, 1),
    (46, 1083, 'Office of Overseas Prosecutorial Development, Assistance and Training - JSI', 'OPDAT - JSI', null, 1, 0, 'OPDAT', 1, 1),
    (47, 1083, 'Office of Defense Coordination', 'ODC', null, 1, 0, 'ODC', 0, 1),
    (48, 1083, 'Defense Attaché Office', 'DAO', null, 1, 0, 'DAO', 0, 1),
    (49, 1083, 'Office of Defense Coordination - Intelligence', 'ODC-Intel', null, 1, 0, 'ODC', 0, 1),
    (50, 1083, 'Office of Defense Coordination - Land/Air', 'ODC-Land/Air', null, 1, 0, 'ODC', 0, 1),
    (51, 1083, 'Office of Defense Coordination - Maritime', 'ODC-Maritime', null, 1, 0, 'ODC', 0, 1),
    (52, 1083, 'Office of Defense Coordination - Training', 'ODC-Training', null, 1, 0, 'ODC', 0, 1),
    (53, 1083, 'Office of Defense Coordination - PATT ', 'ODC-PATT ', null, 1, 0, 'ODC', 0, 1),
    (54, 1083, 'Office of Defense Coordination - HADR', 'ODC-HADR', null, 1, 0, 'ODC', 0, 1),
    (55, 1083, 'US Consulates in Mexico', 'US CONS', null, 1, 0, '', 0, 1),
    (56, 1083, 'US Consulate in Nogales, Sonora', 'Nogales', null, 1, 0, '', 0, 1),
    (57, 1083, 'Bureau of Information Resource Management ', 'IRM', null, 1, 0, 'IRM', 0, 1),
    (58, 1083, 'United Nations', 'UN', null, 1, 0, 'UN', 0, 1),
    (59, 1083, 'FBI-Operational Travel', 'FBI-OT', null, 1, 0, 'FBI', 1, 1),
    (60, 1083, 'DEA-Operational Travel', 'DEA-OT', null, 1, 0, 'DEA', 1, 1),
    (61, 1083, 'HSI-Operational Travel', 'HSI-OT', null, 1, 0, 'HSI', 1, 1),
    (62, 1083, 'Consular Affairs', 'CONS', null, 1, 0, 'CONS', 1, 1)

GO

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT users.BusinessUnits OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('users.BusinessUnits', RESEED, 65)
GO


-- #### 
-- #### USER BUSINESS UNITS
-- #### 
-- #### Give everyone a default of INL and additional business units INL-JUS and INL-INT
PRINT 'INSERT [users].[AppUserBusinessUnits]';
INSERT INTO users.[AppUserBusinessUnits]
	([AppUserID]
      ,[BusinessUnitID]
      ,[DefaultBusinessUnit]
      ,[Writeable]
      ,[ModifiedByAppUserID])
SELECT [AppUserID], [BusinessUnitID], (CASE b.acronym WHEN 'INL' THEN 1 ELSE 0 END), 1, 1
FROM users.BusinessUnits b
CROSS JOIN users.AppUsers u
WHERE b.Acronym IN ('INL', 'INL-JUS', 'INL-INT', 'DEA', 'CONS')



-- ####
-- #### States
-- ####
SET IDENTITY_INSERT [location].[States] ON
GO
 
INSERT INTO [location].[States] 
        ([StateID]
        ,[CountryID]
        ,[StateName]
        ,[StateCodeA2]
        ,[Abbreviation]
        ,[INKCode]
        ,[IsActive]
        ,[ModifiedByAppUserID])
VALUES (1, 2159, N'Aguascalientes', N'AS', N'AGS', N'AGS', 1, 1),
        (2, 2159, N'Baja California', N'BC', N'BC', N'BC', 1, 1),
        (3, 2159, N'Baja California Sur', N'BS', N'BCS', N'BCSR', 1, 1),
        (4, 2159, N'Campeche', N'CC', N'CAMP', N'CAMP', 1, 1),
        (5, 2159, N'Chiapas', N'CS', N'CHIS', N'CHIS', 1, 1),
        (6, 2159, N'Chihuahua', N'CH', N'CHIH', N'CHIH', 1, 1),
        (7, 2159, N'Coahuila', N'CL', N'COAH', N'COAH', 1, 1),
        (8, 2159, N'Colima', N'CM', N'COL', N'COLI', 1, 1),
        (9, 2159, N'Distrito Federal', N'DF', N'DF', N'DF', 1, 1),
        (10, 2159, N'Durango', N'DG', N'DGO', N'DGO', 1, 1),
        (11, 2159, N'Guanajuato', N'GT', N'GTO', N'GTO', 1, 1),
        (12, 2159, N'Guerrero', N'GR', N'GRO', N'GRO', 1, 1),
        (13, 2159, N'Hidalgo', N'HG', N'HGO', N'HGO', 1, 1),
        (14, 2159, N'Jalisco', N'JC', N'JAL', N'JAL', 1, 1),
        (15, 2159, N'Mexico', N'MC', N'MEX', N'MXCO', 1, 1),
        (16, 2159, N'Michoacan', N'MN', N'MICH', N'MCH', 1, 1),
        (17, 2159, N'Morelos', N'MS', N'MOR', N'MOR', 1, 1),
        (18, 2159, N'Nacido en el Extranjero', N'NE', N'NE', N'NE', 1, 1),
        (19, 2159, N'Nayarit', N'NT', N'NAY', N'NAY', 1, 1),
        (20, 2159, N'Nuevo Leon', N'NL', N'NL', N'NL', 1, 1),
        (21, 2159, N'Oaxaca', N'OC', N'OAX', N'OAX', 1, 1),
        (22, 2159, N'Puebla', N'PL', N'PUE', N'PUE', 1, 1),
        (23, 2159, N'Queretaro', N'QT', N'QRO', N'QRO', 1, 1),
        (24, 2159, N'Quintana Roo', N'QR', N'QR', N'QROO', 1, 1),
        (25, 2159, N'San Luis Potosi', N'SP', N'SLP', N'SLP', 1, 1),
        (26, 2159, N'Sinaloa', N'SL', N'SIN', N'SIN', 1, 1),
        (27, 2159, N'Sonora', N'SR', N'SON', N'SON', 1, 1),
        (28, 2159, N'Tabasco', N'TC', N'TAB', N'TAB', 1, 1),
        (29, 2159, N'Tamaulipas', N'TS', N'TAMPS', N'TAMP', 1, 1),
        (30, 2159, N'Tlaxcala', N'TL', N'TLAX', N'TLAX', 1, 1),
        (31, 2159, N'Veracruz', N'VZ', N'VER', N'VER', 1, 1),
        (32, 2159, N'Yucatan', N'YN', N'YUC', N'YUC', 1, 1),
        (33, 2159, N'Zacatecas', N'ZS', N'ZAC', N'ZAC', 1, 1),
		(34, 2254, N'California', N'CA', N'CA', N'CA', 1, 1),
		(35, 2254, N'New York', N'NY', N'NY', N'NY', 1, 1),
		(36, 2254, N'Virginia', N'VA', N'VA', N'VA', 1, 1)
GO

SET IDENTITY_INSERT [location].[States] OFF
GO

DBCC CHECKIDENT ('[location].[States]', RESEED)
GO

INSERT INTO [location].States
(StateName, StateCodeA2, Abbreviation, CountryID, INKCode, IsActive, ModifiedByAppUserID)
SELECT 'Unknown', 'UK', 'UNK', CountryID, 'UNK-' + CAST(CountryID AS NVARCHAR(5)), 1, 1  FROM [location].Countries GROUP BY CountryID ORDER BY CountryID;
GO




-- ####
-- #### Cities
-- ####
SET IDENTITY_INSERT [location].[Cities] ON
GO

INSERT INTO [location].[Cities]
        ([CityID]
        ,[CityName]
        ,[StateID]
        ,[IsActive]
        ,[ModifiedByAppUserID]) 
VALUES (1, N'Abasolo', 7, 1, 1),
        (2, N'Abasolo', 11, 1, 1),
        (3, N'Abasolo', 20, 1, 1),
        (4, N'Abasolo', 29, 1, 1),
        (5, N'Acala', 5, 1, 1),
        (6, N'Acambaro', 11, 1, 1),
        (7, N'Acaponeta', 19, 1, 1),
        (8, N'Acapulco de Juarez', 12, 1, 1),
        (9, N'Acatlan de Juarez', 14, 1, 1),
        (10, N'Acatlan de Osorio', 13, 1, 1),
        (11, N'Acatlan de Osorio', 22, 1, 1),
        (12, N'Acatlan de Osorio', 31, 1, 1),
        (13, N'Acayucan', 31, 1, 1),
        (14, N'Actopan', 13, 1, 1),
        (15, N'Actopan', 31, 1, 1),
        (16, N'Agua Dulce', 31, 1, 1),
        (17, N'Agua Prieta', 27, 1, 1),
        (18, N'Aguaruto', 26, 1, 1),
        (19, N'Aguascalientes', 1, 1, 1),
        (20, N'Ahome', 26, 1, 1),
        (21, N'Ahuacatlan', 19, 1, 1),
        (22, N'Ahuacatlan', 22, 1, 1),
        (23, N'Ahualulco de Mercado', 14, 1, 1),
        (24, N'Ajijic', 14, 1, 1),
        (25, N'Aldama', 5, 1, 1),
        (26, N'Aldama', 6, 1, 1),
        (27, N'Aldama', 29, 1, 1),
        (28, N'Almoloya de Juarez', 15, 1, 1),
        (29, N'Altamira', 29, 1, 1),
        (30, N'Altotonga', 31, 1, 1),
        (31, N'Alvarado', 31, 1, 1),
        (32, N'Amatepec', 15, 1, 1),
        (33, N'Ameca', 14, 1, 1),
        (34, N'Amozoc', 22, 1, 1),
        (35, N'Anahuac', 6, 1, 1),
        (36, N'Anahuac', 8, 1, 1),
        (37, N'Anahuac', 9, 1, 1),
        (38, N'Anahuac', 20, 1, 1),
        (39, N'Anahuac', 33, 1, 1),
        (40, N'Angel R Cabada', 31, 1, 1),
        (41, N'Angostura', 26, 1, 1),
        (42, N'Apan', 13, 1, 1),
        (43, N'Apaseo El Grande', 11, 1, 1),
        (44, N'Apatzingan de La Constitucion', 16, 1, 1),
        (45, N'Apaxtla de Castrejon', 12, 1, 1),
        (46, N'Apizaco', 30, 1, 1),
        (47, N'Apodaca', 20, 1, 1),
        (48, N'Arandas', 14, 1, 1),
        (49, N'Arcelia', 12, 1, 1),
        (50, N'Armeria', 8, 1, 1),
        (51, N'Arriaga', 5, 1, 1),
        (52, N'Arteaga', 7, 1, 1),
        (53, N'Arteaga', 16, 1, 1),
        (54, N'Asientos', 1, 1, 1),
        (55, N'Asuncion Nochixtlan', 21, 1, 1),
        (56, N'Atlixco', 22, 1, 1),
        (57, N'Atotonilco El Alto', 14, 1, 1),
        (58, N'Atoyac', 14, 1, 1),
        (59, N'Atoyac', 31, 1, 1),
        (60, N'Atoyac de Alvarez', 12, 1, 1),
        (61, N'Autlan de Navarro', 14, 1, 1),
        (62, N'Ayutla de los Libres', 12, 1, 1),
        (63, N'Azoyu', 12, 1, 1),
        (64, N'Bahias de Huatulco', 21, 1, 1),
        (65, N'Banderilla', 31, 1, 1),
        (66, N'Benito Juarez', 5, 1, 1),
        (67, N'Benito Juarez', 6, 1, 1),
        (68, N'Benito Juarez', 7, 1, 1),
        (69, N'Benito Juarez', 16, 1, 1),
        (70, N'Benito Juarez', 20, 1, 1),
        (71, N'Boca Del Rio', 31, 1, 1),
        (72, N'Bucerias', 19, 1, 1),
        (73, N'Buenavista de Cuellar', 12, 1, 1),
        (74, N'Cabo San Lucas', 3, 1, 1),
        (75, N'Caborca (heroica Caborca)', 27, 1, 1),
        (76, N'Cacahotan', 5, 1, 1),
        (77, N'Cadereyta Jimenez', 20, 1, 1),
        (78, N'Calera de Victor Rosales', 33, 1, 1),
        (79, N'Calkini', 4, 1, 1),
        (80, N'Calpulalpan', 30, 1, 1),
        (81, N'Calvillo', 1, 1, 1),
        (82, N'Campeche', 4, 1, 1),
        (83, N'Cananea', 27, 1, 1),
        (84, N'Canatlan', 10, 1, 1),
        (85, N'Cancun', 9, 1, 1),
        (86, N'Cancun', 12, 1, 1),
        (87, N'Cancun', 24, 1, 1),
        (88, N'Cancun', 27, 1, 1),
        (89, N'Cancun', 30, 1, 1),
        (90, N'Cancun', 31, 1, 1),
        (91, N'Cancun', 33, 1, 1),
        (92, N'Candelaria', 4, 1, 1),
        (93, N'Capulhuac', 15, 1, 1),
        (94, N'Cardenas', 25, 1, 1),
        (95, N'Cardenas', 28, 1, 1),
        (96, N'Carlos A Carrillo', 31, 1, 1),
        (97, N'Casimiro Castillo', 14, 1, 1),
        (98, N'CastaÃ±os', 7, 1, 1),
        (99, N'Catemaco', 31, 1, 1),
        (100, N'Cazones de Herrera', 31, 1, 1),
        (101, N'Cedral', 25, 1, 1),
        (102, N'Celaya', 11, 1, 1),
        (103, N'Cerritos', 25, 1, 1),
        (104, N'Cerro Azul', 31, 1, 1),
        (105, N'Chahuites', 21, 1, 1),
        (106, N'Chalco de Diaz Covarrubias', 15, 1, 1),
        (107, N'Champoton', 4, 1, 1),
        (108, N'Chapala', 14, 1, 1),
        (109, N'Charcas', 25, 1, 1),
        (110, N'Chetumal (ciudad Chetumal)', 24, 1, 1),
        (111, N'Chiapa de Corzo', 5, 1, 1),
        (112, N'Chiautempan', 30, 1, 1),
        (113, N'Chiconcuac', 15, 1, 1),
        (114, N'Chihuahua', 6, 1, 1),
        (115, N'Chilapa de Alvarez', 12, 1, 1),
        (116, N'Chilpancingo de los Bravo', 12, 1, 1),
        (117, N'Chimalhuacan', 15, 1, 1),
        (118, N'Choix', 26, 1, 1),
        (119, N'Cienega de Flores', 20, 1, 1),
        (120, N'Cihuatlan', 14, 1, 1),
        (121, N'Cintalapa de Figueroa', 5, 1, 1),
        (122, N'Ciudad AcuÃ±a', 7, 1, 1),
        (123, N'Ciudad Adolfo Lopez Mateos', 15, 1, 1),
        (124, N'Ciudad Allende', 6, 1, 1),
        (125, N'Ciudad Allende', 7, 1, 1),
        (126, N'Ciudad Allende', 11, 1, 1),
        (127, N'Ciudad Allende', 20, 1, 1),
        (128, N'Ciudad Altamirano', 12, 1, 1),
        (129, N'Ciudad Camargo', 6, 1, 1),
        (130, N'Ciudad Camargo', 29, 1, 1),
        (131, N'Ciudad Constitucion (villa Constitucion)', 3, 1, 1),
        (132, N'Ciudad Cuauhtemoc', 6, 1, 1),
        (133, N'Ciudad Cuauhtemoc', 8, 1, 1),
        (134, N'Ciudad Cuauhtemoc', 9, 1, 1),
        (135, N'Ciudad Cuauhtemoc', 33, 1, 1),
        (136, N'Ciudad de Fray Bernardino de Sahagun', 13, 1, 1),
        (137, N'Ciudad de Mexico', 5, 1, 1),
        (138, N'Ciudad de Mexico', 6, 1, 1),
        (139, N'Ciudad de Mexico', 8, 1, 1),
        (140, N'Ciudad de Mexico', 9, 1, 1),
        (141, N'Ciudad de Mexico', 12, 1, 1),
        (142, N'Ciudad de Mexico', 16, 1, 1),
        (143, N'Ciudad de Mexico', 22, 1, 1),
        (144, N'Ciudad de Mexico', 24, 1, 1),
        (145, N'Ciudad de Mexico', 27, 1, 1),
        (146, N'Ciudad de Mexico', 30, 1, 1),
        (147, N'Ciudad de Mexico', 31, 1, 1),
        (148, N'Ciudad de Mexico', 33, 1, 1),
        (149, N'Ciudad Del Carmen', 4, 1, 1),
        (150, N'Ciudad Del Carmen', 20, 1, 1),
        (151, N'Ciudad Del Maiz', 25, 1, 1),
        (152, N'Ciudad Delicias', 6, 1, 1),
        (153, N'Ciudad Gustavo Diaz Ordaz', 29, 1, 1),
        (154, N'Ciudad Guzman', 14, 1, 1),
        (155, N'Ciudad Hidalgo', 7, 1, 1),
        (156, N'Ciudad Hidalgo', 10, 1, 1),
        (157, N'Ciudad Hidalgo', 16, 1, 1),
        (158, N'Ciudad Hidalgo', 20, 1, 1),
        (159, N'Ciudad Hidalgo', 29, 1, 1),
        (160, N'Ciudad Ixtepec', 21, 1, 1),
        (161, N'Ciudad Juarez', 5, 1, 1),
        (162, N'Ciudad Juarez', 6, 1, 1),
        (163, N'Ciudad Juarez', 7, 1, 1),
        (164, N'Ciudad Juarez', 16, 1, 1),
        (165, N'Ciudad Juarez', 20, 1, 1),
        (166, N'Ciudad Lerdo', 10, 1, 1),
        (167, N'Ciudad Madero', 29, 1, 1),
        (168, N'Ciudad Mante', 29, 1, 1),
        (169, N'Ciudad Nezahualcoyotl', 15, 1, 1),
        (170, N'Ciudad Obregon', 27, 1, 1),
        (171, N'Ciudad Sabinas', 7, 1, 1),
        (172, N'Ciudad Serdan', 22, 1, 1),
        (173, N'Ciudad Valles', 25, 1, 1),
        (174, N'Ciudad Victoria', 11, 1, 1),
        (175, N'Ciudad Victoria', 29, 1, 1),
        (176, N'Coacalco de Berriozabal', 15, 1, 1),
        (177, N'Coatepec', 22, 1, 1),
        (178, N'Coatepec', 31, 1, 1),
        (179, N'Coatzacoalcos', 31, 1, 1),
        (180, N'Coatzintla', 31, 1, 1),
        (181, N'Cocula', 12, 1, 1),
        (182, N'Cocula', 14, 1, 1),
        (183, N'Colima', 8, 1, 1),
        (184, N'Colotlan', 14, 1, 1),
        (185, N'Comalcalco', 28, 1, 1),
        (186, N'Comitan de Dominguez', 5, 1, 1),
        (187, N'Comonfort', 11, 1, 1),
        (188, N'Compostela', 19, 1, 1),
        (189, N'Copala', 12, 1, 1),
        (190, N'Cordoba', 31, 1, 1),
        (191, N'Cortazar', 11, 1, 1),
        (192, N'Cosala', 26, 1, 1),
        (193, N'Cosamaloapan de Carpio', 31, 1, 1),
        (194, N'Cosio', 1, 1, 1),
        (195, N'Cosolapa', 21, 1, 1),
        (196, N'Cosoleacaque', 31, 1, 1),
        (197, N'Coyuca de Benitez', 12, 1, 1),
        (198, N'Coyuca de Catalan', 12, 1, 1),
        (199, N'Cozumel', 24, 1, 1),
        (200, N'Cruz Azul', 13, 1, 1),
        (201, N'Cruz Grande', 12, 1, 1),
        (202, N'Cuajinicuilapa', 12, 1, 1),
        (203, N'Cuatro Cienegas de Carranza', 7, 1, 1),
        (204, N'Cuautitlan', 15, 1, 1),
        (205, N'Cuautitlan Izcalli', 15, 1, 1),
        (206, N'Cuautla (cuautla de Morelos)', 14, 1, 1),
        (207, N'Cuautla (cuautla de Morelos)', 17, 1, 1),
        (208, N'Cuautlancingo', 22, 1, 1),
        (209, N'Cueramaro', 11, 1, 1),
        (210, N'Cuernavaca', 17, 1, 1),
        (211, N'Cuicatlan', 21, 1, 1),
        (212, N'Cuichapa', 31, 1, 1),
        (213, N'Cuitlahuac', 31, 1, 1),
        (214, N'Culiacan', 26, 1, 1),
        (215, N'Cunduacan', 28, 1, 1),
        (216, N'Cutzamala de Pinzon', 12, 1, 1),
        (217, N'Doctor Arroyo', 20, 1, 1),
        (218, N'Durango', 10, 1, 1),
        (219, N'Ebano', 25, 1, 1),
        (220, N'Ecatepec de Morelos', 15, 1, 1),
        (221, N'Ejutla de Crespo', 21, 1, 1),
        (222, N'El Camaron', 21, 1, 1),
        (223, N'El Cercado', 20, 1, 1),
        (224, N'El Grullo', 14, 1, 1),
        (225, N'El Higo', 31, 1, 1),
        (226, N'El Ocotito', 12, 1, 1),
        (227, N'El Pueblito', 23, 1, 1),
        (228, N'El Quince', 14, 1, 1),
        (229, N'El Rosario', 6, 1, 1),
        (230, N'El Rosario', 26, 1, 1),
        (231, N'El Rosario', 27, 1, 1),
        (232, N'El Salto', 10, 1, 1),
        (233, N'El Salto', 11, 1, 1),
        (234, N'Emiliano Zapata', 13, 1, 1),
        (235, N'Emiliano Zapata', 17, 1, 1),
        (236, N'Emiliano Zapata', 28, 1, 1),
        (237, N'Emiliano Zapata', 30, 1, 1),
        (238, N'Emiliano Zapata', 31, 1, 1),
        (239, N'Empalme', 27, 1, 1),
        (240, N'Empalme Escobedo', 11, 1, 1),
        (241, N'Ensenada', 2, 1, 1),
        (242, N'Escarcega', 4, 1, 1),
        (243, N'Escuinapa', 26, 1, 1),
        (244, N'Etzatlan', 14, 1, 1),
        (245, N'Felipe Carrillo Puerto', 24, 1, 1),
        (246, N'Fortin de las Flores', 31, 1, 1),
        (247, N'Fraccion El Refugio', 25, 1, 1),
        (248, N'Francisco I Madero', 7, 1, 1),
        (249, N'Francisco I Madero', 13, 1, 1),
        (250, N'Francisco I Madero', 19, 1, 1),
        (251, N'Fresnillo (fresnillo de Gonzalez Echeve', 33, 1, 1),
        (252, N'Frontera', 7, 1, 1),
        (253, N'Frontera', 28, 1, 1),
        (254, N'Galeana', 17, 1, 1),
        (255, N'Garcia', 20, 1, 1),
        (256, N'General Escobedo', 20, 1, 1),
        (257, N'General Miguel Aleman', 14, 1, 1),
        (258, N'General Miguel Aleman', 31, 1, 1),
        (259, N'Gomez Palacio', 10, 1, 1),
        (260, N'Gonzalez', 29, 1, 1),
        (261, N'Guadalajara', 14, 1, 1),
        (262, N'Guadalupe', 6, 1, 1),
        (263, N'Guadalupe', 20, 1, 1),
        (264, N'Guadalupe', 22, 1, 1),
        (265, N'Guadalupe', 33, 1, 1),
        (266, N'Guadalupe (ciudad Guadalupe)', 6, 1, 1),
        (267, N'Guadalupe (ciudad Guadalupe)', 20, 1, 1),
        (268, N'Guadalupe (ciudad Guadalupe)', 22, 1, 1),
        (269, N'Guadalupe (ciudad Guadalupe)', 33, 1, 1),
        (270, N'Guamuchil', 26, 1, 1),
        (271, N'Guanajuato', 11, 1, 1),
        (272, N'Guasave', 26, 1, 1),
        (273, N'Guaymas (heroica Guaymas)', 27, 1, 1),
        (274, N'Guerrero Negro', 3, 1, 1),
        (275, N'Gutierrez Zamora', 31, 1, 1),
        (276, N'Hecelchakan', 4, 1, 1),
        (277, N'Hermosillo', 27, 1, 1),
        (278, N'Heroica Ciudad de Tlaxiaco', 21, 1, 1),
        (279, N'Heroica Mulege', 3, 1, 1),
        (280, N'Hidalgo Del Parral', 6, 1, 1),
        (281, N'Higuera de Zaragoza', 26, 1, 1),
        (282, N'Hopelchen', 4, 1, 1),
        (283, N'Huajuapan de Leon', 21, 1, 1),
        (284, N'Hualahuises', 20, 1, 1),
        (285, N'Huamantla', 30, 1, 1),
        (286, N'Huamuxtitlan', 12, 1, 1),
        (287, N'Huanimaro', 11, 1, 1),
        (288, N'Huatabampo', 27, 1, 1),
        (289, N'Huatusco', 31, 1, 1),
        (290, N'Huauchinango', 22, 1, 1),
        (291, N'Huayacocotla', 31, 1, 1),
        (292, N'Huejuquilla El Alto', 14, 1, 1),
        (293, N'Huejutla de Reyes', 13, 1, 1),
        (294, N'Huetamo de NuÃ±ez', 16, 1, 1),
        (295, N'Huiloapan de Cuauhtemoc', 31, 1, 1),
        (296, N'Huimanguillo', 28, 1, 1),
        (297, N'Huitzuco', 12, 1, 1),
        (298, N'Huixquilucan de Degollado', 15, 1, 1),
        (299, N'Huixtla', 5, 1, 1),
        (300, N'Iguala de La Independencia', 12, 1, 1),
        (301, N'Irapuato', 11, 1, 1),
        (302, N'Isla', 31, 1, 1),
        (303, N'Isla Mujeres', 24, 1, 1),
        (304, N'Ixmiquilpan', 13, 1, 1),
        (305, N'Ixtaczoquitlan', 31, 1, 1),
        (306, N'Ixtapaluca', 15, 1, 1),
        (307, N'Ixtlan Del Rio', 19, 1, 1),
        (308, N'Izucar de Matamoros', 22, 1, 1),
        (309, N'Jacona de Plancarte', 16, 1, 1),
        (310, N'Jala', 19, 1, 1),
        (311, N'Jalostotitlan', 14, 1, 1),
        (312, N'Jalpa', 33, 1, 1),
        (313, N'Jalpa de Mendez', 28, 1, 1),
        (314, N'Jaltipan de Morelos (jaltipan)', 31, 1, 1),
        (315, N'Jamay', 14, 1, 1),
        (316, N'Jaumave', 29, 1, 1),
        (317, N'Jerecuaro', 11, 1, 1),
        (318, N'Jerez (jerez de Garcia Salinas)', 33, 1, 1),
        (319, N'Jesus Maria', 1, 1, 1),
        (320, N'Jesus Maria', 14, 1, 1),
        (321, N'Jimenez', 6, 1, 1),
        (322, N'Jimenez', 7, 1, 1),
        (323, N'Jimenez', 16, 1, 1),
        (324, N'Jimenez', 29, 1, 1),
        (325, N'Jiquilpan', 16, 1, 1),
        (326, N'Jiquipilas', 5, 1, 1),
        (327, N'Jocotepec', 14, 1, 1),
        (328, N'Jojutla', 17, 1, 1),
        (329, N'Jose Cardel', 31, 1, 1),
        (330, N'Juan Aldama', 33, 1, 1),
        (331, N'Juan Diaz Covarrubias', 31, 1, 1),
        (332, N'Juan Rodriguez Clara', 31, 1, 1),
        (333, N'Juchitan (juchitan de Zaragoza)', 21, 1, 1),
        (334, N'Juchitepec de Mariano Riva Palacio', 15, 1, 1),
        (335, N'Kantunilkin', 16, 1, 1),
        (336, N'Kantunilkin', 24, 1, 1),
        (337, N'Kantunilkin', 30, 1, 1),
        (338, N'La Barca', 14, 1, 1),
        (339, N'La Cruz', 26, 1, 1),
        (340, N'La Paz', 3, 1, 1),
        (341, N'La Paz', 15, 1, 1),
        (342, N'La PeÃ±ita de Jaltemba', 19, 1, 1),
        (343, N'La Piedad de Cavadas', 16, 1, 1),
        (344, N'La Union', 12, 1, 1),
        (345, N'Lagos de Moreno', 14, 1, 1),
        (346, N'Lagunas Estacion', 21, 1, 1),
        (347, N'Las Choapas', 31, 1, 1),
        (348, N'Las Guacamayas', 16, 1, 1),
        (349, N'Las Guacamayas', 24, 1, 1),
        (350, N'Las Guacamayas', 30, 1, 1),
        (351, N'Las Margaritas', 5, 1, 1),
        (352, N'Las Pintitas', 14, 1, 1),
        (353, N'Las Rosas', 5, 1, 1),
        (354, N'Las Varas', 19, 1, 1),
        (355, N'Lazaro Cardenas', 16, 1, 1),
        (356, N'Lazaro Cardenas', 24, 1, 1),
        (357, N'Lazaro Cardenas', 30, 1, 1),
        (358, N'Leon de los Aldama (leon)', 11, 1, 1),
        (359, N'Lerdo de Tejada', 31, 1, 1),
        (360, N'Linares', 20, 1, 1),
        (361, N'Loma Bonita', 21, 1, 1),
        (362, N'Loreto', 3, 1, 1),
        (363, N'Loreto', 33, 1, 1),
        (364, N'Los Mochis', 26, 1, 1),
        (365, N'Los Reyes Acaquilpan (la Paz)', 3, 1, 1),
        (366, N'Los Reyes Acaquilpan (la Paz)', 15, 1, 1),
        (367, N'Los Reyes de Salgado (los Reyes)', 16, 1, 1),
        (368, N'Los Reyes de Salgado (los Reyes)', 31, 1, 1),
        (369, N'Luis Moya', 33, 1, 1),
        (370, N'Macuspana', 28, 1, 1),
        (371, N'Madera', 6, 1, 1),
        (372, N'Magdalena', 14, 1, 1),
        (373, N'Magdalena', 27, 1, 1),
        (374, N'Magdalena', 31, 1, 1),
        (375, N'Manuel Estacion', 29, 1, 1),
        (376, N'Manzanillo', 8, 1, 1),
        (377, N'Mapastepec', 5, 1, 1),
        (378, N'Maravatio de Ocampo', 16, 1, 1),
        (379, N'Mariscala de Juarez', 21, 1, 1),
        (380, N'Marquelia', 12, 1, 1),
        (381, N'Matamoros (heroica Matamoros)', 6, 1, 1),
        (382, N'Matamoros (heroica Matamoros)', 7, 1, 1),
        (383, N'Matamoros (heroica Matamoros)', 29, 1, 1),
        (384, N'Matamoros de La Laguna', 6, 1, 1),
        (385, N'Matamoros de La Laguna', 7, 1, 1),
        (386, N'Matamoros de La Laguna', 29, 1, 1),
        (387, N'Matehuala', 25, 1, 1),
        (388, N'Matias Romero', 21, 1, 1),
        (389, N'Mazatlan', 26, 1, 1),
        (390, N'Melchor Muzquiz', 7, 1, 1),
        (391, N'Melchor Ocampo', 15, 1, 1),
        (392, N'Melchor Ocampo', 20, 1, 1),
        (393, N'Melchor Ocampo', 33, 1, 1),
        (394, N'Merida', 32, 1, 1),
        (395, N'Metepec', 13, 1, 1),
        (396, N'Metepec', 15, 1, 1),
        (397, N'Mexicali', 2, 1, 1),
        (398, N'Miahuatlan de Porfirio Diaz', 21, 1, 1),
        (399, N'Miguel Aleman', 29, 1, 1),
        (400, N'Minatitlan', 8, 1, 1),
        (401, N'Minatitlan', 31, 1, 1),
        (402, N'Mocorito', 26, 1, 1),
        (403, N'Monclova', 7, 1, 1),
        (404, N'Montemorelos', 20, 1, 1),
        (405, N'Monterrey', 20, 1, 1),
        (406, N'Morelia', 16, 1, 1),
        (407, N'Morelos', 6, 1, 1),
        (408, N'Morelos', 7, 1, 1),
        (409, N'Morelos', 15, 1, 1),
        (410, N'Morelos', 16, 1, 1),
        (411, N'Morelos', 33, 1, 1),
        (412, N'Moroleon', 11, 1, 1),
        (413, N'Motozintla', 5, 1, 1),
        (414, N'Motul', 32, 1, 1),
        (415, N'Moyahua de Estrada', 33, 1, 1),
        (416, N'Nadadores', 7, 1, 1),
        (417, N'Naranjo', 26, 1, 1),
        (418, N'Naranjos', 31, 1, 1),
        (419, N'Natividad', 21, 1, 1),
        (420, N'Naucalpan de Juarez', 15, 1, 1),
        (421, N'Nava', 7, 1, 1),
        (422, N'Navojoa', 27, 1, 1),
        (423, N'Navolato', 26, 1, 1),
        (424, N'Nochistlan', 33, 1, 1),
        (425, N'Nogales', 27, 1, 1),
        (426, N'Nogales', 31, 1, 1),
        (427, N'Nombre de Dios', 10, 1, 1),
        (428, N'Nueva Ciudad Guerrero', 6, 1, 1),
        (429, N'Nueva Ciudad Guerrero', 7, 1, 1),
        (430, N'Nueva Ciudad Guerrero', 29, 1, 1),
        (431, N'Nueva Rosita', 7, 1, 1),
        (432, N'Nuevo Casas Grandes', 6, 1, 1),
        (433, N'Nuevo Laredo', 29, 1, 1),
        (434, N'Oaxaca (oaxaca de Juarez)', 21, 1, 1),
        (435, N'Ocosingo', 5, 1, 1),
        (436, N'Ocotlan', 14, 1, 1),
        (437, N'Ocotlan de Morelos', 21, 1, 1),
        (438, N'Ocoyoacac', 15, 1, 1),
        (439, N'Ocozocoautla de Espinosa', 5, 1, 1),
        (440, N'Ojinaga', 6, 1, 1),
        (441, N'Ojocaliente', 33, 1, 1),
        (442, N'Olinala', 12, 1, 1),
        (443, N'Orizaba', 31, 1, 1),
        (444, N'Pabellon de Arteaga', 1, 1, 1),
        (445, N'Pachuca de Soto', 13, 1, 1),
        (446, N'Palenque', 5, 1, 1),
        (447, N'Panuco', 31, 1, 1),
        (448, N'Panuco', 33, 1, 1),
        (449, N'Panuco de Coronado', 10, 1, 1),
        (450, N'Papantla (papantla de Olarte)', 31, 1, 1),
        (451, N'Paracho', 16, 1, 1),
        (452, N'Paraiso', 28, 1, 1),
        (453, N'Paraje Nuevo', 31, 1, 1),
        (454, N'Parras de La Fuente', 7, 1, 1),
        (455, N'Paso de Ovejas', 31, 1, 1),
        (456, N'Paso Del Macho', 31, 1, 1),
        (457, N'Patzcuaro', 16, 1, 1),
        (458, N'PeÃ±on Blanco', 10, 1, 1),
        (459, N'Penjamo', 11, 1, 1),
        (460, N'Petatlan', 12, 1, 1),
        (461, N'Pichucalco', 5, 1, 1),
        (462, N'Piedras Negras', 7, 1, 1),
        (463, N'Pijijiapan', 5, 1, 1),
        (464, N'Pinotepa Nacional', 21, 1, 1),
        (465, N'Platon Sanchez', 31, 1, 1),
        (466, N'Playa Del Carmen', 24, 1, 1),
        (467, N'Playa Vicente', 31, 1, 1),
        (468, N'Pomuch', 4, 1, 1),
        (469, N'Poncitlan', 14, 1, 1),
        (470, N'Poza Rica (poza Rica de Hidalgo)', 31, 1, 1),
        (471, N'Puebla (heroica Puebla)', 22, 1, 1),
        (472, N'Puente de Ixtla', 17, 1, 1),
        (473, N'Puerto Adolfo Lopez Mateos', 3, 1, 1),
        (474, N'Puerto Escondido', 21, 1, 1),
        (475, N'Puerto Madero', 5, 1, 1),
        (476, N'Puerto PeÃ±asco', 27, 1, 1),
        (477, N'Puerto San Blas', 19, 1, 1),
        (478, N'Puerto Vallarta', 14, 1, 1),
        (479, N'Purisima de Bustos', 11, 1, 1),
        (480, N'Puruandiro', 16, 1, 1),
        (481, N'Putla Villa de Guerrero', 21, 1, 1),
        (482, N'Queretaro', 23, 1, 1),
        (483, N'Quila', 26, 1, 1),
        (484, N'Ramos Arizpe', 7, 1, 1),
        (485, N'Reforma', 5, 1, 1),
        (486, N'Reynosa (ciudad Reynosa)', 29, 1, 1),
        (487, N'Rincon de Romos', 1, 1, 1),
        (488, N'Rincon de Tamayo', 11, 1, 1),
        (489, N'Rio Blanco', 31, 1, 1),
        (490, N'Rio Bravo (ciudad Rio Bravo)', 29, 1, 1),
        (491, N'Rio Grande', 21, 1, 1),
        (492, N'Rio Grande', 33, 1, 1),
        (493, N'Rio Verde', 25, 1, 1),
        (494, N'Rodolfo Sanchez T (maneadero)', 2, 1, 1),
        (495, N'Romita', 11, 1, 1),
        (496, N'Rosarito', 2, 1, 1),
        (497, N'Ruiz', 19, 1, 1),
        (498, N'Sabancuy', 4, 1, 1),
        (499, N'Sabancuy', 20, 1, 1),
        (500, N'Sabinas Hidalgo', 20, 1, 1),
        (501, N'Sahuayo de Morelos', 16, 1, 1),
        (502, N'Salamanca', 11, 1, 1),
        (503, N'Salina Cruz', 21, 1, 1),
        (504, N'Salinas de Hidalgo', 25, 1, 1),
        (505, N'Saltillo', 7, 1, 1),
        (506, N'Salvatierra', 11, 1, 1),
        (507, N'San Andres Cholula', 22, 1, 1),
        (508, N'San Andres Tuxtla', 31, 1, 1),
        (509, N'San Blas', 26, 1, 1),
        (510, N'San Buenaventura', 7, 1, 1),
        (511, N'San Cristobal de las Casas', 5, 1, 1),
        (512, N'San Diego de Alejandria', 14, 1, 1),
        (513, N'San Felipe', 2, 1, 1),
        (514, N'San Felipe Jalapa de Diaz', 21, 1, 1),
        (515, N'San Fernando', 5, 1, 1),
        (516, N'San Fernando', 29, 1, 1),
        (517, N'San Francisco de los Romo', 1, 1, 1),
        (518, N'San Francisco Del Rincon', 11, 1, 1),
        (519, N'San Francisco Ixhuatan', 21, 1, 1),
        (520, N'San Francisco Telixtlahuaca', 21, 1, 1),
        (521, N'San Ignacio', 3, 1, 1),
        (522, N'San Ignacio', 26, 1, 1),
        (523, N'San Ignacio Cerro Gordo', 14, 1, 1),
        (524, N'San Jeronimo de Juarez', 9, 1, 1),
        (525, N'San Jeronimo de Juarez', 12, 1, 1),
        (526, N'San Jeronimo de Juarez', 24, 1, 1),
        (527, N'San Jeronimo de Juarez', 27, 1, 1),
        (528, N'San Jeronimo de Juarez', 30, 1, 1),
        (529, N'San Jeronimo de Juarez', 31, 1, 1),
        (530, N'San Jeronimo de Juarez', 33, 1, 1),
        (531, N'San Jose de los Olvera', 23, 1, 1),
        (532, N'San Jose Del Cabo', 3, 1, 1),
        (533, N'San Jose El Verde', 14, 1, 1),
        (534, N'San Juan Bautista Lo de Soto', 21, 1, 1),
        (535, N'San Juan Bautista Valle Nacional', 21, 1, 1),
        (536, N'San Juan Cacahuatepec', 21, 1, 1),
        (537, N'San Juan de los Lagos', 14, 1, 1),
        (538, N'San Juan Del Rio', 10, 1, 1),
        (539, N'San Juan Del Rio', 21, 1, 1),
        (540, N'San Juan Del Rio', 23, 1, 1),
        (541, N'San Julian', 14, 1, 1),
        (542, N'San Luis Acatlan', 12, 1, 1),
        (543, N'San Luis de La Loma', 12, 1, 1),
        (544, N'San Luis de La Paz', 11, 1, 1),
        (545, N'San Luis Potosi', 25, 1, 1),
        (546, N'San Luis Rio Colorado (horcasitas)', 27, 1, 1),
        (547, N'San Luis San Pedro', 12, 1, 1),
        (548, N'San Marcos', 12, 1, 1),
        (549, N'San Marcos', 14, 1, 1),
        (550, N'San Martin Texmelucan de Labastida', 22, 1, 1),
        (551, N'San Mateo Atenco', 15, 1, 1),
        (552, N'San Miguel de Allende', 6, 1, 1),
        (553, N'San Miguel de Allende', 7, 1, 1),
        (554, N'San Miguel de Allende', 11, 1, 1),
        (555, N'San Miguel de Allende', 20, 1, 1),
        (556, N'San Miguel El Alto', 14, 1, 1),
        (557, N'San Miguel El Grande', 21, 1, 1),
        (558, N'San Nicolas de los Garza', 20, 1, 1),
        (559, N'San Pablo Huitzo', 21, 1, 1),
        (560, N'San Pablo Villa de Mitla', 21, 1, 1),
        (561, N'San Pedro Cholula', 22, 1, 1),
        (562, N'San Pedro de las Colinas', 7, 1, 1),
        (563, N'San Pedro Garza Garcia', 20, 1, 1),
        (564, N'San Pedro Lagunillas', 19, 1, 1),
        (565, N'San Pedro Mixtepec', 21, 1, 1),
        (566, N'San Pedro Pochutla', 21, 1, 1),
        (567, N'San Pedro Tapanatepec', 21, 1, 1),
        (568, N'San Pedro Totolapa', 21, 1, 1),
        (569, N'San Rafael', 31, 1, 1),
        (570, N'San Sebastian Tecomaxtlahuaca', 21, 1, 1),
        (571, N'San Vicente Chicoloapan de Juarez', 15, 1, 1),
        (572, N'Santa Catarina', 11, 1, 1),
        (573, N'Santa Catarina', 20, 1, 1),
        (574, N'Santa Catarina', 25, 1, 1),
        (575, N'Santa Cruz Itundujia', 21, 1, 1),
        (576, N'Santa Maria Del Oro', 10, 1, 1),
        (577, N'Santa Maria Del Oro', 15, 1, 1),
        (578, N'Santa Maria Huatulco', 21, 1, 1),
        (579, N'Santa Maria Tultepec', 15, 1, 1),
        (580, N'Santa Rosa Treinta', 17, 1, 1),
        (581, N'Santiago', 20, 1, 1),
        (582, N'Santiago Ixcuintla', 19, 1, 1),
        (583, N'Santiago Jamiltepec', 21, 1, 1),
        (584, N'Santiago Juxtlahuaca', 21, 1, 1),
        (585, N'Santiago Maravatio', 11, 1, 1),
        (586, N'Santiago Papasquiaro', 10, 1, 1),
        (587, N'Santiago Suchilquitongo', 21, 1, 1),
        (588, N'Santiago Tulantepec', 13, 1, 1),
        (589, N'Santiago Tuxtla', 31, 1, 1),
        (590, N'Santo Domingo Tehuantepec', 21, 1, 1),
        (591, N'Sayula', 14, 1, 1),
        (592, N'Sihuapan', 31, 1, 1),
        (593, N'Silao', 11, 1, 1),
        (594, N'Sinaloa de Leyva', 26, 1, 1),
        (595, N'Soledad de Doblado', 31, 1, 1),
        (596, N'Soledad de Graciano Sanchez', 25, 1, 1),
        (597, N'Sombrerete', 33, 1, 1),
        (598, N'Sonoyta', 27, 1, 1),
        (599, N'Soto La Marina', 29, 1, 1),
        (600, N'Tacambaro de Codallos', 16, 1, 1),
        (601, N'Tala', 14, 1, 1),
        (602, N'Talpa de Allende', 14, 1, 1),
        (603, N'Tamasopo', 25, 1, 1),
        (604, N'Tamazula', 14, 1, 1),
        (605, N'Tamazulapam', 21, 1, 1),
        (606, N'Tamazunchale', 25, 1, 1),
        (607, N'Tampico', 29, 1, 1),
        (608, N'Tampico Alto', 31, 1, 1),
        (609, N'Tamuin', 25, 1, 1),
        (610, N'Tangancicuaro de Arista', 16, 1, 1),
        (611, N'Tantoyuca', 31, 1, 1),
        (612, N'Tapachula', 5, 1, 1),
        (613, N'Tarandacuao', 11, 1, 1),
        (614, N'Taxco de Alarcon', 12, 1, 1),
        (615, N'Teapa', 28, 1, 1),
        (616, N'Tecalitlan', 14, 1, 1),
        (617, N'Tecamac de Felipe Villanueva', 15, 1, 1),
        (618, N'Tecamachalco', 22, 1, 1),
        (619, N'Tecate', 2, 1, 1),
        (620, N'Tecoman', 8, 1, 1),
        (621, N'Tecpan de Galeana', 12, 1, 1),
        (622, N'Tecuala', 19, 1, 1),
        (623, N'Tehuacan', 22, 1, 1),
        (624, N'Tejupilco de Hidalgo', 15, 1, 1),
        (625, N'Teloloapan', 12, 1, 1),
        (626, N'Tempoal', 31, 1, 1),
        (627, N'Tenosique', 28, 1, 1),
        (628, N'Teocaltiche', 14, 1, 1),
        (629, N'Teotitlan de Flores Magon', 21, 1, 1),
        (630, N'Tepatitlan de Morelos', 14, 1, 1),
        (631, N'Tepeaca', 22, 1, 1),
        (632, N'Tepecoacuilco de Trujano', 12, 1, 1),
        (633, N'Tepeji Del Rio', 13, 1, 1),
        (634, N'Tepezala', 1, 1, 1),
        (635, N'Tepic', 19, 1, 1),
        (636, N'Tepotzotlan', 15, 1, 1),
        (637, N'Tequila', 14, 1, 1),
        (638, N'Tequila', 31, 1, 1),
        (639, N'Tequixquiac', 15, 1, 1),
        (640, N'Texcoco de Mora', 15, 1, 1),
        (641, N'Teziutlan', 22, 1, 1),
        (642, N'Tezonapa', 31, 1, 1),
        (643, N'Ticul', 32, 1, 1),
        (644, N'Tierra Blanca', 11, 1, 1),
        (645, N'Tierra Blanca', 31, 1, 1),
        (646, N'Tierra Colorada', 12, 1, 1),
        (647, N'Tierra Nueva', 25, 1, 1),
        (648, N'Tihuatlan', 31, 1, 1),
        (649, N'Tijuana', 2, 1, 1),
        (650, N'Tixtla de Guerrero', 12, 1, 1),
        (651, N'Tizayuca', 13, 1, 1),
        (652, N'Tizimin', 32, 1, 1),
        (653, N'Tlacojalpan', 31, 1, 1),
        (654, N'Tlacolula de Matamoros', 21, 1, 1),
        (655, N'Tlajomulco de ZuÃ±iga', 14, 1, 1),
        (656, N'Tlalixtaquilla', 12, 1, 1),
        (657, N'Tlalnepantla de Baz', 15, 1, 1),
        (658, N'Tlapa de Comonfort', 12, 1, 1),
        (659, N'Tlapacoyan', 31, 1, 1),
        (660, N'Tlapehuala', 12, 1, 1),
        (661, N'Tlaquepaque', 14, 1, 1),
        (662, N'Tlaquiltenango', 17, 1, 1),
        (663, N'Tlaxcala (tlaxcala de Xicohtencatl)', 30, 1, 1),
        (664, N'Tlaxcoapan', 13, 1, 1),
        (665, N'Todos Santos', 3, 1, 1),
        (666, N'Todos Santos', 15, 1, 1),
        (667, N'Toluca de Lerdo', 15, 1, 1),
        (668, N'Tonala', 5, 1, 1),
        (669, N'Tonala', 14, 1, 1),
        (670, N'Topolobampo', 26, 1, 1),
        (671, N'Torreon', 7, 1, 1),
        (672, N'Tototlan', 14, 1, 1),
        (673, N'Tres Valles', 31, 1, 1),
        (674, N'Tula', 29, 1, 1),
        (675, N'Tula de Allende', 13, 1, 1),
        (676, N'Tulancingo', 13, 1, 1),
        (677, N'Tultitlan de Mariano Escobedo', 15, 1, 1),
        (678, N'Tuxpam de Rodriguez Cano', 31, 1, 1),
        (679, N'Tuxpan', 14, 1, 1),
        (680, N'Tuxpan', 16, 1, 1),
        (681, N'Tuxpan', 19, 1, 1),
        (682, N'Tuxtepec (san Juan Bautista Tuxtepec)', 21, 1, 1),
        (683, N'Tuxtla Gutierrez', 5, 1, 1),
        (684, N'Union de San Antonio', 14, 1, 1),
        (685, N'Union Hidalgo', 21, 1, 1),
        (686, N'Uriangato', 11, 1, 1),
        (687, N'Uruapan', 16, 1, 1),
        (688, N'Valladolid', 32, 1, 1),
        (689, N'Valle de Chalco Solidaridad', 15, 1, 1),
        (690, N'Valle de Guadalupe', 14, 1, 1),
        (691, N'Valle de Santiago', 11, 1, 1),
        (692, N'Valle Hermoso', 29, 1, 1),
        (693, N'Valparaiso', 33, 1, 1),
        (694, N'Venustiano Carranza', 5, 1, 1),
        (695, N'Venustiano Carranza', 9, 1, 1),
        (696, N'Venustiano Carranza', 16, 1, 1),
        (697, N'Venustiano Carranza', 22, 1, 1),
        (698, N'Veracruz', 31, 1, 1),
        (699, N'Vicente Estacion', 21, 1, 1),
        (700, N'Vicente Guerrero', 10, 1, 1),
        (701, N'Vicente Guerrero', 22, 1, 1),
        (702, N'Viesca', 7, 1, 1),
        (703, N'Villa Alberto A Alvarado', 3, 1, 1),
        (704, N'Villa Corona', 14, 1, 1),
        (705, N'Villa de Alvarez', 8, 1, 1),
        (706, N'Villa de Cos', 33, 1, 1),
        (707, N'Villa de Reyes', 25, 1, 1),
        (708, N'Villa de Zaachila', 21, 1, 1),
        (709, N'Villa Hidalgo', 14, 1, 1),
        (710, N'Villa Hidalgo', 19, 1, 1),
        (711, N'Villa Hidalgo', 21, 1, 1),
        (712, N'Villa Hidalgo', 25, 1, 1),
        (713, N'Villa Hidalgo', 27, 1, 1),
        (714, N'Villa Hidalgo', 33, 1, 1),
        (715, N'Villa Nicolas Romero', 15, 1, 1),
        (716, N'Villa San Blas Atempa', 21, 1, 1),
        (717, N'Villa Sola de Vega', 21, 1, 1),
        (718, N'Villa Union', 26, 1, 1),
        (719, N'Villa Vicente Guerrero', 30, 1, 1),
        (720, N'Villa Yecuatla', 31, 1, 1),
        (721, N'Villaflores', 5, 1, 1),
        (722, N'Villagran', 11, 1, 1),
        (723, N'Villagran', 29, 1, 1),
        (724, N'Villahermosa', 28, 1, 1),
        (725, N'Villanueva', 33, 1, 1),
        (726, N'Xalapa Enriquez', 31, 1, 1),
        (727, N'Xalisco', 19, 1, 1),
        (728, N'Xicotencatl', 29, 1, 1),
        (729, N'Xicotepec', 22, 1, 1),
        (730, N'Xonacatlan', 15, 1, 1),
        (731, N'Yahualica de Gonzalez Gallo', 14, 1, 1),
        (732, N'Yurecuaro', 16, 1, 1),
        (733, N'Yuriria', 11, 1, 1),
        (734, N'Zacapu', 16, 1, 1),
        (735, N'Zacatecas', 33, 1, 1),
        (736, N'Zacatepec de Hidalgo', 17, 1, 1),
        (737, N'Zacatlan', 22, 1, 1),
        (738, N'Zacoalco de Torres', 14, 1, 1),
        (739, N'Zamora de Hidalgo', 16, 1, 1),
        (740, N'Zapopan', 14, 1, 1),
        (741, N'Zapotiltic', 14, 1, 1),
        (742, N'Zaragoza', 7, 1, 1),
        (743, N'Zaragoza', 22, 1, 1),
        (744, N'Zaragoza', 25, 1, 1),
        (745, N'Zaragoza', 31, 1, 1),
        (746, N'Zimapan', 13, 1, 1),
        (747, N'Zimatlan de Alvarez', 21, 1, 1),
        (748, N'Zinapecuaro de Figueroa', 16, 1, 1),
        (749, N'Zitacuaro (heroica Zitacuaro)', 16, 1, 1),
        (750, N'Zumpango Del Rio', 12, 1, 1),
		(751, N'Los Angeles', 34, 1, 1),
		(752, N'San Diego', 34, 1, 1),
		(753, N'San Francisco', 34, 1, 1),
		(754, N'Albany', 35, 1, 1),
		(755, N'Buffalo', 35, 1, 1),
		(756, N'New York City', 35, 1, 1),
		(757, N'Alexandria', 36, 1, 1),
		(758, N'Blacksburg', 36, 1, 1),
		(759, N'Fairfax', 36, 1, 1),
		(760, N'Fredericksburg', 36, 1, 1),
		(761, N'Leesburg', 36, 1, 1),
		(762, N'Richmond', 36, 1, 1)

GO

SET IDENTITY_INSERT [location].[Cities] OFF
GO

DBCC CHECKIDENT ('[location].[Cities]', RESEED)
GO

INSERT INTO [location].Cities
(CityName, StateID, IsActive, ModifiedByAppUserID)
SELECT 'Unknown', StateID, 1, 1 FROM [location].States GROUP BY StateID ORDER BY StateID;
GO



-- ####
-- #### Locations
-- ####  
INSERT INTO [location].[Locations] 
        ([LocationName]
        ,[CityID]
        ,[IsActive]
        ,[ModifiedByAppUserID])

SELECT c.CityName + ', ' + s.StateName, c.CityID, 1, 1
FROM [location].[Cities] c
INNER JOIN [location].[States] s ON s.StateID = c.StateID


/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('[location].[Locations]', RESEED)
GO




-- ####
-- #### Inter Agency Agreements
-- ####
SET IDENTITY_INSERT [training].[InterAgencyAgreements] ON
GO

INSERT INTO [training].[InterAgencyAgreements]
           ([InterAgencyAgreementID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
        (1, N'SINLEC14YOMX1', N'SINLEC14YOMX1', 1, 1),
        (2, N'SINLEC14YOMX2', N'SINLEC14YOMX2', 1, 1),
        (3, N'SINLEC14YOMX3', N'SINLEC14YOMX3', 1, 1),
        (4, N'SINLEC14YIMX3', NULL, 1, 1),
        (5, N'SINLEC14YIMX5', NULL, 1, 1),
        (6, N'SINLEC14YMX2', NULL, 1, 1),
        (7, N'SINLE12YIMX4', NULL, 1, 1),
        (8, N'SINLEC14YAMX2', NULL, 1, 1),
        (9, N'Synthetic Drugs', NULL, 1, 1),
        (10, N'SINLEC16YL4MX1', NULL, 1, 1),
        (11, N'SINLEC16Y7MX1', NULL, 1, 1)
GO
SET IDENTITY_INSERT [training].[InterAgencyAgreements] OFF
GO

DBCC CHECKIDENT ('[training].[InterAgencyAgreements]', RESEED)
GO



-- ####
-- #### Key Activities
-- ####
SET IDENTITY_INSERT [training].[KeyActivities] ON
GO

INSERT INTO [training].[KeyActivities]
           ([KeyActivityID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
		(1, N'Border Security - Airports', NULL, 1, 1),
		(2, N'Border Security - Border Control And Investigations', NULL, 1, 1),
		(3, N'Border Security - Institutionalize A Stronger Inter-Agency And Regional Border Security Policy', NULL, 1, 1),
		(4, N'Border Security - Land Ports Of Entry', NULL, 1, 1),
		(5, N'Border Security - Mail Distribution', NULL, 1, 1),
		(6, N'Border Security - Places In Between', NULL, 1, 1),		
		(7, N'Border Security - Seaports', NULL, 1, 1),        
		(8, N'Counternarcotics And Special Investigations - Aviation', NULL, 1, 1),        
		(9, N'Counternarcotics And Special Investigations - Counter Transnational Criminal Organization Capacity Building Development', NULL, 1, 1),        
		(10, N'Criminal Prosecutions - Criminal Prosecutions', NULL, 1, 1),               
        (11, N'Criminal Prosecutions - Drug Demand Reduction', NULL, 1, 1),
		(12, N'Criminal Special Investigation - Anti-Money Laundering Strategy', NULL, 1, 1),
		(13, N'Criminal Special Investigation - Canine Units', NULL, 1, 1),
		(14, N'Security And Law Enforcement - Forensics', NULL, 1, 1),
		(15, N'Security And Law Enforcement - Intel Analysts', NULL, 1, 1),
		(16, N'Security And Law Enforcement - Police Profesionalization', NULL, 1, 1),
		(17, N'Security And Law Enforcement - Prisons', NULL, 1, 1)
GO

SET IDENTITY_INSERT [training].[KeyActivities] OFF
GO

DBCC CHECKIDENT ('[training].[KeyActivities]', RESEED)
GO



-- ####
-- #### ProjectCodes
-- ####
SET IDENTITY_INSERT [training].[ProjectCodes] ON
GO

INSERT INTO [training].[ProjectCodes]
           ([ProjectCodeID]
           ,[Code]
           ,[Description]
		   ,[IsActive]
		   ,[ModifiedByAppUserID])
     VALUES
		(1, N'IN14MX59', N'Ion Scanners', 1, 1),
		(2, N'IN16MX02/A2/NIIE', N'NIIE', 1, 1),
		(3, N'IN23MX04', N'Law Enforcement Infrastructure', 1, 1),
		(4, N'IN23MX07', N'Interdiction', 1, 1),
		(5, N'IN23MX53', N'Enhanced Security for Official Combating Organized Crime', 1, 1),
		(6, N'IN23MX55', N'Data Analysis and Maintenance', 1, 1),
		(7, N'IN23MX58', N'Mobile Gamma Ray, Non-Intrusive Inspection Equipment', 1, 1),
		(8, N'IN23MX60', N'National Migration Institute', 1, 1),
		(9, N'IN23MX61', N'Communications and Transportation Secretariat', 1, 1),
		(10, N'IN23MX62', N'NIIE & Canine Inspection (Customs)', 1, 1),
		(11, N'IN23MX63', N'National Security Investigation Center', 1, 1),
		(12, N'IN23MX64', N'NIIE & Canine Inspection (SSP)', 1, 1),
		(13, N'IN23MX65', N'National Police Registry', 1, 1),
		(14, N'IN23MX66', N'Security Equipment for Law Enforcement', 1, 1),
		(15, N'IN23MX75', N'Forensics Laboratories - IAA with DOJ, amount: $1,600,000', 1, 1),
		(16, N'IN23MX83', N'Transport Helicopters, Training and Maintenance Systems (Supplemental)', 1, 1),
		(17, N'IN23MX85', N'Canine Training-Customs', 1, 1),
		(18, N'IN23MX86', N'Canine Training-SSP', 1, 1),
		(19, N'IN23MX87', N'Canine Training-PGR', 1, 1),
		(20, N'IN23MX88', N'SSP IT Support', 1, 1),
		(21, N'IN23MX90', N'National Migration Institute Gpos Beta', 1, 1),
		(22, N'IN23MX91', N'Law Enforcement Inter-Agency Support', 1, 1),
		(23, N'IN23MX92', N'Port Security Program (Air Port)', 1, 1),
		(24, N'IN23MX93', N'Port Security Program (Sea Port)', 1, 1),
		(25, N'IN23MX94', N'Non Intrusive Inspection Equipment (Multi- Other)', 1, 1),
		(26, N'IN23MX97', N'Aviation Management Assistance Program', 1, 1),
		(27, N'IN25MX09', N'Demand Reduction', 1, 1),
		(28, N'IN25MX54', N'Drug Demand Reduction', 1, 1),
		(29, N'IN32MX08', N'Money Laundering', 1, 1),
		(30, N'IN32MX67', N'Financial Crimes', 1, 1),
		(31, N'IN35MX52', N'Merida PGR OASISS', 1, 1),
		(32, N'IN35MX53', N'Expand Anti-TIP OASISS Program', 1, 1),
		(33, N'IN41MX03', N'Law Enforcement Professionalization', 1, 1),
		(34, N'IN41MX55', N'Merida PGR Link-Data Collection and Analysis', 1, 1),
		(35, N'IN41MX56', N'PGR Constanza Judicial Processes Improvement and Coordination Initiative', 1, 1),
		(36, N'IN41MX68', N'Prosecutorial Capacity Building - IAA with DOJ, amount: $7,452,000', 1, 1),
		(37, N'IN41MX69', N'Technical Assistance in Prison Management', 1, 1),
		(38, N'IN41MX70', N'Strengthen Units on Anti-Gang, Anti-Organized Crime, Anti-Money Laundering', 1, 1),
		(39, N'IN41MX71', N'Asset Forfeiture - IAA with DOJ, amount: $1,000,000', 1, 1),
		(40, N'IN41MX72', N'Police Professionalization/Enhancement', 1, 1),
		(41, N'IN41MX73', N'Evidence Preservation and Chain of Custody - IAA with DOJ, amount: $2,000,000', 1, 1),
		(42, N'IN41MX74', N'Extradition Training - IAA with DOJ, amount: $1,862,000', 1, 1),
		(43, N'IN41MX76', N'Stand Up Robust Polygraph Capability', 1, 1),
		(44, N'IN41MX81', N'Pre-Trial Case Resolution Alternatives - IAA with DOJ, amount: $1,000,000.', 1, 1),
		(45, N'IN41MX89', N'Institution Building and Rule of Law', 1, 1),
		(46, N'IN41MXZW', N'Victim and Witness Protection and Restitution', 1, 1),
		(47, N'IN42MX80', N'Support for Human Rights NGOs & Civil Society  - IAA with AID, amount: $500,000', 1, 1),
		(48, N'IN42MXZY', N'Human Rights Training for Law Enforcement, Prosecutors & Others', 1, 1),
		(49, N'IN52MX06', N'Anti Corruption', 1, 1),
		(50, N'IN52MX77', N'Expand "Culture of Lawfulness" Program', 1, 1),
		(51, N'IN52MX78', N'Citizen Participation Councils - IAA with AID, amount: $2,500,000', 1, 1),
		(52, N'IN52MX79', N'Strengthen PGR & SSP OIG/OPR  - IAA with DOJ, amount: $2,000,000', 1, 1),
		(53, N'IN53MX95', N'Anonymous Citizens Complaints Project (SMS)', 1, 1),
		(54, N'IN60MXZX', N'Strategic-Social Communications', 1, 1),
		(55, N'IN81MX01', N'PD&S 2008-2009', 1, 1),
		(56, N'IN81MXM1', N'PD&S 2009-2010', 1, 1),
		(57, N'IN99MX05', N'Vetted Units', 1, 1),
		(58, N'IN16MX02/A2/APIS', N'APIS', 1, 1),
		(59, N'IN53MX96', N'IN53MX96', 1, 1),
		(60, N'IN41MX98', N'IN41MX98', 1, 1),
		(61, N'IN23MX82', N'IN23MX82', 1, 1),
		(62, N'IN23MX84', N'IN23MX84', 1, 1),
		(64, N'IN23MXZV', N'Border Security', 1, 1),
		(65, N'FY07 EXBS', N'FY07 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(66, N'FY08 EXBS', N'FY08 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(67, N'FY09 EXBS', N'FY09 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(68, N'FY10 EXBS', N'FY10 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(69, N'FY11 EXBS', N'FY11 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(70, N'FY12 EXBS', N'FY12 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(71, N'FY13 EXBS', N'FY13 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(72, N'FY14 EXBS', N'FY14 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(73, N'FY15 EXBS', N'FY15 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(74, N'FY16 EXBS', N'FY16 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(75, N'FY17 EXBS', N'FY17 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(76, N'FY18 EXBS', N'FY18 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(77, N'FY19 EXBS', N'FY19 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(78, N'FY20 EXBS', N'FY20 EXBS MEXICO PROGRAM FUNDS', 1, 1),
		(79, N'REGIONAL EXBS', N'EXBS REGIONAL PROGRAM FUNDS', 1, 1),
		(85, N'INL HQ', N'INL Headquarters', 1, 1),
		(86, N'INL MX', N'INL Mexico', 1, 1),
		(87, N'ICITAP', N'International Criminal Investigative Training Assistance Program', 1, 1),
		(88, N'OPDAT', N'Office of Overseas Prosecutorial Development Assistance and Training', 1, 1),
		(89, N'FBI', N'Federal Bureau of Investigation', 1, 1),
		(90, N'DOD', N'Department of Defense', 1, 1),
		(91, N'Other', N'Other', 1, 1)
GO

SET IDENTITY_INSERT [training].[ProjectCodes] OFF
GO

DBCC CHECKIDENT ('[training].[ProjectCodes]', RESEED)
GO



-- ####
-- #### Vetting Funding Sources
-- ####
SET IDENTITY_INSERT [vetting].[VettingFundingSources] ON
GO

INSERT INTO [vetting].[VettingFundingSources]
		([VettingFundingSourceID]
		,[Code]
		,[Description]
		,[IsActive]
		,[ModifiedByAppUserID])
	VALUES
	(1, '1050', 'Latin American Cooperation',1,1),
	(2, '1050a', 'African Cooperation',1,1),
	(3, '1051', 'Payment of Personnel Expenses (1051)',1,1),
	(4, '1203', 'Training for General Purpose Forces of the United States Armed Forces with Military and Other Security Forces of Friendly Foreign Countries (Section 1203)',1,1),
	(5, '1204', 'Enhancing the capability of foreign countries to respond to incidents involving weapons of mass destruction (Section 1204)',1,1),
	(6, '1206', 'Section 1206 Program (Authority to build the capacity of foreign forces)',1,1),
	(7, '1222', 'Transfer of defense articles that have not been excessed to the defense and security forces of Afghanistan (Section 1222)',1,1),
	(8, 'ACI', 'Andean Counterdrug Program',1,1),
	(9, 'AEECA', 'Assistance for Europe, Eurasia, and Central Asia',1,1),
	(10, 'ALP', 'Aviation Leadership Program',1,1),
	(11, 'APRI', 'Asia Pacific Regional Initiative',1,1),
	(12, 'ASFF', 'Afghanistan Security Forces Fund',1,1),
	(13, 'ATA', 'Anti-Terrorism Assistance',1,1),
	(14, 'CLRA', 'Counter-Lord''s Resistance Army',1,1),
	(15, 'CN', 'Counter-Narcotics',1,1),
	(16, 'CN-1004', 'Section 1004 of the NDAA for Fiscal Year 1991 (Counter-Narcotics)',1,1),
	(17, 'CN-1021', 'Section 1021 of the NDAA for Fiscal Year 2005 (Counter-Narcotics)',1,1),
	(18, 'CN-1022', 'Section 1022 of the NDAA for Fiscal Year 2004 (Counter-Narcotics)',1,1),
	(19, 'CN-1033', 'Section 1033 of the NDAA for Fiscal Year 1998 (Counter-Narcotics)',1,1),
	(20, 'CTFP', 'Regional Defense Combating Terrorism Fellowship Program (CTFP)',1,1),
	(21, 'CTR', 'Cooperative Threat Reduction',1,1),
	(22, 'DEA', 'Drug Enforcement Agency (only if implementing with INCLE funds, otherwise not Leahy-applicable)',1,1),
	(23, 'DOD', 'Department of Defense',1,1),
	(24, 'DOJ', 'Department of Justice (Note: ICITAP, OPDAT, FBI, etc. usually conduct training with INCLE funds)',1,1),
	(25, 'DOS', 'Department of State',1,1),
	(26, 'DRDWN', 'Drawdown',1,1),
	(27, 'EARSI', 'East Africa Regional Strategic Initiative',1,1),
	(28, 'EDA', 'Excess Defense Articles',1,1),
	(29, 'ESF', 'Economic Support Funds',1,1),
	(30, 'FMF', 'Foreign Military Financing',1,1),
	(31, 'GSCF', 'Global Security Contingency Fund',1,1),
	(32, 'HAD', 'Humanitarian demining assistance',1,1),
	(33, 'ILEA', 'International Law Enforcement Training Academies',1,1),
	(34, 'IMET', 'International Military & Education Training',1,1),
	(35, 'INCLE', 'International Narcotics & Law Enforcement',1,1),
	(36, 'ITEF', 'Iraq Train and Equip Fund',1,1),
	(37, 'J/TIP', 'Office to Combat Trafficking in Persons (formerly G/TIP)',1,1),
	(38, 'JCET', 'Special Operations Forces: training with friendly foreign forces (aka: Joint Combined Exchange Training (JCET))',1,1),
	(39, 'MERIDA', 'The Merida Initiative is counter-narcotics assistance between the USG and Mexico to combat transnational crime in Central America',1,1),
	(40, 'MODA', 'Ministry of Defense Advisors Program',1,1),
	(41, 'NADR', 'Nonproliferation, Anti-terrorism, Demining, and Related Programs',1,1),
	(42, 'OSC-I', 'Office of Security Cooperation-Iraq (OSC-I)',1,1),
	(43, 'PCCF', 'Pakistan Counterinsurgency Capability Fund',1,1),
	(44, 'PFP', 'Western European Partnership for Peace',1,1),
	(45, 'PKO', 'Peace Keeping Operations',1,1),
	(46, 'PKO-ACOTA', 'Africa Contingency Operations Training and Assistance (Peace Keeping Operations)',1,1),
	(47, 'PKO-COESPU', 'Center of Excellence for Stability Police Units (Peace Keeping Operations)',1,1),
	(48, 'PKO-GPOI', 'Global Peace Operations Initiative (Peace Keeping Operations)',1,1),
	(49, 'REGCENT', 'Regional Centers',1,1),
	(50, 'REGCENT-GCMC', 'George C. Marshall Regional Center',1,1),
	(51, 'SPP', 'State Partnership Program',1,1),
	(52, 'TSCTP', 'Trans Sahara Counterterrorism Partnership',1,1),
	(53, 'USAID', 'US Agency for International Development',1,1)
GO

SET IDENTITY_INSERT [vetting].[VettingFundingSources] OFF
GO

DBCC CHECKIDENT ('[vetting].[VettingFundingSources]', RESEED)
GO



-- ####
-- #### Ranks
-- ####
SET IDENTITY_INSERT [persons].[Ranks] ON
GO

INSERT INTO [persons].[Ranks]
		([RankID]
		,[RankName]
		,[CountryID]
		,[ModifiedByAppUserID])
VALUES (1, N'Admiral', 2159, 1), 
        (2, N'Airman First Class', 2159, 1), 
        (3, N'Airman', 2159, 1), 
        (4, N'Brigadier General', 2159, 1), 
        (5, N'Captain', 2159, 1), 
        (6, N'Chief Master Sergeant', 2159, 1), 
        (7, N'Chief Petty Officer', 2159, 1), 
        (8, N'Chief Warrant Officer 2', 2159, 1), 
        (9, N'Chief Warrant Officer 3', 2159, 1), 
        (10, N'Chief Warrant Officer 4', 2159, 1), 
        (11, N'Chief Warrant Officer 5', 2159, 1), 
        (12, N'Colonel', 2159, 1), 
        (13, N'Commander', 2159, 1), 
        (14, N'Corporal', 2159, 1), 
        (15, N'Ensign', 2159, 1), 
        (16, N'First Lieutenant', 2159, 1), 
        (17, N'Fleet Admiral', 2159, 1), 
        (18, N'General of the Air Force', 2159, 1), 
        (19, N'General of the Army', 2159, 1), 
        (20, N'General', 2159, 1), 
        (21, N'Gunnery Sergeant', 2159, 1), 
        (22, N'Lance Corporal', 2159, 1), 
        (23, N'Lieutenant Colonel', 2159, 1), 
        (24, N'Lieutenant Commander', 2159, 1), 
        (25, N'Lieutenant General', 2159, 1), 
        (26, N'Lieutenant Junior Grade', 2159, 1), 
        (27, N'Lieutenant', 2159, 1), 
        (28, N'Major General', 2159, 1), 
        (29, N'Major', 2159, 1), 
        (30, N'Master Chief Petty Officer', 2159, 1), 
        (31, N'Master Sergeant', 2159, 1), 
        (32, N'Petty Officer, First Class', 2159, 1), 
        (33, N'Petty Officer, Second Class', 2159, 1), 
        (34, N'Petty Officer, Third Class', 2159, 1), 
        (35, N'Private First Class', 2159, 1), 
        (36, N'Private', 2159, 1), 
        (37, N'Rear Admiral (lower half)', 2159, 1), 
        (38, N'Rear Admiral (upper half)', 2159, 1), 
        (39, N'Seaman Apprentice', 2159, 1), 
        (40, N'Seaman Recruit', 2159, 1), 
        (41, N'Seaman', 2159, 1), 
        (42, N'Second Lieutenant', 2159, 1), 
        (43, N'Senior Airman', 2159, 1), 
        (44, N'Senior Chief Petty Officer', 2159, 1), 
        (45, N'Senior Master Sergeant', 2159, 1), 
        (46, N'Sergeant First Class', 2159, 1), 
        (47, N'Sergeant Major', 2159, 1), 
        (48, N'Sergeant', 2159, 1), 
        (49, N'Staff Sergeant', 2159, 1), 
        (50, N'Technical Sergeant', 2159, 1), 
        (51, N'Vice Admiral', 2159, 1), 
        (52, N'Warrant Officer 1', 2159, 1), 
        (53, N'Almirante', 2159, 1), 
        (54, N'Cabo', 2159, 1), 
        (55, N'Capitán de Corbeta', 2159, 1), 
        (56, N'Capitán de Fragata', 2159, 1), 
        (57, N'Capitán de Navío', 2159, 1), 
        (58, N'Capitan Primero', 2159, 1), 
        (59, N'Capitan Segundo', 2159, 1), 
        (60, N'Contralmirante', 2159, 1), 
        (61, N'Coronel', 2159, 1), 
        (62, N'General Brigadier', 2159, 1), 
        (63, N'General de Brigada', 2159, 1), 
        (64, N'General de Division', 2159, 1), 
        (65, N'General Secretario de la Defensa Nacional', 2159, 1), 
        (66, N'Guardiamarina', 2159, 1), 
        (67, N'Marinero', 2159, 1), 
        (68, N'Mayor', 2159, 1), 
        (69, N'N/A', 2159, 1), 
        (70, N'Primer Maestre', 2159, 1), 
        (71, N'Sargento Primero', 2159, 1), 
        (72, N'Sargento Segundo', 2159, 1), 
        (73, N'Secretario de Marina', 2159, 1),
        (74, N'Segundo Maestre', 2159, 1), 
        (75, N'Soldado de primera', 2159, 1), 
        (76, N'Soldado', 2159, 1), 
        (77, N'Subteniente', 2159, 1), 
        (78, N'Teniente Coronel', 2159, 1), 
        (79, N'Teniente de Corbeta ', 2159, 1), 
        (80, N'Teniente de Fragata', 2159, 1), 
        (81, N'Teniente de Navío', 2159, 1), 
        (82, N'Teniente', 2159, 1), 
        (83, N'Tercer Maestre', 2159, 1), 
        (84, N'Vicealmirante', 2159, 1)
GO

SET IDENTITY_INSERT [persons].[Ranks] OFF
GO

DBCC CHECKIDENT ('[persons].[Ranks]', RESEED)
GO



-- ####
-- #### TRAINING EVENT
-- ####
PRINT 'INSERT [training].[SaveTrainingEvent]';
EXEC	[training].[SaveTrainingEvent]
        --@TrainingEventID = 10,
		@Name = N'A Training Event',
		@NameInLocalLang = N'TEST',
		@TrainingEventTypeID = 1,
		@Justification = N'justification',
		@Objectives = N'objectives',
		@ParticipantProfile = N'profile',
		@SpecialRequirements = N'requirements',
		@ProgramID = NULL,
		@TrainingUnitID = 2,
		@CountryID = 2159,
		@PostID = 1083,
		@ConsularDistrictID = NULL,
		@OrganizerAppUserID = 101,
		@PlannedParticipantCnt = 1,
		@PlannedMissionDirectHireCnt = 2,
        @PlannedNonMissionDirectHireCnt = 3,
		@PlannedMissionOutsourceCnt = 4,
		@PlannedOtherCnt = 5,
		@EstimatedBudget = 6,
		@EstimatedStudents = 7,
		@FundingSourceID = NULL,
		@AuthorizingLawID = NULL,
		@ModifiedByAppUserID = 3374,
        @ProjectCodes = '[{"TrainingEventID":4,"ProjectCodeID":3,"ModifiedByAppUserID":1},{"TrainingEventID":4,"ProjectCodeID":4,"ModifiedByAppUserID":1}]',
        @USPartnerAgencies = '[{"TrainingEventID":4,"AgencyID":5,"ModifiedByAppUserID":1},{"TrainingEventID":4,"AgencyID":6,"ModifiedByAppUserID":1}]',
        @Locations = '[{"TrainingEventID":6,"LocationID":8,"EventStartDate":"1/2/2019","EventEndDate":"2/2/2019","TravelStartDate":"1/1/2019","TravelEndDate":"2/1/2019","IsActive":"1","ModifiedByAppUserID":1},{"TrainingEventID":6,"LocationID":5,"EventStartDate":"1/1/2019","EventEndDate":"2/1/2019","TravelStartDate":"12/31/2018","TravelEndDate":"2/2/2019","IsActive":"1","ModifiedByAppUserID":1}]',
		@Stakeholders = '[{"TrainingEventID":1,"AppUserID":2,"ModifiedByAppUserID":1},{"TrainingEventID":1,"AppUserID":2361,"ModifiedByAppUserID":1}]'
		--@IAAs = '[{"TrainingEventID":4,"IAAID":6,"ModifiedByAppUserID":0},{"TrainingEventID":4,"IAAID":7,"ModifiedByAppUserID":0}]'

GO

EXEC	[training].[SaveTrainingEvent]
        --@TrainingEventID = 10,
		@Name = N'A Second Event',
		@NameInLocalLang = N'TEST',
		@TrainingEventTypeID = 1,
		@Justification = N'justification',
		@Objectives = N'objectives',
		@ParticipantProfile = N'profile',
		@SpecialRequirements = N'requirements',
		@ProgramID = NULL,
		@TrainingUnitID = 2,
		@CountryID = 2159,
		@PostID = 1083,
		@ConsularDistrictID = NULL,
		@OrganizerAppUserID = 3374,
		@PlannedParticipantCnt = 1,
		@PlannedMissionDirectHireCnt = 2,
        @PlannedNonMissionDirectHireCnt = 3,
		@PlannedMissionOutsourceCnt = 4,
		@PlannedOtherCnt = 5,
		@EstimatedBudget = 6,
		@EstimatedStudents = 7,
		@FundingSourceID = NULL,
		@AuthorizingLawID = NULL,
		@ModifiedByAppUserID = 3374,
        @ProjectCodes = '[{"TrainingEventID":4,"ProjectCodeID":3,"ModifiedByAppUserID":1},{"TrainingEventID":4,"ProjectCodeID":4,"ModifiedByAppUserID":1}]',
        @USPartnerAgencies = '[{"TrainingEventID":4,"AgencyID":5,"ModifiedByAppUserID":1},{"TrainingEventID":4,"AgencyID":6,"ModifiedByAppUserID":1}]',
        @Locations = '[{"TrainingEventID":6,"LocationID":121,"EventStartDate":"2/2/2019","EventEndDate":"3/2/2019","TravelStartDate":"2/1/2019","TravelEndDate":"3/1/2019","IsActive":"1","ModifiedByAppUserID":1},{"TrainingEventID":6,"LocationID":158,"EventStartDate":"3/1/2019","EventEndDate":"4/1/2019","TravelStartDate":"2/28/2019","TravelEndDate":"4/2/2019","IsActive":"1","ModifiedByAppUserID":1}]',
		@Stakeholders = '[{"TrainingEventID":1,"AppUserID":2,"ModifiedByAppUserID":1},{"TrainingEventID":1,"AppUserID":2361,"ModifiedByAppUserID":1}]'
		--@IAAs = '[{"TrainingEventID":4,"IAAID":6,"ModifiedByAppUserID":0},{"TrainingEventID":4,"IAAID":7,"ModifiedByAppUserID":0}]'

GO

EXEC	[training].[SaveTrainingEvent]
        --@TrainingEventID = 10,
		@Name = N'I Like Training',
		@NameInLocalLang = N'TEST',
		@TrainingEventTypeID = 1,
		@Justification = N'justification',
		@Objectives = N'objectives',
		@ParticipantProfile = N'profile',
		@SpecialRequirements = N'requirements',
		@ProgramID = NULL,
		@TrainingUnitID = 2,
		@CountryID = 2159,
		@PostID = 1083,
		@ConsularDistrictID = NULL,
		@OrganizerAppUserID = 3374,
		@PlannedParticipantCnt = 1,
		@PlannedMissionDirectHireCnt = 2,
        @PlannedNonMissionDirectHireCnt = 3,
		@PlannedMissionOutsourceCnt = 4,
		@PlannedOtherCnt = 5,
		@EstimatedBudget = 6,
		@EstimatedStudents = 7,
		@FundingSourceID = NULL,
		@AuthorizingLawID = NULL,
		@ModifiedByAppUserID = 3374,
        @ProjectCodes = '[{"TrainingEventID":4,"ProjectCodeID":3,"ModifiedByAppUserID":1},{"TrainingEventID":4,"ProjectCodeID":4,"ModifiedByAppUserID":1}]',
        @USPartnerAgencies = '[{"TrainingEventID":4,"AgencyID":5,"ModifiedByAppUserID":1},{"TrainingEventID":4,"AgencyID":6,"ModifiedByAppUserID":1}]',
        @Locations = '[{"TrainingEventID":6,"LocationID":125,"EventStartDate":"2/2/2019","EventEndDate":"3/2/2019","TravelStartDate":"2/1/2019","TravelEndDate":"3/1/2019","IsActive":"1","ModifiedByAppUserID":1},{"TrainingEventID":6,"LocationID":155,"EventStartDate":"3/1/2019","EventEndDate":"4/1/2019","TravelStartDate":"2/28/2019","TravelEndDate":"4/2/2019","IsActive":"1","ModifiedByAppUserID":1}]',
		@Stakeholders = '[{"TrainingEventID":1,"AppUserID":2,"ModifiedByAppUserID":1},{"TrainingEventID":1,"AppUserID":2361,"ModifiedByAppUserID":1}]'
		--@IAAs = '[{"TrainingEventID":4,"IAAID":6,"ModifiedByAppUserID":0},{"TrainingEventID":4,"IAAID":7,"ModifiedByAppUserID":0}]'

GO

select * from training.TrainingEventsView

PRINT 'INSERT [training].[TrainingEventKeyActivities]';
insert into training.TrainingEventKeyActivities
(TrainingEventID, KeyActivityID, ModifiedByAppUserID)
VALUES
(1, 5, 1),
(1, 3, 1),
(2, 15, 1),
(3, 9, 1);

select * from training.TrainingEventKeyActivities;

PRINT 'INSERT [training].[TrainingEventCourseDefinitions]';
INSERT INTO training.TrainingEventCourseDefinitions
(TrainingEventID, CourseRosterkey, TestsWeighting, PerformanceWeighting, ProductsWeighting, MinimumAttendance, MinimumFinalGrade, IsActive, ModifiedByAppUserID)
VALUES
(1, '1124201933137', 80, 80, 80, 80, 80, 1, 1);
INSERT INTO training.TrainingEventCourseDefinitions
(TrainingEventID, CourseRosterkey, TestsWeighting, PerformanceWeighting, ProductsWeighting, MinimumAttendance, MinimumFinalGrade, IsActive, ModifiedByAppUserID)
VALUES
(2, '1124201933137', 80, 80, 80, 80, 80, 1, 1);

select * from training.TrainingEventCourseDefinitions;



-- ####
-- #### UNIT LIBRARY
-- ####
SET IDENTITY_INSERT unitlibrary.Units  ON
GO

DECLARE @IdentityBigInt BIGINT;

PRINT 'INSERT [persons].[Persons] at beginning of INSERT [unitlibrary].[Units]';
Insert into persons.Persons (FirstMiddleNames, Gender, IsUSCitizen, ModifiedByAppUserID)
VALUES ('Tester', 'O', 1, 1);

SET @IdentityBigInt = SCOPE_IDENTITY();

PRINT 'INSERT [unitlibrary].[Units]';
INSERT INTO unitlibrary.Units 
(UnitID, UnitParentID, CountryID, UnitLocationID, ConsularDistrictID, IsMainAgency, UnitMainAgencyID, UnitName, UnitNameEnglish, UnitGenID,
UnitTypeID, VettingBatchTypeID, VettingActivityTypeID, ReportingTypeID, UnitHeadPersonID, HQLocationID, VettingPrefix,
HasDutyToInform, IsLocked, ModifiedByAppUserID, POCName, POCEmailAddress, POCTelephone)
VALUES 
( 1000, null, 2159, 33, 1029, 1, 1000, 'Mexico', 'Mexico', 'COUNTRY0001', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1001, 1000, 2159, 33, 1029, 1, 1001, 'Presidencia de la República', 'Presidency', 'PRES0001', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1002, 1001, 2159, 33, 1029, 0, 1001, 'Oficina de la Presidencia', 'Office of the Presidency', 'PRES0002', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1003, 1002, 2159, 33, 1029, 0, 1001, 'Coordinación de Marca País y Medios Internacionales', 'Coordination of Country-Brand and International Media', 'PRES0004', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1004, 1002, 2159, 33, 1029, 0, 1001, 'Coordinador General de Comunicación Social y Vocero del Gobierno de la Republica', 'General Coordination of Social Communication and Federal Government Spokesperson', 'PRES0008', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1005, 1002, 2159, 33, 1029, 0, 1001, 'Coordinación General de Política y Gobierno', 'General Coordination of Policy and Government', 'PRES0010', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1006, 1002, 2159, 33, 1029, 0, 1001, 'Secretaria Particular del Presidente', 'Personal Secretary of the President', 'PRES0014', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1007, 1006, 2159, 33, 1029, 0, 1001, 'Coordinación General de Administración', 'General Coordination of Administration', 'PRES0015', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1008, 1002, 2159, 33, 1029, 0, 1001, 'Órgano Interno de Control de la Presidencia de la Republica', 'Internal Organ of Control of the Republic Presidency', 'PRES0022', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1009, 1002, 2159, 33, 1029, 0, 1001, 'Coordinación de Asesores', 'Coordination of Advisors', 'PRES0003', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1010, 1002, 2159, 33, 1029, 0, 1001, 'Coordinación de Opinión Publica', 'Coordination of Public Opinion', 'PRES0005', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1011, 1002, 2159, 33, 1029, 0, 1001, 'Coordinación de Estrategia Digital Nacional', 'Coordination of National Digital Strategy', 'PRES0006', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1012, 1002, 2159, 33, 1029, 0, 1001, 'Subjefatura de la Oficina de Presidencia', 'Deputy Office of the Presidency', 'PRES0007', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1013, 1004, 2159, 33, 1029, 0, 1001, 'Coordinación de Crónica Presidencial', 'Coordination of Presidential Chronic', 'PRES0009', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1014, 1005, 2159, 33, 1029, 0, 1001, 'Secretaria Técnico del Gabinete', 'Technical Secretariat of the Cabinet', 'PRES0011', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1015, 1005, 2159, 33, 1029, 0, 1001, 'Coordinación de Enlace Institucional', 'Coordination of Institutional Connection', 'PRES0012', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1016, 1005, 2159, 33, 1029, 0, 1001, 'Coordinación de Ciencia, Tecnología e Innovación', 'Coordination of Science, Technology and Innovation', 'PRES0013', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1017, 1007, 2159, 33, 1029, 0, 1001, 'Dirección General de Finanzas y Presupuesto', 'General Directorate of Finance and Budget', 'PRES0016', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1018, 1007, 2159, 33, 1029, 0, 1001, 'Dirección General de Recursos Humanos', 'General Directorate of Human Resources', 'PRES0017', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1019, 1007, 2159, 33, 1029, 0, 1001, 'Dirección General de Recursos Materiales y Servicios Generales', 'General Directorate of Material Resources and General Services', 'PRES0018', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1020, 1007, 2159, 33, 1029, 0, 1001, 'Dirección General de Tecnologías de la Información', 'General Directorate of Information Technologies', 'PRES0019', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1021, 1006, 2159, 33, 1029, 0, 1001, 'Unidad de Enlace para la Transparencia y Acceso a la Información de la Oficina de la Presidencia de la Republica', 'Unit of Connection for the Transparency and Information Access of the Presidency', 'PRES0020', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1022, 1002, 2159, 33, 1029, 0, 1001, 'Secretaria Técnica del Consejo de Seguridad Nacional', 'Technical Secretariat of the Council of National Security', 'PRES0021', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1023, 1008, 2159, 33, 1029, 0, 1001, 'Área de Auditoria Interna de Presidencia de la Republica', 'Area of Internal Audit of Republic Presidency', 'PRES0023', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1024, 1008, 2159, 33, 1029, 0, 1001, 'Área de Auditoria para el Desarrollo y Mejora de la Gestión Publica del Órgano Interno de Control', 'Area of Audit for the Development and Improvement of the Public Administration of the Internal Organ of Control', 'PRES0024', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1025, 1008, 2159, 33, 1029, 0, 1001, 'Área de Responsabilidades y Área de Quejas del Órgano Interno de Control', 'Area of Responsibilities and Area of Complaints of the Internal Organ of Control', 'PRES0025', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1026, 1001, 2159, 33, 1029, 1, 1001, 'Secretaría de Gobernación', 'Secretariat of the Interior', 'SEGOB0001', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1027, 1026, 2159, 33, 1029, 0, 1001, 'Subsecretaría de Derechos Humanos', 'Undersecretariat of Human Rights', 'SEGOB0002', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1028, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Institucional', 'Deputy General Directorate of Institutional Liaison', 'SEGOB0003', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1029, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Investigación y Atención a Casos', 'Deputy General Directorate of Investigation and Assistance to Cases', 'SEGOB0009', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1030, 1029, 2159, 33, 1029, 0, 1001, 'Dirección de Atención a Casos', 'Directorate of Assistance to Cases', 'SEGOB0010', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1031, 1029, 2159, 33, 1029, 0, 1001, 'Dirección de Estudios e Investigación', 'Directorate of Studies and Investigation', 'SEGOB0013', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1032, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Políticas Públicas del Programa Nacional de Derechos Humanos', 'Deputy General Directorate of Public Policy of the National Program of Human Rights', 'SEGOB0016', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1033, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Recepción de Casos y Reacción Rápida', 'Deputy General Directorate of Reception of Cases and Quick Reaction', 'SEGOB0018', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1034, 1033, 2159, 33, 1029, 0, 1001, 'Dirección de Reacción Rápida e Implementación de Medidas Urgentes de Protección', 'Directorate of Quick Reaction and Implementation of Urgent Measures of Protection', 'SEGOB0019', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1035, 1033, 2159, 33, 1029, 0, 1001, 'Dirección de Recepción de Casos y Atención de Acuerdos de la Junta de Gobierno', 'Directorate of Reception of Cases and Assistance of Agreements of the Government Board', 'SEGOB0023', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1036, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Unidad de Evaluación de Riesgos', 'Deputy General Directorate of Risk Evaluation Unit', 'SEGOB0026', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1037, 1036, 2159, 33, 1029, 0, 1001, 'Dirección de Elaboración de Estudios de Riesgo', 'Directorate of Elaboration of Risks Studies', 'SEGOB0027', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1038, 1036, 2159, 33, 1029, 0, 1001, 'Dirección de Seguimiento e Implementación de Medidas Preventivas o de Protección', 'Directorate of Monitoring and Implementation of Preventive Measures or Protection', 'SEGOB0031', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1039, 1027, 2159, 33, 1029, 0, 1001, 'Dirección de Prevención Seguimiento y Análisis', 'Directorate of Prevention Monitoring and Analysis', 'SEGOB0035', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1040, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General de Estrategias para la Atención de Derechos Humanos', 'General Directorate of Strategies for the Assistance to Human Rights', 'SEGOB0045', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1041, 1040, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Atención a Victimas del Delito y Grupos Vulnerables', 'General Directorate of Assistance to Victims of Crime and Vulnerable Groups', 'SEGOB0046', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1042, 1041, 2159, 33, 1029, 0, 1001, 'Dirección de Atención a Grupos en Riesgo', 'Directorate of Assistance to Groups At Risk', 'SEGOB0047', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1043, 1040, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Estrategias Operativas de Atención', 'Deputy General Directorate of Operative Strategies of Attention', 'SEGOB0050', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1044, 1043, 2159, 33, 1029, 0, 1001, 'Dirección de Elaboración y Difusión de Instrumentos de Apoyo', 'Directorate of Elaboration and Diffusion of Instruments of Support', 'SEGOB0051', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1045, 1043, 2159, 33, 1029, 0, 1001, 'Dirección de Enlace con la Comisión Ejecutiva de Atención a Victimas', 'Directorate of Connection with the Executive Commission of Assistance to Victims', 'SEGOB0054', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1046, 1043, 2159, 33, 1029, 0, 1001, 'Dirección de Relaciones y Coordinación Interinstitucional', 'Directorate of Relations and Institutional Coordination', 'SEGOB0057', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1047, 1040, 2159, 33, 1029, 0, 1001, 'Dirección de Desarrollo de Programas', 'Directorate of Program Development', 'SEGOB0060', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1048, 1027, 2159, 33, 1029, 0, 1001, 'Dirección General de Política Pública de Derechos Humanos', 'General Directorate of Public Policy of Human Rights', 'SEGOB0063', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1049, 1048, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Planeación de Políticas Públicas   de Derechos Humanos', 'Deputy General Directorate of Public Policy of Human Rights', 'SEGOB0064', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1050, 1049, 2159, 33, 1029, 0, 1001, 'Dirección de Coordinación de Políticas Públicas   de Derechos Humanos en la Administración Pública Federal', 'Directorate of Coordination of Public Policy of Human Rights in the Federal Public Administration', 'SEGOB0065', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1051, 1049, 2159, 33, 1029, 0, 1001, 'Dirección de Planeación Seguimiento y Evaluación de Políticas Públicas   de Derechos Humanos', 'Directorate of Planning Monitoring and Evaluation of Public Policy of Human Rights', 'SEGOB0068', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1052, 1049, 2159, 33, 1029, 0, 1001, 'Dirección de Vinculación y Enlace', 'Directorate of Entailment and Liaison', 'SEGOB0071', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1053, 1048, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta para la Implementación de la Reforma Constitucional de Derechos Humanos', 'Deputy General Directorate for the Implementation of the Constitutional Reform of Human Rights', 'SEGOB0075', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1054, 1053, 2159, 33, 1029, 0, 1001, 'Dirección de Colaboración Interinstitucional', 'Directorate of Institutional Collaboration', 'SEGOB0076', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1055, 1053, 2159, 33, 1029, 0, 1001, 'Dirección de Estudios e Investigación', 'Directorate of Studies and Investigation', 'SEGOB0080', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1056, 1053, 2159, 33, 1029, 0, 1001, 'Dirección de Implementación y Seguimiento de la Reforma Constitucional en la Administración Pública Federal', 'Directorate of Implementation and Monitoring of the Constitutional Reform in the Federal Public Administration', 'SEGOB0082', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1057, 1048, 2159, 33, 1029, 0, 1001, 'Dirección de Promoción y Capacitación en Derechos Humanos', 'Directorate of Promotion and Training in Human Rights', 'SEGOB0085', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1058, 1027, 2159, 33, 1029, 0, 1001, 'Coordinación Administrativa', 'Administrative Coordination', 'SEGOB0094', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1059, 1058, 2159, 33, 1029, 0, 1001, 'Subdirección de Recursos Humanos', 'Subdirectorate of Human Resources', 'SEGOB0095', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1060, 1027, 2159, 33, 1029, 0, 1001, 'Subsecretario de Enlace Legislativo y Acuerdos Políticos', 'Undersecretariat of Legislative Liaison and Politics Agreements', 'SEGOB0102', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1061, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Enlace con Cámara de Diputados', 'Deputy General Directorate of Liaison with the Chamber of Deputies', 'SEGOB0103', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1062, 1061, 2159, 33, 1029, 0, 1001, 'Dirección de Temas Sociales y de Justicia', 'Directorate in Matter Social and of Justice Affairs', 'SEGOB0104', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1063, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Enlace con Gobierno Federal y Sociedad Civil', 'Deputy General Directorate of Entailment with Federal Government and Civil Society', 'SEGOB0109', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1064, 1063, 2159, 33, 1029, 0, 1001, 'Dirección de Enlace con el Gabinete de Crecimiento con Calidad', 'Directorate of Entailment with the Cabinet of Development with Quality', 'SEGOB0110', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1065, 1063, 2159, 33, 1029, 0, 1001, 'Dirección de Enlace con Gabinetes de Desarrollo Humano y Social y de Orden y Respeto', 'Directorate of Entailment with Cabinets of Human and Social Development and of Order and Respect', 'SEGOB0114', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1066, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Legislativo con el Senado', 'Deputy General Directorate of Legislative Liaison with the Senate', 'SEGOB0120', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1067, 1066, 2159, 33, 1029, 0, 1001, 'Dirección de Asuntos con el Senado', 'Directorate of Affairs with the Senate', 'SEGOB0121', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1068, 1066, 2159, 33, 1029, 0, 1001, 'Dirección de Enlace con el Senado de Asuntos de Gobierno Sociales e Internacionales', 'Directorate of Connection with the Senate of Affairs About Social', 'SEGOB0124', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1069, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Proceso Legislativo', 'Deputy General Directorate of Legislative Procedure', 'SEGOB0126', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1070, 1069, 2159, 33, 1029, 0, 1001, 'Dirección de Procedimientos Legislativos', 'Directorate of Legislative Procedures', 'SEGOB0127', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1071, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General de Acuerdos Políticos', 'General Directorate of Political Agreements', 'SEGOB0133', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1072, 1071, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Vinculación Interna para los Acuerdos Políticos', 'Deputy General Directorate of Internal Entailment for the Political Agreements', 'SEGOB0134', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1073, 1072, 2159, 33, 1029, 0, 1001, 'Dirección de Apoyo Técnico de Vinculación Interna', 'Directorate of Technical Support of Internal Liaison', 'SEGOB0135', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1074, 1071, 2159, 33, 1029, 0, 1001, 'Dirección de Impulso y Construcción de Acuerdos Políticos', 'Directorate of Impulse and Construction of Political Agreements', 'SEGOB0139', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1075, 1071, 2159, 33, 1029, 0, 1001, 'Dirección de Seguimiento y Promoción de Acuerdos Políticos', 'Directorate of Monitoring and Promotion of Political Agreements', 'SEGOB0143', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1076, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General de Estudios Legislativos', 'General Directorate of Legislative Studies', 'SEGOB0147', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1077, 1076, 2159, 33, 1029, 0, 1001, 'Dirección de Estudios Jurídicos', 'Directorate of Legal Studies', 'SEGOB0148', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1078, 1076, 2159, 33, 1029, 0, 1001, 'Dirección de Estudios Legislativos', 'Directorate of Legislative Studies', 'SEGOB0151', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1079, 1076, 2159, 33, 1029, 0, 1001, 'Dirección de Estudios y Diagnósticos para la Modernización de las Instituciones del Estado y en la Resolución de Asuntos Extraordinarios', 'Directorate of Studies and Diagnostic for the Modernization of the Institutions of the State and in the Resolution of Extraordinary Affairs', 'SEGOB0155', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1080, 1060, 2159, 33, 1029, 0, 1001, 'Dirección General de Información Legislativa', 'General Directorate of Legislative Information', 'SEGOB0158', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1081, 1080, 2159, 33, 1029, 0, 1001, 'Dirección de Análisis y Estrategia Legislativa', 'Directorate of Analysis and Legislative Strategy', 'SEGOB0159', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1082, 1080, 2159, 33, 1029, 0, 1001, 'Dirección de Proyectos en Materia Legislativa', 'Directorate of Projects in Legislative Matter', 'SEGOB0161', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1083, 1080, 2159, 33, 1029, 0, 1001, 'Dirección del Sistema de Información Legislativa', 'Directorate of the System of Legislative Information', 'SEGOB0164', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1084, 1060, 2159, 33, 1029, 0, 1001, 'Coordinación Técnica', 'Technical Coordination', 'SEGOB0169', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1085, 1060, 2159, 33, 1029, 0, 1001, 'Dirección de Administración Planeación y Finanzas', 'Directorate of Administration Planning and Finances', 'SEGOB0173', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1086, 1026, 2159, 33, 1029, 0, 1001, 'Subsecretaría  de Gobierno', 'Undersecretariat of the Government', 'SEGOB0178', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1087, 1086, 2159, 33, 1029, 0, 1001, 'Unidad de Enlace Federal y Coordinación con Entidades Federativas', 'Unit of Federal Connection and Coordination with Federal Entities', 'SEGOB0179', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1088, 1087, 2159, 33, 1029, 0, 1001, 'Delegación General Regional Noroeste', 'Regional General Directorate Northeast', 'SEGOB0180', 2, 2, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1089, 1087, 2159, 33, 1029, 0, 1001, 'Delegación General Regional Occidente', 'Regional General Directorate Occident', 'SEGOB0187', 2, 2, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1090, 1087, 2159, 33, 1029, 0, 1001, 'Delegación General Regional Sureste', 'Regional General Directorate Southeast', 'SEGOB0197', 2, 2, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1091, 1087, 2159, 33, 1029, 0, 1001, 'Dirección General de Coordinación de Delegaciones', 'General Directorate of Coordination of Delegations', 'SEGOB0206', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1092, 1091, 2159, 33, 1029, 0, 1001, 'Delegación Distrito Federal', 'Delegation Distrito Federal', 'SEGOB0208', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1093, 1091, 2159, 33, 1029, 0, 1001, 'Delegación Hidalgo', 'Delegation Hidalgo', 'SEGOB0212', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1094, 1091, 2159, 33, 1029, 0, 1001, 'Delegación Tlaxcala', 'Delegation Tlaxcala', 'SEGOB0216', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1095, 1087, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta Zona Noreste', 'Deputy General Directorate Zone Northeast', 'SEGOB0218', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1096, 1095, 2159, 33, 1029, 0, 1001, 'Delegación Tamaulipas', 'Delegation Tamaulipas', 'SEGOB0223', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1097, 1087, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Enlace Federal', 'Deputy General Directorate of Federal Connection', 'SEGOB0227', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1098, 1097, 2159, 33, 1029, 0, 1001, 'Subdirección de Información Política', 'Subdirectorate of Political Information', 'SEGOB0228', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1099, 1087, 2159, 33, 1029, 0, 1001, 'Dirección General Adjunta de Vinculación de Programas de Apoyo Social en las Zonas Noroeste Noreste Bajío Centro Sur y Sureste', 'Deputy General Directorate of Connection of Programs of Social Support in Northeast Zones Northeast Bajio Center South and Southeast', 'SEGOB0231', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', ''),
( 1100, 1099, 2159, 33, 1029, 0, 1001, 'Dirección de Coordinación y Seguimiento del Programa Social B', 'Directorate of Coordination and Monitoring of the Social Program B', 'SEGOB0232', 2, 1, 3, 1, @IdentityBigInt, 33, '',0, 0, 101, '', '', '')

/*  Turn IDENTITY_INSERT OFF    */
SET IDENTITY_INSERT unitlibrary.Units OFF
GO

/*  Set new INDENTIY Starting VALUE */
DBCC CHECKIDENT ('unitlibrary.Units', RESEED)
GO

/* Generate UnitAcronyms */
PRINT 'UPDATE [unitlibrary].[Units] Acronyms';
UPDATE unitlibrary.units
SET UnitAcronym = 
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(unitname, ' ', ''), '.', ''),
'a' COLLATE Latin1_General_CS_AI, ''), 'b', ''), 'c', ''), 'd', ''), 'e', ''), 'f', ''), 'g', ''), 'h', ''), 'i', ''), 'j', ''), 
'k', ''), 'l', ''), 'm', ''), 'n', ''), 'o', ''), 'p', ''), 'q', ''), 'r', ''), 's', ''), 't', ''), 
'u', ''), 'v', ''), 'w', ''), 'x', ''), 'y', ''), 'z', '')
WHERE UnitAcronym IS NULL;

PRINT 'INSERT [unitlibrary].[UnitAliases]';
insert into unitlibrary.UnitAliases(UnitID, UnitAlias, ModifiedByAppUserID) 
values 
(1001, 'testing', 1),
(1010, 'Alias 1', 1),
(1010, 'Alias 2', 1),
(1010, 'Alias 3', 1),
(1021, 'ATF', 1),
(1024, 'FBI', 1),
(1027, 'DEA', 1);
select * from unitlibrary.UnitsView


-- ####
-- #### PARTICIPANTS
-- ####

-- Insert Post batch size info
PRINT 'INSERT [vetting].[PostVettingConfiguration]';
insert into [vetting].[PostVettingConfiguration]
(PostID, MaxBatchSize, LeahyBatchLeadTime, CourtesyBatchLeadTime, ModifiedByAppUserID)
values (1083, 4, 35, 5, 1);

select * from [vetting].[PostVettingConfiguration];

-- load persons
PRINT 'INSERT [persons].[Persons]';
INSERT INTO persons.Persons
(FirstMiddleNames, LastNames, IsUSCitizen, Gender, DOB, NationalID, POBCityID, ModifiedByAppUserID)
VALUES
('First', 'Tester', 0, 'M', '1/1/1960', 'aaaaaa', 444, 1),
('Second', 'Tester', 0, 'M', '1/1/1960', 'aaaaab', 444, 1),
('Third', 'Tester', 0, 'M', '1/1/1960', 'aaaaac', 444, 1),
('Fourth', 'Tester', 0, 'M', '1/1/1960', 'aaaaad', 444, 1),
('Fifth', 'Tester', 0, 'M', '1/1/1960', 'aaaaae', 444, 1),
('Sixth', 'Tester', 0, 'M', '1/1/1960', 'aaaaaf', 444, 1),
('Seventh', 'Tester', 0, 'M', '1/1/1960', 'aaaaag', 444, 1),
('Eighth', 'Tester', 0, 'M', '1/1/1960', 'aaaaah', 444, 1),
('Ninth', 'Tester', 0, 'M', '1/1/1960', 'aaaaai', 444, 1),
('Tenth', 'Tester', 0, 'M', '1/1/1960', 'aaaaaj', 444, 1),
('James','SMITH', 0, 'M', '01/01/1960', 'aaaaak', 444, 1),
('John','JOHNSON', 0, 'M', '01/02/1960', 'aaaaal', 444, 1),
('Robert','WILLIAMS', 0, 'M', '01/03/1960', 'aaaaam', 444, 1),
('Michael','BROWN', 0, 'M', '01/04/1960', 'aaaaan', 444, 1),
('William','JONES', 0, 'M', '01/05/1960', 'aaaaao', 444, 1),
('David','MILLER', 0, 'M', '01/06/1960', 'aaaaap', 444, 1),
('Richard','DAVIS', 0, 'M', '01/07/1960', 'aaaaaq', 444, 1),
('Joseph','GARCIA', 0, 'M', '01/08/1960', 'aaaaar', 444, 1),
('Thomas','RODRIGUEZ', 0, 'M', '01/09/1960', 'aaaaas', 444, 1),
('Charles','WILSON', 0, 'M', '01/10/1960', 'aaaaat', 444, 1),
('Christopher','MARTINEZ', 0, 'M', '01/11/1960', 'aaaaau', 444, 1),
('Daniel','ANDERSON', 0, 'M', '01/12/1960', 'aaaaav', 444, 1),
('Matthew','TAYLOR', 0, 'M', '01/13/1960', 'aaaaaw', 444, 1),
('Anthony','THOMAS', 0, 'M', '01/14/1960', 'aaaaax', 444, 1),
('Donald','HERNANDEZ', 0, 'M', '01/15/1960', 'aaaaay', 444, 1),
('Mark','MOORE', 0, 'M', '01/16/1960', 'aaaaaz', 444, 1),
('Paul','MARTIN', 0, 'M', '01/17/1960', 'baaaab', 444, 1),
('Steven','JACKSON', 0, 'M', '01/18/1960', 'baaaac', 444, 1),
('Andrew','THOMPSON', 0, 'M', '01/19/1960', 'baaaaa', 444, 1),
('Kenneth','WHITE', 0, 'M', '01/20/1960', 'baaaad', 444, 1),
('George','LOPEZ', 0, 'M', '01/21/1960', 'baaaae', 444, 1),
('Joshua','LEE', 0, 'M', '01/22/1960', 'baaaaf', 444, 1),
('Kevin','GONZALEZ', 0, 'M', '01/23/1960', 'baaaag', 444, 1),
('Brian','HARRIS', 0, 'M', '01/24/1960', 'baaaah', 444, 1),
('Edward','CLARK', 0, 'M', '01/25/1960', 'baaaai', 444, 1),
('Ronald','LEWIS', 0, 'M', '01/26/1960', 'baaaaj', 444, 1),
('Timothy','ROBINSON', 0, 'M', '01/27/1960', 'baaaak', 444, 1),
('Jason','WALKER', 0, 'M', '01/28/1960', 'baaaal', 444, 1),
('Jeffrey','PEREZ', 0, 'M', '01/29/1960', 'baaaam', 444, 1),
('Ryan','HALL', 0, 'M', '01/30/1960', 'baaaan', 444, 1),
('Jacob','YOUNG', 0, 'M', '01/31/1960', 'baaaao', 444, 1),
('Gary','ALLEN', 0, 'M', '02/01/1960', 'baaaap', 444, 1),
('Nicholas','SANCHEZ', 0, 'M', '02/02/1960', 'baaaaq', 444, 1),
('Eric','WRIGHT', 0, 'M', '02/03/1960', 'baaaar', 444, 1),
('Stephen','KING', 0, 'M', '02/04/1960', 'baaaas', 444, 1),
('Jonathan','SCOTT', 0, 'M', '02/05/1960', 'baaaat', 444, 1),
('Larry','GREEN', 0, 'M', '02/06/1960', 'baaaau', 444, 1),
('Justin','BAKER', 0, 'M', '02/07/1960', 'baaaav', 444, 1),
('Scott','ADAMS', 0, 'M', '02/08/1960', 'baaaaw', 444, 1),
('Brandon','NELSON', 0, 'M', '02/09/1960', 'baaaax', 444, 1),
('Frank','HILL', 0, 'M', '02/10/1960', 'baaaay', 444, 1),
('Benjamin','RAMIREZ', 0, 'M', '02/11/1960', 'baaaaz', 444, 1),
('Gregory','CAMPBELL', 0, 'M', '02/12/1960', 'caaaaa', 444, 1),
('Raymond','MITCHELL', 0, 'M', '02/13/1960', 'caaaab', 444, 1),
('Samuel','ROBERTS', 0, 'M', '02/14/1960', 'caaaac', 444, 1),
('Patrick','CARTER', 0, 'M', '02/15/1960', 'caaaad', 444, 1),
('Alexander','PHILLIPS', 0, 'M', '02/16/1960', 'caaaae', 444, 1),
('Jack','EVANS', 0, 'M', '02/17/1960', 'caaaaf', 444, 1),
('Dennis','TURNER', 0, 'M', '02/18/1960', 'caaaag', 444, 1),
('Jerry','TORRES', 0, 'M', '02/19/1960', 'caaaah', 444, 1),
('Tyler','PARKER', 0, 'M', '02/20/1960', 'caaaai', 444, 1),
('Aaron','COLLINS', 0, 'M', '02/21/1960', 'caaaaj', 444, 1),
('Henry','EDWARDS', 0, 'M', '02/22/1960', 'caaaak', 444, 1),
('Jose','STEWART', 0, 'M', '02/23/1960', 'caaaal', 444, 1),
('Douglas','FLORES', 0, 'M', '02/24/1960', 'caaaam', 444, 1),
('Peter','MORRIS', 0, 'M', '02/25/1960', 'caaaan', 444, 1),
('Adam','NGUYEN', 0, 'M', '02/26/1960', 'caaaao', 444, 1),
('Nathan','MURPHY', 0, 'M', '02/27/1960', 'caaaap', 444, 1),
('Zachary','RIVERA', 0, 'M', '02/28/1960', 'caaaaq', 444, 1),
('Walter','COOK', 0, 'M', '02/29/1960', 'caaaar', 444, 1),
('Kyle','ROGERS', 0, 'M', '03/01/1960', 'caaaas', 444, 1),
('Harold','MORGAN', 0, 'M', '03/02/1960', 'caaaat', 444, 1),
('Carl','PETERSON', 0, 'M', '03/03/1960', 'caaaau', 444, 1),
('Jeremy','COOPER', 0, 'M', '03/04/1960', 'caaaav', 444, 1),
('Gerald','REED', 0, 'M', '03/05/1960', 'caaaaw', 444, 1),
('Keith','BAILEY', 0, 'M', '03/06/1960', 'caaaax', 444, 1),
('Roger','BELL', 0, 'M', '03/07/1960', 'caaaay', 444, 1),
('Arthur','GOMEZ', 0, 'M', '03/08/1960', 'caaaaz', 444, 1),
('Terry','KELLY', 0, 'M', '03/09/1960', 'daaaac', 444, 1),
('Lawrence','HOWARD', 0, 'M', '03/10/1960', 'daaaaa', 444, 1),
('Sean','WARD', 0, 'M', '03/11/1960', 'daaaab', 444, 1),
('Christian','COX', 0, 'M', '03/12/1960', 'daaaad', 444, 1),
('Ethan','DIAZ', 0, 'M', '03/13/1960', 'daaaae', 444, 1),
('Austin','RICHARDSON', 0, 'M', '03/14/1960', 'daaaaf', 444, 1),
('Joe','WOOD', 0, 'M', '03/15/1960', 'daaaag', 444, 1),
('Albert','WATSON', 0, 'M', '03/16/1960', 'daaaah', 444, 1),
('Jesse','BROOKS', 0, 'M', '03/17/1960', 'daaaai', 444, 1),
('Willie','BENNETT', 0, 'M', '03/18/1960', 'daaaaj', 444, 1),
('Billy','GRAY', 0, 'M', '03/19/1960', 'daaaak', 444, 1),
('Bryan','JAMES', 0, 'M', '03/20/1960', 'daaaal', 444, 1),
('Bruce','REYES', 0, 'M', '03/21/1960', 'daaaam', 444, 1),
('Noah','CRUZ', 0, 'M', '03/22/1960', 'daaaan', 444, 1),
('Jordan','HUGHES', 0, 'M', '03/23/1960', 'daaaao', 444, 1),
('Dylan','PRICE', 0, 'M', '03/24/1960', 'daaaap', 444, 1),
('Ralph','MYERS', 0, 'M', '03/25/1960', 'daaaaq', 444, 1),
('Roy','LONG', 0, 'M', '03/26/1960', 'daaaar', 444, 1),
('Alan','FOSTER', 0, 'M', '03/27/1960', 'daaaas', 444, 1),
('Wayne','SANDERS', 0, 'M', '03/28/1960', 'daaaat', 444, 1),
('Eugene','ROSS', 0, 'M', '03/29/1960', 'daaaau', 444, 1),
('Juan','MORALES', 0, 'M', '03/30/1960', 'daaaav', 444, 1),
('Gabriel','POWELL', 0, 'M', '03/31/1960', 'daaaaw', 444, 1),
('Louis','SULLIVAN', 0, 'M', '04/01/1960', 'daaaax', 444, 1),
('Russell','RUSSELL', 0, 'M', '04/02/1960', 'daaaay', 444, 1),
('Randy','ORTIZ', 0, 'M', '04/03/1960', 'daaaaz', 444, 1),
('Vincent','JENKINS', 0, 'M', '04/04/1960', 'eaaaab', 444, 1),
('Philip','GUTIERREZ', 0, 'M', '04/05/1960', 'eaaaac', 444, 1),
('Logan','PERRY', 0, 'M', '04/06/1960', 'eaaaaa', 444, 1),
('Bobby','BUTLER', 0, 'M', '04/07/1960', 'eaaaad', 444, 1),
('Harry','BARNES', 0, 'M', '04/08/1960', 'eaaaae', 444, 1),
('Johnny','FISHER', 0, 'M', '04/09/1960', 'eaaaaf', 444, 1),
('Mary','HENDERSON', 0, 'F', '04/10/1960', 'eaaaag', 444, 1),
('Patricia','COLEMAN', 0, 'F', '04/11/1960', 'eaaaah', 444, 1),
('Jennifer','SIMMONS', 0, 'F', '04/12/1960', 'eaaaai', 444, 1),
('Linda','PATTERSON', 0, 'F', '04/13/1960', 'eaaaaj', 444, 1),
('Elizabeth','JORDAN', 0, 'F', '04/14/1960', 'eaaaak', 444, 1),
('Barbara','REYNOLDS', 0, 'F', '04/15/1960', 'eaaaal', 444, 1),
('Susan','HAMILTON', 0, 'F', '04/16/1960', 'eaaaam', 444, 1),
('Jessica','GRAHAM', 0, 'F', '04/17/1960', 'eaaaan', 444, 1),
('Sarah','KIM', 0, 'F', '04/18/1960', 'eaaaao', 444, 1),
('Margaret','GONZALES', 0, 'F', '04/19/1960', 'eaaaap', 444, 1),
('Karen','ALEXANDER', 0, 'F', '04/20/1960', 'eaaaaq', 444, 1),
('Nancy','RAMOS', 0, 'F', '04/21/1960', 'eaaaar', 444, 1),
('Lisa','WALLACE', 0, 'F', '04/22/1960', 'eaaaas', 444, 1),
('Betty','GRIFFIN', 0, 'F', '04/23/1960', 'eaaaat', 444, 1),
('Dorothy','WEST', 0, 'F', '04/24/1960', 'eaaaau', 444, 1),
('Sandra','COLE', 0, 'F', '04/25/1960', 'eaaaav', 444, 1),
('Ashley','HAYES', 0, 'F', '04/26/1960', 'eaaaaw', 444, 1),
('Kimberly','CHAVEZ', 0, 'F', '04/27/1960', 'eaaaax', 444, 1),
('Donna','GIBSON', 0, 'F', '04/28/1960', 'eaaaay', 444, 1),
('Emily','BRYANT', 0, 'F', '04/29/1960', 'eaaaaz', 444, 1),
('Carol','ELLIS', 0, 'F', '04/30/1960', 'faaaaa', 444, 1),
('Michelle','STEVENS', 0, 'F', '05/01/1960', 'faaaab', 444, 1),
('Amanda','MURRAY', 0, 'F', '05/02/1960', 'faaac', 444, 1),
('Melissa','FORD', 0, 'F', '05/03/1960', 'faaaad', 444, 1),
('Deborah','MARSHALL', 0, 'F', '05/04/1960', 'faaaae', 444, 1),
('Stephanie','OWENS', 0, 'F', '05/05/1960', 'faaaaf', 444, 1),
('Rebecca','MCDONALD', 0, 'F', '05/06/1960', 'faaaag', 444, 1),
('Laura','HARRISON', 0, 'F', '05/07/1960', 'faaaah', 444, 1),
('Helen','RUIZ', 0, 'F', '05/08/1960', 'faaaai', 444, 1),
('Sharon','KENNEDY', 0, 'F', '05/09/1960', 'faaaaj', 444, 1),
('Cynthia','WELLS', 0, 'F', '05/10/1960', 'faaaak', 444, 1),
('Kathleen','ALVAREZ', 0, 'F', '05/11/1960', 'faaaal', 444, 1),
('Amy','WOODS', 0, 'F', '05/12/1960', 'faaaam', 444, 1),
('Shirley','MENDOZA', 0, 'F', '05/13/1960', 'faaaan', 444, 1),
('Angela','CASTILLO', 0, 'F', '05/14/1960', 'faaaao', 444, 1),
('Anna','OLSON', 0, 'F', '05/15/1960', 'faaaap', 444, 1),
('Ruth','WEBB', 0, 'F', '05/16/1960', 'faaaaq', 444, 1),
('Brenda','WASHINGTON', 0, 'F', '05/17/1960', 'faaaar', 444, 1),
('Pamela','TUCKER', 0, 'F', '05/18/1960', 'faaaas', 444, 1),
('Nicole','FREEMAN', 0, 'F', '05/19/1960', 'faaaat', 444, 1),
('Katherine','BURNS', 0, 'F', '05/20/1960', 'faaaau', 444, 1),
('Samantha','HENRY', 0, 'F', '05/21/1960', 'faaaav', 444, 1),
('Christine','VASQUEZ', 0, 'F', '05/22/1960', 'faaaaw', 444, 1),
('Catherine','SNYDER', 0, 'F', '05/23/1960', 'faaaax', 444, 1),
('Virginia','SIMPSON', 0, 'F', '05/24/1960', 'faaaay', 444, 1),
('Debra','CRAWFORD', 0, 'F', '05/25/1960', 'faaaaz', 444, 1),
('Rachel','JIMENEZ', 0, 'F', '05/26/1960', 'gaaaac', 444, 1),
('Janet','PORTER', 0, 'F', '05/27/1960', 'gaaaaa', 444, 1),
('Emma','MASON', 0, 'F', '05/28/1960', 'gaaaab', 444, 1),
('Carolyn','SHAW', 0, 'F', '05/29/1960', 'gaaaad', 444, 1),
('Maria','GORDON', 0, 'F', '05/30/1960', 'gaaaae', 444, 1),
('Heather','WAGNER', 0, 'F', '05/31/1960', 'gaaaaf', 444, 1),
('Diane','HUNTER', 0, 'F', '06/01/1960', 'gaaaag', 444, 1),
('Julie','ROMERO', 0, 'F', '06/02/1960', 'gaaaah', 444, 1),
('Joyce','HICKS', 0, 'F', '06/03/1960', 'gaaaai', 444, 1),
('Evelyn','DIXON', 0, 'F', '06/04/1960', 'gaaaaj', 444, 1),
('Joan','HUNT', 0, 'F', '06/05/1960', 'gaaaak', 444, 1),
('Victoria','PALMER', 0, 'F', '06/06/1960', 'gaaaal', 444, 1),
('Kelly','ROBERTSON', 0, 'F', '06/07/1960', 'gaaaam', 444, 1),
('Christina','BLACK', 0, 'F', '06/08/1960', 'gaaaan', 444, 1),
('Lauren','HOLMES', 0, 'F', '06/09/1960', 'gaaaao', 444, 1),
('Frances','STONE', 0, 'F', '06/10/1960', 'gaaaap', 444, 1),
('Martha','MEYER', 0, 'F', '06/11/1960', 'gaaaaq', 444, 1),
('Judith','BOYD', 0, 'F', '06/12/1960', 'gaaaar', 444, 1),
('Cheryl','MILLS', 0, 'F', '06/13/1960', 'gaaaas', 444, 1),
('Megan','WARREN', 0, 'F', '06/14/1960', 'gaaaat', 444, 1),
('Andrea','FOX', 0, 'F', '06/15/1960', 'gaaaau', 444, 1),
('Olivia','ROSE', 0, 'F', '06/16/1960', 'gaaaav', 444, 1),
('Ann','RICE', 0, 'F', '06/17/1960', 'gaaaaw', 444, 1),
('Jean','MORENO', 0, 'F', '06/18/1960', 'gaaaax', 444, 1),
('Alice','SCHMIDT', 0, 'F', '06/19/1960', 'gaaaay', 444, 1),
('Jacqueline','PATEL', 0, 'F', '06/20/1960', 'gaaaaz', 444, 1),
('Hannah','FERGUSON', 0, 'F', '06/21/1960', 'haaaab', 444, 1),
('Doris','NICHOLS', 0, 'F', '06/22/1960', 'haaaac', 444, 1),
('Kathryn','HERRERA', 0, 'F', '06/23/1960', 'haaaaa', 444, 1),
('Gloria','MEDINA', 0, 'F', '06/24/1960', 'haaaad', 444, 1),
('Teresa','RYAN', 0, 'F', '06/25/1960', 'haaaae', 444, 1),
('Sara','FERNANDEZ', 0, 'F', '06/26/1960', 'haaaaf', 444, 1),
('Janice','WEAVER', 0, 'F', '06/27/1960', 'haaaag', 444, 1),
('Marie','DANIELS', 0, 'F', '06/28/1960', 'haaaah', 444, 1),
('Julia','STEPHENS', 0, 'F', '06/29/1960', '232TH4624', 444, 1),
('Grace','GARDNER', 0, 'F', '06/30/1960', 'haaaai', 444, 1),
('Judy','PAYNE', 0, 'F', '07/01/1960', 'haaaaj', 444, 1),
('Theresa','KELLEY', 0, 'F', '07/02/1960', 'haaaak', 444, 1),
('Madison','DUNN', 0, 'F', '07/03/1960', 'haaaal', 444, 1),
('Beverly','PIERCE', 0, 'F', '07/04/1960', 'haaaam', 444, 1),
('Denise','ARNOLD', 0, 'F', '07/05/1960', 'haaaan', 444, 1),
('Marilyn','TRAN', 0, 'F', '07/06/1960', 'haaaao', 444, 1),
('Amber','SPENCER', 0, 'F', '07/07/1960', 'haaaap', 444, 1),
('Danielle','PETERS', 0, 'F', '07/08/1960', '232TH4621', 444, 1),
('Rose','HAWKINS', 0, 'F', '07/09/1960', 'haaaaq', 444, 1),
('Brittany','GRANT', 0, 'F', '07/10/1960', 'haaaar', 444, 1),
('Diana','HANSEN', 0, 'F', '07/11/1960', 'haaaas', 444, 1),
('Abigail','CASTRO', 0, 'F', '07/12/1960', 'haaaat', 444, 1),
('Natalie','HOFFMAN', 0, 'F', '07/13/1960', 'haaaau', 444, 1),
('Jane','HART', 0, 'F', '07/14/1960', 'haaaav', 444, 1),
('Lori','ELLIOTT', 0, 'F', '07/15/1960', '4545REF45', 444, 1),
('Alexis','CUNNINGHAM', 0, 'F', '07/16/1960', 'haaaaw', 444, 1),
('Tiffany','KNIGHT', 0, 'F', '07/17/1960', 'haaaax', 444, 1),
('Kayla','BRADLEY', 0, 'F', '07/18/1960', '965433434', 444, 1)


select * from persons.Persons;

-- load person unit library info
PRINT 'INSERT [persons].[PersonsUnitLibraryInfo]';
INSERT INTO persons.PersonsUnitLibraryInfo
(PersonID, UnitID, IsVettingReq, IsLeahyVettingReq, IsArmedForces, IsLawEnforcement, IsSecurityIntelligence, IsValidated, JobTitle, RankID, ModifiedByAppUserID)
VALUES
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'First'),    1088, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Second'),   1089, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Third'),    1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Fourth'),   1004, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Fifth'),    1005, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Sixth'),    1006, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Seventh'),  1007, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Eighth'),   1091, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Ninth'),    1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tenth'),    1089, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Julia'),    1088, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Danielle'), 1089, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Kayla'),    1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Lori'),     1004, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Madison'),  1005, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Samuel'),   1006, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tyler'),    1007, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Adam'),     1091, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Walter'),   1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Kyle'),     1089, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Frances'),  1088, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Megan'),    1089, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Doris'),    1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Heather'),  1004, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Victoria'), 1005, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Jose'),     1006, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Harold'),   1007, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Arthur'),   1091, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Ralph'),    1090, 1, 1, 0, 0, 0, 0, 'Tester', 72, 1),
((select PersonID from persons.Persons WHERE FirstMiddleNames = 'Jack'),     1089, 1, 0, 0, 0, 0, 0, 'Tester', 72, 1)

select * from persons.PersonsUnitLibraryInfoView;


-- load students 
PRINT 'INSERT [training].[TrainingEventParticipants]';
INSERT INTO training.TrainingEventParticipants
(TrainingEventParticipantTypeID, PersonID, TrainingEventID, IsVIP, IsParticipant, IsTraveling, RemovedFromEvent, ModifiedByAppUserID, DepartureCityID, DepartureDate, ReturnDate)
VALUES
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'First'), 1, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Second'), 1, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Third'), 1, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Fourth'), 1, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Fifth'), 1, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Jose'), 2, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Harold'), 2, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Arthur'), 2, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (SELECT PersonID FROM persons.Persons WHERE FirstMiddleNames = 'Ralph'), 2, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( 1, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Jack'), 2, 0, 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020');

INSERT INTO training.TrainingEventParticipants
(PersonID, TrainingEventID, IsVIP, IsParticipant, IsTraveling, RemovedFromEvent, ModifiedByAppUserID)
VALUES
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Sixth'), 1, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Seventh'), 1, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Eighth'), 1, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Ninth'), 1, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tenth'), 1, 0, 1, 0, 0, 1),

( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Frances'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Megan'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Doris'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Heather'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Victoria'), 2, 0, 1, 0, 0, 1),

( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'First'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Second'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Third'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Fourth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Fifth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Sixth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Seventh'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Eighth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Ninth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tenth'), 2, 0, 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Madison'), 2, 0, 1, 0, 0, 1);


select * from training.TrainingEventParticipants WHERE TrainingEventParticipantTypeID != 2;

-- load instructors
PRINT 'INSERT [training].[TrainingEventParticipants 1]';
INSERT INTO training.TrainingEventParticipants
(PersonID, TrainingEventID, IsTraveling, RemovedFromEvent, ModifiedByAppUserID, DepartureCityID, DepartureDate, ReturnDate)
VALUES
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Julia'), 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Danielle'), 2, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Kayla'), 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Lori'), 2, 1, 0, 1, 120, '8/9/2020', '8/24/2020'),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Madison'), 1, 1, 0, 1, 120, '8/9/2020', '8/24/2020');

-- load student training 
PRINT 'INSERT [training].[TrainingEventParticipants 2]';
INSERT INTO training.TrainingEventParticipants
(PersonID, TrainingEventID, IsTraveling, RemovedFromEvent, ModifiedByAppUserID)
VALUES
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Samuel'), 2, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tyler'), 1,  0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Adam'), 2, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Walter'), 1, 0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Kyle'), 2, 0, 0, 1),

( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Tyler'), 2,  0, 0, 1),
( (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Walter'), 2, 0, 0, 1);

select * from training.TrainingEventParticipants;

DECLARE @IdentityInt INT;

PRINT 'INSERT [training].[TrainingEventGroups]';
INSERT INTO training.TrainingEventGroups
(TrainingEventID, GroupName, ModifiedByAppUserID)
VALUES
(2, 'Group A', 1);
SET @IdentityInt = SCOPE_IDENTITY();

PRINT 'INSERT [training].[TrainingEventGroupMembers]';
INSERT INTO training.TrainingEventGroupMembers
(TrainingEventGroupID, PersonID, GroupMemberTypeID, ModifiedByAppUserID)
VALUES
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Frances'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Megan'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Doris'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Heather'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Victoria'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Danielle'), 1, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Lori'), 1, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Samuel'), 1, 1)

PRINT 'INSERT [training].[TrainingEventGroups]';
INSERT INTO training.TrainingEventGroups
(TrainingEventID, GroupName, ModifiedByAppUserID)
VALUES
(2, 'Group B', 1);
SET @IdentityInt = SCOPE_IDENTITY();

PRINT 'INSERT [training].[TrainingEventGroupMembers]';
INSERT INTO training.TrainingEventGroupMembers
(TrainingEventGroupID, PersonID, GroupMemberTypeID, ModifiedByAppUserID)
VALUES
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Jose'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Harold'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Arthur'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Ralph'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Jack'), 2, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Adam'), 1, 1),
( @IdentityInt, (select PersonID from persons.Persons WHERE FirstMiddleNames = 'Kyle'), 1, 1)

select * from training.TrainingEventGroups;
select * from training.TrainingEventGroupMembers;


-- ####
-- #### AUTHORIZING LAW AND FUNDING SOURCE FOR POST
-- ####

-- INSERT AGENCY AT POST AUTHORIZING LAWS
PRINT 'INSERT [vetting].[AgencyAtPostAuthorizingLaws]';
insert into vetting.AgencyAtPostAuthorizingLaws
(PostID, UnitID, AuthorizingLawID, IsActive, ModifiedByAppUserID)
select 1083, 1, AuthorizingLawID, 1, 1 from vetting.AuthorizingLaws

select * from vetting.AgencyAtPostAuthorizingLawsView;

-- INSERT AGENCY AT POST VETTING FUNDING SOURCES
PRINT 'INSERT [vetting].[AgencyAtPostVettingFundingSources]';
insert into vetting.AgencyAtPostVettingFundingSources
(PostID, UnitID, VettingFundingSourceID, IsActive, ModifiedByAppUserID)
select 1083, 1, VettingFundingSourceID, 1, 1 from vetting.VettingFundingSources

select * from vetting.AgencyAtPostVettingFundingSourcesView;

-- INSERT POST-SPECIFIC VETTING TYPES
PRINT 'INSERT [vetting].[PostVettingTypes]';
insert into vetting.PostVettingTypes
(PostID, VettingTypeID, UnitID, ModifiedByAppUserID)
select 1083, VettingTypeID, 1, 1 from vetting.VettingTypes;

select * from vetting.PostVettingTypesView;

-- ####
-- #### VETTING BATCHES
-- ###

--INSERT VETTING BATCH AND PERSON VETTING BATCHES

PRINT 'EXEC [vetting].[SaveVettingBatch]';
EXEC   [vetting].[SaveVettingBatch]
			@VettingBatchName = N'First Vetting Batch', 
			@TrainingEventID = 1, 
            @CountryID = 2159,
			@VettingBatchTypeID = 2 ,
			@AssignedToAppUserID = NULL,
			@VettingBatchStatusID = 8, 
			@BatchRejectionReason = N'Note to test vetting batch rejection comment',
			@IsCorrectionRequired = 0,
			@CourtesyVettingOverrideFlag = 0,
			@CourtesyVettingOverrideReason = NULL,
			@GTTSTrackingNumber = NULL, 
			@LeahyTrackingNumber = NULL, 
			@INKTrackingNumber = NULL,
			@DateVettingResultsNeededBy = NULL,
			@DateSubmitted = N'1/1/2019',
			@DateAccepted ='2/5/2019',
			@DateSentToCourtesy = NULL,
			@DateCourtesyCompleted  = NULL,
			@DateSentToLeahy  = N'1/15/2019',
			@DateLeahyResultsReceived = N'4/20/2019',
			@DateVettingResultsNotified = NULL,
			@VettingFundingSourceID = 1,    
			@AuthorizingLawID = 1,    
			@VettingBatchNotes = NULL,
			@ModifiedByAppUserID = 1,
			@ModifiedDate = N'4/20/2019',
			@PersonVettings = '[{"Name1":"Julia", "Name5":"STEPHENS", "PersonsUnitLibraryInfoID":11,"VettingPersonStatusID":2,"VettingStatusDate":"4/20/2019", "ModifiedByAppUserID": 1, "ModifiedDate": "4/20/2019"},
								{"Name1":"Tyler", "Name5":"PARKER", "PersonsUnitLibraryInfoID":17,"VettingPersonStatusID":3,"VettingStatusDate":"4/20/2019", "ModifiedByAppUserID": 1, "ModifiedDate":"4/20/2019"},
								{"Name1":"Kayla", "Name5":"BRADLEY", "PersonsUnitLibraryInfoID":13,"VettingPersonStatusID":5,"VettingStatusDate":"4/20/2018", "ModifiedByAppUserID": 1, "ModifiedDate":"1/20/2019"},
								{"Name1":"Walter", "Name5":"COOK", "PersonsUnitLibraryInfoID":19,"VettingPersonStatusID":4,"VettingStatusDate":"4/20/2019", "ModifiedByAppUserID": 1, "ModifiedDate":"4/20/2019"}]'




