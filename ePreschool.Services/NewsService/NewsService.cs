using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models.New;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class NewsService : BaseService<New, NewModel, NewUpsertModel, NewsSearchObject, INewsRepository>, INewsService
    {
        private readonly UnitOfWork _unitOfWork;

        public NewsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<NewUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
        }
    }
}
