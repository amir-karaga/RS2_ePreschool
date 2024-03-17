using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class ChildProfile : BaseProfile
    {
        public ChildProfile()
        {
            CreateMap<ChildModel, Child>().ReverseMap();

            CreateMap<ChildUpsertModel, PersonInsertModel>().
            ForPath(x => x.Child.ParentId, opt => opt.MapFrom(x => x.ParentId)).
            ForPath(x => x.Child.EmergencyContact, opt => opt.MapFrom(x => x.EmergencyContact)).
            ForPath(x => x.Child.DateOfEnrollment, opt => opt.MapFrom(x => x.DateOfEnrollment)).
            ForPath(x => x.Child.SpecialNeeds, opt => opt.MapFrom(x => x.SpecialNeeds)).
            ForPath(x => x.Child.Note, opt => opt.MapFrom(x => x.Note)).
            ForPath(x => x.Child.EducatorId, opt => opt.MapFrom(x => x.EducatorId)).
            ForPath(x => x.Child.KindergartenId, opt => opt.MapFrom(x => x.KindergartenId)).
            ForPath(x => x.Child.Educator, opt => opt.Ignore()).
            ForMember(x => x.Employee, opt => opt.Ignore()).
            ForMember(x => x.ApplicationUser, opt => opt.Ignore()).
            ForMember(x => x.Parent, opt => opt.Ignore());
        }
    }
}
