/*
    This script reloads the Onboarding... tables with the Costa Rica Onboarding Data Values.

    1) Truncate any pre-existing data in the Onboarding... tables.
    2) Insert new Onboarding Template data records for the country being onboarded.
*/

USE [INLDB]
GO

SET NOCOUNT ON;

-- *****************************************************
-- Show Onboarding table record counts - BEFORE TRUNCATE
-- *****************************************************
SELECT 'BEFORE TRUNCATE' AS Status, 
    (SELECT COUNT(*) FROM [migration].[OnboardingAuthorizingDocumentsList]) AS AuthDocsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingBusinessUnitsList]) AS BusinessUnitsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingCitiesList]) AS CitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingDefaultBudgetCalcValues]) AS OnboardingDefaultBudgetCalcValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingImplementingPartners]) AS OnboardingImplementingPartners,
    (SELECT COUNT(*) FROM [migration].[OnboardingKeyActivitiesList]) AS KeyActivitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingPostConfigurationValues]) AS PostConfigValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingRanksList]) AS RanksList,
    (SELECT COUNT(*) FROM [migration].[OnboardingStatesList]) AS StatesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingTrainingEventFundingSourcesList]) AS TEFundSourcesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingUsersList]) AS UsersList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingAuthorizingLawsList]) AS VettingAuthLawsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingFundingList]) AS VettingFundingList;


-- *****************************************************
-- Empty the Onboarding tables of any pre-existing data.
-- *****************************************************
TRUNCATE TABLE [migration].[OnboardingAuthorizingDocumentsList];
TRUNCATE TABLE [migration].[OnboardingBusinessUnitsList];
TRUNCATE TABLE [migration].[OnboardingCitiesList];
TRUNCATE TABLE [migration].[OnboardingDefaultBudgetCalcValues];
TRUNCATE TABLE [migration].[OnboardingImplementingPartners];
TRUNCATE TABLE [migration].[OnboardingKeyActivitiesList];
TRUNCATE TABLE [migration].[OnboardingPostConfigurationValues];
TRUNCATE TABLE [migration].[OnboardingRanksList];
TRUNCATE TABLE [migration].[OnboardingStatesList];
TRUNCATE TABLE [migration].[OnboardingTrainingEventFundingSourcesList];
TRUNCATE TABLE [migration].[OnboardingUsersList];
TRUNCATE TABLE [migration].[OnboardingVettingAuthorizingLawsList];
TRUNCATE TABLE [migration].[OnboardingVettingFundingList];

-- **********************************************************************
-- Show Onboarding table record counts - AFTER TRUNCATE & BEFORE INSERTS.
-- **********************************************************************
SELECT 'AFTER TRUNCATE & BEFORE INSERTS' AS Status,
    (SELECT COUNT(*) FROM [migration].[OnboardingAuthorizingDocumentsList]) AS AuthDocsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingBusinessUnitsList]) AS BusinessUnitsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingCitiesList]) AS CitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingDefaultBudgetCalcValues]) AS OnboardingDefaultBudgetCalcValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingImplementingPartners]) AS OnboardingImplementingPartners,
    (SELECT COUNT(*) FROM [migration].[OnboardingKeyActivitiesList]) AS KeyActivitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingPostConfigurationValues]) AS PostConfigValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingRanksList]) AS RanksList,
    (SELECT COUNT(*) FROM [migration].[OnboardingStatesList]) AS StatesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingTrainingEventFundingSourcesList]) AS TEFundSourcesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingUsersList]) AS UsersList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingAuthorizingLawsList]) AS VettingAuthLawsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingFundingList]) AS VettingFundingList;

-- ****************************************************************************
-- Insert new Onboarding Template data records for the country being onboarded.
-- ****************************************************************************
-- OnboardingAuthorizingDocumentsList
INSERT [migration].[OnboardingAuthorizingDocumentsList] ([Code], [Description]) VALUES (N'LOA 2009-01', N'Letter of Agreement between USA and Costa Rica');
INSERT [migration].[OnboardingAuthorizingDocumentsList] ([Code], [Description]) VALUES (N'SINLEC15YBUS', N'IAA Customs and Borders Patrol');
INSERT [migration].[OnboardingAuthorizingDocumentsList] ([Code], [Description]) VALUES (N'ICITAP', N'IAA Regional ICITAP');

