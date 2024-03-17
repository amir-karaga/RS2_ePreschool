using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class AppConfigsService : BaseService<AppConfig, AppConfigModel, AppConfigUpsertModel, BaseSearchObject, IAppConfigsRepository>, IAppConfigsService
    {
        public AppConfigsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<AppConfigUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
