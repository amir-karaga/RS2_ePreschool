using AutoMapper;
using ePreschool.Api.Services.AccessManager;
using ePreschool.Api.Services.FileManager;
using ePreschool.Api.ViewModel;
using ePreschool.Core;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Services;
using Lahor.Shared.Messages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;

namespace ePreschool.Api.Controllers
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class AccessController : BaseController
    {
        private readonly IAccessManager _accessManager;
        private readonly IFileManager _fileManager;
        private readonly IParentsService _parentsService;
        private readonly IMapper _mapper;
        private readonly ApplicationUsersService _applicationUsersService;
        public AccessController(IMapper mapper, IParentsService parentsService, IFileManager fileManager, IAccessManager accessManager, ILogger<AccessController> logger, IActivityLogsService activityLogs, IApplicationUsersService applicationUsersService) : base(logger, activityLogs)
        {
            _accessManager = accessManager;
            _fileManager = fileManager;
            _parentsService = parentsService;
            _mapper = mapper;
            _applicationUsersService = (ApplicationUsersService)applicationUsersService;
        }

        [HttpPost]
        public async Task<IActionResult> SignIn(AccessSignInModel model)
        {
            if (model.UserName.IsNullOrEmpty() || model.Password.IsNullOrEmpty())
                return BadRequest(Messages.InValidMessage);

            try
            {
                var loginInformation = await _accessManager.SignInAsync(model.UserName, model.Password, model.RememberMe);
                return Ok(loginInformation);
            }
            catch (UserNotVerifiedException e)
            {
                Logger.LogError(e, "User not verified exception");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _applicationUsersService.GetType().ToString(), e, null, model.UserName);
                return StatusCode(401, e.Message);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _applicationUsersService.GetType().ToString(), e, null, model.UserName);
                return BadRequest(e.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Registration([FromBody] RegistrationModel model)
        {
            try
            {
                return Ok(await _parentsService.AddAsync(_mapper.Map<ParentUpsertModel>(model)));
            }
            catch (UserNotVerifiedException e)
            {
                Logger.LogError(e, "User not verified exception");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _applicationUsersService.GetType().ToString(), e, null, model.UserName);
                return StatusCode(401, e.Message);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when signing in user");
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, _applicationUsersService.GetType().ToString(), e, null, model.UserName);
                return BadRequest(e.Message);
            }
        }
    }
}