-- OnboardingBusinessUnitsList
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'International Narcotics & Law Enforcement', N'INL', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Justice Sector Reform', N'INL-JSR', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Forensics', N'INL-JSR-FOR', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Criminal Investigations', N'INL-JSR-CIT', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Prosecutions', N'INL-JSR-CP', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Investigative Police', N'INL-JSR-INV', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Community Policing', N'INL-COPOL', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Police Professionalization', N'INL-COPOL-PP', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Demand Reduction', N'INL-COLPOL-DDR', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Gang Resistance Education and Training (GREAT) ', N'INL-COPOL-G', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Community Coalitions', N'INL-COPOL-CC', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Community Colaborative Strategy', N'INL-COPOL-CCS', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Maritime and Land Interdictions', N'INL-INT', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Borders and Ports', N'INL-INT-BP', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Air Surveillance', N'INL-INT-AS', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Immigration Police', N'INL-INT-IP', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Prison Management', N'INL-JSR-PM', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Money Laundering', N'INL-JSR-ML', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Gender Based Violence ', N'INL-COPOL-GBV', N'Y', NULL);
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'US Dept. of State Political Office', N'POL', N'Y', N'Y');
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'US Dept. of State Consular Office', N'CONS', N'Y', N'Y');
INSERT [migration].[OnboardingBusinessUnitsList] ([BusinessUnitName], [Acronym], [HasDutyToInform], [CourtesyVettingUnit]) VALUES (N'Regional Security Office', N'RSO', N'Y', N'Y');

-- OnboardingCitiesList
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Alajuela');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Atenas');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Grecia');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Guatuso');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Los Chiles');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Naranjo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Orotina');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Palmares');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Póas');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Rio Cuarto');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'San Carlos');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'San Mateo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'San Ramón');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Sarchí');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Upala');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Alajuela', N'Zarcero');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Alvarado');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Cartago');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'El Guarco');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Jimenez');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'La union');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Oreamuno');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Paraíso');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Cartago', N'Turrialba');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Abangares');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Bagaces');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Cañas');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Carrillo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Hojancha');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'La Cruz');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Liberia');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Nandayure');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Nicoya');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Santa Cruz');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Guanacaste', N'Tilarán');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Barva');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Belén');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Flores');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Heredia');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'San Isidro');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'San Pablo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'San Rafael');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Santa Bárbara');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Santo Domingo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Heredia', N'Sarapiquí');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Guácimo');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Limón');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Matina');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Pococí');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Siquirres');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Limón', N'Talamanca');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Buenos Aires');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Corredores');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Coto brus');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Esparza');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Garabito');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Golfito');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Montes de oro');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Osa');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Parrita');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Puntarenas');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'Puntarenas', N'Quepos');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Acosta');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Alajuelita');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Aserri');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Curridabat');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Desamparados');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Dota');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Escazu');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Goicoechea');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Leon Cortés');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Montes de Oca');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Mora');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Moravia');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Perez Zeledón');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Puriscal');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'San José');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Santa ana');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Tarrazu');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Tibás');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Turrubares');
INSERT [migration].[OnboardingCitiesList] ([StateName], [CityName]) VALUES (N'San José', N'Vasquez de coronado');

