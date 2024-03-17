using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IParentsRepository : IBaseRepository<Parent, int, ParentsSearchObject>
    {
        Task<List<Parent>> GetByCompanyId(int companyId, CancellationToken cancellationToken = default);
    }
}
