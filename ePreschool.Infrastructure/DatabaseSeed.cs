using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Enumerations;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure
{
    public partial class DatabaseContext
    {
        public void Initialize()
        {
            if (Database.GetAppliedMigrations()?.Count() == 0)
                Database.Migrate();
        }

        private readonly DateTime _dateTime = new(2023, 2, 1, 0, 0, 0, 0, DateTimeKind.Local);
        private void SeedData(ModelBuilder modelBuilder)
        {
            SeedCountries(modelBuilder);
            SeedCities(modelBuilder);
            SeedCompanies(modelBuilder);
            SeedUsers(modelBuilder);
            SeedRoles(modelBuilder);
            SeedUserRoles(modelBuilder);
            SeedAppConfig(modelBuilder);
        }

        private void SeedCountries(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Country>().HasData(
                 new Country
                 {
                     Id = 1,
                     Abrv = "BiH",
                     CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                     IsActive = true,
                     IsDeleted = false,
                     Name = "Bosna i Hercegovina"
                 },
                  new Country
                  {
                      Id = 2,
                      Abrv = "HR",
                      CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                      IsActive = true,
                      IsDeleted = false,
                      Name = "Hrvatska"
                  },
                  new Country
                  {
                      Id = 3,
                      Abrv = "SRB",
                      CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                      IsActive = true,
                      IsDeleted = false,
                      Name = "Srbija"
                  },
                  new Country
                  {
                      Id = 4,
                      Abrv = "CG",
                      CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                      IsActive = true,
                      IsDeleted = false,
                      Name = "Crna Gora"
                  },
                new Country
                {
                    Id = 5,
                    Abrv = "MKD",
                    CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                    IsActive = true,
                    IsDeleted = false,
                    Name = "Makedonija"
                });

        }

        private void SeedCities(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<City>().HasData(
                new()
                {
                    Id = 1,
                    Name = "Mostar",
                    Abrv = "MO",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 2,
                    Name = "Sarajevo",
                    Abrv = "SA",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 3,
                    Name = "Jajce",
                    Abrv = "JC",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 4,
                    Name = "Tuzla",
                    Abrv = "TZ",
                    CountryId = 1,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new()
                {
                    Id = 5,
                    Name = "Zagreb",
                    Abrv = "ZG",
                    CountryId = 2,
                    IsActive = true,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                });
        }

        private void SeedUsers(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Person>().HasData(
                new Person
                {
                    Id = 1,
                    FirstName = "Site",
                    LastName = "Admin",
                    BirthDate = _dateTime,
                    BirthPlaceId = 1,
                    JMBG = "123456789",
                    Nationality = "",
                    Citizenship = "",
                    Address = "Mostar",
                    PostCode = "123",
                    Gender = Gender.Muški,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new Person
                {
                    Id = 2,
                    FirstName = "Preschool",
                    LastName = "Owner",
                    BirthDate = _dateTime,
                    BirthPlaceId = 1,
                    JMBG = "123456789",
                    Nationality = "",
                    Citizenship = "",
                    Address = "Mostar",
                    PostCode = "123",
                    Gender = Gender.Muški,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                new Person
                {
                    Id = 3,
                    FirstName = "Preschool",
                    LastName = "Employee",
                    BirthDate = _dateTime,
                    BirthPlaceId = 1,
                    JMBG = "123456789",
                    Nationality = "",
                    Citizenship = "",
                    Address = "Mostar",
                    PostCode = "123",
                    Gender = Gender.Muški,
                    CreatedAt = _dateTime,
                    ModifiedAt = null
                },
                 new Person
                 {
                     Id = 4,
                     FirstName = "Preschool",
                     LastName = "Parent",
                     BirthDate = _dateTime,
                     BirthPlaceId = 1,
                     JMBG = "123456789",
                     Nationality = "",
                     Citizenship = "",
                     Address = "Mostar",
                     PostCode = "123",
                     Gender = Gender.Muški,
                     CreatedAt = _dateTime,
                     ModifiedAt = null
                 }
                );
            modelBuilder.Entity<ApplicationUser>().HasData(
            new ApplicationUser
            {
                Id = 1,
                Active = true,
                Email = "site.admin@epreschool.com",
                NormalizedEmail = "SITE.ADMIN@EPRESCHOOL.COM",
                UserName = "site.admin",
                NormalizedUserName = "SITE.ADMIN",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                IsAdministrator = true,
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = _dateTime
            },
            new ApplicationUser
            {
                Id = 2,
                Active = true,
                Email = "preschool.owner@mail.com",
                NormalizedEmail = "PRESCHOOL.OWNER@MAIL.COM",
                UserName = "preschool.owner",
                NormalizedUserName = "PRESCHOOL.OWNER",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                IsPreschoolOwner = true,
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = _dateTime
            },
            new ApplicationUser
            {
                Id = 3,
                Active = true,
                Email = "employee@mail.com",
                NormalizedEmail = "EMPLOYEE@MAIL.COM",
                UserName = "employee",
                NormalizedUserName = "EMPLOYEE",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                IsEmployee = true,
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = _dateTime
            },
            new ApplicationUser
            {
                Id = 4,
                Active = true,
                Email = "parent@mail.com",
                NormalizedEmail = "PARENT@MAIL.COM",
                UserName = "parent",
                NormalizedUserName = "PARENT",
                PasswordHash = "AQAAAAEAACcQAAAAEAGwZeqqUuR5X1kcmNbxwyTWxg2VDSnKdFTIFBQrQe5J/UTwcPlFFe6VkMa+yAmKgQ==", //Test1234
                PhoneNumber = "38762123456",
                IsParent = true,
                ConcurrencyStamp = Guid.NewGuid().ToString(),
                EmailConfirmed = true,
                CreatedAt = _dateTime
            }
            );
            modelBuilder.Entity<Employee>().HasData(
            new Employee
            {
                Id = 2,
                Qualifications = Qualification.VŠS,
                Biography = "",
                DateOfEmployment = _dateTime,
                DrivingLicence = DrivingLicence.B,
                MarriageStatus = MarriageStatus.Oženjen,
                Pay = 2000,
                Position = Position.Direktor,
                WorkExperience = true,
                CreatedAt = _dateTime,
                CompanyId = 1
            },
            new Employee
            {
                Id = 3,
                Qualifications = Qualification.SSS,
                Biography = "",
                DateOfEmployment = _dateTime,
                DrivingLicence = DrivingLicence.B,
                MarriageStatus = MarriageStatus.Oženjen,
                Pay = 2000,
                Position = Position.Odgajatelj,
                WorkExperience = true,
                CreatedAt = _dateTime,
                CompanyId = 1
            }
            );
            modelBuilder.Entity<Parent>().HasData(
            new Parent
            {
                Id = 4,
                EmployerAddress = "Mostar",
                EmployerName = "Bingo Mostar",
                EmployerPhoneNumber = "38763222333",
                IsEmployed = true,
                JobDescription = "",
                MarriageStatus = MarriageStatus.Oženjen,
                Qualification = Qualification.VŠS,
                CreatedAt = _dateTime,
                KindergartenId = 1,
            }
            );
        }
        private void SeedRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ApplicationRole>().HasData(
                new ApplicationRole
                {
                    Id = 1,
                    RoleLevel = Role.Administrator,
                    CreatedAt = _dateTime,
                    Name = "Administrator",
                    NormalizedName = "ADMINISTRATOR",
                    ConcurrencyStamp = Guid.NewGuid().ToString()
                },
                 new ApplicationRole
                 {
                     Id = 2,
                     RoleLevel = Role.PreschoolOwner,
                     CreatedAt = _dateTime,
                     Name = "PreschoolOwner",
                     NormalizedName = "PRESCHOOLOWNER",
                     ConcurrencyStamp = Guid.NewGuid().ToString()
                 },
                  new ApplicationRole
                  {
                      Id = 3,
                      RoleLevel = Role.Employee,
                      CreatedAt = _dateTime,
                      Name = "Employee",
                      NormalizedName = "EMPLOYEE",
                      ConcurrencyStamp = Guid.NewGuid().ToString()
                  },
                   new ApplicationRole
                   {
                       Id = 4,
                       RoleLevel = Role.Parent,
                       CreatedAt = _dateTime,
                       Name = "Parent",
                       NormalizedName = "PARENT",
                       ConcurrencyStamp = Guid.NewGuid().ToString()
                   }
                );
        }
        private void SeedUserRoles(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<ApplicationUserRole>().HasData(
                new ApplicationUserRole
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    UserId = 1,
                    RoleId = 1
                },
                 new ApplicationUserRole
                 {
                     Id = 2,
                     CreatedAt = _dateTime,
                     UserId = 2,
                     RoleId = 2
                 },
                  new ApplicationUserRole
                  {
                      Id = 3,
                      CreatedAt = _dateTime,
                      UserId = 3,
                      RoleId = 3
                  },
                  new ApplicationUserRole
                  {
                      Id = 4,
                      CreatedAt = _dateTime,
                      UserId = 4,
                      RoleId = 4
                  }
                );
        }
        private void SeedCompanies(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Company>().HasData(
                new Company
                {
                    Id = 1,
                    CreatedAt = _dateTime,
                    Address = "Mostar b.b",
                    IsActive = true,
                    Email = "preschool1@gmail.com",
                    IdentificationNumber = "445877566221546464",
                    LocationId = 2,
                    Name = "Preschool1",
                    PhoneNumber = "38762111222"
                });
        }

        private void SeedAppConfig(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<AppConfig>().HasData(
                 new AppConfig
                 {
                     Id = 1,
                     MonthlyFee = 300,
                     CreatedAt = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                     IsDeleted = false,
                 });
        }

    }
}
