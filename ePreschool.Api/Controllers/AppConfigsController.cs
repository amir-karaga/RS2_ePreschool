using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class AppConfigsController : BaseCrudController<AppConfigModel, AppConfigUpsertModel, BaseSearchObject, IAppConfigsService>
    {
        public AppConfigsController(IFileManager fileManager, IAppConfigsService service, ILogger<AppConfigsController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        { }

    }
}
