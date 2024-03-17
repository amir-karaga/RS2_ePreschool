using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure
{
    public partial class DatabaseContext : IdentityDbContext<ApplicationUser, ApplicationRole, int, ApplicationUserClaim, ApplicationUserRole, ApplicationUserLogin, ApplicationRoleClaim, ApplicationUserToken>
    {
        public DbSet<Country> Countries { get; set; }
        public DbSet<City> Cities { get; set; }
        public DbSet<ActivityLog> Logs { get; set; }
        public DbSet<Person> Persons { get; set; }
        public DbSet<Employee> Employees { get; set; }
        public DbSet<Parent> Parents { get; set; }
        public DbSet<Child> Children { get; set; }
        public DbSet<New> News { get; set; }
        public DbSet<Company> Companies { get; set; }
        public DbSet<MonthlyPayment> MonthlyPayments { get; set; }
        public DbSet<EmployeeReviews> EmployeeReviews { get; set; }
        public DbSet<AppConfig> AppConfigs { get; set; }
        public DbSet<Message> Messages { get; set; }

        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {

        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
            SeedData(modelBuilder);
            ApplyConfigurations(modelBuilder);

            modelBuilder.Entity<ApplicationUserRole>()
                .HasKey(ur => ur.Id);

            modelBuilder.Entity<ApplicationUserRole>()
                .HasOne(ur => ur.User)
                .WithMany(u => u.Roles)
                .HasForeignKey(ur => ur.UserId);

            modelBuilder.Entity<ApplicationUserRole>()
                .HasOne(ur => ur.Role)
                .WithMany(r => r.Roles)
                .HasForeignKey(ur => ur.RoleId);
        }
    }
}
