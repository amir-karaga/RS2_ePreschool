using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class EmployeeReviewsValidator : AbstractValidator<EmployeeReviewsUpsertModel>
    {
        public EmployeeReviewsValidator()
        {
        }
    }
}
