using ePreschool.Services;

namespace ePreschool.Api
{
    public static class Registry
    {
        public static void AddMapper(this IServiceCollection services)
        {
            services.AddAutoMapper(typeof(Program), typeof(BaseProfile));
        }
    }
}
