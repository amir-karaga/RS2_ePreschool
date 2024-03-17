using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface ICountriesService : IBaseService<int, CountryModel, CountryUpsertModel, BaseSearchObject>
    {
    }
}
