using System;
using System.Data;
using System.Linq;
using System.Text;
using System.Collections.Generic;
using Dapper;

namespace INL.SearchService.Data
{
    public class SearchRepository : ISearchRepository
    {
        private readonly IDbConnection dbConnection;

        public SearchRepository(IDbConnection dbConnection)
        {
            this.dbConnection = dbConnection;
        }

        public List<InstructorsViewEntity> GetInstructors(IInstructorSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<InstructorsViewEntity>(
                "search.InstructorSearch",
                param: new
                {
                    SearchString = param.SearchString,
                    CountryID = param.CountryID
                },
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }

        public List<StudentsViewEntity> GetStudents(IStudentSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<StudentsViewEntity>(
                "search.StudentSearch",
                param: new
                {
                    SearchString = param.SearchString,
                    CountryID = param.CountryID
                },
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }

        public List<PersonsViewEntity> SearchPersons(IPersonSearchEntity param, out int recordsFiltered)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var parameters = new DynamicParameters();
            parameters.Add("@SearchString", param.SearchString);
            parameters.Add("@CountryID", param.CountryID);
            parameters.Add("@OrderColumn", param.OrderColumn);
            parameters.Add("@OrderDirection", param.OrderDirection);
            parameters.Add("@PageNumber", param.PageNumber);
            parameters.Add("@PageSize", param.PageSize);
            parameters.Add("@ParticipantType", param.ParticipantType);
            parameters.Add("@RecordsFiltered", dbType: DbType.Int32, direction: ParameterDirection.Output);

            var result = dbConnection.Query<PersonsViewEntity>(
                "search.PersonSearch",
                parameters,
                commandType: CommandType.StoredProcedure).AsList();

            recordsFiltered = parameters.Get<Int32>("@RecordsFiltered");

            return result;
        }

        public List<ParticipantsViewEntity> SearchParticipants(IParticipantSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<ParticipantsViewEntity>(
                "search.ParticipantSearch",
                param,
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }

        public List<ParticipantsAndPersonsViewEntity> SearchParticipantsAndPersons(IParticipantAndPersonSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<ParticipantsAndPersonsViewEntity>(
                "search.ParticipantAndPersonSearch",
                param,
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }

        public List<TrainingEventsViewEntity> SearchTrainingEvents(ITrainingEventSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<TrainingEventsViewEntity>(
                "search.TrainingEventSearch",
                param,
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }


        public List<VettingBatchesDetailViewEntity> SearchVettingBatches(IVettingBatchesSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<VettingBatchesDetailViewEntity>(
                "search.VettingBatchesSearch",
                param,
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }

        public List<IEnumerable<object>> SearchNotifications(INotificationsSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            List<IEnumerable<object>> result = new List<IEnumerable<object>>();

            using (var tables = dbConnection.QueryMultiple(
                "search.NotificationsSearch",
                param,
                commandType: CommandType.StoredProcedure))
            {
                result.Add(tables.Read<dynamic>().ToList());
                result.Add(tables.Read<NotificationsViewEntity>().ToList());
            }

            return result;
        }

        public List<IEnumerable<object>> SearchUnits(IUnitSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            List<IEnumerable<object>> result = new List<IEnumerable<object>>();

            using (var tables = dbConnection.QueryMultiple(
                "search.UnitSearch",
                param,
                commandType: CommandType.StoredProcedure))
            {
                result.Add(tables.Read<dynamic>().ToList());
                result.Add(tables.Read<UnitsViewEntity>().ToList());
            }

            return result;
        }

        public List<PersonsVettingViewEntity> SearchPersonsVettings(IPersonsVettingSearchEntity param)
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();

            var result = dbConnection.Query<PersonsVettingViewEntity>(
                "search.PersonsVettingSearch",
                param,
                commandType: CommandType.StoredProcedure).AsList();


            return result;
        }
    }
}
