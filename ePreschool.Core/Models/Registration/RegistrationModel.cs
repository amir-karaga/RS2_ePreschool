using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;

namespace ePreschool.Core
{
    public class RegistrationModel : BaseModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public string PhoneNumber { get; set; }
        public Gender Gender { get; set; }
        public DateTime BirthDate { get; set; }
        public int KindergartenId { get; set; }
        public string Address { get; set; }
        public string PostCode { get; set; }
        public Qualification Qualification { get; set; }
        public bool IsEmployed { get; set; }
        public string? EmployerName { get; set; }
        public string? EmployerAddress { get; set; }
        public string? EmployerPhoneNumber { get; set; }
    }
}
