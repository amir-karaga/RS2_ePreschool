using AutoMapper;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using FluentValidation;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Services
{
    public class ApplicationUsersService: IApplicationUsersService
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly IApplicationUserRolesRepository _applicationUserRolesRepository;
        private readonly IApplicationRolesRepository _applicationRolesRepository;
        private readonly ICrypto _crypto;
        private readonly IEmail _email;
        private readonly IPasswordHasher<ApplicationUser> _passwordHasher;
        private readonly IMapper _mapper;

        public ApplicationUsersService(IUnitOfWork unitOfWork, IApplicationUserRolesRepository applicationUserRolesRepository,
            IApplicationRolesRepository applicationRolesRepository, ICrypto crypto, IMapper mapper,
            IPasswordHasher<ApplicationUser> passwordHasher,IEmail email, IValidator<ApplicationUserModel> validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _applicationUserRolesRepository = applicationUserRolesRepository;
            _applicationRolesRepository = applicationRolesRepository;
            _crypto= crypto;
            _email = email;
            _passwordHasher = passwordHasher;
            _mapper = mapper;
        }

        public async Task<ApplicationUserModel> FindByUserNameOrEmailAsync(string pUserName, CancellationToken cancellationToken = default)
        {
            var entity = await _unitOfWork.ApplicationUsersRepository.FindByUserNameOrEmailAsync(pUserName);
            return _mapper.Map<ApplicationUserModel>(entity);
        }

        public virtual async Task<ApplicationUserModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await _unitOfWork.ApplicationUsersRepository.GetByIdAsync(id, cancellationToken);
            return _mapper.Map<ApplicationUserModel>(entity);
        }

    }
}
