using AutoMapper;
using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using Microsoft.EntityFrameworkCore;

namespace ePreschool.Infrastructure.Repositories
{
    public class ChildrenRepository : BaseRepository<Child, int, ChildrenSearchObject>, IChildrenRepository
    {
        public ChildrenRepository(IMapper mapper, DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public override async Task<PagedList<Child>> GetPagedAsync(ChildrenSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(x => x.IsDeleted == false &&
              (searchObject.SearchFilter != null &&
           (x.Person.FirstName.ToLower().Contains(searchObject.SearchFilter.ToLower()) ||
            x.Person.LastName.ToLower().Contains(searchObject.SearchFilter.ToLower())) ||
            searchObject.SearchFilter == null || searchObject.SearchFilter == string.Empty) &&
            ((searchObject.KindergartenId == x.KindergartenId || searchObject.KindergartenId == null || searchObject.KindergartenId == 0)) &&
            (searchObject.EducatorId == x.EducatorId || searchObject.EducatorId == null || searchObject.EducatorId == 0) &&
            (searchObject.ParentId == x.ParentId || searchObject.ParentId == null || searchObject.ParentId == 0))
        .Select(x => new Child
        {
            Id = x.Id,
            Person = x.Person,
            DateOfEnrollment = x.DateOfEnrollment,
            EmergencyContact = x.EmergencyContact,
            Note = x.Note,
            SpecialNeeds = x.SpecialNeeds,
            ModifiedAt = x.ModifiedAt,
            ParentId = x.ParentId,
            KindergartenId = x.KindergartenId,
            EducatorId = x.EducatorId
        })
        .ToPagedListAsync(searchObject, cancellationToken);
        }

        public async Task<List<Child>> GetByParentIdAsync(int parentId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c =>
            c.ParentId == parentId).Select(x => new Child
            {
                Id = x.Id,
                Person = x.Person,
                DateOfEnrollment = x.DateOfEnrollment,
                EmergencyContact = x.EmergencyContact,
                Note = x.Note,
                SpecialNeeds = x.SpecialNeeds,
                ModifiedAt = x.ModifiedAt,
                ParentId = x.ParentId,
                KindergartenId = x.KindergartenId,
                EducatorId = x.EducatorId
            }).ToListAsync(cancellationToken);
        }

        public async Task<List<Child>> GetByCompanyId(int companyId, CancellationToken cancellationToken = default)
        {
            return await DbSet.AsNoTracking().Where(c =>
            c.KindergartenId == companyId).Select(x => new Child
            {
                Id = x.Id,
                Person = x.Person,
                DateOfEnrollment = x.DateOfEnrollment,
                EmergencyContact = x.EmergencyContact,
                Note = x.Note,
                SpecialNeeds = x.SpecialNeeds,
                ModifiedAt = x.ModifiedAt,
                ParentId = x.ParentId,
                KindergartenId = x.KindergartenId,
                EducatorId = x.EducatorId
            }).ToListAsync(cancellationToken);
        }

        public override async Task<Child> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var obj = await DbSet.Select(x => new Child
            {
                Id = x.Id,
                Person = x.Person,
                DateOfEnrollment = x.DateOfEnrollment,
                EmergencyContact = x.EmergencyContact,
                Note = x.Note,
                SpecialNeeds = x.SpecialNeeds,
                ModifiedAt = x.ModifiedAt,
                ParentId = x.ParentId,
                KindergartenId = x.KindergartenId,
                EducatorId = x.EducatorId
            }).FirstOrDefaultAsync<Child>(x => x.Id == id);
            return obj;

        }
    }
}
