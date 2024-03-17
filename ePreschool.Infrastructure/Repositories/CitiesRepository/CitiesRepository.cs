using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class CitiesRepository : BaseRepository<City, int,CountriesCitiesSearchObject>, ICitiesRepository
    {
        public CitiesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<IEnumerable<City>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c => c.CountryId == countryId).ToListAsync(cancellationToken);
        }
        public override async Task<PagedList<City>> GetPagedAsync(CountriesCitiesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.Country).Where(c => searchObject.SearchFilter == null || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower()))
                .Where(c => (searchObject.CountryId == null || c.CountryId == searchObject.CountryId) && c.IsDeleted == false).Take(10)
               .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
