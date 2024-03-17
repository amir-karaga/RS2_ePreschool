using ePreschool.Core.Enumerations;

namespace ePreschool.Core.SearchObjects
{
    public class EmployeeSearchObject : BaseSearchObject
    {
        public int? CompanyId { get; set; }
        public Position? Position { get; set; }
    }
}
