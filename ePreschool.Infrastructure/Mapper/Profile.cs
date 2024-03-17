using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.Models.ApplicationUser;
using ePreschool.Core.Models.New;

namespace ePreschool.Infrastructure.Mapper
{
    public class Profiles : Profile
    {

        public Profiles()
        {
            #region User

            CreateMap<ApplicationUserRole, ApplicationUserRoleModel>()
                .ForMember(x => x.User, opt => opt.Ignore())
                .ReverseMap();
            CreateMap<ApplicationRole, ApplicationRoleModel>()
                .ReverseMap();

            CreateMap<ApplicationUserModel, ApplicationUser>()
                    .ForMember(au => au.Roles, auDto => auDto.MapFrom(x => x.UserRoles))
                    .ReverseMap();

            CreateMap<ApplicationUserModel, ApplicationUserLoginData>().
            ForPath(x => x.FirstName, opt => opt.MapFrom(x => x.Person.FirstName)).
            ForPath(x => x.LastName, opt => opt.MapFrom(x => x.Person.LastName)).
            ForPath(x => x.ProfilePhoto, opt => opt.MapFrom(x => x.Person.ProfilePhoto)).
            ForPath(x => x.ProfilePhotoThumbnail, opt => opt.MapFrom(x => x.Person.ProfilePhotoThumbnail));

            #endregion

            #region Country

            CreateMap<Country, CountryModel>().ReverseMap();
            CreateMap<CountryModel, Country>().ReverseMap();
            CreateMap<CountryModel, CountryUpsertModel>().ReverseMap();
            CreateMap<Country, CountryUpsertModel>().ReverseMap();
            CreateMap<CountryModel, EntityItemModel>().
                    ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
                    ForMember(x => x.Label, opt => opt.MapFrom(x => x.Name));

            #endregion

            #region City

            CreateMap<City, CityModel>().ReverseMap();
            CreateMap<CityModel, CityUpsertModel>().ReverseMap();
            CreateMap<CityModel, EntityItemModel>().
                    ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
                    ForMember(x => x.Label, opt => opt.MapFrom(x => x.Name));

            #endregion

            #region Person

            CreateMap<Person, EntityItemModel>().
            ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
            ForMember(x => x.Label, opt => opt.MapFrom(x => $"{x.FirstName} {x.LastName}"));

            CreateMap<PersonModel, Person>().ReverseMap();
            CreateMap<Person, PersonInsertModel>().ReverseMap();

            #endregion

            #region New

            CreateMap<New, NewModel>().ReverseMap();
            CreateMap<NewModel, NewUpsertModel>().ReverseMap();

            #endregion


            #region AppConfig

            CreateMap<AppConfig, AppConfigModel>().ReverseMap();
            CreateMap<AppConfigModel, AppConfigUpsertModel>().ReverseMap();

            #endregion

            #region Employee

            CreateMap<EmployeeModel, Employee>().ReverseMap();

            CreateMap<EmployeeUpsertModel, PersonInsertModel>().
            ForPath(x => x.Employee.MarriageStatus, opt => opt.MapFrom(x => x.MarriageStatus)).
            ForPath(x => x.Employee.Biography, opt => opt.MapFrom(x => x.Biography)).
            ForPath(x => x.Employee.DateOfEmployment, opt => opt.MapFrom(x => x.DateOfEmployment)).
            ForPath(x => x.Employee.DrivingLicence, opt => opt.MapFrom(x => x.DrivingLicence)).
            ForPath(x => x.Employee.Pay, opt => opt.MapFrom(x => x.Pay)).
            ForPath(x => x.Employee.Position, opt => opt.MapFrom(x => x.Position)).
            ForPath(x => x.Employee.Qualifications, opt => opt.MapFrom(x => x.Qualifications)).
            ForPath(x => x.Employee.WorkExperience, opt => opt.MapFrom(x => x.WorkExperience)).
            ForPath(x => x.ApplicationUser.UserName, opt => opt.MapFrom(x => x.UserName)).
            ForPath(x => x.ApplicationUser.Email, opt => opt.MapFrom(x => x.Email)).
            ForPath(x => x.ApplicationUser.PhoneNumber, opt => opt.MapFrom(x => x.PhoneNumber)).
            ForPath(x => x.ApplicationUser.NormalizedUserName, opt => opt.MapFrom(x => x.UserName.ToUpper())).
            ForPath(x => x.ApplicationUser.NormalizedEmail, opt => opt.MapFrom(x => x.Email.ToUpper())).
            ForMember(x => x.Parent, opt => opt.Ignore()).
            ForMember(x => x.Child, opt => opt.Ignore());
            #endregion

            #region Parent

            CreateMap<ParentModel, Parent>().ReverseMap();
            CreateMap<ParentBaseModel, Parent>().ReverseMap();

            CreateMap<ParentUpsertModel, PersonInsertModel>().
            ForPath(x => x.Parent.MarriageStatus, opt => opt.MapFrom(x => x.MarriageStatus)).
            ForPath(x => x.Parent.Qualification, opt => opt.MapFrom(x => x.Qualification)).
            ForPath(x => x.Parent.EmployerPhoneNumber, opt => opt.MapFrom(x => x.EmployerPhoneNumber)).
            ForPath(x => x.Parent.EmployerName, opt => opt.MapFrom(x => x.EmployerName)).
            ForPath(x => x.Parent.EmployerAddress, opt => opt.MapFrom(x => x.EmployerAddress)).
            ForPath(x => x.Parent.IsEmployed, opt => opt.MapFrom(x => x.IsEmployed)).
            ForPath(x => x.Parent.JobDescription, opt => opt.MapFrom(x => x.JobDescription)).
            ForPath(x => x.ApplicationUser.UserName, opt => opt.MapFrom(x => x.UserName)).
            ForPath(x => x.ApplicationUser.Email, opt => opt.MapFrom(x => x.Email)).
            ForPath(x => x.ApplicationUser.PhoneNumber, opt => opt.MapFrom(x => x.PhoneNumber)).
            ForPath(x => x.ApplicationUser.NormalizedUserName, opt => opt.MapFrom(x => x.UserName.ToUpper())).
            ForPath(x => x.ApplicationUser.NormalizedEmail, opt => opt.MapFrom(x => x.Email.ToUpper())).
            ForMember(x => x.Employee, opt => opt.Ignore()).
            ForMember(x => x.Child, opt => opt.Ignore());
            #endregion

            #region Child

            CreateMap<ChildModel, Child>().ReverseMap();

            CreateMap<ChildUpsertModel, PersonInsertModel>().
            ForPath(x => x.Child.ParentId, opt => opt.MapFrom(x => x.ParentId)).
            ForPath(x => x.Child.EmergencyContact, opt => opt.MapFrom(x => x.EmergencyContact)).
            ForPath(x => x.Child.DateOfEnrollment, opt => opt.MapFrom(x => x.DateOfEnrollment)).
            ForPath(x => x.Child.SpecialNeeds, opt => opt.MapFrom(x => x.SpecialNeeds)).
            ForPath(x => x.Child.Note, opt => opt.MapFrom(x => x.Note)).
            ForMember(x => x.Employee, opt => opt.Ignore()).
            ForMember(x => x.ApplicationUser, opt => opt.Ignore()).
            ForMember(x => x.Parent, opt => opt.Ignore());
            #endregion

        }
    }
}
