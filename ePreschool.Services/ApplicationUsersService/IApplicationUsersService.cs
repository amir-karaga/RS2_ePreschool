using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IApplicationUsersService
    {
        Task<ApplicationUserModel> FindByUserNameOrEmailAsync(string pUserName, CancellationToken cancellationToken = default);
        Task<ApplicationUserModel?> GetByIdAsync(int id, CancellationToken cancellationToken = default);

    }
}
