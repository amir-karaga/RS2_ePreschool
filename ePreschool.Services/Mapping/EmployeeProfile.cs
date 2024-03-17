using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class EmployeeProfile : BaseProfile
    {
        public EmployeeProfile()
        {
            CreateMap<Employee, EmployeeModel>()
            .ForMember(dest => dest.AverageReviewsRating,
               opt => opt.MapFrom(src => src.Reviews != null && src.Reviews.Any()
                                            ? src.Reviews.Average(r => r.ReviewRating)
                                            : 0)).ReverseMap();

            CreateMap<EmployeeUpsertModel, PersonInsertModel>().
            ForPath(x => x.Employee.MarriageStatus, opt => opt.MapFrom(x => x.MarriageStatus)).
            ForPath(x => x.Employee.Biography, opt => opt.MapFrom(x => x.Biography)).
            ForPath(x => x.Employee.DateOfEmployment, opt => opt.MapFrom(x => x.DateOfEmployment)).
            ForPath(x => x.Employee.DrivingLicence, opt => opt.MapFrom(x => x.DrivingLicence)).
            ForPath(x => x.Employee.Pay, opt => opt.MapFrom(x => x.Pay)).
            ForPath(x => x.Employee.Position, opt => opt.MapFrom(x => x.Position)).
            ForPath(x => x.Employee.Qualifications, opt => opt.MapFrom(x => x.Qualifications)).
            ForPath(x => x.Employee.WorkExperience, opt => opt.MapFrom(x => x.WorkExperience)).
            ForPath(x => x.Employee.CompanyId, opt => opt.MapFrom(x => x.CompanyId)).
            ForPath(x => x.ApplicationUser.UserName, opt => opt.MapFrom(x => x.UserName)).
            ForPath(x => x.ApplicationUser.Email, opt => opt.MapFrom(x => x.Email)).
            ForPath(x => x.ApplicationUser.PhoneNumber, opt => opt.MapFrom(x => x.PhoneNumber)).
            ForPath(x => x.ApplicationUser.NormalizedUserName, opt => opt.MapFrom(x => x.UserName.ToUpper())).
            ForPath(x => x.ApplicationUser.NormalizedEmail, opt => opt.MapFrom(x => x.Email.ToUpper())).
            ForMember(x => x.Parent, opt => opt.Ignore()).
            ForMember(x => x.Child, opt => opt.Ignore());
        }
    }
}
