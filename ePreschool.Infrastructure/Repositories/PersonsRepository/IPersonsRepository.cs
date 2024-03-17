using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IPersonsRepository : IBaseRepository<Person, int, BaseSearchObject>
    {

    }
}
