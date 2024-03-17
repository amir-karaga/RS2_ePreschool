using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class CompanyValidator : AbstractValidator<CompanyUpsertModel>
    {
        public CompanyValidator()
        {
        }
    }
}
