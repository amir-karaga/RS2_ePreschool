using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.Models.EmployeeReviews;
using ePreschool.Core.SearchObjects;
namespace ePreschool.Infrastructure.Repositories
{
    public class EmployeeReviewsRepository : BaseRepository<EmployeeReviews, int, BaseSearchObject>, IEmployeesReviewsRepository
    {
        public EmployeeReviewsRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {

        }

        public List<EmployeeReviews> GetByPrechoolId(int prechoolId)
        {
            return DbSet
                .Where(x => x.Employee.CompanyId == prechoolId)
                .ToList();
        }
    }
}
