using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface ICompaniesRepository : IBaseRepository<Company, int, BaseSearchObject>
    {
    }
}
