using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class ApplicationUserValidator : AbstractValidator<ApplicationUserModel>
    {
        public ApplicationUserValidator()
        {
        }
    }
}
