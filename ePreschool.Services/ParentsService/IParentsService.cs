using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IParentsService : IBaseService<int, ParentModel, ParentUpsertModel, ParentsSearchObject>
    {
    }
}
