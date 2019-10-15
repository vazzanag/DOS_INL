using System.Collections.Generic;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Abstractions;
using Mapster;
using Newtonsoft.Json;
using INL.SearchService.Data;
using INL.SearchService.Models;

namespace INL.SearchService
{
    public class SearchService : ISearchService
    {
        private readonly ISearchRepository searchRepository;
        private readonly ILogger log;

        public SearchService(ISearchRepository searchRepository, ILogger log = null)
		{
			this.searchRepository = searchRepository;
			if (log != null) this.log = log;
			else this.log = NullLogger.Instance;

			if (!AreMappingsConfigured)
			{
				ConfigureMappings();
			}
		}

        public IGetInstructors_Result GetInstructors(IGetInstructors_Param param)
        {
            // Convert to repo input
            var getInstructorsSearchEntity = param.Adapt<IInstructorSearchEntity>();

            // Call repo
            var getInstructorsViewEntity = searchRepository.GetInstructors(getInstructorsSearchEntity);

            // Convert to result
            var result = new GetInstructors_Result
            {
                Collection = getInstructorsViewEntity.Adapt<List<IGetInstructors_Item>>()
            };


            return result;
        }

        public IGetStudents_Result GetStudents(IGetStudents_Param param)
        {
            // Convert to repo input
            var getStudentsSearchEntity = param.Adapt<IStudentSearchEntity>();

            // Call repo
            var getStudentsViewEntity = searchRepository.GetStudents(getStudentsSearchEntity);

            // Convert to result
            var result = new GetStudents_Result
            {
                Collection = getStudentsViewEntity.Adapt<List<IGetStudents_Item>>()
            };


            return result;
        }

        public ISearchParticipants_Result SearchParticipants(ISearchParticipants_Param param)
        {
            // Convert to repo input
            var geParticipantSearchEntity = param.Adapt<IParticipantSearchEntity>();

            // Call repo
            var getParticipantViewEntity = searchRepository.SearchParticipants(geParticipantSearchEntity);

            // Convert to result
            var result = new SearchParticipants_Result
            {
                Collection = getParticipantViewEntity.Adapt<List<ISearchParticipants_Item>>()
            };


            return result;
        }

        public ISearchParticipants_Result SearchParticipantsAndPersons(ISearchParticipants_Param param)
        {
            // Convert to repo input
            var getParticipantAndPersonSearchEntity = param.Adapt<IParticipantAndPersonSearchEntity>();

            // Call repo
            var getParticipantAndPersonViewEntity = searchRepository.SearchParticipantsAndPersons(getParticipantAndPersonSearchEntity);

            // Convert to result
            var result = new SearchParticipants_Result
            {
                Collection = getParticipantAndPersonViewEntity.Adapt<List<ISearchParticipants_Item>>()
            };

            return result;
        }

        public ISearchPersons_Result SearchPersons(ISearchPersons_Param param, out int recordsFiltered)
        {
            // Convert to repo input
            var searchPersonsSearchEntity = param.Adapt<IPersonSearchEntity>();

            // Call repo
            var searchPersonsViewEntity = searchRepository.SearchPersons(searchPersonsSearchEntity, out recordsFiltered);

            // Convert to result
            var result = new SearchPersons_Result
            {
                Collection = searchPersonsViewEntity.Adapt<List<ISearchPersons_Item>>(),
                Draw = (int)param.PageNumber,
                RecordsFiltered = recordsFiltered,
                RecordsTotal = recordsFiltered
            };

            return result;
        }

        public ISearchTrainingEvents_Result SearchTrainingEvents(ISearchTrainingEvents_Param param)
        {
            // Convert to repo input
            var getPersonsSearchEntity = param.Adapt<ITrainingEventSearchEntity>();

            // Call repo
            var getPersonsViewEntity = searchRepository.SearchTrainingEvents(getPersonsSearchEntity);

            // Convert to result
            var result = new SearchTrainingEvents_Result
            {
                Collection = getPersonsViewEntity.Adapt<List<SearchTrainingEvents_Item>>()
            };

            return result;
        }

        public ISearchVettingBatches_Result SearchVettingBatches(ISearchVettingBatches_Param param)
        {
            // Convert to repo input
            var getVettingBatchesSearchEntity = param.Adapt<IVettingBatchesSearchEntity>();

            // Call repo
            var getVettingBatchesDetailViewEntity = searchRepository.SearchVettingBatches(getVettingBatchesSearchEntity);

            // Convert to result
            var result = new SearchVettingBatches_Result
            {
                Collection = getVettingBatchesDetailViewEntity.Adapt<List<ISearchVettingBatches_Item>>()
            };


            return result;
        }

        public ISearchNotifications_Result SearchNotifications(ISearchNotifications_Param param)
        {
            // Convert for repo
            var searchNotificationsEntity = param.Adapt<NotificationsSearchEntity>();

            // Call repo
            var notificationsPaged = searchRepository.SearchNotifications(searchNotificationsEntity);

            // Prepare result
            var result = new SearchNotifications_Result();

            foreach (IEnumerable<object> o in notificationsPaged)
            {
                if (o.GetType() == typeof(List<NotificationsViewEntity>))
                    result.Collection = (o as List<NotificationsViewEntity>).Adapt<List<SearchNotifications_Item>>();
                else if (o.GetType() == typeof(List<dynamic>))
                    result.RecordCount = (o as List<dynamic>)[0].RecordCount;
            }

            return result;
        }

