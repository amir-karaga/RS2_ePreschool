using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Shared.Constants;
using ePreschool.Shared.Models;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using FluentValidation;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Services
{
    public class ParentsService : BaseService<Parent, ParentModel, ParentUpsertModel, ParentsSearchObject, IParentsRepository>, IParentsService
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly IApplicationUserRolesRepository _applicationUserRolesRepository;
        private readonly IApplicationRolesRepository _applicationRolesRepository;
        private readonly ICrypto _crypto;
        private readonly IEmail _email;
        private readonly IMapper _mapper;
        private readonly IPasswordHasher<ApplicationUser> _passwordHasher;
        private readonly IRabbitMQProducer _rabbitMQProducer;
        public ParentsService(IUnitOfWork unitOfWork, IApplicationUserRolesRepository applicationUserRolesRepository,
            IApplicationRolesRepository applicationRolesRepository, ICrypto crypto,
            IPasswordHasher<ApplicationUser> passwordHasher, IEmail email, IMapper mapper, IRabbitMQProducer rabbitMQProducer,
            IValidator<ParentUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _applicationUserRolesRepository = applicationUserRolesRepository;
            _applicationRolesRepository = applicationRolesRepository;
            _crypto = crypto;
            _email = email;
            _mapper = mapper;
            _passwordHasher = passwordHasher;
            _rabbitMQProducer = rabbitMQProducer;
        }

        public override async Task<ParentModel> AddAsync(ParentUpsertModel entityModel, CancellationToken cancellationToken = default)
        {
            try
            {
                dynamic newUser = _mapper.Map<PersonInsertModel>(entityModel);
                newUser.ApplicationUser.Active = true;
                newUser.ApplicationUser.EmailConfirmed = true;
                newUser.ApplicationUser.IsParent = true;
                newUser.ApplicationUser.ConcurrencyStamp = Guid.NewGuid().ToString();
                string password = _crypto.GeneratePassword();
                newUser.ApplicationUser.PasswordHash = _passwordHasher.HashPassword(new ApplicationUser(), password);
                newUser = _mapper.Map<Person>(newUser);
                await _unitOfWork.PersonsRepository.AddAsync(newUser);

                await _unitOfWork.SaveChangesAsync();

                var role = await _applicationRolesRepository.GetByRoleLevelOrName((int)Role.Parent, Role.Parent.ToString());
                await _applicationUserRolesRepository.AddAsync(new ApplicationUserRole
                {
                    UserId = newUser.Id,
                    RoleId = role.Id
                });
                await _unitOfWork.SaveChangesAsync();
                try
                {
                    var message = EmailMessages.GeneratePasswordEmail($"{newUser.FirstName} {newUser.LastName}", password);

                    var email = new EmailModel
                    {
                        Title = EmailMessages.ClientEmailSubject,
                        Body = message,
                        Email = entityModel.Email,
                    };

                    _rabbitMQProducer.SendMessage(email);
                }
                catch (Exception ex)
                {
                    throw;
                }

                return _mapper.Map<ParentModel>(newUser.Parent);
            }
            catch (Exception ex)
            {

                throw;
            }

        }
    }
}
