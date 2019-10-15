using System.Threading.Tasks;
using System.Collections.Generic;
using INL.TrainingService.Models;
using INL.TrainingService.Client;

namespace INL.UnitTests
{
    public class MockedTrainingServiceClient : ITrainingServiceClient
    {
        public Task<IGetPersonsTrainingEvents_Result> GetPersonsTrainingEventsAsync(long personID, string trainingEventStatus)
        {
            var result = new GetPersonsTrainingEvents_Result()
            {
                Collection = new List<GetPersonsTrainingEvent_Item>()
                {
                    new GetPersonsTrainingEvent_Item()
                    {
                        TrainingEventID = 1,
                        Name ="First Tester",
                        PersonID = personID,
                        ParticipantType = "Student",
                        EventEndDate =new System.DateTime(2019,1,4),
                        EventStartDate = new System.DateTime(2019,1,1),
                        BusinessUnitAcronym = "DEA",
                        TrainingEventRosterDistinction="",
                        Certificate= true,
                        TrainingEventStatus = "Closed"
                    }
                }
            };
            return Task.FromResult<IGetPersonsTrainingEvents_Result>(result);
        }
        public Task<IGetTrainingEventParticipants_Result> GetTrainingEventRemovedParticipants(long trainingEventID)
        {
            var result = new GetTrainingEventParticipants_Result()
            {
                Collection = new List<GetTrainingEventParticipant_Item>()
                {
                    new GetTrainingEventParticipant_Item()
                    {
                        ParticipantID = 1,
                        PersonID =1,
                        ParticipantType = "Student",
                        Ordinal =0,
                        FirstMiddleNames ="First",
                        LastNames = "Tester",
                        Gender = 'F',
                        UnitID = 1,
                        UnitName = "Test Unit",
                        UnitNameEnglish = "Test Unit",
                        UnitParentName = "Test Parent Unit",
                        UnitParentNameEnglish ="Test Parent Unit",
                        UnitTypeID = 1,
                        UnitType = "Test",
                        AgencyName = "Test Agency",
                        AgencyNameEnglish ="Test Agency",
                        UnitMainAgencyID = 1,
                        IsUSCitizen = true,
                        NationalID = "TEST0001",
                        ResidenceCountryID =1,
                        ResidenceStreetAddress ="",
                        ResidenceStateID =1,
                        ResidenceCityID =1,
                        POBCountryID =1,
                        POBStateID =1,
                        POBCityID =1,
                        DepartureCountryID =1,
                        DepartureStateID =1,
                        DepartureCityID =1,
                        ContactEmail ="",
                        ContactPhone ="",
                        DOB = new System.DateTime(1960,1,1),
                        FatherName = "",
                        MotherName = "",
                        HighestEducationID =1,
                        FamilyIncome = null,
                        EnglishLanguageProficiencyID =1,
                        PassportNumber = "",
                        PassportExpirationDate = null,
                        PassportIssuingCountryID = null,
                        PoliceMilSecID = "",
                        HostNationPOCName = "",
                        HostNationPOCEmail = "",
                        JobTitle = "",
                        RankID = null,
                        RankName = "",
                        YearsInPosition = null,
                        MedicalClearanceStatus = null,
                        MedicalClearanceDate = null,
                        PsychologicalClearanceStatus = null,
                        PsychologicalClearanceDate = null,
                        TrainingEventID = 1,
                        GroupName = "",
                        IsVIP = false,
                        IsParticipant = true,
                        IsTraveling = false,
                        DepartureCity = "",
                        DepartureState = "",
                        DepartureDate = null,
                        ReturnDate = null,
                        VettingBatchTypeID = null,
                        VettingTrainingEventID = null,
                        VettingTrainingEventName =  "",
                        VettingBatchType = "",
                        VettingBatchStatusID =  null,
                        VisaStatusID =null,
                        VisaStatus = "",
                        PaperworkStatusID = null,
                        TravelDocumentStatusID = null,
                        RemovedFromEvent = false,
                        RemovalReasonID = null,
                        RemovalReason = "",
                        RemovalCauseID =null,
                        RemovalCause = "",
                        TrainingEventRosterDistinction =null,
                        DateCanceled = null,
                        Comments = "",
                        ModifiedByAppUserID = 1,
                        ModifiedDate = new System.DateTime(),
                        PassedLocalGovTrust = null,
                        LocalGovTrustCertDate = null,
                        OtherVetting = false,
                        PassedOtherVetting = null,
                        OtherVettingDescription = "",
                        OtherVettingDate = null,
                        IsVettingReq =false,
                        IsLeahyVettingReq =false,
                        IsArmedForces =false,
                        IsLawEnforcement =false,
                        IsSecurityIntelligence =false,
                        IsValidated =false,
                        RemovedFromVetting =false,
                    }
                }
            };
            return Task.FromResult<IGetTrainingEventParticipants_Result>(result);
        }

