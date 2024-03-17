using ePreschool.Core.Models.New;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface INewsService : IBaseService<int, NewModel, NewUpsertModel, NewsSearchObject>
    {
    }
}
