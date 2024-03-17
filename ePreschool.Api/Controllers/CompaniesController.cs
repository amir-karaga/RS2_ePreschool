using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CompaniesController : BaseCrudController<CompanyModel, CompanyUpsertModel, BaseSearchObject, ICompaniesService>
    {
        public CompaniesController(IFileManager fileManager, ICompaniesService service, ILogger<CompaniesController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        { }

    }
}
