using ePreschool.Core.Models.New;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class NewValidator : AbstractValidator<NewUpsertModel>
    {
        public NewValidator()
        {
        }
    }
}
