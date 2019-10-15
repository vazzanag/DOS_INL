using System;
using System.Data;
//using Microsoft.Extensions.Logging;
using INL.ReferenceService.Models;
using INL.ReferenceService.Data;
using System.Collections.Generic;
using Mapster;

namespace INL.ReferenceService
{
    public class ReferenceService : IReferenceService
    {
        private readonly IReferenceRepository referenceRepository;
		//private readonly ILogger log;


		public ReferenceService(IReferenceRepository repository/*, ILogger logger*/)
		{
            //log = logger;
            referenceRepository = repository;
		}

        public TrainingReference_Result GetTrainingReferences()
        {
            TrainingReference_Result result = new TrainingReference_Result();

            // GET REFERENCES
            List<IEnumerable<object>> r = referenceRepository.GetTrainingReferences();

            // FORMAT FOR RESULT
            foreach (IEnumerable<object> o in r)
            {
                if (o.GetType() == typeof(List<KeyActivitiesEntity>))
                    result.ReferenceTables.KeyActivities = (o as List<KeyActivitiesEntity>).Adapt<IEnumerable<KeyActivities_Item>>();
                else if (o.GetType() == typeof(List<ProjectCodesEntity>))
                    result.ReferenceTables.ProjectCodes = (o as List<ProjectCodesEntity>).Adapt<IEnumerable<ProjectCodes_Item>>();
                else if (o.GetType() == typeof(List<TrainingEventTypesEntity>))
                    result.ReferenceTables.EventTypes = (o as List<TrainingEventTypesEntity>).Adapt<IEnumerable<TrainingEventTypes_Item>>();
                else if (o.GetType() == typeof(List<USPartnerAgenciesEntity>))
                    result.ReferenceTables.PartnerAgencies = (o as List<USPartnerAgenciesEntity>).Adapt<IEnumerable<USPartnerAgencies_Item>>();
                else if (o.GetType() == typeof(List<BusinessUnitsEntity>))
                    result.ReferenceTables.BusinessUnits = (o as List<BusinessUnitsEntity>).Adapt<IEnumerable<BusinessUnits_Item>>();
                else if (o.GetType() == typeof(List<CountriesEntity>))
                    result.ReferenceTables.Countries = (o as List<CountriesEntity>).Adapt<IEnumerable<Countries_Item>>();
                else if (o.GetType() == typeof(List<StatesEntity>))
                    result.ReferenceTables.States = (o as List<StatesEntity>).Adapt<IEnumerable<States_Item>>();
                else if (o.GetType() == typeof(List<IAAsEntity>))
                    result.ReferenceTables.IAAs = (o as List<IAAsEntity>).Adapt<IEnumerable<IAAs_Item>>();
                else if (o.GetType() == typeof(List<AppUsersEntity>))
                    result.ReferenceTables.AppUsers = (o as List<AppUsersEntity>).Adapt<IEnumerable<AppUsers_Item>>();
                else if (o.GetType() == typeof(List<VisaStatusesEntity>))
                    result.ReferenceTables.VisaStatuses = (o as List<VisaStatusesEntity>).Adapt<IEnumerable<VisaStatus_Item>>();
            }

            return result;

        }

        public ReferenceTables_Results GetReferences(IGetReferenceTable_Param param)
        {
            // CREATE OBJECT TO RETURN
            ReferenceTables_Results ret = new ReferenceTables_Results();

            // CALL REPO
            var result = referenceRepository.GetReferences(param.ReferenceList, param.CountryID, param.PostID);

            // CONVERT RESULT FOR RETURN
            foreach (IReferenceTablesEntity t in result)
            {
                var temp = t.Adapt<ReferenceTables_Item>();
                ret.Collection.Add(temp);
            }

            return ret;
        }
    }
}
