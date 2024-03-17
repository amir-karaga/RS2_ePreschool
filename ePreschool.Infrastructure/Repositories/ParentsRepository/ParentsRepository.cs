using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class ParentsRepository : BaseRepository<Parent, int, ParentsSearchObject>, IParentsRepository
    {
        public ParentsRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<Parent> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.Where(x => x.IsDeleted == false).Select(x => new Parent
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
                EmployerAddress = x.EmployerAddress,
                EmployerName = x.EmployerName,
                CreatedAt = x.CreatedAt,
                ModifiedAt = x.ModifiedAt,
                EmployerPhoneNumber = x.EmployerPhoneNumber,
                Qualification = x.Qualification,
                MarriageStatus = x.MarriageStatus,
                KindergartenId = x.KindergartenId
            }).FirstOrDefaultAsync<Parent>(x => x.Id == id);
            return obj;

        }
        public override async Task<PagedList<Parent>> GetPagedAsync(ParentsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(x =>
           (searchObject.SearchFilter != null &&
           (x.Person.FirstName.ToLower().Contains(searchObject.SearchFilter.ToLower()) ||
            x.Person.LastName.ToLower().Contains(searchObject.SearchFilter.ToLower())) ||
            searchObject.SearchFilter == null || searchObject.SearchFilter == string.Empty) &&
            (searchObject.CompanyId != null && x.KindergartenId == searchObject.CompanyId || searchObject.CompanyId == null))
         .Select(x => new Parent
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
             Kindergarten = x.Kindergarten,
             KindergartenId = x.KindergartenId,
             JobDescription = x.JobDescription,
             CreatedAt = x.CreatedAt,
             EmployerAddress = x.EmployerAddress,
             EmployerName = x.EmployerName,
             EmployerPhoneNumber = x.EmployerPhoneNumber,
             IsEmployed = x.IsEmployed,
             MarriageStatus = x.MarriageStatus,
             Qualification = x.Qualification
         })
         .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async Task<List<Parent>> GetByCompanyId(int companyId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c =>
            c.KindergartenId == companyId).Select(x => new Parent
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
                Kindergarten = x.Kindergarten,
                JobDescription = x.JobDescription,
                CreatedAt = x.CreatedAt,
                EmployerAddress = x.EmployerAddress,
                EmployerName = x.EmployerName,
                EmployerPhoneNumber = x.EmployerPhoneNumber,
                IsEmployed = x.IsEmployed,
                MarriageStatus = x.MarriageStatus,
                Qualification = x.Qualification
            }).ToListAsync(cancellationToken);
        }

    }
}
