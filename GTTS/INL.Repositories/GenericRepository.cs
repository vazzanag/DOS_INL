using System.Collections.Generic;
using System.Threading.Tasks;
using System.Linq;
using System.Data;
using Dapper;
using System;
using System.Dynamic;

namespace INL.Repositories
{
    public class GenericRepository<R, E, T> : IGenericRepository<R, E, T>
    {

        public string InsertSProcName { get; set; }
        public string GetByIdSProcName { get; set; }
        public string GetAllSProcName { get; set; }
        public string GetByParentIdSProcName { get; set; }
        public string PrimaryKeyName { get; set; }
        public string ParentPrimaryKeyName { get; set; }
		
        private readonly IDbConnection dbConnection;


        public GenericRepository(IDbConnection dbConnection, string insertSProcName, string getByIdSProcName, string primaryKeyName, string getAllSProcName = null, string getByParentIdSProcName = null, string parentPrimaryKeyName = null)
        {
            this.dbConnection = dbConnection;
            InsertSProcName = insertSProcName;
            GetByIdSProcName = getByIdSProcName;
            GetAllSProcName = getAllSProcName;
            GetByParentIdSProcName = getByParentIdSProcName;
            PrimaryKeyName = primaryKeyName;
            ParentPrimaryKeyName = parentPrimaryKeyName;
        }


        public R Save(E entity)
        {
            return Insert(entity).FirstOrDefault();
		}

        public V Save<V, S>(string saveSProcName, S entity)
        {
            OpenConnection();

            return dbConnection.Query<V>(
                saveSProcName,
                entity,
                commandType: CommandType.StoredProcedure).FirstOrDefault();
        }

        public async Task<R> SaveAsync(E entity)
		{
			var result = await InsertAsync(entity);
			return result.FirstOrDefault();
		}


		public List<R> SaveGetList(E entity)
        {
			return Insert(entity).ToList();
		}


		public async Task<List<R>> SaveGetListAsync(E entity)
		{
			var result = await InsertAsync(entity);
			return result.ToList();
		}


        public R Update(string sProcName, IList<Tuple<string, object, DbType>> parameters)
        {
            var dynamicParameters = new DynamicParameters { };
            foreach (Tuple<string, object, DbType> param in parameters)
            {
                dynamicParameters.Add(param.Item1, param.Item2, param.Item3, ParameterDirection.Input);
            }

            var updatedEntitytId = dbConnection.Query<T>(
                sProcName,
                param: dynamicParameters,
                commandType: CommandType.StoredProcedure).FirstOrDefault();

            return Get(updatedEntitytId).FirstOrDefault();
        }

        public bool Delete(string sProcName, IList<Tuple<string, object, DbType>> parameters)
        {
            var dynamicParameters = new DynamicParameters { };
            foreach (Tuple<string, object, DbType> param in parameters)
            {
                dynamicParameters.Add(param.Item1, param.Item2, param.Item3, ParameterDirection.Input);
            }

            return dbConnection.Execute(
                sProcName,
                param: dynamicParameters,
                commandType: CommandType.StoredProcedure) > 0;
        }

		public R GetById(T primaryKey)
        {
            return Get(primaryKey).FirstOrDefault();
		}


		public async Task<R> GetByIdAsync(T primaryKey)
		{
			var result = await GetAsync(primaryKey);
			return result.FirstOrDefault();
		}


		public V Get<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters)
		{
			return GetEnumerable<V>(sProcName, parameters).FirstOrDefault();
		}


		public R Get(string sProcName, IList<Tuple<string, object, DbType>> parameters)
        {
			return GetAsync(sProcName, parameters).Result;
		}


		public async Task<R> GetAsync(string sProcName, IList<Tuple<string, object, DbType>> parameters)
		{
			var dynamicParameters = new DynamicParameters { };
			foreach (Tuple<string, object, DbType> param in parameters)
			{
				dynamicParameters.Add(param.Item1, param.Item2, param.Item3, ParameterDirection.Input);
			}

			var result = await dbConnection.QueryAsync<R>(
				sProcName,
				param: dynamicParameters,
				commandType: CommandType.StoredProcedure);

			return result.FirstOrDefault();
		}


