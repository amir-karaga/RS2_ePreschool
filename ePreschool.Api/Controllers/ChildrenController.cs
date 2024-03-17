using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class ChildrenController : BaseCrudController<ChildModel, ChildUpsertModel, ChildrenSearchObject, IChildrenService>
    {
        private readonly IFileManager _fileManager;
        private readonly IChildrenService ChildrenService;
        private readonly IMapper _mapper;
        public ChildrenController(IFileManager fileManager, IChildrenService service, ILogger<CitiesController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        {
            _fileManager = fileManager;
            ChildrenService = service;
            _mapper = mapper;
        }

        [HttpGet("GetPaged")]
        public override async Task<IActionResult> GetPaged([FromQuery] ChildrenSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            try
            {
                if (bool.Parse(User.Claims.FirstOrDefault(x => x.Type == "IsEmployee")?.Value ?? "false"))
                {
                    searchObject.EducatorId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");
                }
                else if (bool.Parse(User.Claims.FirstOrDefault(x => x.Type == "IsParent")?.Value ?? "false"))
                {
                    searchObject.ParentId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id")?.Value ?? "0");
                }
                var dto = await Service.GetPagedAsync(searchObject, cancellationToken);
                return Ok(dto);
            }
            catch (Exception e)
            {
                Logger.LogError(e, "Problem when getting paged resources for page number {0}, with page size {1}", searchObject.PageNumber, searchObject.PageSize);
                await ActivityLogs.LogAsync(ActivityLogType.SystemError, Service.GetType().ToString(), e);
                return BadRequest();
            }
        }

        [HttpPost]
        public override async Task<IActionResult> Post([FromForm] ChildUpsertModel entity, CancellationToken cancellationToken = default)
        {
            var file = entity.File;
            if (file != null)
            {
                entity.ProfilePhoto = await _fileManager.UploadFile(file);
            }
            return Ok(await ChildrenService.AddAsync(entity));
        }

        [HttpPut]
        public override async Task<IActionResult> Put([FromForm] ChildUpsertModel entity, CancellationToken cancellationToken = default)
        {
            var file = entity.File;
            if (file != null)
            {
                entity.ProfilePhoto = await _fileManager.UploadFile(file);
            }
            return Ok(await ChildrenService.UpdateAsync(entity));
        }

        [HttpGet("GetMonthlyPayments")]

        public async Task<IActionResult> GetMonthlyPayments([FromQuery] MonthlyPaymentSearchObject searchObject)
        {
            if (User.Claims != null)
            {
                if (bool.Parse(User.Claims.FirstOrDefault(x => x.Type == "IsParent")?.Value ?? "false"))
                    searchObject.ParentId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id").Value);
            }
            return Ok(await ChildrenService.GetMonthlyPayments(searchObject));
        }

    }
}
