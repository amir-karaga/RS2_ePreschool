namespace ePreschool.Core.Models
{
    public class CountryUpsertModel : BaseUpsertModel
    {
        public string Name { get; set; }
        public string Abrv { get; set; }
        public bool IsActive { get; set; }
    }
}
