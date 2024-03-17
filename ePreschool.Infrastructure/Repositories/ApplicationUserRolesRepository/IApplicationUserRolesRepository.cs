using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IApplicationUserRolesRepository
    {
        Task<IEnumerable<ApplicationUserRole>> GetByUserId(int pUserId);
        Task<ApplicationUserRole?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<PagedList<ApplicationUserRole>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task AddAsync(ApplicationUserRole entity, CancellationToken cancellationToken = default);
        Task AddRangeAsync(IEnumerable<ApplicationUserRole> entities, CancellationToken cancellationToken = default);

        void Update(ApplicationUserRole entity);
        void UpdateRange(IEnumerable<ApplicationUserRole> entities);
        void Remove(ApplicationUserRole entity);
        Task RemoveByIdAsync(int id, bool isSoft = true, CancellationToken cancellationToken = default);
    }
}
