using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class MonthlyPaymentsService : BaseService<MonthlyPayment, MonthlyPaymentModel, MonthlyPaymentUpsertModel, MonthlyPaymentSearchObject, IMonthlyPaymentsRepostitory>, IMonthlyPaymentsService
    {
        public MonthlyPaymentsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MonthlyPaymentUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
