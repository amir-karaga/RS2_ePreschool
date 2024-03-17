using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public interface IApplicationRolesService
    {
        Task<ApplicationRoleModel> GetByRoleLevelIdOrName(int roleLeveleId, string roleName);
    }
}
