using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Models
{
    public class PersonModel : BaseModel
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
        public Gender? Gender { get; set; }
        public string? ProfilePhoto { get; set; }
        public string? ProfilePhotoThumbnail { get; set; }
        public int? BirthPlaceId { get; set; }
        public CityModel? BirthPlace { get; set; }
        public string? JMBG { get; set; }
        public int? PlaceOfResidenceId { get; set; }
        public CityModel? PlaceOfResidence { get; set; }
        public string? Nationality { get; set; }
        public string? Citizenship { get; set; }
        public string Address { get; set; }
        public string PostCode { get; set; }
        public ApplicationUserModel ApplicationUser { get; set; }
        public override string ToString()
        {
            return $"{FirstName} {LastName}";
        }
    }
}
