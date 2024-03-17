using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class MonthlyPaymentValidator : AbstractValidator<MonthlyPaymentUpsertModel>
    {
        public MonthlyPaymentValidator()
        {
        }
    }
}
