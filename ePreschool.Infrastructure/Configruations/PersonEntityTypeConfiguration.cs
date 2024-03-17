using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace ePreschool.Infrastructure.Configurations
{
    internal class PersonEntityTypeConfiguration : BaseEntityTypeConfiguration<Person>
    {
        public override void Configure(EntityTypeBuilder<Person> builder)
        {

            builder
               .HasOne(p => p.Parent)
               .WithOne(p => p.Person)
               .HasForeignKey<Parent>(p => p.Id);

            builder
                .HasOne(p => p.Employee)
                .WithOne(e => e.Person)
                .HasForeignKey<Employee>(e => e.Id);

            builder
               .HasOne(p => p.Child)
               .WithOne(e => e.Person)
               .HasForeignKey<Child>(e => e.Id);

            builder
                .HasOne(p => p.ApplicationUser)
                .WithOne(au => au.Person)
                .HasForeignKey<ApplicationUser>(au => au.Id);
        }
    }
}
