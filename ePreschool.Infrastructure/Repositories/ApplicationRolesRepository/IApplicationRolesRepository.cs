using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IApplicationRolesRepository
    {
        Task<ApplicationRole> GetByRoleLevelOrName(int roleLevelId, string roleName);
        Task<ApplicationRole?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<PagedList<ApplicationRole>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task AddAsync(ApplicationRole entity, CancellationToken cancellationToken = default);
        Task AddRangeAsync(IEnumerable<ApplicationRole> entities, CancellationToken cancellationToken = default);

        void Update(ApplicationRole entity);
        void UpdateRange(IEnumerable<ApplicationRole> entities);
        void Remove(ApplicationRole entity);
        Task RemoveByIdAsync(int id, bool isSoft = true, CancellationToken cancellationToken = default);
    }
}
