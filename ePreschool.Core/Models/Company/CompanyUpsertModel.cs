
namespace ePreschool.Core.Models
{
    public class CompanyUpsertModel:BaseUpsertModel
    {
        public bool IsActive { get; set; }
        public string Name { get; set; }
        public string IdentificationNumber { get; set; }
        public string Address { get; set; }
        public int LocationId { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
    }
}
