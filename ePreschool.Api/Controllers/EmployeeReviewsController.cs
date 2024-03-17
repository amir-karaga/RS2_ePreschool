using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class EmployeeReviewsController : BaseCrudController<EmployeeReviewsModel, EmployeeReviewsUpsertModel, BaseSearchObject, IEmployeeReviewsService>
    {
        public EmployeeReviewsController(IFileManager fileManager,IEmployeeReviewsService service, ILogger<EmployeeReviewsController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        {}

    }
}
