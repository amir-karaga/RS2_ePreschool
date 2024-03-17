using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IAppConfigsRepository : IBaseRepository<AppConfig, int, BaseSearchObject>
    {
    }
}
