using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;

namespace ePreschool.Api.Controllers
{
    [Authorize(AuthenticationSchemes = "Bearer")]
    public class MessagesController : BaseCrudController<MessageModel, MessageUpsertModel, MessagesSearchObject, IMessagesService>
    {
        public MessagesController(IFileManager fileManager, IMessagesService service, ILogger<MessagesController> logger, IActivityLogsService activityLogs, IMapper mapper) : base(service, logger, activityLogs)
        { }

    }
}
