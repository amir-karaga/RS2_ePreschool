using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services
{
    public class AppConfigValidator : AbstractValidator<AppConfigUpsertModel>
    {
        public AppConfigValidator()
        {
            RuleFor(c => c.MonthlyFee).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
