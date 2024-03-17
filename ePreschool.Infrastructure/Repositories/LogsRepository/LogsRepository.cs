using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class LogsRepository : BaseRepository<ActivityLog, int, BaseSearchObject>, ILogsRepository
    {
        public LogsRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {

        }
    }
}
