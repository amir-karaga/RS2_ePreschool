
namespace ePreschool.Core.Models
{
    public class ApplicationUserRoleModel : BaseModel
    {
        public ApplicationUserModel User { get; set; }
        public ApplicationRoleModel Role { get; set; }
        public int UserId { get; set; }
        public int RoleId { get; set; }
    }
}
