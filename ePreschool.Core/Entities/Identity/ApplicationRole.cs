using ePreschool.Core.Entities.Base;
using ePreschool.Core.Enumerations;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Core.Entities.Identity
{
    public class ApplicationRole: IdentityRole<int>, IBaseEntity
    {
        public Role RoleLevel { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.Now;
        public DateTime? ModifiedAt { get; set; }
        public bool IsDeleted { get; set; }
        public ICollection<ApplicationUserRole> Roles { get; set; }

    }
}