-- OnboardingDefaultBudgetCalcValues
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'Domestic Flight (Round Trip)', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'International Flight (Round Trip)', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'Domestic Flight (One Way)', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'International Flight (One Trip)', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'Baggage Fees', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'Excess Baggage Fees', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'ARPEL / Firearms Fee', 850.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Air Transportation', N'Ticket Penalties', 0.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Rental Car - Economy (seats up to 4)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Rental Car - Compact (seats up to 5)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Rental Car - Full-Size (seats up to 5)', 50.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Rental Car - Suburban (seats up to 7)', 50.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Rental Car - Passenger Van (seats up to 15)', 100.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Bus - Small (seats up to 10)', 100.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Bus - Medium (seats up to 40)', 950.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Bus - Large (seats up to 50)', 1000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Van - Small (seats up to 5)', 300.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Van - Medium (seats up to 10)', 400.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Shuttle - Small (seats up to 5)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Shuttle - Large (seats up to 20)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Taxi (one-way)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Taxi (round trip)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Ground Transportation', N'Bus Fare', 0.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Lodging', N'Hotel', 45.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Lodging', N'Academy / Training Center', 45.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Lodging', N'Lay-Over Lodging', 45.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'M&IE', N'M&IE', 45.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Insurance', N'Travel Insurance', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Insurance', N'Health Insurance', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Insurance', N'Pilot''s Insurance', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Insurance', N'Canine Insurance', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (1-10 People)', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (1-25 People)', 2800.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (1-50 People)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (51-100 People)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (101-200 People)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (201-400 People)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (401-600 People)', 7500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Conference Rooms', N'Conf. Room (601-800 People)', 10000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Equipment', N'AV Equipment', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Equipment', N'IT Equipment', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Equipment', N'Internet Connection', 2800.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Equipment', N'Microphones / Headsets', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Coffee / Refreshments - Morning (venue)', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Coffee / Refreshments - All Day (venue)', 2800.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Coffee / Refreshments - Morning (vendor)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Coffee / Refreshments - All Day (vendor)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Lunch / Dinner Service (venue)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Meals & Refreshments', N'Lunch / Dinner Service (vendor)', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Interpretation Services', N'Interpreter', 1500.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Interpretation Services', N'Table-Top Booth', 2800.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Interpretation Services', N'Full-Size Booth', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Interpretation Services', N'Mobile Transmitter', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Interpretation Services', N'Headsets', 5000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Event Registration', N'Registration Fee', 0.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Certificates (standard)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Certificates (embossed)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Certificate Holders', 50.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Folders', 50.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Binders', 100.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Flip Boards', 100.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Notepads (10 pcs.)', 950.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Pens (10 pcs.)', 1000.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Pencils (10 pcs.)', 300.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Markers (10 pcs.)', 400.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Paper - Letter (500 pcs.)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Paper - Legal (500 pcs.)', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Photographs', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Thumb Drives / USBs', 75.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Training Supplies', N'Shipping', 0.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Gas / Fuel', 0.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Internet Access', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Visa Fees', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'ATM Fees', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Parking Fees', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Tolls', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Event Assistant / Support', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Furniture Rental', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Translation Services', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Photography / Video Service', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Printing (black & white)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Printing (color)', 25.0000);
INSERT [migration].[OnboardingDefaultBudgetCalcValues] ([CategoryName], [ItemType], [DefaultValue]) VALUES (N'Special Services / Other', N'Shipping', 0.0000);

-- OnboardingImplementingPartners
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Acción Joven', N'FAJ');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Arquitectura Solidaria', N'ARSOL');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Colombo Plan', NULL);
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Community Anti-Drug Coalitions of America ', N'CADCA');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Contractor', NULL);
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Customs and Border Patrol', N'CBP');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Department of Defense', N'DOD');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Department of Homeland Security', N'DHS');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Department of Justice', N'DOJ');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Department of State', N'DOS');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Drug Enforcement Administration', N'DEA');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'El Centro de Estudios y Capacitación Cooperativa ', N'CENECOP');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Escuela Nacional de Carabineros ', N'ESCAR');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Export Control and Related Border Security', N'EXBS');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Federal Bureau of Investigation', N'FBI');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Fraud Prevention Unit', N'FPU');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Fundación para la paz y la democracia', N'FUNPADEM');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Gang Resistance Education And Training', N'GREAT');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Grantee', NULL);
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Homeland Security Investigations', N'HSI');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'International Criminal Investigative Training Assistance Program', N'ICITAP');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'International Law Enforcement Academy', N'ILEA');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'International Narcotics and Law Enforcement Affairs', N'INL');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'International Narcotics and Law Enforcement Affairs - Costa Rica', N'INL-COSTARICA');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Miami Dade Police Department', N'MDPD');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'National Center for State Courts', N'NCSC');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Office of Defense Coordination', N'ODC');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Office of Foreign Assets Control ', N'OFAC');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Office of Overseas Prosecutorial Development Assistance & Training', N'OPDAT');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Organization of American States', N'OAS');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Population Services International', N'PSI');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'RET International', N'RET');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Unión Nacional de Gobiernos Locales ', N'UNGL');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'United Nations Office on Drugs and Crime', N'UNODC');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'Western Hemisphere Institute for Security Cooperation', N'WHINSEC');
INSERT [migration].[OnboardingImplementingPartners] ([FullName], [Acronym]) VALUES (N'World Customs Organization', N'WCO');

