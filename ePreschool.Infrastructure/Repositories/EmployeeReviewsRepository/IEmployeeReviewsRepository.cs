using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IEmployeesReviewsRepository:IBaseRepository<EmployeeReviews, int, BaseSearchObject>
    {
        List<EmployeeReviews> GetByPrechoolId(int prechoolId);
    }
}
