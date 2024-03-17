using AutoMapper;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class ApplicationUsersRepository : IApplicationUsersRepository
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<ApplicationUser> DbSet;
        public ApplicationUsersRepository(IMapper mapper, DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<ApplicationUser>();
        }

        public virtual async Task<ApplicationUser?> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            return await DbSet.FirstOrDefaultAsync(x => x.Id == id, cancellationToken);
        }

        public virtual async Task<PagedList<ApplicationUser>> GetPagedAsync(BaseSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject, cancellationToken);
        }

        public virtual async Task AddAsync(ApplicationUser entity, CancellationToken cancellationToken = default)
        {
            entity.Id = default;
            await DbSet.AddAsync(entity, cancellationToken);
        }

        public virtual async Task AddRangeAsync(IEnumerable<ApplicationUser> entities, CancellationToken cancellationToken = default)
        {
            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
        }

        public virtual void Update(ApplicationUser entity)
        {
            DbSet.Update(entity);
        }

        public virtual void UpdateRange(IEnumerable<ApplicationUser> entities)
        {
            DbSet.UpdateRange(entities);
        }

        public virtual void Remove(ApplicationUser entity)
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
        public async Task<ApplicationUser> FindByUserNameOrEmailAsync(string UserName, CancellationToken cancellationToken = default)
        {
            return await DbSet.Include(x => x.Person).FirstOrDefaultAsync(c => (c.UserName == UserName || c.Email == UserName) && c.Active == true);
        }

    }
}
