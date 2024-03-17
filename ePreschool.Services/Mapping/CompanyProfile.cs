using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class CompanyProfile : BaseProfile
    {
        public CompanyProfile()
        {
            CreateMap<Company, CompanyModel>().ReverseMap();
            CreateMap<Company, CompanyUpsertModel>().ReverseMap();
            CreateMap<CompanyModel, EntityItemModel>().
                    ForMember(x => x.Id, opt => opt.MapFrom(x => x.Id)).
                    ForMember(x => x.Label, opt => opt.MapFrom(x => x.Name));
        }
    }
}
