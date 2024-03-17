using ePreschool.Core.Entities.Base;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Core.Entities.Identity
{
    public class ApplicationUserRole : IdentityUserRole<int>, IBaseEntity
    {
        public int Id { get; set; }
        public ApplicationUser User { get; set; }
        public ApplicationRole Role { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? ModifiedAt { get; set; }
        public bool IsDeleted { get; set; }
    }
}
