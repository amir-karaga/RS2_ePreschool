using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class MonthlyPaymentProfile : BaseProfile
    {
        public MonthlyPaymentProfile()
        {
            CreateMap<MonthlyPayment, MonthlyPaymentModel>().ReverseMap();
            CreateMap<MonthlyPayment, MonthlyPaymentUpsertModel>().ReverseMap();
        }
    }
}
