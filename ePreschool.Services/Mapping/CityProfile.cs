using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class CityProfile : BaseProfile
    {
        public CityProfile()
        {
            CreateMap<City, CityModel>().ReverseMap();
            CreateMap<City, CityUpsertModel>().ReverseMap();
            CreateMap<CityModel, EntityItemModel>().
                    ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
                    ForMember(x => x.Label, opt => opt.MapFrom(x => x.Name));
        }
    }
}
