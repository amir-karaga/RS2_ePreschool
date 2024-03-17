using ePreschool.Core.Entities;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Infrastructure.Repositories
{
    public class MonthlyPaymentsRepository : BaseRepository<MonthlyPayment, int, MonthlyPaymentSearchObject>, IMonthlyPaymentsRepostitory
    {
        public MonthlyPaymentsRepository(DatabaseContext databaseContext) : base(databaseContext)
        {
        }

        public async Task<List<MonthlyPayment>> GetMonthlyPaymentsByChildren(int childId)
        {
            return DbSet.
                   Where(x => x.ChildId == childId).OrderByDescending(x => x.Year).OrderByDescending(x => x.Month)
                   .ToList();
        }

        public override async Task<PagedList<MonthlyPayment>> GetPagedAsync(MonthlyPaymentSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return await DbSet.Where(x =>
           ((searchObject.CompanyId == null || searchObject.CompanyId == x.Child.KindergartenId)
           && (searchObject.IsPaid == null || searchObject.IsPaid.Value == x.IsPaid)))
        .Select(x => new MonthlyPayment
        {
            Id = x.Id,
            Price = x.Price,
            Year = x.Year,
            Month = x.Month,
            ChildId = x.ChildId,
            Child = new Child
            {
                Person = new Person
                {
                    FirstName = x.Child.Person.FirstName,
                    LastName = x.Child.Person.LastName,
                }
            },
            Discount = x.Discount,
            IsPaid = x.IsPaid,
            Note = x.Note,
            CreatedAt = x.CreatedAt,
            ParentId = x.ParentId,
            Parent = new Parent
            {
                Person = new Person
                {
                    FirstName = x.Child.Person.FirstName,
                    LastName = x.Child.Person.LastName,
                }
            },
            Status = x.Status,
        })
        .ToPagedListAsync(searchObject, cancellationToken);
        }

    }
}
