using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class AppConfigsRepository : BaseRepository<AppConfig, int, BaseSearchObject>, IAppConfigsRepository
    {
        public AppConfigsRepository(DatabaseContext databaseContext) : base(databaseContext)
        { }
    }
}