        public Task<IGetTrainingEventLocations_Result> GetTrainingEventLocations(long trainingEventID)
        {
            var result = new GetTrainingEventLocations_Result()
            {
                Collection = new List<GetTrainingEventLocation_Item>()
                {
                    new GetTrainingEventLocation_Item()
                    {
                        LocationName = "Test Location 1",
                        CityName = "Washington",
                        StateName = "District of Columbia",
                        StateAbbreviation = "DC",
                        StateCode = "DC",
                        CountryName = "United States of America",
                        CountryAbbreviation = "USA",
                        CountryCode = "USA"
                    }
                }
            };
            return Task.FromResult<IGetTrainingEventLocations_Result>(result);
        }

        public Task<IGetTrainingEventParticipants_Result> GetTrainingEventParticipants(long trainingEventID)
        {
            var result = new GetTrainingEventParticipants_Result()
            {
                Collection = new List<GetTrainingEventParticipant_Item>()
                {
                    new GetTrainingEventParticipant_Item()
                    {
                        ParticipantID = 1,
                        TrainingEventParticipantID = 4,
                        PersonID =1,
                        ParticipantType = "Student",
                        Ordinal =0,
                        FirstMiddleNames ="First",
                        LastNames = "Tester",
                        Gender = 'F',
                        UnitID = 1,
                        UnitName = "Test Unit",
                        UnitNameEnglish = "Test Unit",
                        UnitParentName = "Test Parent Unit",
                        UnitParentNameEnglish ="Test Parent Unit",
                        UnitTypeID = 1,
                        UnitType = "Test",
                        AgencyName = "Test Agency",
                        AgencyNameEnglish ="Test Agency",
                        UnitMainAgencyID = 1,
                        IsUSCitizen = true,
                        NationalID = "TEST0001",
                        ResidenceCountryID =1,
                        ResidenceStreetAddress ="",
                        ResidenceStateID =1,
                        ResidenceCityID =1,
                        POBCountryID =1,
                        POBStateID =1,
                        POBCityID =1,
                        DepartureCountryID =1,
                        DepartureStateID =1,
                        DepartureCityID =1,
                        ContactEmail ="",
                        ContactPhone ="",
                        DOB = new System.DateTime(1960,1,1),
                        FatherName = "",
                        MotherName = "",
                        HighestEducationID =1,
                        FamilyIncome = null,
                        EnglishLanguageProficiencyID =1,
                        PassportNumber = "",
                        PassportExpirationDate = null,
                        PassportIssuingCountryID = null,
                        PoliceMilSecID = "",
                        HostNationPOCName = "",
                        HostNationPOCEmail = "",
                        JobTitle = "",
                        RankID = null,
                        RankName = "",
                        YearsInPosition = null,
                        MedicalClearanceStatus = null,
                        MedicalClearanceDate = null,
                        PsychologicalClearanceStatus = null,
                        PsychologicalClearanceDate = null,
                        TrainingEventID = 1,
                        GroupName = "",
                        IsVIP = false,
                        IsParticipant = true,
                        IsTraveling = false,
                        DepartureCity = "",
                        DepartureState = "",
                        DepartureDate = null,
                        ReturnDate = null,
                        VettingBatchTypeID = null,
                        VettingTrainingEventID = null,
                        VettingTrainingEventName =  "",
                        VettingBatchType = "",
                        VettingBatchStatusID =  null,
                        VisaStatusID =null,
                        VisaStatus = "",
                        PaperworkStatusID = null,
                        TravelDocumentStatusID = null,
                        RemovedFromEvent = false,
                        RemovalReasonID = null,
                        RemovalReason = "",
                        RemovalCauseID =null,
                        RemovalCause = "",
                        TrainingEventRosterDistinction =null,
                        DateCanceled = null,
                        Comments = "",
                        ModifiedByAppUserID = 1,
                        ModifiedDate = new System.DateTime(),
                        PassedLocalGovTrust = null,
                        LocalGovTrustCertDate = null,
                        OtherVetting = false,
                        PassedOtherVetting = null,
                        OtherVettingDescription = "",
                        OtherVettingDate = null,
                        IsVettingReq =false,
                        IsLeahyVettingReq =false,
                        IsArmedForces =false,
                        IsLawEnforcement =false,
                        IsSecurityIntelligence =false,
                        IsValidated =false,
                        RemovedFromVetting =false,
                    }
                }
            };
            return Task.FromResult<IGetTrainingEventParticipants_Result>(result);
        }
    }
}
