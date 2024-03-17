using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class EmployeesRepository : BaseRepository<Employee, int, EmployeeSearchObject>, IEmployeesRepository
    {
        public EmployeesRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Employee>> GetPagedAsync(EmployeeSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(x => x.IsDeleted == false &&
           (searchObject.SearchFilter != null &&
           (x.Person.FirstName.ToLower().Contains(searchObject.SearchFilter.ToLower()) ||
            x.Person.LastName.ToLower().Contains(searchObject.SearchFilter.ToLower())) ||
            searchObject.SearchFilter == null || searchObject.SearchFilter == string.Empty) &&
            (searchObject.CompanyId != null && x.CompanyId == searchObject.CompanyId || searchObject.CompanyId == null) &&
            (searchObject.Position != null && x.Position == searchObject.Position || searchObject.Position == null))
        .Select(x => new Employee
        {
            Id = x.Id,
            Person = x.Person,
            DateOfEmployment = x.DateOfEmployment,
            CreatedAt = x.CreatedAt,
            Biography = x.Biography,
            DrivingLicence = x.DrivingLicence,
            MarriageStatus = x.MarriageStatus,
            Pay = x.Pay,
            ModifiedAt = x.ModifiedAt,
            Position = x.Position,
            Qualifications = x.Qualifications,
            WorkExperience = x.WorkExperience,
            Reviews = x.Reviews
        })
        .ToPagedListAsync(searchObject, cancellationToken);
        }

        public override async Task<Employee> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.Select(x => new Employee
            {
                Id = x.Id,
                Person = new Person
                {
                    Id = x.Person.Id,
                    FirstName = x.Person.FirstName,
                    LastName = x.Person.LastName,
                    Address = x.Person.Address,
                    CreatedAt = x.Person.CreatedAt,
                    ModifiedAt = x.Person.ModifiedAt,
                    BirthDate = x.Person.BirthDate,
                    BirthPlaceId = x.Person.BirthPlaceId,
                    Citizenship = x.Person.Citizenship,
                    Gender = x.Person.Gender,
                    JMBG = x.Person.JMBG,
                    Nationality = x.Person.Nationality,
                    PlaceOfResidenceId = x.Person.PlaceOfResidenceId,
                    PostCode = x.Person.PostCode,
                    ProfilePhoto = x.Person.ProfilePhoto,
                    ProfilePhotoThumbnail = x.Person.ProfilePhotoThumbnail,
                    ApplicationUser = new ApplicationUser
                    {
                        UserName = x.Person.ApplicationUser.UserName,
                        Email = x.Person.ApplicationUser.Email,
                        PhoneNumber = x.Person.ApplicationUser.PhoneNumber
                    }
                },
                DateOfEmployment = x.DateOfEmployment,
                Qualifications = x.Qualifications,
                CreatedAt = x.CreatedAt,
                ModifiedAt = x.ModifiedAt,
                Biography = x.Biography,
                Position = x.Position,
                DrivingLicence = x.DrivingLicence,
                MarriageStatus = x.MarriageStatus,
                Pay = x.Pay,
                WorkExperience = x.WorkExperience,
                CompanyId = x.CompanyId,
                Reviews = x.Reviews
            }).FirstOrDefaultAsync<Employee>(x => x.Id == id);
            return obj;

        }

        public async Task<List<EntityItemModel>> GetEntityItemModelsByCompanyId(int companyId, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.Where(x => x.CompanyId == companyId && x.Position == Core.Enumerations.Position.Odgajatelj).Select(x => new EntityItemModel
            {
                Id = x.Id,
                Label = x.Person.FirstName + " " + x.Person.LastName,
            }).ToListAsync(cancellationToken);
            return obj;
        }
    }
}
