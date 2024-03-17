using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface ICitiesRepository : IBaseRepository<City, int, CountriesCitiesSearchObject>
    {
        Task<IEnumerable<City>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default);
    }
}
