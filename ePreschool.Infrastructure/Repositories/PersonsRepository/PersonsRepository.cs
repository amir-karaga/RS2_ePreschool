using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class PersonsRepository : BaseRepository<Person, int, BaseSearchObject>, IPersonsRepository
    {
        public PersonsRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {

        }

    }
}
