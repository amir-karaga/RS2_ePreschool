using ePreschool.Api.Services.FileManager;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    [Route("api/[controller]")]
    [Authorize(AuthenticationSchemes = "Bearer")]
    [ApiController]
    public class ApplicationUsersController : BaseController
    {
        private readonly IFileManager _fileManager;
        private readonly ApplicationUsersService ApplicationUsersService;
        public ApplicationUsersController(ILogger<AccessController> logger, IActivityLogsService activityLogs,
            IFileManager fileManager, IApplicationUsersService applicationUsersService) : base(logger, activityLogs)
        {
            _fileManager = fileManager;
            ApplicationUsersService = (ApplicationUsersService)applicationUsersService;
        }

        [HttpGet("GetUserProfile")]
        public async Task<IActionResult> GetUserProfile()
        {
            if (User.Claims == null)
            {
                return BadRequest(null);
            }

            return Ok(await ApplicationUsersService.GetByIdAsync(int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id").Value)));
        }

    }
}
