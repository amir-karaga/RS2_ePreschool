using ePreschool.Core.Entities.Base;

namespace ePreschool.Core.Entities
{
    public class Child : BaseEntity
    {
        public int ParentId { get; set; }
        public Parent Parent { get; set; }
        public Person Person { get; set; }
        public Employee Educator { get; set; }
        public int EducatorId { get; set; }
        public Company Kindergarten { get; set; }
        public int KindergartenId { get; set; }
        public DateTime? DateOfEnrollment { get; set; }
        public string? EmergencyContact { get; set; }
        public string? SpecialNeeds { get; set; }
        public string? Note { get; set; }

    }
}
