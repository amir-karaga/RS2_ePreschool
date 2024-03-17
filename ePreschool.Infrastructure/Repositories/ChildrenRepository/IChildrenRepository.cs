using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IChildrenRepository : IBaseRepository<Child, int, ChildrenSearchObject>
    {
        Task<List<Child>> GetByParentIdAsync(int parentId, CancellationToken cancellationToken = default);
        Task<List<Child>> GetByCompanyId(int companyId, CancellationToken cancellationToken = default);
    }
}
