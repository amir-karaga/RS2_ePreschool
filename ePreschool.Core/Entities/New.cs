using ePreschool.Core.Entities.Base;
using ePreschool.Core.Entities.Identity;

namespace ePreschool.Core.Entities
{
    public class New:BaseEntity
    {
        public string Name { get; set; }
        public int UserId { get; set; }
        public ApplicationUser User { get; set; }
        public string? Image { get; set; }
        public string Text { get; set; }
        public bool Public { get; set; }
    }
}
