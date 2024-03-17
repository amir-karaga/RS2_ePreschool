using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Shared.Models;

namespace ePreschool.Services
{
    public class ApplicationUserProfile : BaseProfile
    {
        public ApplicationUserProfile()
        {
            CreateMap<ApplicationUserRole, ApplicationUserRoleModel>()
                .ForMember(x => x.User, opt => opt.Ignore())
                .ReverseMap();
            CreateMap<ApplicationRole, ApplicationRoleModel>()
                .ReverseMap();

            CreateMap<ApplicationUserModel, ApplicationUser>()
                    .ForMember(au => au.Roles, auDto => auDto.MapFrom(x => x.UserRoles))
                    .ReverseMap();

            CreateMap<ApplicationUserModel, LoginInformation>().
            ForPath(x => x.UserId, opt => opt.MapFrom(x => x.Id)).
            ForPath(x => x.FirstName, opt => opt.MapFrom(x => x.Person.FirstName)).
            ForPath(x => x.LastName, opt => opt.MapFrom(x => x.Person.LastName)).
            ForPath(x => x.ProfilePhoto, opt => opt.MapFrom(x => x.Person.ProfilePhoto)).
            ForPath(x => x.ProfilePhotoThumbnail, opt => opt.MapFrom(x => x.Person.ProfilePhotoThumbnail));
        }
    }
}
