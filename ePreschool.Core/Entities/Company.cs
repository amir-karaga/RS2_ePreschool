using ePreschool.Core.Entities.Base;

namespace ePreschool.Core.Entities
{
    public class Company : BaseEntity
    {
        public bool IsActive { get; set; }
        public string Name { get; set; }
        public string? IdentificationNumber { get; set; }
        public string? Address { get; set; }
        public City Location { get; set; }
        public int LocationId { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
    }
}
