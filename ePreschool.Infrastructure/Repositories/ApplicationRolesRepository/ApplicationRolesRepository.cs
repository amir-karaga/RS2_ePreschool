using AutoMapper;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class ApplicationRolesRepository : IApplicationRolesRepository
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<ApplicationRole> DbSet;
        public ApplicationRolesRepository(IMapper mapper, DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<ApplicationRole>();
        }
        public async Task<ApplicationRole> GetByRoleLevelOrName(int roleLevelId, string roleName)
        {
            return DatabaseContext.Roles.FirstOrDefault(c => (int)c.RoleLevel == roleLevelId || c.Name==roleName);
        }

        public virtual async Task<ApplicationRole?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.FindAsync(id, cancellationToken);
        }

        public virtual async Task<PagedList<ApplicationRole>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }

        public virtual async Task AddAsync(ApplicationRole entity, CancellationToken cancellationToken = default)
        {
            entity.Id = default;
            await DbSet.AddAsync(entity, cancellationToken);
        }

        public virtual async Task AddRangeAsync(IEnumerable<ApplicationRole> entities, CancellationToken cancellationToken = default)
        {
            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
        }

        public virtual void Update(ApplicationRole entity)
        {
            DbSet.Update(entity);
        }

        public virtual void UpdateRange(IEnumerable<ApplicationRole> entities)
        {
            DbSet.UpdateRange(entities);
        }

        public virtual void Remove(ApplicationRole entity)
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
