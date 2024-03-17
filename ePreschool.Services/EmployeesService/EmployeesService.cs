using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Shared.Constants;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using FluentValidation;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Services
{
    public class EmployeesService : BaseService<Employee, EmployeeModel, EmployeeUpsertModel, EmployeeSearchObject, IEmployeesRepository>, IEmployeesService
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly ICrypto _crypto;
        private readonly IEmail _email;
        private readonly IPasswordHasher<ApplicationUser> _passwordHasher;
        public IMapper _mapper;

        public EmployeesService(IUnitOfWork unitOfWork, IApplicationUserRolesRepository applicationUserRolesRepository, IApplicationRolesRepository applicationRolesRepository,
            ICrypto crypto, IPasswordHasher<ApplicationUser> passwordHasher, IEmail email, IMapper mapper, IValidator<EmployeeUpsertModel> validator,
            IApplicationUsersRepository applicationUsersRepository) : base(mapper, unitOfWork, validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _crypto = crypto;
            _email = email;
            _passwordHasher = passwordHasher;
            _mapper = mapper;
        }
        public override async Task<EmployeeModel> AddAsync(EmployeeUpsertModel entityModel, CancellationToken cancellationToken = default)
        {
            try
            {
                entityModel.DateOfEmployment = DateTime.Now;
                dynamic newUser = _mapper.Map<PersonInsertModel>(entityModel);
                newUser.ApplicationUser.Active = true;
                newUser.ApplicationUser.EmailConfirmed = true;
                newUser.ApplicationUser.IsEmployee = true;
                newUser.ApplicationUser.ConcurrencyStamp = Guid.NewGuid().ToString();
                var password = _crypto.GeneratePassword();
                newUser.ApplicationUser.PasswordHash = _passwordHasher.HashPassword(new ApplicationUser(), password);
                newUser.ApplicationUser.IsDeleted = false;
                newUser = _mapper.Map<Person>(newUser);
                await _unitOfWork.PersonsRepository.AddAsync(newUser);
                await _unitOfWork.SaveChangesAsync();
                var role = await _unitOfWork.ApplicationRolesRepository.GetByRoleLevelOrName((int)Role.Employee, Role.Employee.ToString());
                if (entityModel.Position == Position.Direktor)
                {
                    role = await _unitOfWork.ApplicationRolesRepository.GetByRoleLevelOrName((int)Role.PreschoolOwner, Role.PreschoolOwner.ToString());
                }
                await _unitOfWork.ApplicationUserRolesRepository.AddAsync(new ApplicationUserRole
                {
                    UserId = newUser.Id,
                    RoleId = role.Id
                });
                await _unitOfWork.SaveChangesAsync();

                var message = EmailMessages.GeneratePasswordEmail($"{newUser.FirstName} {newUser.LastName}", password);
                await _email.Send("Login kredencijali", message, newUser.ApplicationUser.Email);
                return _mapper.Map<EmployeeModel>(newUser.Employee);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        public override async Task<EmployeeModel> UpdateAsync(EmployeeUpsertModel entityModel, CancellationToken cancellationToken = default)
        {
            try
            {
                var personInsert = _mapper.Map<PersonInsertModel>(entityModel);
                var updateUser = _mapper.Map<Person>(personInsert);
                var employee = updateUser.Employee;
                employee.Reviews = null;
                employee.Id = updateUser.Id;
                CurrentRepository.Update(employee);
                updateUser.Employee = null;
                updateUser.ApplicationUser = null;
                _unitOfWork.PersonsRepository.Update(updateUser);
                var appUser = await _unitOfWork.ApplicationUsersRepository.GetByIdAsync(entityModel.Id.Value, cancellationToken);
                appUser.Roles = null;
                appUser.Email = entityModel.Email;
                appUser.PhoneNumber = entityModel.PhoneNumber;
                _unitOfWork.ApplicationUsersRepository.Update(appUser);
                await _unitOfWork.SaveChangesAsync();
                return _mapper.Map<EmployeeModel>(updateUser.Employee);

            }
            catch (Exception ex)
            {

                throw;
            }
        }


    }
}
