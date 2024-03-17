using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class CompaniesRepository : BaseRepository<Company, int, BaseSearchObject>, ICompaniesRepository
    {
        public CompaniesRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public virtual async Task<Company?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.Include(x => x.Location).FirstOrDefaultAsync(x => x.Id == id);
            return obj;
        }
        public override async Task<PagedList<Company>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(c => c.Location).Where(c => (searchObject.SearchFilter == null || c.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())) && c.IsDeleted == false)
               .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
