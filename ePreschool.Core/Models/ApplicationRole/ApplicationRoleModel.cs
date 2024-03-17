using ePreschool.Core.Entities.Base;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Core.Models
{
    public class ApplicationRoleModel : IdentityRole<int>, IBaseEntity
    {
        public int? RoleLevel { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime? ModifiedAt { get; set; }
        public bool IsDeleted { get; set; }
        public ICollection<ApplicationUserRoleModel> UserRoles { get; set; }

    }
}
