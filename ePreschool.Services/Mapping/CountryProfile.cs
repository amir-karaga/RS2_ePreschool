using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class CountryProfile : BaseProfile
    {
        public CountryProfile()
        {
            //CreateMap<CountryModel, Country>().ReverseMap();
            CreateMap<Country, CountryModel>();
            //CreateMap<CountryModel, CountryInsertModel>().ReverseMap();
            //CreateMap<CountryModel, CountryUpdateModel>().ReverseMap();
            //CreateMap<CountryModel, CountryUpsertModel>().ReverseMap();
            CreateMap<CountryUpsertModel, Country>().ReverseMap();
            CreateMap<CountryModel, EntityItemModel>().
                    ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
                    ForMember(x => x.Label, opt => opt.MapFrom(x => x.Name));
        }
    }
}
