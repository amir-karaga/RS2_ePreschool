using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class AppConfigProfile : BaseProfile
    {
        public AppConfigProfile()
        {
            CreateMap<AppConfig, AppConfigModel>().ReverseMap();
            CreateMap<AppConfig, AppConfigUpsertModel>().ReverseMap();
        }
    }
}
