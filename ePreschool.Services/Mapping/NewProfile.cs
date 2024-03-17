using ePreschool.Core.Entities;
using ePreschool.Core.Models.New;

namespace ePreschool.Services
{
    public class NewProfile : BaseProfile
    {
        public NewProfile()
        {
            CreateMap<New, NewModel>().ReverseMap();
            CreateMap<NewModel, NewUpsertModel>().ReverseMap();
            CreateMap<New, NewUpsertModel>().ReverseMap();
        }
    }
}
