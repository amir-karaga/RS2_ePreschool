
namespace ePreschool.Core.Models
{
    public class CityModel : BaseModel
    {
        public string Name { get; set; }
        public string Abrv { get; set; }
        public CountryModel Country { get; set; }
        public int CountryId { get; set; }
        public bool IsActive { get; set; }
    }
}