-- OnboardingKeyActivitiesList 
-- Because users are not supplying short form [codes] for Key Activities, we need to put the long 
-- form description text in the [Code] column and the short form code text in the [Description] 
-- column.  This way the drop-down list will display the long form text in the application.
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Airports', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Institutionalize A Stronger Inter-Agency And Regional Border Security Policy', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Land Ports Of Entry ', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Mail Distribution', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Places In Between', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Border Security - Seaports', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Capacity Enhancement', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Community Coalitions', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Community Collaborative Strategy', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Cyber Security', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - GREAT', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Municipal Police Development', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Reducing Gender Based Violence', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Community Policing - Support After School programs', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Counternarcotics And Special Investigations - Aviation', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Counternarcotics And Special Investigations - Counter Transnational Criminal Organization Capacity Building Development', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Criminal Prosecutions - Criminal Prosecutions', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Criminal Special Investigation - Canine Units', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Anti-Corruption', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Asset Forfeiture', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Forensics ', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Judicial Wire Intercept Center ', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Justice Sector Reform', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Juvenile Justice', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Money Laundering', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justice Sector Reform - Penitentiary Accreditation', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Justicie Sector Reform - Capacity Building for OIJ', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Airport Security', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Aviation', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Biometrics', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Border Police', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Customs', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Improved Border inspection', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Improved Maritime and Land Interdictions', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Migration Agency', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Maritime and Land Interdictions - Seaport/Container Security', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Security And Law Enforcement - Forensics', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Security And Law Enforcement - Intel Analysts', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Security And Law Enforcement - Police Profesionalization', NULL);
INSERT [migration].[OnboardingKeyActivitiesList] ([Code], [Description]) VALUES (N'Security And Law Enforcement - Prisons', NULL);

-- OnboardingPostConfigurationValues
INSERT [migration].[OnboardingPostConfigurationValues] ([CourtesyNameCheckTime], [CourtesyVettingTime], [LeahyVettingTime], [VettingBatchSize], [CloseOutNotificiationsTime], [POL_POC_Email]) VALUES (5, 5, 10, 30, 10, N'augerve@state.gov');

-- OnboardingRanksList
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Captain');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Chief Master Sergeant');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Chief of Police Delegation');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Colonel');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Commander');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Commissioner');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Lieutenant');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Seaman');
INSERT [migration].[OnboardingRanksList] ([RankName]) VALUES (N'Sergeant');

-- OnboardingStatesList
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Alajuela');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Cartago');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Guanacaste');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Heredia');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Limón');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'Puntarenas');
INSERT [migration].[OnboardingStatesList] ([StateName]) VALUES (N'San José');

-- OnboardingTrainingEventFundingSourcesList
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN13CRNB', N'Borders and Ports');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN23CRM4', N'Vetted Units');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN23CRND', N'Regional Maritime and Land Interdiction');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN25CRMY', N'Demand Reduction');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN36CRNC', N'Community Policing');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN41CRM9', N'Prison Management');
INSERT [migration].[OnboardingTrainingEventFundingSourcesList] ([Code], [Description]) VALUES (N'IN41CRMH', N'Justice Sector Reform');

