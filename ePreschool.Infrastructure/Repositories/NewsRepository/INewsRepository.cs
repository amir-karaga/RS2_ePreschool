using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface INewsRepository : IBaseRepository<New, int, NewsSearchObject>
    {
    }
}
