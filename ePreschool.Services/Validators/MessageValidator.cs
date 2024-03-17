using ePreschool.Core.Models;
using FluentValidation;

namespace ePreschool.Services
{
    public class MessageValidator : AbstractValidator<MessageUpsertModel>
    {
        public MessageValidator()
        {
            RuleFor(c => c.FromUserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.ToUserId).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Text).NotNull().WithErrorCode(ErrorCodes.NotNull).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