        public ISearchUnits_Result SearchUnits(ISearchUnits_Param param)
        {
            // Convert for repo
            var searchUnitsEntity = param.Adapt<UnitSearchEntity>();

            // Call repo
            var unitsPaged = searchRepository.SearchUnits(searchUnitsEntity);

            // Prepare result
            var result = new SearchUnits_Result();

            foreach (IEnumerable<object> o in unitsPaged)
            {
                if (o.GetType() == typeof(List<UnitsViewEntity>))
                    result.Collection = (o as List<UnitsViewEntity>).Adapt<List<SearchUnits_Item>>();
                else if (o.GetType() == typeof(List<dynamic>))
                    result.RecordCount = (o as List<dynamic>)[0].RecordCount;
            }

            return result;
        }

        public ISearchPersonsVetting_Result SearchPersonsVettings(ISearchPersonsVetting_Param param, long vettingBatchID)
        {
            // Convert to repo input
            var getPersonsVettingSearchEntity = param.Adapt<IPersonsVettingSearchEntity>();

            getPersonsVettingSearchEntity.VettingBatchID = vettingBatchID;

            // Call repo
            var getPersonsVettingResultEntity = searchRepository.SearchPersonsVettings(getPersonsVettingSearchEntity);

            // Convert to result
            var result = new SearchPersonsVetting_Result
            {
                Collection = getPersonsVettingResultEntity.Adapt<List<SearchPersonsVetting_Item>>()
            };


            return result;
        }

        #region ### Mapster Config
        private static bool AreMappingsConfigured { get; set; }
        private static object MappingConfigurationLock = new { };
        private static void ConfigureMappings()
        {
            var deserializationSettings = new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore,
                MissingMemberHandling = MissingMemberHandling.Ignore
            };

            lock (MappingConfigurationLock)
            {
                TypeAdapterConfig<IGetInstructors_Param, IInstructorSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new InstructorSearchEntity());

                TypeAdapterConfig<IInstructorsViewEntity, IGetInstructors_Item>
                    .ForType()
                    .ConstructUsing(s => new GetInstructors_Item());

                TypeAdapterConfig<ISearchPersons_Param, IPersonSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new PersonSearchEntity());

                TypeAdapterConfig<PersonsViewEntity, ISearchPersons_Item>
                    .ForType()
                    .ConstructUsing(s => new SearchPersons_Item());

                TypeAdapterConfig<IGetStudents_Param, IStudentSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new StudentSearchEntity());

                TypeAdapterConfig<IStudentsViewEntity, IGetStudents_Item>
                    .ForType()
                    .ConstructUsing(s => new GetStudents_Item());


                TypeAdapterConfig<ISearchParticipants_Param, IParticipantSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new ParticipantSearchEntity());

                TypeAdapterConfig<ISearchParticipants_Param, IParticipantAndPersonSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new ParticipantAndPersonSearchEntity());

                TypeAdapterConfig<ISearchTrainingEvents_Param, ITrainingEventSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new TrainingEventSearchEntity());

                TypeAdapterConfig<ParticipantsViewEntity, ISearchParticipants_Item>
                    .ForType()
                    .ConstructUsing(s => new SearchParticipants_Item());

                TypeAdapterConfig<ParticipantsAndPersonsViewEntity, ISearchParticipants_Item>
                    .ForType()
                    .ConstructUsing(s => new SearchParticipants_Item());

                TypeAdapterConfig<TrainingEventsViewEntity, SearchTrainingEvents_Item>
                    .ForType()
                    .Map(
                        dest => dest.KeyActivities,
                        src => string.IsNullOrEmpty(src.KeyActivitiesJSON) ? null : JsonConvert.DeserializeObject(("" + src.KeyActivitiesJSON), typeof(List<SearchTrainingEventKeyActivities_Item>))
                        )
                    .Map(
                        dest => dest.Locations,
                        src => string.IsNullOrEmpty(src.LocationsJSON) ? null : JsonConvert.DeserializeObject(("" + src.LocationsJSON), typeof(List<SearchTrainingEventLocations_Item>))
                        );

                TypeAdapterConfig<ISearchVettingBatches_Param, IVettingBatchesSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new VettingBatchesSearchEntity());

                TypeAdapterConfig<VettingBatchesDetailViewEntity, ISearchVettingBatches_Item>
                    .ForType()
                    .ConstructUsing(s => new SearchVettingBatches_Item());

                TypeAdapterConfig<ISearchPersonsVetting_Param, IPersonsVettingSearchEntity>
                    .ForType()
                    .ConstructUsing(s => new PersonsVettingSearchEntity());

                TypeAdapterConfig<PersonsVettingViewEntity, ISearchPersonsVetting_Item>
                    .ForType()
                    .ConstructUsing(s => new SearchPersonsVetting_Item());

                AreMappingsConfigured = true;
            }

        }
        #endregion
    }
}
