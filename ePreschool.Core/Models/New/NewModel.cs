using ePreschool.Core.Models.ApplicationUser;

namespace ePreschool.Core.Models.New
{
    public class NewModel:BaseModel
    {
        public string Name { get; set; }
        public int UserId { get; set; }
        public ApplicationUserModel User { get; set; }
        public string? Image { get; set; }
        public string Text { get; set; }
        public bool Public { get; set; }
    }
}
