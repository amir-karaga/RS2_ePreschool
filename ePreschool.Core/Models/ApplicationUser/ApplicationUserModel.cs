using ePreschool.Core.Entities.Base;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Core.Models
{
    public class ApplicationUserModel : IdentityUser<int>, IBaseEntity
    {
        public DateTime CreatedAt { get; set; }
        public DateTime? ModifiedAt { get; set; }
        public bool IsDeleted { get; set; }
        public bool Active { get; set; }
        public string CompanyName { get; set; }
        public string IdentificationNumberCompany { get; set; }
        public bool IsAdministrator { get; set; }
        public bool IsEmployee { get; set; }
        public bool IsParent { get; set; }
        public bool IsPreschoolOwner { get; set; }
        public PersonModel Person { get; set; }
        public ICollection<ApplicationUserRoleModel> UserRoles { get; set; }
    }
}