		public List<V> GetList<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters)
		{
			return GetEnumerable<V>(sProcName, parameters).ToList();
		}


		private IEnumerable<X> GetEnumerable<X>(string sProcName, IList<Tuple<string, object, DbType>> parameters)
		{
			var dynamicParameters = new DynamicParameters { };
			foreach (Tuple<string, object, DbType> param in parameters)
			{
				dynamicParameters.Add(param.Item1, param.Item2, param.Item3, ParameterDirection.Input);
			}
			return dbConnection.Query<X>(
				sProcName,
				param: dynamicParameters,
				commandType: CommandType.StoredProcedure);
		}

        public List<V> GetListFromMultiples<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters)
        {
            return GetEnumerableFromMultiples<V>(sProcName, parameters).ToList();
        }

        private List<X> GetEnumerableFromMultiples<X>(string sProcName, IList<Tuple<string, object, DbType>> parameters)
        {
            var dynamicParameters = new DynamicParameters { };
            foreach (Tuple<string, object, DbType> param in parameters)
            {
                dynamicParameters.Add(param.Item1, param.Item2, param.Item3, ParameterDirection.Input);
            }

            List<X> result = new List<X>();
            using (var tables = dbConnection.QueryMultiple(sProcName, param: dynamicParameters, commandType: CommandType.StoredProcedure))
            {
                bool allTablesRead = false;
                var currentFetch = tables.ReadAsync<X>().Result.FirstOrDefault();

                while (!allTablesRead)
                {
                    result.Add(currentFetch);
                    try
                    {
                        currentFetch = tables.ReadAsync<X>().Result.FirstOrDefault();
                    }
                    catch (ObjectDisposedException)
                    {
                        allTablesRead = true;
                    }
                }
            }
            return result;
        }

        public List<R> GetAll()
        {
            return Get().ToList();
		}


		public async Task<List<R>> GetAllAsync()
		{
			var result = await GetAsync();			
			return result.ToList();
		}


		public List<R> GetByParentId(object parentId)
        {
			return GetByParentIdAsync(parentId).Result;
		}


		public async Task<List<R>> GetByParentIdAsync(object parentId)
		{
			var dynamicParameters = new DynamicParameters { };
			dynamicParameters.Add(ParentPrimaryKeyName, parentId, DbType.Int32, ParameterDirection.Input);

			var result = await dbConnection.QueryAsync<R>(
				GetByParentIdSProcName,
				param: dynamicParameters,
				commandType: CommandType.StoredProcedure);

			return result.ToList();
		}


		IEnumerable<R> Insert(E entity) {
			return InsertAsync(entity).Result;
		}


		async Task<IEnumerable<R>> InsertAsync(E entity)
        {
            OpenConnection();

            var savedResult = await dbConnection.QueryAsync<T>(
                InsertSProcName,
                entity,
                commandType: CommandType.StoredProcedure);
			
			return Get(savedResult.FirstOrDefault());
		}


		IEnumerable<R> Get(T primaryKey = default(T))
		{
			return GetAsync(primaryKey).Result;
		}


		async Task<IEnumerable<R>> GetAsync(T primaryKey = default (T))
        {
            OpenConnection();

            if (primaryKey.Equals(default(T)))
            {
                return await dbConnection.QueryAsync<R>(
                      GetAllSProcName,
                      commandType: CommandType.StoredProcedure);
            }

            var dynamicParameters = new DynamicParameters { };
            dynamicParameters.Add(PrimaryKeyName, primaryKey, DbType.Int32, ParameterDirection.Input);

            return await dbConnection.QueryAsync<R>(
                GetByIdSProcName,
                param: dynamicParameters,
                commandType: CommandType.StoredProcedure);
        }

        private void OpenConnection()
        {
            if (dbConnection.State == ConnectionState.Closed) dbConnection.Open();
        }
    }
}
