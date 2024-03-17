using ePreschool.Core.Entities.Base;
using ePreschool.Core.Entities.Identity;
using ePreschool.Infrastructure.Configurations;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace ePreschool.Infrastructure
{
    public partial class DatabaseContext: IdentityDbContext<ApplicationUser, ApplicationRole, int, ApplicationUserClaim, ApplicationUserRole, ApplicationUserLogin, ApplicationRoleClaim, ApplicationUserToken>
    {

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.LogTo(Console.WriteLine);
            base.OnConfiguring(optionsBuilder);
        }
        private void ConfigureModel(ModelBuilder modelBuilder)
        {
            foreach (var entityType in modelBuilder.Model.GetEntityTypes())
            {
                var isDeletedProperty = entityType.FindProperty(nameof(BaseEntity.IsDeleted));
                if (isDeletedProperty == null)
                    continue;

                var parameter = Expression.Parameter(entityType.ClrType, "p");

                entityType.SetQueryFilter(Expression.Lambda(
                    Expression.Equal(
                        Expression.Property(parameter, isDeletedProperty.PropertyInfo),
                        Expression.Constant(false, typeof(bool))
                    ),
                    parameter
                ));
            }
        }
        public override int SaveChanges()
        {
            ModifyTimestamps();

            return base.SaveChanges();
        }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            ModifyTimestamps();

            return base.SaveChangesAsync(cancellationToken);
        }

        private void ModifyTimestamps()
        {
            foreach (var entry in ChangeTracker.Entries())
            {
                dynamic entity;
                if (entry.Entity is IBaseEntity)
                {
                    entity = (IBaseEntity)entry.Entity;
                }
                else
                {
                    entity = (BaseEntity)entry.Entity;
                }

                if (entry.State == EntityState.Modified) entity.ModifiedAt = DateTime.Now;
                else if (entry.State == EntityState.Added) entity.CreatedAt = DateTime.Now;
            }
        }

        private void ApplyConfigurations(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(BaseEntityTypeConfiguration<>).Assembly);
            modelBuilder.ApplyConfigurationsFromAssembly(typeof(BaseIdentityEntityTypeConfiguration<>).Assembly);
        }
    }
}
