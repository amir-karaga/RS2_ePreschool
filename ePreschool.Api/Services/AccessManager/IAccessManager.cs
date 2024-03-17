using ePreschool.Shared.Models;
using Microsoft.AspNetCore.Identity;

namespace ePreschool.Api.Services.AccessManager
{
    public interface IAccessManager
    {
        Task<LoginInformation> SignInAsync(string email, string password, bool rememberMe);
        Task<IdentityResult> ChangePassword(string currentPassword, string newPassword);
        Task ResetPassword(string email);
    }
}
