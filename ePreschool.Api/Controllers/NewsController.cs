using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models.New;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class NewsController : BaseCrudController<NewModel, NewUpsertModel, NewsSearchObject, INewsService>
    {
        private readonly IFileManager _fileManager;
        private readonly INewsService newsService;
        private readonly IMapper Mapper;
        public NewsController(IFileManager fileManager, INewsService service, IMapper mapper,
            ILogger<NewsController> logger, IActivityLogsService activityLogs) : base(service, logger, activityLogs)
        {
            _fileManager = fileManager;
            newsService = service;
            Mapper = mapper;
        }

        [HttpPost]
        public override async Task<IActionResult> Post([FromForm] NewUpsertModel newModel, CancellationToken cancellationToken = default)
        {
            if (User.Claims != null)
            {
                newModel.UserId = int.Parse(User.Claims.FirstOrDefault(x => x.Type == "Id").Value);
            }
            var file = newModel.File;
            if (file != null)
            {
                newModel.Image = await _fileManager.UploadFile(file);
            }
            return Ok(await newsService.AddAsync(newModel));
        }


        [HttpPut]
        public override async Task<IActionResult> Put([FromForm] NewUpsertModel newModel, CancellationToken cancellationToken = default)
        {
            var file = newModel.File;
            if (file != null)
            {
                newModel.Image = await _fileManager.UploadFile(file);
            }
            return Ok(await newsService.UpdateAsync(newModel));
        }
    }
}
