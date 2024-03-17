using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IEmployeesRepository : IBaseRepository<Employee, int, EmployeeSearchObject>
    {
        Task<List<EntityItemModel>> GetEntityItemModelsByCompanyId(int companyId, CancellationToken cancellationToken = default);
    }
}
