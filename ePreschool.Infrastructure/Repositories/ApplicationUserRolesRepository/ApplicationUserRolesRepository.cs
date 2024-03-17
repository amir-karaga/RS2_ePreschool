using AutoMapper;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories.ApplicationUserRolesRepository
{
    public class ApplicationUserRolesRepository : IApplicationUserRolesRepository
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<ApplicationUserRole> DbSet;
        public ApplicationUserRolesRepository(IMapper mapper, DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<ApplicationUserRole>();
        }
        public async Task<IEnumerable<ApplicationUserRole>> GetByUserId(int pUserId)
        {
            return await DbSet.Where(c => c.UserId == pUserId).ToListAsync();
        }

        public virtual async Task<ApplicationUserRole?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.FindAsync(id, cancellationToken);
        }

        public virtual async Task<PagedList<ApplicationUserRole>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }

        public virtual async Task AddAsync(ApplicationUserRole entity, CancellationToken cancellationToken = default)
        {
            entity.Id = default;
            await DbSet.AddAsync(entity, cancellationToken);
        }

        public virtual async Task AddRangeAsync(IEnumerable<ApplicationUserRole> entities, CancellationToken cancellationToken = default)
        {
            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
        }

        public virtual void Update(ApplicationUserRole entity)
        {
            DbSet.Update(entity);
        }

        public virtual void UpdateRange(IEnumerable<ApplicationUserRole> entities)
        {
            DbSet.UpdateRange(entities);
        }

        public virtual void Remove(ApplicationUserRole entity)
        {
            DbSet.Remove(entity);
        }

        public virtual async Task RemoveByIdAsync(int id, bool isSoft = true, CancellationToken cancellationToken = default)
        {
            if (isSoft)
            {
                var entitiesToUpdate = await DbSet.Where(e => e.Id.Equals(id)).ToListAsync();

                foreach (var entity in entitiesToUpdate)
                {
                    entity.IsDeleted = true;
                    entity.ModifiedAt = DateTime.Now;
                }

                await DatabaseContext.SaveChangesAsync();
            }
            else
            {
                var entitiesToDelete = await DbSet.Where(e => e.Id.Equals(id)).ToListAsync();
                DbSet.RemoveRange(entitiesToDelete);

                await DatabaseContext.SaveChangesAsync();
            }

        }

    }
}
