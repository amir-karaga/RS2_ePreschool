using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public interface IMessagesRepository : IBaseRepository<Message, int, MessagesSearchObject>
    {
    }
}
