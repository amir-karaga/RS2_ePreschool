using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IEmployeesService : IBaseService<int, EmployeeModel, EmployeeUpsertModel, EmployeeSearchObject>
    {
    }
}
