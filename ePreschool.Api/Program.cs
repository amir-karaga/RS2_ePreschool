using ePreschool.Api;
using ePreschool.Api.Services;
using ePreschool.Api.Services.AccessManager;
using ePreschool.Api.Services.ActivityLogger;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Entities.Identity;
using ePreschool.Infrastructure;
using ePreschool.Infrastructure.Repositories;
using ePreschool.Infrastructure.Repositories.ApplicationUserRolesRepository;
using ePreschool.Infrastructure.UnitOfWork;
using ePreschool.Services;
using ePreschool.Shared.Constants;
using ePreschool.Shared.LoggedUserData;
using ePreschool.Shared.Models;
using ePreschool.Shared.Services.Crypto;
using ePreschool.Shared.Services.Email;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.Filters;
using System.Globalization;
using System.Text;

var builder = WebApplication.CreateBuilder(args);
CultureInfo.DefaultThreadCurrentCulture = new CultureInfo("bs-BA");
CultureInfo.DefaultThreadCurrentUICulture = new CultureInfo("bs-BA");
#region DBContext

var connectionString = builder.Configuration.GetConnectionString(ConfigurationValues.ConnectionString);
builder.Services.AddDbContext<DatabaseContext>(options => options.UseNpgsql(connectionString));
AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);


#endregion

#region MappingAndValidation

builder.Services.AddScoped<ILoggedUserData, LoggedUserData>();

builder.Services.AddMapper();

#endregion

#region Api

// Add services to the container.
builder.Services.AddSession();
builder.Services.AddHttpContextAccessor();
builder.Services.AddControllers();
builder.Services.AddSignalR();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.Configure<FormOptions>(o =>
{
    o.ValueLengthLimit = int.MaxValue;
    o.MultipartBodyLengthLimit = int.MaxValue;
    o.MemoryBufferThreshold = int.MaxValue;
});

#endregion

#region CustomServices

builder.Services.AddScoped<IAccessManager, AccessManager>();
builder.Services.AddScoped<IActivityLogger, ActivityLogger>();
builder.Services.AddSingleton<ICrypto, Crypto>();
builder.Services.AddSingleton<IEmail, Email>();
builder.Services.AddScoped<IFileManager, FileManager>();
builder.Services.AddScoped<IEnumManager, EnumManager>();
builder.Services.AddScoped<IRabbitMQProducer, RabbitMQProducer>();

#endregion

#region Repositories

builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IActivityLogsRepository, ActivityLogsRepository>();
builder.Services.AddScoped<IApplicationUsersRepository, ApplicationUsersRepository>();
builder.Services.AddScoped<IApplicationRolesRepository, ApplicationRolesRepository>();
builder.Services.AddScoped<IApplicationUserRolesRepository, ApplicationUserRolesRepository>();
builder.Services.AddScoped<ICountriesRepository, CountriesRepository>();
builder.Services.AddScoped<ICitiesRepository, CitiesRepository>();
builder.Services.AddScoped<INewsRepository, NewsRepository>();
builder.Services.AddScoped<IPersonsRepository, PersonsRepository>();
builder.Services.AddScoped<IEmployeesRepository, EmployeesRepository>();
builder.Services.AddScoped<IParentsRepository, ParentsRepository>();
builder.Services.AddScoped<IChildrenRepository, ChildrenRepository>();
builder.Services.AddScoped<ICompaniesRepository, CompaniesRepository>();
builder.Services.AddScoped<IMonthlyPaymentsRepostitory, MonthlyPaymentsRepository>();
builder.Services.AddScoped<IEmployeesReviewsRepository, EmployeeReviewsRepository>();
builder.Services.AddScoped<IAppConfigsRepository, AppConfigsRepository>();
builder.Services.AddScoped<IMessagesRepository, MessagesRepository>();
builder.Services.AddScoped<ILogsRepository, LogsRepository>();

#endregion

#region Services

builder.Services.AddValidators();
builder.Services.AddServices();

#endregion

#region AspNetCoreIdentity

builder.Services.Configure<JWTConfig>(builder.Configuration.GetSection("JWTConfig"));
builder.Services.Configure<CookiePolicyOptions>(options =>
{
    options.CheckConsentNeeded = _ => false;
    options.Secure = CookieSecurePolicy.SameAsRequest;
    options.HttpOnly = Microsoft.AspNetCore.CookiePolicy.HttpOnlyPolicy.Always;
});
builder.Services.AddDistributedMemoryCache();

builder.Services.AddIdentity<ApplicationUser, ApplicationRole>(options =>
{
    options.SignIn.RequireConfirmedAccount = false;
    options.Password = new PasswordOptions
    {
        RequireDigit = true,
        RequiredLength = 6,
        RequireLowercase = true,
        RequireUppercase = true,
        RequireNonAlphanumeric = false,
        RequiredUniqueChars = 0
    };
})
.AddEntityFrameworkStores<DatabaseContext>()
.AddDefaultTokenProviders();


builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("oauth2", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey
    });
    options.OperationFilter<SecurityRequirementsOperationFilter>();

});

builder.Services.AddAuthentication(x =>
{
    x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(
              options =>
              {
                  options.TokenValidationParameters = new TokenValidationParameters()
                  {
                      ValidateIssuerSigningKey = true,
                      IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(builder.Configuration.GetSection(ConfigurationValues.TokenKey).Value)),
                      ValidateIssuer = false,
                      ValidateAudience = false,
                      ValidateLifetime = true
                  };
              });

builder.Services.AddCors(options =>
{
    options.AddPolicy("MyCorsPolicy", builder =>
    {
        builder.AllowAnyOrigin()
               .AllowAnyMethod()
               .AllowAnyHeader();
    });
});

#endregion

#region App

var app = builder.Build();

// Configure the HTTP request pipeline.
//if (app.Environment.IsDevelopment())
//{
app.UseCors("MyCorsPolicy");
app.UseSwagger();
app.UseSwaggerUI(c =>
{
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "My API V1");
});
app.UseDeveloperExceptionPage();
//}

app.UseHttpsRedirection();
app.UseSession();
app.UseAuthentication();
app.UseStaticFiles();

// global cors policy
app.UseCors(x => x
    .AllowAnyMethod()
    .AllowAnyHeader()
    .SetIsOriginAllowed(origin => true) // allow any origin
                                        //.WithOrigins("https://localhost:44351")); // Allow only this origin can also have multiple origins separated with comma
    .AllowCredentials()); // allow credentials
app.UseAuthorization();

app.MapControllers();

using var scope = app.Services.CreateScope();

var ctx = scope.ServiceProvider.GetRequiredService<DatabaseContext>();
ctx.Initialize();

await app.RunAsync();
#endregion
