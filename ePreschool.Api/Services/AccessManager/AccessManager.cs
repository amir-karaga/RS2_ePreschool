using AutoMapper;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Services;
using ePreschool.Shared.Constants;
using ePreschool.Shared.Models;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace ePreschool.Api.Services.AccessManager
{
    public class AccessManager : IAccessManager
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly UserManager<ApplicationUser> _userManager;
        private readonly ICrypto _cryptoService;
        private readonly IApplicationUsersService _applicationUsersService;
        private readonly IParentsService _parenntsService;
        private readonly IEmployeesService _employeesService;
        private readonly IConfiguration _configuration;
        private readonly IEmail _email;
        private readonly IMapper _mapper;
        private readonly JWTConfig _jwtConfig;

        public AccessManager(ICrypto cryptoService, IUnitOfWork unitOfWork,
                            IApplicationUsersService applicationUsersService, UserManager<ApplicationUser> userManager,
                            IOptions<JWTConfig> jwtConfig, IConfiguration configuration, IEmail email, IMapper mapper,
                            IParentsService parentsService, IEmployeesService employeesService)
        {
            _cryptoService = cryptoService;
            _applicationUsersService = applicationUsersService;
            _unitOfWork = (UnitOfWork)unitOfWork;
            _userManager = userManager;
            _jwtConfig = jwtConfig.Value;
            _configuration = configuration;
            _email = email;
            _mapper = mapper;
            _parenntsService = parentsService;
            _employeesService = employeesService;
        }

        public async Task<LoginInformation> SignInAsync(string username, string password, bool rememberMe = false)
        {
            var user = await _applicationUsersService.FindByUserNameOrEmailAsync(username);
            if (user == null)
            {
                throw new UserNotFoundException();
            }

            if (!await _userManager.CheckPasswordAsync(new ApplicationUser() { PasswordHash = user.PasswordHash }, password))
            {
                throw new WrongCredentialsException(user);
            }
            int? currentCompanyId = null;
            if (user.IsEmployee || user.IsPreschoolOwner)
            {
                var employee = await _employeesService.GetByIdAsync(user.Id);
                currentCompanyId = employee.CompanyId;
            }
            else if (user.IsParent)
            {
                var parent = await _parenntsService.GetByIdAsync(user.Id);
                currentCompanyId = parent.KindergartenId;
            }
            var loginInformation = _mapper.Map<LoginInformation>(user);
            loginInformation.CurrentCompanyId = currentCompanyId;
            loginInformation.Token = GenerateToken(user);
            return loginInformation;

        }

        public async Task<IdentityResult> ChangePassword(string currentPassword, string newPassword)
        {
            return await _userManager.ChangePasswordAsync(await _userManager.FindByIdAsync("testId"), currentPassword, newPassword);
        }

        public async Task ResetPassword(string email)
        {
            var user = await _userManager.FindByEmailAsync(email);
            var newPassword = _cryptoService.GeneratePassword();
            await _userManager.ResetPasswordAsync(user, await _userManager.GeneratePasswordResetTokenAsync(user), newPassword);
        }
        private string GenerateToken(ApplicationUserModel user)
        {
            try
            {


                var claims = CreateClaims(user);

                var tokenKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration.GetSection(ConfigurationValues.TokenKey).Value));
                var signInCreds = new SigningCredentials(tokenKey, SecurityAlgorithms.HmacSha256Signature);
                var token = new JwtSecurityToken(claims: claims, expires: DateTime.Now.AddMinutes(int.Parse(_configuration.GetSection(ConfigurationValues.TokenValidityInMinutes).Value)), signingCredentials: signInCreds);

                return new JwtSecurityTokenHandler().WriteToken(token);
            }
            catch (Exception ex)
            {

                throw;
            }
        }


        private IEnumerable<Claim> CreateClaims(ApplicationUserModel user)
        {
            var identity = new ClaimsIdentity(CookieAuthenticationDefaults.AuthenticationScheme);

            identity.AddClaim(new Claim(nameof(user.Id), user.Id.ToString()));
            identity.AddClaim(new Claim(nameof(user.Email), user.Email));
            identity.AddClaim(new Claim(nameof(user.IsAdministrator), user.IsAdministrator.ToString()));
            identity.AddClaim(new Claim(nameof(user.IsEmployee), user.IsEmployee.ToString()));
            identity.AddClaim(new Claim(nameof(user.IsParent), user.IsParent.ToString()));
            identity.AddClaim(new Claim(nameof(user.IsPreschoolOwner), user.IsPreschoolOwner.ToString()));
            identity.AddClaim(new Claim(nameof(user.Person.FirstName), user.Person.FirstName));
            identity.AddClaim(new Claim(nameof(user.Person.LastName), user.Person.LastName));

            //if (user.Person.ProfilePhoto.IsSet())
            //    identity.AddClaim(new Claim(CustomClaimTypes.ProfilePhoto, CustomClaimTypes.ProfilePhoto));

            //if (user.Person.ProfilePhotoThumbnail.IsSet())
            //    identity.AddClaim(new Claim(CustomClaimTypes.ProfilePhoto, user.Person.ProfilePhotoThumbnail));
            foreach (var item in user.UserRoles)
                identity.AddClaim(new Claim(ClaimTypes.Role, item.RoleId.ToString()));

            return identity.Claims;
        }
    }

    public class UserNotFoundException : Exception
    {
        public UserNotFoundException(string message = null) : base(message) { }
    }

    public class WrongCredentialsException : Exception
    {
        public ApplicationUserModel User { get; set; }

        public WrongCredentialsException(ApplicationUserModel user, string message = null) : base(message)
        {
            User = user;
        }
    }
}

