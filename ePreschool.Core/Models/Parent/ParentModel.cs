using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Models
{
    public class ParentModel:BaseModel
    {
        public string JobDescription { get; set; }
        public bool IsEmployed { get; set; }
        public string EmployerName { get; set; }
        public string EmployerAddress { get; set; }
        public string EmployerPhoneNumber { get; set; }
        public Qualification Qualification { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
        public CompanyModel Kindergarten { get; set; }
        public int KindergartenId { get; set; }
        public PersonModel Person { get; set; }
    }
}
