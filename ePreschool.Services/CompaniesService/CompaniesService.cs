using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class CompaniesService : BaseService<Company, CompanyModel, CompanyUpsertModel, BaseSearchObject, ICompaniesRepository>, ICompaniesService
    {
        public CompaniesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<CompanyUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }

        public virtual async Task<CompanyModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await CurrentRepository.GetByIdAsync(id, cancellationToken);
            var item = Mapper.Map<CompanyModel>(entity);
            item.Rating = await CalculateRating(id);
            return item;
        }


        public virtual async Task<PagedList<CompanyModel>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                var pagedList = await CurrentRepository.GetPagedAsync(searchObject, cancellationToken);
                var companies = Mapper.Map<PagedList<CompanyModel>>(pagedList);
                foreach (var item in companies.Items)
                {
                    item.Rating = await CalculateRating(item.Id);
                }
                return companies;

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        private async Task<decimal> CalculateRating(int companyId)
        {
            int totalRating = 0;
            var employees = (await UnitOfWork.EmployeesRepository.GetPagedAsync(new EmployeeSearchObject
            {
                CompanyId = companyId,
                Position = Position.Odgajatelj,
                PageNumber = 1,
                PageSize = 1000
            })).Items;
            if (employees.Count > 0)
            {
                int totalReviews = 0;
                foreach (var employee in employees)
                {
                    totalReviews += employee.Reviews.Count();
                    totalRating += employee.Reviews.Sum(x => x.ReviewRating);
                }
                if (totalReviews == 0)
                    return 0;
                return totalRating / (decimal)(totalReviews * 1.00);
            }
            else
            {
                return 0;
            }
        }
    }
}
