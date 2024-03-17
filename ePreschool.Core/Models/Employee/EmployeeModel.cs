using ePreschool.Core.Entities;
using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Models
{
    public class EmployeeModel:BaseModel
    {
        public Qualification Qualifications { get; set; }
        public bool WorkExperience { get; set; }
        public Position? Position { get; set; }
        public DrivingLicence? DrivingLicence { get; set; }
        public DateTime? DateOfEmployment { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
        public CompanyModel Company { get; set; }
        public int CompanyId { get; set; }
        public string? Biography { get; set; }
        public float? Pay { get; set; }
        public PersonModel Person { get; set; }
        public float AverageReviewsRating { get; set; }
        public ICollection<EmployeeReviewsModel> Reviews { get; set; } = null!;
    }
}
