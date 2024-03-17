using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using FluentValidation;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Services
{
    public class ChildrenService : BaseService<Child, ChildModel, ChildUpsertModel, ChildrenSearchObject, IChildrenRepository>, IChildrenService
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly IApplicationUserRolesRepository _applicationUserRolesRepository;
        private readonly IApplicationRolesRepository _applicationRolesRepository;
        private readonly IParentsRepository _parentsRepository;
        private readonly ICompaniesRepository _companiesRepository;
        private readonly ICrypto _crypto;
        private readonly IEmail _email;
        private readonly IMapper _mapper;
        private readonly IPasswordHasher<ApplicationUser> _passwordHasher;

        public ChildrenService(IUnitOfWork unitOfWork, IApplicationUserRolesRepository applicationUserRolesRepository,
            IApplicationRolesRepository applicationRolesRepository, ICrypto crypto, IPasswordHasher<ApplicationUser> passwordHasher,
            IEmail email, IMapper mapper, IValidator<ChildUpsertModel> validator, IParentsRepository parentsRepository,
            ICompaniesRepository companiesRepository) : base(mapper, unitOfWork, validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _applicationUserRolesRepository = applicationUserRolesRepository;
            _applicationRolesRepository = applicationRolesRepository;
            _crypto = crypto;
            _email = email;
            _mapper = mapper;
            _passwordHasher = passwordHasher;
            _parentsRepository = parentsRepository;
            _companiesRepository = companiesRepository;
        }

        public override async Task<ChildModel> AddAsync(ChildUpsertModel entityModel, CancellationToken cancellationToken = default)
        {
            entityModel.DateOfEnrollment = DateTime.Now;
            var personInsert = _mapper.Map<PersonInsertModel>(entityModel);
            var newUser = _mapper.Map<Person>(personInsert);
            newUser.ApplicationUser = null;
            await _unitOfWork.PersonsRepository.AddAsync(newUser);
            await _unitOfWork.SaveChangesAsync();
            return _mapper.Map<ChildModel>(newUser.Child);
        }

        public override async Task<ChildModel> UpdateAsync(ChildUpsertModel entityModel, CancellationToken cancellationToken = default)
        {
            try
            {
                var personInsert = _mapper.Map<PersonInsertModel>(entityModel);
                var newUser = _mapper.Map<Person>(personInsert);
                var child = newUser.Child;
                child.Id = newUser.Id;
                CurrentRepository.Update(child);
                newUser.Child = null;
                newUser.ApplicationUser = null;
                _unitOfWork.PersonsRepository.Update(newUser);
                await _unitOfWork.SaveChangesAsync();
                return _mapper.Map<ChildModel>(newUser.Child);

            }
            catch (Exception)
            {

                throw;
            }
        }

        public async Task<PagedList<MonthlyPaymentModel>> GetMonthlyPayments(MonthlyPaymentSearchObject searchObject)
        {
            var monthlyPayments = new List<MonthlyPaymentModel>();
            var childItems = new List<ChildModel>();
            if (searchObject.ChildId.HasValue && searchObject.ParentId.HasValue)
            {
                childItems.Add(Mapper.Map<ChildModel>(await CurrentRepository.GetByIdAsync(searchObject.ChildId.Value)));
            }
            if (searchObject.ParentId.HasValue && !searchObject.ChildId.HasValue && !searchObject.CompanyId.HasValue)
            {
                childItems = Mapper.Map<List<ChildModel>>(await CurrentRepository.GetByParentIdAsync(searchObject.ParentId.Value));
            }
            if (searchObject.CompanyId.HasValue)
            {
                childItems = Mapper.Map<List<ChildModel>>(await CurrentRepository.GetByCompanyId(searchObject.CompanyId.Value));
            }
            foreach (var child in childItems)
            {
                var dateOfEnrollment = child.DateOfEnrollment;
                var monthPaymentsByChild = await _unitOfWork.MonthlyPaymentsRepository.GetMonthlyPaymentsByChildren(child.Id);
                //var lastPayment = monthPaymentsByChild.Where(x=> x.IsPaid == true).FirstOrDefault();
                DateTime currentDate = DateTime.Now;
                int yearOfPaymentStart = dateOfEnrollment.Year;
                int monthOfPaymentStart = dateOfEnrollment.Month;
                var appConfigData = (await _unitOfWork.AppConfigsRepository.GetPagedAsync(new BaseSearchObject
                {
                    PageNumber = 1,
                    PageSize = 999
                })).Items?.FirstOrDefault();
                //if (lastPayment != null && searchObject.IsPaid.HasValue && searchObject.IsPaid == false)
                //{
                //    yearOfPaymentStart = lastPayment.Month == 12 ? lastPayment.Year + 1 : lastPayment.Year;
                //    monthOfPaymentStart = lastPayment.Month == 12 ? 1 : lastPayment.Month + 1;
                //}
                int startMonth = 0;
                int endMonth = 0;
                for (int i = yearOfPaymentStart; i <= currentDate.Year; i++)
                {
                    startMonth = i == dateOfEnrollment.Year ? monthOfPaymentStart : 1;
                    endMonth = i == currentDate.Year ? currentDate.Month : 12;
                    for (int j = startMonth; j <= endMonth; j++)
                    {
                        var monthlyPayment = monthPaymentsByChild.FirstOrDefault(x => x.Month == j && x.Year == i);
                        var newMonthlyPayment = new MonthlyPaymentModel
                        {
                            ChildId = child.Id,
                            Child = child,
                            ParentId = child.ParentId,
                            Month = j,
                            Year = i,
                            Price = monthlyPayment != null ? monthlyPayment.Price : appConfigData != null ? appConfigData.MonthlyFee : 0,
                            IsPaid = monthlyPayment != null,
                        };
                        if (searchObject.IsPaid == null || (searchObject.IsPaid.HasValue && (newMonthlyPayment.IsPaid == searchObject.IsPaid)))
                        {
                            monthlyPayments.Add(newMonthlyPayment);
                        }
                    }
                }
            }
            var pagedList = new PagedList<MonthlyPaymentModel>();
            var totalItemCount = monthlyPayments.Count;

            pagedList.Items = monthlyPayments.Skip((searchObject.PageNumber - 1) * searchObject.PageSize).Take(searchObject.PageSize).ToList();
            pagedList.PageNumber = searchObject.PageNumber;
            pagedList.PageSize = searchObject.PageSize;
            pagedList.TotalCount = totalItemCount;

            pagedList.PageCount = pagedList.TotalCount > 0 ? (int)Math.Ceiling(pagedList.TotalCount / (double)pagedList.PageSize) : 0;
            if (pagedList.PageCount <= 0 || pagedList.PageNumber > pagedList.PageCount)
                return pagedList;

            pagedList.HasPreviousPage = pagedList.PageNumber > 1;
            pagedList.HasNextPage = pagedList.PageNumber < pagedList.PageCount;

            pagedList.IsFirstPage = pagedList.PageNumber == 1;
            pagedList.IsLastPage = pagedList.PageNumber == pagedList.PageCount;

            return pagedList;
        }
    }
}
