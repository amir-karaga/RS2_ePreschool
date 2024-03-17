using ePreschool.Core.Entities.Base;
using ePreschool.Core.Entities.Identity;
using ePreschool.Infrastructure.Configurations;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ePreschool.Infrastructure.Configurations
{

    internal class ApplicationRoleEntityTypeConfiguration : BaseIdentityEntityTypeConfiguration<ApplicationRole>
    {
        public void Configure(EntityTypeBuilder<ApplicationRole> builder)
        {
            builder
                 .Property(ar => ar.Id)
                 .ValueGeneratedNever();
        }
    }
}
