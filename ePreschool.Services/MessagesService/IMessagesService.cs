using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface IMessagesService : IBaseService<int, MessageModel, MessageUpsertModel, MessagesSearchObject>
    {

    }
}
