using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Data;
using System.Text;

namespace INL.Repositories
{
    public interface IGenericRepository<R, E, T>
    {
        R Save(E entity);
        List<R> SaveGetList(E entity);
        V Save<V, S>(string saveSProcName, S entity);
        R Update(string sProcName, IList<Tuple<string, object, DbType>> parameters);
        bool Delete(string sProcName, IList<Tuple<string, object, DbType>> parameters);
        R GetById(T primaryKey);
        V Get<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters);
        List<V> GetList<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters);
        List<V> GetListFromMultiples<V>(string sProcName, IList<Tuple<string, object, DbType>> parameters);
        List<R> GetAll();
        List<R> GetByParentId(object parentId);
		Task<R> SaveAsync(E entity);
		Task<List<R>> SaveGetListAsync(E entity);
		Task<R> GetByIdAsync(T primaryKey);
		Task<R> GetAsync(string sProcName, IList<Tuple<string, object, DbType>> parameters);
		Task<List<R>> GetAllAsync();
		Task<List<R>> GetByParentIdAsync(object parentId);
	}
}
