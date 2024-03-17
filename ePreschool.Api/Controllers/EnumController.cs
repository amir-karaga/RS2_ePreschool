using ePreschool.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    //[Authorize(AuthenticationSchemes = "Bearer")]
    [Route("[controller]")]
    [ApiController]
    public class EnumController : ControllerBase
    {
        private readonly IEnumManager _enumManager;
        public EnumController(IEnumManager enumManager)
        {
            _enumManager = enumManager;
        }

        [HttpGet]
        [Route("genders")]
        public IActionResult Genders()
        {
            return Ok(_enumManager.Genders());

        }

        [HttpGet]
        [Route("drivingLicenses")]
        public IActionResult DrivingLicenses()
        {
            return Ok(_enumManager.DrivingLicenses());

        }

        [HttpGet]
        [Route("positions")]
        public IActionResult Positions()
        {
            return Ok(_enumManager.Positions());

        }

        [HttpGet]
        [Route("marriageStatuses")]
        public IActionResult MarriageStatuses()
        {
            return Ok(_enumManager.MarriageStatuses());

        }

        [HttpGet]
        [Route("qualifications")]
        public IActionResult Qualifications()
        {
            return Ok(_enumManager.Qualifications());

        }

        [HttpGet]
        [Route("cities")]
        public async Task<IActionResult> Cities()
        {
            return Ok(await _enumManager.Cities());
        }

        [HttpGet]
        [Route("companies")]
        public async Task<IActionResult> Companies()
        {
            return Ok(await _enumManager.Companies());
        }
    }
}
