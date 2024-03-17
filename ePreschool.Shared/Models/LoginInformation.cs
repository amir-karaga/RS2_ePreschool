using ePreschool.Core.Models.ApplicationUser;

namespace ePreschool.Shared.Models
{
    public class LoginInformation
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string ProfilePhoto { get; set; }
        public string ProfilePhotoThumbnail { get; set; }
        public int? CurrentCompanyId { get; set; }
        public bool IsAdministrator { get; set; }
        public bool IsPreschoolOwner { get; set; }
        public bool IsEmployee { get; set; }
        public bool IsParent { get; set; }
        public string Token { get; set; }
    }
}
