using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IMonthlyPaymentsService : IBaseService<int, MonthlyPaymentModel, MonthlyPaymentUpsertModel, MonthlyPaymentSearchObject>
    {
    }
}
