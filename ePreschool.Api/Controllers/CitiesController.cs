using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CitiesController : BaseCrudController<CityModel, CityUpsertModel, CountriesCitiesSearchObject, ICitiesService>
    {
        public CitiesController(IFileManager fileManager, ICitiesService service, ILogger<CitiesController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        { }

    }
}
