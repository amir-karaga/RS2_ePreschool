using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class ActivityLogsRepository : BaseRepository<ActivityLog, int, BaseSearchObject>, IActivityLogsRepository
    {
        public ActivityLogsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {}
    }
}
