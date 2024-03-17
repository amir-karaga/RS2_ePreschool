using ePreschool.Core.Enumerations;
using Microsoft.AspNetCore.Http;

namespace ePreschool.Core.Models
{
    public class ParentUpsertModel : PersonBaseModel
    {
        public string Email { get; set; }
        public string UserName { get; set; }
        public string PhoneNumber { get; set; }
        public string JobDescription { get; set; }
        public bool IsEmployed { get; set; }
        public string EmployerName { get; set; }
        public string EmployerAddress { get; set; }
        public string EmployerPhoneNumber { get; set; }
        public int KindergartenId { get; set; }
        public IFormFile? File { get; set; }
        public Qualification Qualification { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
    }
}
