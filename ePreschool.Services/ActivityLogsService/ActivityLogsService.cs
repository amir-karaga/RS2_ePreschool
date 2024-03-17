﻿using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Mvc.Controllers;

namespace ePreschool.Services
{
    public class ActivityLogsService : BaseService<ActivityLog, ActivityLogModel, ActivityLogUpsertModel, BaseSearchObject, IActivityLogsRepository>, IActivityLogsService
    {
        private readonly IHttpContextAccessor _httpContext;
        public ActivityLogsService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<ActivityLogUpsertModel> validator, IHttpContextAccessor httpContext) : base(mapper, unitOfWork, validator)
        {
            _httpContext = httpContext;
        }
        public async Task<List<ActivityLogModel>> LogAsync(ActivityLogType logType, string tableName, Exception ex, IEnumerable<int?> rowIds = null, string email = null)
        {
            var activityList = new List<ActivityLogModel>();
            try
            {
                if (rowIds != null)
                {
                    foreach (int rowId in rowIds)
                    {
                        var addedLog = await LogAsync(logType, rowId, tableName, ex);
                        activityList.Add(addedLog);
                    }
                    return activityList;
                }
                else
                {
                    var addedLog = await LogAsync(logType, null, tableName, ex, email);
                    activityList.Add(addedLog);
                    return activityList;
                }
            }
            catch
            {
                return null;
            }
        }

        public async Task<ActivityLogModel> LogAsync(ActivityLogType logType, int? rowId, string tableName, Exception? ex, string email=null)
        {
            var httpContext = _httpContext.HttpContext;
            var userId = httpContext?.User.FindFirst("Id")?.Value;
            var userEmail = email ?? httpContext?.User.FindFirst("Email")?.Value;

            var addedLog = await AddAsync(new ActivityLogUpsertModel()
            {
                Email = userEmail,
                UserId = !string.IsNullOrWhiteSpace(userId)? int.Parse(userId) : null,
                HostName = httpContext?.Request.Host.ToString() ?? "N/A",
                ActiveUrl = httpContext?.Request.Path.ToString() ?? "N/A",
                ActionMethod = httpContext?.Request.Method.ToString() ?? "N/A",
                ExceptionMessage = ex?.Message,
                ExceptionType = ex?.GetType().ToString(),
                Controller = httpContext?.Features.Get<IEndpointFeature>()?.Endpoint?.Metadata.GetMetadata<ControllerActionDescriptor>()?.ControllerName ?? "N/A",
                WebBrowser = httpContext?.Request.Headers["sec-ch-ua"].ToString() ?? "N/A",
                IPAddress = httpContext?.Connection?.LocalIpAddress?.ToString() ?? "N/A",
                ReferrerUrl = httpContext?.Request.Headers["Referer"].ToString() ?? "N/A",
                ActivityId = logType,
                RowId = rowId,
                Description = $"Inner Exception: {ex?.InnerException?.Message ?? "N/A"} | Stack Trace: {ex?.StackTrace ?? "N/A"}",
                TableName = tableName.Replace("RideWithMe.Services.", "").Replace("Service", "")
            });

            return addedLog;
        }

       
    }
}
