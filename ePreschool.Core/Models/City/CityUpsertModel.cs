namespace ePreschool.Core.Models
{
    public class CityUpsertModel : BaseUpsertModel
    {
        public string Name { get; set; }
        public string Abrv { get; set; }
        public int CountryId { get; set; }
        public bool IsActive { get; set; }
    }
}
