using ePreschool.Core;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class RegistrationProfile : BaseProfile
    {
        public RegistrationProfile()
        {
            CreateMap<RegistrationModel, ParentUpsertModel>().ReverseMap();
        }
    }
}