-- OnboardingUsersList
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Mitssy ', N'Rovira', N'roviram@state.gov', N'Gender Based Violence ', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Carmen ', N'Rodriguez', N'rodriguezce2@state.gov', N'International Narcotics & Law Enforcement', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Melissa ', N'Miranda', N'mirandam1@state.gov', N'Justice Sector Reform', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Carla', N'Ortega', N'ortegacm@state.gov', N'Community Colaborative Strategy', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Rodrigo ', N'Roman', N'romanrj@state.gov', N'Community Coalitions', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Priscilla', N'Hernandez', N'hernandezpm2@state.gov', N'Air Surveillance', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Danny', N'Villalobos', N'villalobosDA@state.gov', N'Maritime and Land Interdictions', N'Program Manager');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Emily', N'White ', N'WhiteEB@state.gov', N'US Dept. of State Political Office', N'Vetting Coordinator');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Vanessa', N'Auger', N'AugerVE@state.gov', N'US Dept. of State Political Office', N'Vetting Coordinator');
INSERT [migration].[OnboardingUsersList] ([FirstName], [LastName], [EmailAddress], [BusinessUnit], [Role]) VALUES (N'Sarah', N'Bannister', N'BannisterSJ@state.gov', N'US Dept. of State Political Office', N'Vetting Coordinator');

-- OnboardingVettingAuthorizingLawsList
INSERT [migration].[OnboardingVettingAuthorizingLawsList] ([Code], [Description]) VALUES (N'AECA', N'Arms Export Control Act');
INSERT [migration].[OnboardingVettingAuthorizingLawsList] ([Code], [Description]) VALUES (N'DODAA', N'DOD Annual Appropriations Act');
INSERT [migration].[OnboardingVettingAuthorizingLawsList] ([Code], [Description]) VALUES (N'FAA', N'Foreign Assistance Act');

-- OnboardingVettingFundingList
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'ALP', N'Aviation Leadership Program');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'CN', N'Counter-Narcotics');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'DEA', N'Drug Enforcement Agency (only if implementing with INCLE funds, otherwise not Leahy-applicable)');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'DOD', N'Department of Defense');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'DOJ', N'Department of Justice (Note: ICITAP, OPDAT, FBI, etc. usually conduct training with INCLE funds)');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'DOS', N'Department of State');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'ILEA', N'International Law Enforcement Training Academies');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'INCLE', N'International Narcotics & Law Enforcement');
INSERT [migration].[OnboardingVettingFundingList] ([Code], [Description]) VALUES (N'J/TIP', N'Office to Combat Trafficking in Persons (formerly G/TIP)');

-- ****************************************************
-- Show Onboarding table record counts - AFTER INSERTS.
-- ****************************************************
SELECT 'AFTER INSERTS' AS Status,
    (SELECT COUNT(*) FROM [migration].[OnboardingAuthorizingDocumentsList]) AS AuthDocsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingBusinessUnitsList]) AS BusinessUnitsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingCitiesList]) AS CitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingDefaultBudgetCalcValues]) AS OnboardingDefaultBudgetCalcValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingImplementingPartners]) AS OnboardingImplementingPartners,
    (SELECT COUNT(*) FROM [migration].[OnboardingKeyActivitiesList]) AS KeyActivitiesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingPostConfigurationValues]) AS PostConfigValues,
    (SELECT COUNT(*) FROM [migration].[OnboardingRanksList]) AS RanksList,
    (SELECT COUNT(*) FROM [migration].[OnboardingStatesList]) AS StatesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingTrainingEventFundingSourcesList]) AS TEFundSourcesList,
    (SELECT COUNT(*) FROM [migration].[OnboardingUsersList]) AS UsersList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingAuthorizingLawsList]) AS VettingAuthLawsList,
    (SELECT COUNT(*) FROM [migration].[OnboardingVettingFundingList]) AS VettingFundingList;

SET NOCOUNT OFF;