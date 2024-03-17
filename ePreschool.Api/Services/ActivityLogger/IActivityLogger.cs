using ePreschool.Core.Enumerations;

namespace ePreschool.Api.Services.ActivityLogger
{
    public interface IActivityLogger
    {
        //Task CreateLog(LogDto log);
    }

    public class LogDto
    {
        public LogDto(ActivityLogType logType, string tableName, int? rowId, string title, string message, Exception exception = null)
        {
            Title = title;
            Message = message;
            LogType = logType;
            RowId = rowId;
            TableName = tableName;
            Exception = exception;
        }

        public string Title { get; set; }
        public string Message { get; set; }
        public ActivityLogType LogType { get; set; }
        public int? RowId { get; set; }
        public string TableName { get; set; }
        public Exception Exception { get; set; }
    }
}
