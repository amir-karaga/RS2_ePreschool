using ePreschool.Core.Entities.Base;
using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Entities
{
    public class Parent : BaseEntity
    {
        public string? JobDescription { get; set; }
        public bool IsEmployed { get; set; }
        public string? EmployerName { get; set; }
        public string? EmployerAddress { get; set; }
        public string? EmployerPhoneNumber { get; set; }
        public Qualification? Qualification { get; set; }
        public MarriageStatus? MarriageStatus { get; set; }
        public Company Kindergarten { get; set; } = default!;
        public int KindergartenId { get; set; }
        public Person Person { get; set; } = default!;

    }
}
