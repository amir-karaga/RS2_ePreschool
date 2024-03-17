using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class CitiesService : BaseService<City, CityModel, CityUpsertModel, CountriesCitiesSearchObject, ICitiesRepository>, ICitiesService
    {
        public CitiesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CityUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public async Task<IEnumerable<CityModel>> GetByCountryIdAsync(int countryId, CancellationToken cancellationToken = default)
        {
            var cities = await CurrentRepository.GetByCountryIdAsync(countryId, cancellationToken);

            return Mapper.Map<IEnumerable<CityModel>>(cities);
        }
    }
}
