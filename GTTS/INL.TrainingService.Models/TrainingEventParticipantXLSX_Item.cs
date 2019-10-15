using System;
using System.Collections.Generic;
using System.Text;

namespace INL.TrainingService.Models
{
    public class TrainingEventParticipantXLSX_Item
    {
        public long ParticipantXLSXID { get; set; }
        public Int64? EventXLSXID { get; set; }
        public Int64? TrainingEventID { get; set; }
        public Int64? PersonID { get; set; }
        public string ParticipantStatus { get; set; }
        public string FirstMiddleName { get; set; }
        public string LastName { get; set; }
        public string NationalID { get; set; }
        public char Gender { get; set; }
        public string IsUSCitizen { get; set; }
        public DateTime? DOB { get; set; }
        public int? POBCityID { get; set; }
        public string POBCity { get; set; }
        public int POBStateID { get; set; }
        public string POBState { get; set; }
        public int POBCountryID { get; set; }
        public string POBCountry { get; set; }
        public int ResidenceCityID { get; set; }
        public string ResidenceCity { get; set; }
        public int ResidenceStateID { get; set; }
        public string ResidenceState { get; set; }
        public int ResidenceCountryID { get; set; }
        public string ResidenceCountry { get; set; }
        public string ContactEmail { get; set; }
        public string ContactPhone { get; set; }
        public int? HighestEducationID { get; set; }
        public string HighestEducation { get; set; }
        public int? EnglishLanguageProficiencyID { get; set; }
        public string EnglishLanguageProficiency { get; set; }
        public string PassportNumber { get; set; }
        public DateTime? PassportExpirationDate { get; set; }
        public string JobTitle { get; set; }
        public string IsUnitCommander { get; set; }
        public int? YearsInPosition { get; set; }
        public string POCName { get; set; }
        public string POCEmailAddress { get; set; }
        public int? RankID { get; set; }
        public string Rank { get; set; }
        public string PoliceMilSecID { get; set; }
        public string VettingType { get; set; }
        public string HasLocalGovTrust { get; set; }
        public DateTime? LocalGovTrustCertDate { get; set; }
        public string PassedExternalVetting { get; set; }
        public string ExternalVettingDescription { get; set; }
        public DateTime? ExternalVettingDate { get; set; }
        public int? DepartureCountryID { get; set; }
        public int? DepartureStateID { get; set; }
        public int? DepartureCityID { get; set; }
        public string DepartureCity { get; set; }
        public long UnitID { get; set; }
        public string UnitGenID { get; set; }
        public string UnitName { get; set; }
        public string UnitParents { get; set; }
        public string UnitBreakdown { get; set; }
        public string UnitAlias { get; set; }
        public long? UnitMainAgencyID { get; set; }
        public string Comments { get; set; }
        public string MarkForAction { get; set; }
        public string LoadStatus { get; set; }
        public string Validations { get; set; }
        public int? ImportVersion { get; set; }
        public int ModifiedByAppUserID { get; set; }
        public int? LastVettingStatusID { get; set; }
        public string LastVettingStatusCode { get; set; }
        public DateTime? LastVettingStatusDate { get; set; }
        public int? LastVettingTypeID { get; set; }
        public string LastVettingTypeCode { get; set; }
        public DateTime?  VettingValidEndDate {get;set;}

        public bool ParticipantAlternateValid { get; set; }


        public bool IsNameValid { get; set; }
        public string NameValidationMessage { get; set; }
        
        public bool IsGenderValid { get; set; }
        public string GenderValidationMessage { get; set; }

        public bool IsDOBValid { get; set; }
        public string DOBValidationMessage { get; set; }
        
        public bool IsPOBValid { get; set; }
        public string POBValidationMessage { get; set; }

        public bool IsNationalIDValid { get; set; }
        public string NationalIDValidationMessage { get; set; }

        public bool IsResidenceCountryValid { get; set; }
        public string ResidenceCountryValidationMessage { get; set; }

        public bool IsResidenceStateValid { get; set; }
        public string ResidenceStateValidationMessage { get; set; }

        public bool IsEducationLevelValid { get; set; }
        public string EducationLevelValidationMessage { get; set; }

        public bool IsEnglishLanguageProficiencyValid { get; set; }
        public string EnglishLanguageProficiencyValidationMessage { get; set; }

        public bool IsUnitGenIDValid { get; set; }
        public string UnitGenIDValidationMessage { get; set; }

        public bool IsUnitValid { get; set; }
        public string UnitValidationMessage { get; set; }

        public bool IsRankValid { get; set; }
        public string RankValidationMessage { get; set; }

		public bool IsApprovedVettingValidByEventStartDate { get; set; }

		public string LastVettingExpirationExpression { get; set; }

		public IMatchingPerson_Item MatchingPersonWithMatchingNaitonalID { get; set; }
        public IMatchingPerson_Item MatchingPersonsWithoutMatchingNationalID { get; set; }

        public bool IsValid
        {
            get
            {
                bool isValid = true;

                if (!IsDOBValid) isValid = false;
                else if (!IsEducationLevelValid) isValid = false;
                else if (!IsEnglishLanguageProficiencyValid) isValid = false;
                else if (!IsNameValid) isValid = false;
                else if (!IsGenderValid) isValid = false;
                else if (!IsUnitValid) isValid = false;
                else if (!IsUnitGenIDValid) isValid = false;
                else if (!IsRankValid) isValid = false;
                else if (!IsNationalIDValid) isValid = false;
                else if (!IsPOBValid) isValid = false;
                else if (!IsResidenceCountryValid) isValid = false;
                else if (!IsResidenceStateValid) isValid = false;
                else if (!IsNationalIDValid) isValid = false;
                else if (!IsGenderValid) isValid = false;
                else if (!IsPOBValid) isValid = false;

                return isValid;
            }
        }

    }
}
