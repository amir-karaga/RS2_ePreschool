using ePreschool.Core.Entities;

namespace ePreschool.Core.Models
{
    public class ChildModel:BaseModel
    {
        public int ParentId { get; set; }
        public ParentBaseModel Parent { get; set; }
        public PersonModel Person { get; set; }
        public EmployeeModel Educator { get; set; }
        public int EducatorId { get; set; }
        public CompanyModel Kindergarten { get; set; }
        public int KindergartenId { get; set; }
        public DateTime DateOfEnrollment { get; set; }
        public string EmergencyContact { get; set; }
        public string SpecialNeeds { get; set; }
        public string Note { get; set; }
    }
}
