using ePreschool.Core.Entities.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ePreschool.Infrastructure.Configurations
{
    internal class ApplicationUserRoleEntityTypeConfiguration
    {
        public void Configure(EntityTypeBuilder<ApplicationUserRole> builder)
        {

            builder.HasKey(ur => ur.Id);

            builder.HasOne(ur => ur.User)
                .WithMany(us => us.Roles)
                .HasForeignKey(ur => ur.UserId);

            builder.HasOne(ur => ur.Role)
                .WithMany(us => us.Roles)
                .HasForeignKey(ur => ur.RoleId);
        }
    }
}
