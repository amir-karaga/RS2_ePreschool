using ePreschool.Shared.Models;
using System.Security.Claims;

namespace ePreschool.Shared.LoggedUserData
{
    public interface ILoggedUserData
    {
        UserDataModel GetUserData(ClaimsPrincipal claimsPrincipal);
    }
}
