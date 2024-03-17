using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface ILogsRepository : IBaseRepository<ActivityLog, int, BaseSearchObject>
    {

    }
}
