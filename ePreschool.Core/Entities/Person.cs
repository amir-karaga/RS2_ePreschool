using ePreschool.Core.Entities.Base;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Entities
{
    public class Person : BaseEntity
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public DateTime BirthDate { get; set; }
        public Gender? Gender { get; set; }
        public string? ProfilePhoto { get; set; }
        public string? ProfilePhotoThumbnail { get; set; }
        public int? BirthPlaceId { get; set; }
        public City? BirthPlace { get; set; }
        public string? JMBG { get; set; }
        public int? PlaceOfResidenceId { get; set; }
        public City? PlaceOfResidence { get; set; }
        public string? Nationality { get; set; }
        public string? Citizenship { get; set; }
        public string? Address { get; set; }
        public string? PostCode { get; set; }
        public ApplicationUser ApplicationUser { get; set; }
        public Employee Employee { get; set; }
        public Parent Parent { get; set; }
        public Child Child { get; set; }

    }
}
