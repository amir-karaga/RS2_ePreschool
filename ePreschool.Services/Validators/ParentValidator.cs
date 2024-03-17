using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class ParentValidator : AbstractValidator<ParentUpsertModel>
    {
        public ParentValidator()
        {
        }
    }
}
