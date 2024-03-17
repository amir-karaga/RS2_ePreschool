using ePreschool.Core.Models;
using ePreschool.Core.Models.New;
using ePreschool.Services.Validators;
using FluentValidation;
using Microsoft.Extensions.DependencyInjection;

namespace ePreschool.Services
{
    public static class Registry
    {
        public static void AddServices(this IServiceCollection services)
        {
            services.AddScoped<ICitiesService, CitiesService>();
            services.AddScoped<ICountriesService, CountriesService>();
            services.AddScoped<IActivityLogsService, ActivityLogsService>();
            services.AddScoped<IApplicationRolesService, ApplicationRolesService>();
            services.AddScoped<IApplicationUsersService, ApplicationUsersService>();
            services.AddScoped<IApplicationUserRolesService, ApplicationUserRolesService>();
            services.AddScoped<IChildrenService, ChildrenService>();
            services.AddScoped<IEmployeesService, EmployeesService>();
            services.AddScoped<INewsService, NewsService>();
            services.AddScoped<IParentsService, ParentsService>();
            services.AddScoped<ICompaniesService, CompaniesService>();
            services.AddScoped<IMonthlyPaymentsService, MonthlyPaymentsService>();
            services.AddScoped<IEmployeeReviewsService, EmployeeReviewsService>();
            services.AddScoped<IAppConfigsService, AppConfigsService>();
            services.AddScoped<IMessagesService, MessagesService>();
            services.AddScoped<IRecommenderSystemsService, RecommenderSystemsService>();
        }

        public static void AddValidators(this IServiceCollection services)
        {
            services.AddScoped<IValidator<CityUpsertModel>, CityValidator>();
            services.AddScoped<IValidator<CountryUpsertModel>, CountryValidator>();
            services.AddScoped<IValidator<ActivityLogUpsertModel>, ActivityLogValidator>();
            services.AddScoped<IValidator<ApplicationUserModel>, ApplicationUserValidator>();
            services.AddScoped<IValidator<ApplicationRoleModel>, ApplicationRoleValidator>();
            services.AddScoped<IValidator<ApplicationUserRoleModel>, ApplicationUserRoleValidator>();
            services.AddScoped<IValidator<ChildUpsertModel>, ChildValidator>();
            services.AddScoped<IValidator<EmployeeUpsertModel>, EmployeeValidator>();
            services.AddScoped<IValidator<NewUpsertModel>, NewValidator>();
            services.AddScoped<IValidator<ParentUpsertModel>, ParentValidator>();
            services.AddScoped<IValidator<CompanyUpsertModel>, CompanyValidator>();
            services.AddScoped<IValidator<MonthlyPaymentUpsertModel>, MonthlyPaymentValidator>();
            services.AddScoped<IValidator<EmployeeReviewsUpsertModel>, EmployeeReviewsValidator>();
            services.AddScoped<IValidator<AppConfigUpsertModel>, AppConfigValidator>();
            services.AddScoped<IValidator<MessageUpsertModel>, MessageValidator>();
        }
    }
}
