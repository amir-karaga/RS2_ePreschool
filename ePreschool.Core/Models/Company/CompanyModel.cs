namespace ePreschool.Core.Models
{
    public class CompanyModel : BaseModel
    {
        public bool IsActive { get; set; }
        public string Name { get; set; } = default!;
        public string IdentificationNumber { get; set; } = default!;
        public string Address { get; set; } = default!;
        public CityModel Location { get; set; } = default!;
        public int LocationId { get; set; }
        public string PhoneNumber { get; set; } = default!;
        public string Email { get; set; } = default!;
        public decimal? Rating { get; set; }
    }
}
