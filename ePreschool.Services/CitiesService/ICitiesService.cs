using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface ICitiesService : IBaseService<int, CityModel, CityUpsertModel, CountriesCitiesSearchObject>
    {
        Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default);

    }
}
