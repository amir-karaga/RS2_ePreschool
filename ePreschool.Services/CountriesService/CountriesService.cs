using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class CountriesService : BaseService<Country, CountryModel, CountryUpsertModel, BaseSearchObject, ICountriesRepository>, ICountriesService
    {
        public CountriesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CountryUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
