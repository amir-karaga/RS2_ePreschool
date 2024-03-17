using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public interface IApplicationUserRolesService
    {
        Task<IEnumerable<ApplicationUserRoleModel>> GetByUserId(int pUserId);
    }
}
