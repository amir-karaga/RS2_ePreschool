using ePreschool.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore.Storage;

namespace ePreschool.Infrastructure.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly DatabaseContext _databaseContext;

        public readonly IActivityLogsRepository ActivityLogsRepository;
        public readonly IApplicationUsersRepository ApplicationUsersRepository;
        public readonly IApplicationRolesRepository ApplicationRolesRepository;
        public readonly IApplicationUserRolesRepository ApplicationUserRolesRepository;
        public readonly IPersonsRepository PersonsRepository;
        public readonly ICountriesRepository CountriesRepository;
        public readonly ICitiesRepository CitiesRepository;
        public readonly INewsRepository NewsRepository;
        public readonly IEmployeesRepository EmployeesRepository;
        public readonly IParentsRepository ParentsRepository;
        public readonly IChildrenRepository ChildrenRepository;
        public readonly ICompaniesRepository CompaniesRepository;
        public readonly IMonthlyPaymentsRepostitory MonthlyPaymentsRepository;
        public readonly IEmployeesReviewsRepository EmployeeReviewsRepository;
        public readonly IAppConfigsRepository AppConfigsRepository;
        public readonly IMessagesRepository MessagesRepository;
        public readonly ILogsRepository LogsRepository;
        public UnitOfWork(
            DatabaseContext databaseContext,
            IApplicationUserRolesRepository applicationUserRolesRepository,
            IApplicationRolesRepository applicationRolesRepository,
            IApplicationUsersRepository applicationUsersRepository,
            IActivityLogsRepository activityLogsRepository,
            ICountriesRepository countriesRepository,
            ICitiesRepository citiesRepository,
            INewsRepository newsRepository,
            IEmployeesRepository employeesRepository,
            IParentsRepository parentsRepository,
            IChildrenRepository childrenRepository,
            ILogsRepository logsRepository,
            IPersonsRepository personsRepository,
            ICompaniesRepository companiesRepository,
            IMonthlyPaymentsRepostitory monthlyPaymentsRepostitory,
            IAppConfigsRepository appConfigsRepository,
            IMessagesRepository messagesRepository,
            IEmployeesReviewsRepository employeesReviewsRepository)
        {
            _databaseContext = databaseContext;
            ActivityLogsRepository = activityLogsRepository;
            ApplicationUserRolesRepository = applicationUserRolesRepository;
            ApplicationRolesRepository = applicationRolesRepository;
            ApplicationUsersRepository = applicationUsersRepository;
            CountriesRepository = countriesRepository;
            CitiesRepository = citiesRepository;
            NewsRepository = newsRepository;
            EmployeesRepository = employeesRepository;
            ParentsRepository = parentsRepository;
            ChildrenRepository = childrenRepository;
            PersonsRepository = personsRepository;
            CompaniesRepository = companiesRepository;
            MonthlyPaymentsRepository = monthlyPaymentsRepostitory;
            EmployeeReviewsRepository = employeesReviewsRepository;
            AppConfigsRepository = appConfigsRepository;
            MessagesRepository = messagesRepository;
            LogsRepository = logsRepository;
        }
        public async Task<IDbContextTransaction> BeginTransactionAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.Database.BeginTransactionAsync(cancellationToken);
        }

        public async Task CommitTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.CommitTransactionAsync(cancellationToken);
        }

        public async Task RollbackTransactionAsync(CancellationToken cancellationToken = default)
        {
            await _databaseContext.Database.RollbackTransactionAsync(cancellationToken);
        }

        public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return await _databaseContext.SaveChangesAsync(cancellationToken);
        }
    }
}
