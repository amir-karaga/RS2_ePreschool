using ePreschool.Core.Entities.Base;
using ePreschool.Core.Enumerations;
namespace ePreschool.Core.Entities
{
    public class Employee : BaseEntity
    {
        public Qualification? Qualifications { get; set; }
        public bool WorkExperience { get; set; }
        public Position? Position { get; set; }
        public DrivingLicence? DrivingLicence { get; set; }
        public DateTime? DateOfEmployment { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
        public string? Biography { get; set; }
        public float? Pay { get; set; }
        public Person Person { get; set; }
        public Company Company { get; set; }
        public int CompanyId { get; set; }
        public ICollection<EmployeeReviews> Reviews { get; set; } = null!;
    }
}
