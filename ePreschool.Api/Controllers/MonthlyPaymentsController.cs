using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class MonthlyPaymentsController : BaseCrudController<MonthlyPaymentModel, MonthlyPaymentUpsertModel, MonthlyPaymentSearchObject, IMonthlyPaymentsService>
    {
        public MonthlyPaymentsController(IFileManager fileManager,IMonthlyPaymentsService service, IMapper mapper, ILogger<MonthlyPaymentsController> logger, IActivityLogsService activityLogs) : base(service, logger, activityLogs)
        {
        }

    }
}
