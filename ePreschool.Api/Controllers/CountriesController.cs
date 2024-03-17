using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class CountriesController : BaseCrudController<CountryModel, CountryUpsertModel, BaseSearchObject, ICountriesService>
    {
        public CountriesController(IFileManager fileManager, ICountriesService service, IMapper mapper, ILogger<CitiesController> logger, IActivityLogsService activityLogs) : base(service, logger, activityLogs)
        {
        }

    }
}
