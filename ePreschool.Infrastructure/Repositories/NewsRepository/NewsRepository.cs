using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Entities.Identity;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
namespace ePreschool.Infrastructure.Repositories
{
    public class NewsRepository : BaseRepository<New, int, NewsSearchObject>, INewsRepository
    {
        public NewsRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<New>> GetPagedAsync(NewsSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet
                .Where(x => x.IsDeleted == false &&
                (searchObject.SearchFilter == null || searchObject.SearchFilter == string.Empty || x.Name.ToLower().Contains(searchObject.SearchFilter.ToLower())))
                .Where(x => (searchObject.IsPublic == null || searchObject.IsPublic == x.Public))
        .Select(x => new New
        {
            Id = x.Id,
            Image = x.Image,
            Name = x.Name,
            Text = x.Text,
            Public = x.Public,
            CreatedAt = x.CreatedAt,
            User = new ApplicationUser
            {
                Person = x.User.Person
            },
        })
        .ToPagedListAsync(searchObject, cancellationToken);
        }
    }
}
