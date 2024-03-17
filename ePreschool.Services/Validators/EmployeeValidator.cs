using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class EmployeeValidator : AbstractValidator<EmployeeUpsertModel>
    {
        public EmployeeValidator()
        {
        }
    }
}
