using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IChildrenService : IBaseService<int, ChildModel, ChildUpsertModel, ChildrenSearchObject>
    {
        Task<PagedList<MonthlyPaymentModel>> GetMonthlyPayments(MonthlyPaymentSearchObject searchObject);
    }
}
