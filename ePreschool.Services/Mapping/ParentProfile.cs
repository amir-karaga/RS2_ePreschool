using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class ParentProfile : BaseProfile
    {
        public ParentProfile()
        {
            CreateMap<ParentModel, Parent>().ReverseMap();

            CreateMap<ParentUpsertModel, PersonInsertModel>().
            ForPath(x => x.Parent.MarriageStatus, opt => opt.MapFrom(x => x.MarriageStatus)).
            ForPath(x => x.Parent.KindergartenId, opt => opt.MapFrom(x => x.KindergartenId)).
            ForPath(x => x.Parent.Qualification, opt => opt.MapFrom(x => x.Qualification)).
            ForPath(x => x.Parent.EmployerPhoneNumber, opt => opt.MapFrom(x => x.EmployerPhoneNumber)).
            ForPath(x => x.Parent.EmployerAddress, opt => opt.MapFrom(x => x.EmployerAddress)).
            ForPath(x => x.Parent.EmployerName, opt => opt.MapFrom(x => x.EmployerName)).
            ForPath(x => x.Parent.EmployerPhoneNumber, opt => opt.MapFrom(x => x.EmployerPhoneNumber)).
            ForPath(x => x.Parent.IsEmployed, opt => opt.MapFrom(x => x.IsEmployed)).
            ForPath(x => x.Parent.JobDescription, opt => opt.MapFrom(x => x.JobDescription)).
            ForPath(x => x.ApplicationUser.UserName, opt => opt.MapFrom(x => x.UserName)).
            ForPath(x => x.ApplicationUser.Email, opt => opt.MapFrom(x => x.Email)).
            ForPath(x => x.ApplicationUser.PhoneNumber, opt => opt.MapFrom(x => x.PhoneNumber)).
            ForPath(x => x.ApplicationUser.NormalizedUserName, opt => opt.MapFrom(x => x.UserName.ToUpper())).
            ForPath(x => x.ApplicationUser.NormalizedEmail, opt => opt.MapFrom(x => x.Email.ToUpper())).
            ForMember(x => x.Employee, opt => opt.Ignore()).
            ForMember(x => x.Child, opt => opt.Ignore());
        }
    }
}
