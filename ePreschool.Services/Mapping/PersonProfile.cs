using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class PersonProfile : BaseProfile
    {
        public PersonProfile()
        {
            CreateMap<Person, EntityItemModel>().
            ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
            ForMember(x => x.Label, opt => opt.MapFrom(x => $"{x.FirstName} {x.LastName}"));

            CreateMap<PersonModel, Person>().ReverseMap();
            CreateMap<Person, PersonInsertModel>().ReverseMap();
        }
    }
}
