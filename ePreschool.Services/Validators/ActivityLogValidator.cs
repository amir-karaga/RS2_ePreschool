using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services.Validators
{
    public class ActivityLogValidator : AbstractValidator<ActivityLogUpsertModel>
    {
        public ActivityLogValidator()
        {
        }
    }
}
