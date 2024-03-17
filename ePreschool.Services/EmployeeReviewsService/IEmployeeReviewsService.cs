using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IEmployeeReviewsService : IBaseService<int, EmployeeReviewsModel, EmployeeReviewsUpsertModel, BaseSearchObject>
    {
    }
}
