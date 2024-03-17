using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class ParentsController : BaseCrudController<ParentModel, ParentUpsertModel, ParentsSearchObject, IParentsService>
    {
        private readonly IFileManager _fileManager;
        private readonly IParentsService ParentsService;
        private readonly IMapper Mapper;
        public ParentsController(IFileManager fileManager, IParentsService service, IMapper mapper, ILogger<CitiesController> logger, IActivityLogsService activityLogs) :
            base(

                service, logger, activityLogs)
        {
            _fileManager = fileManager;
            ParentsService = service;
            Mapper = mapper;
        }

        [HttpPost]
        public override async Task<IActionResult> Post([FromForm] ParentUpsertModel entity, CancellationToken cancellationToken = default)
        {
            //var file = entity.File;
            //if (file != null)
            //{
            //    entity.ProfilePhoto = await _fileManager.UploadFile(file);
            //}
            return Ok(await ParentsService.AddAsync(entity));
        }
    }
}
