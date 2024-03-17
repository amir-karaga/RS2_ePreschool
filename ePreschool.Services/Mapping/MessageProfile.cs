using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class MessageProfile : BaseProfile
    {
        public MessageProfile()
        {
            CreateMap<Message, MessageModel>();
            CreateMap<MessageUpsertModel, Message>();
        }
    }
}
