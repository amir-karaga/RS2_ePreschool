using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IMonthlyPaymentsRepostitory : IBaseRepository<MonthlyPayment, int, MonthlyPaymentSearchObject>
    {
        Task<List<MonthlyPayment>> GetMonthlyPaymentsByChildren(int childId);
    }
}
