using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class ChildValidator : AbstractValidator<ChildUpsertModel>
    {
        public ChildValidator()
        {
        }
    }
}
