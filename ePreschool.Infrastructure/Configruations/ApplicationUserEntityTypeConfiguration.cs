using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ePreschool.Infrastructure.Configurations
{
    internal class ApplicationUserEntityTypeConfiguration
    {
        public void Configure(EntityTypeBuilder<ApplicationUser> builder)
        { 
            builder
                  .Property(au => au.Id);
            //builder
            //    .HasOne(au => au.Person)
            //    .WithOne(p => p.ApplicationUser)
            //    .HasForeignKey<Employee>(x=>x.ApplicationUserId);      
        }
    }
}
