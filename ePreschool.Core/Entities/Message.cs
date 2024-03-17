using ePreschool.Core.Entities.Base;

namespace ePreschool.Core.Entities
{
    public class Message : BaseEntity
    {
        public string? Text { get; set; } = default!;
        public int FromUserId { get; set; }
        public Person FromUser { get; set; } = default!;
        public int ToUserId { get; set; }
        public Person ToUser { get; set; } = default!;
    }
}
