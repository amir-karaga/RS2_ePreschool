using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class CountriesRepository : BaseRepository<Country, int,BaseSearchObject>, ICountriesRepository
    {
        public CountriesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Country>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(c => searchObject.SearchFilter == null || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                .Where(c => c.IsDeleted == false).Take(10)
               .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
