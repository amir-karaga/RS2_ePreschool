using ePreschool.Core.Enumerations;
using Microsoft.AspNetCore.Http;

namespace ePreschool.Core.Models
{
    public class EmployeeUpsertModel : PersonBaseModel
    {
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public IFormFile? File { get; set; }
        public bool WorkExperience { get; set; }
        public DateTime? DateOfEmployment { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
        public Position Position { get; set; }
        public DrivingLicence DrivingLicence { get; set; }
        public Qualification Qualifications { get; set; }
        public int CompanyId { get; set; }
        public string? Biography { get; set; }
        public float? Pay { get; set; }
    }
}
