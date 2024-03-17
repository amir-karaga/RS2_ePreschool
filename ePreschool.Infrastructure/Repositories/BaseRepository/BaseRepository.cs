using ePreschool.Core.Entities.Base;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public abstract class BaseRepository<TEntity, TPrimaryKey, TSearchObject> : IBaseRepository<TEntity, TPrimaryKey, TSearchObject>
        where TEntity : BaseEntity
        where TSearchObject : BaseSearchObject
    {
        protected readonly DatabaseContext DatabaseContext;
        protected readonly DbSet<TEntity> DbSet;

        protected BaseRepository(DatabaseContext databaseContext)
        {
            DatabaseContext = databaseContext;
            DbSet = DatabaseContext.Set<TEntity>();
        }

        public virtual async Task<TEntity?> GetByIdAsync(TPrimaryKey id, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.FindAsync(id);
            return obj;
        }

        public virtual async Task<PagedList<TEntity>> GetPagedAsync(TSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.ToPagedListAsync(searchObject);
        }

        public virtual async Task AddAsync(TEntity entity, CancellationToken cancellationToken = default)
        {
            entity.Id = default;
            await DbSet.AddAsync(entity, cancellationToken);
        }

        public virtual async Task AddRangeAsync(IEnumerable<TEntity> entities, CancellationToken cancellationToken = default)
        {
            foreach (var entity in entities) entity.Id = default;
            await DbSet.AddRangeAsync(entities, cancellationToken);
        }

        public virtual void Update(TEntity entity)
        {
            DbSet.Update(entity);
        }

        public virtual void UpdateRange(IEnumerable<TEntity> entities)
        {
            DbSet.UpdateRange(entities);
        }

        public virtual void Remove(TEntity entity)
        {
            DbSet.Remove(entity);
        }

        public virtual async Task RemoveByIdAsync(TPrimaryKey id, bool isSoft = true, CancellationToken cancellationToken = default)
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
