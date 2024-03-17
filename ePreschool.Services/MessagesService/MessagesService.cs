using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.UnitOfWork;
using FluentValidation;

namespace ePreschool.Services
{
    public class MessagesService : BaseService<Message, MessageModel, MessageUpsertModel, MessagesSearchObject, IMessagesRepository>, IMessagesService
    {
        public MessagesService(IMapper mapper, IUnitOfWork unitOfWork, IValidator<MessageUpsertModel> validator) : base(mapper, unitOfWork, validator)
        {

        }
    }
}
