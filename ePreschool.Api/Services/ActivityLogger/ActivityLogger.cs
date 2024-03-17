using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Infrastructure.UnitOfWork;

namespace ePreschool.Api.Services.ActivityLogger
{
    public class ActivityLogger : IActivityLogger
    {
        private readonly UnitOfWork _unitOfWork;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public ActivityLogger(IUnitOfWork unitOfWork, IHttpContextAccessor httpContextAccessor)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _httpContextAccessor = httpContextAccessor;
        }

        //public async Task CreateLog(ActivityLogModel logModel)
        //{
        //    var log = new ActivityLog();

        //    var request = _httpContextAccessor.HttpContext?.Request;
        //    if (request != null)
        //    {
        //        log.ReferrerUrl = request.Headers["Referer"].ToString();
        //        log.ActiveUrl = request.Path.ToString();
        //        log.Controller = (string)request.RouteValues["Controller"];
        //        log.ActionMethod = (string)request.RouteValues["Action"];
        //    }

        //    log.UserId = null;

        //    log.Message = logModel.Message;
        //    log.Type = logModel.LogType;
        //    log.RowId = logModel.RowId;
        //    log.TableName = logModel.TableName;
        //    log.ExceptionMessage = logModel.Exception?.Message;
        //    log.ExceptionStackTrace = logModel.Exception?.StackTrace;

        //    try
        //    {
        //        await _unitOfWork.LogsRepository.AddAsync(log);
        //        await _unitOfWork.SaveChangesAsync();
        //    }
        //    catch
        //    {
        //        //Ignored
        //    }
        //}
    }
}
