using ePreschool.Core.Entities.Base;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ePreschool.Infrastructure.Configurations
{
    public class BaseIdentityEntityTypeConfiguration<TEntity> : IEntityTypeConfiguration<TEntity> where TEntity : class, IBaseEntity
    {
        public virtual void Configure(EntityTypeBuilder<TEntity> builder)
        {
            builder
                .HasKey(entity => entity.Id);

            builder
                .Property(entity => entity.CreatedAt)
                .IsRequired();

            builder
                .Property(entity => entity.ModifiedAt)
                .IsRequired(false);

            builder
                .Property(entity => entity.IsDeleted)
                .IsRequired()
                .HasDefaultValue(false);

            builder.HasQueryFilter(x => !x.IsDeleted);
        }
    }
}
