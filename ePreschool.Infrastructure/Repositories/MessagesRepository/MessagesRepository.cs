using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class MessagesRepository : BaseRepository<Message, int, MessagesSearchObject>, IMessagesRepository
    {
        public MessagesRepository(DatabaseContext databaseContext) : base(databaseContext)
        { }

        public virtual async Task<PagedList<Message>> GetPagedAsync(MessagesSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(x => (searchObject.FromUserId == null || x.FromUserId == searchObject.FromUserId)
                && (searchObject.ToUserId == null || x.ToUserId == searchObject.ToUserId)).Select(x =>
                new Message
                {
                    Id = x.Id,
                    CreatedAt = x.CreatedAt,
                    Text = x.Text,
                    FromUserId = x.FromUserId,
                    FromUser = x.FromUser,
                    ToUserId = x.ToUserId,
                    ToUser = x.ToUser
                })
                .ToPagedListAsync(searchObject);
        }
    }
}
