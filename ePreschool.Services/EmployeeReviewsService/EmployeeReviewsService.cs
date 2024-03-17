using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class EmployeeReviewsService : BaseService<EmployeeReviews, EmployeeReviewsModel, EmployeeReviewsUpsertModel, BaseSearchObject, IEmployeesReviewsRepository>, IEmployeeReviewsService
    {
        private readonly UnitOfWork _unitOfWork;

        public EmployeeReviewsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<EmployeeReviewsUpsertModel> validator): base(mapper, unitOfWork, validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
        }
    }
}
