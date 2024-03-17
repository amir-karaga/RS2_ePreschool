using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IApplicationUsersRepository
    {
        Task<ApplicationUser?> GetByIdAsync(int id, CancellationToken cancellationToken = default);
        Task<PagedList<ApplicationUser>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default);

        Task AddAsync(ApplicationUser entity, CancellationToken cancellationToken = default);
        Task AddRangeAsync(IEnumerable<ApplicationUser> entities, CancellationToken cancellationToken = default);

        void Update(ApplicationUser entity);
        void UpdateRange(IEnumerable<ApplicationUser> entities);
        void Remove(ApplicationUser entity);
        Task RemoveByIdAsync(int id, bool isSoft = true, CancellationToken cancellationToken = default);
        Task<ApplicationUser> FindByUserNameOrEmailAsync(string UserName, CancellationToken cancellationToken = default);
    }
}
