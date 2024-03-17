namespace ePreschool.Core.Models
{
    public class MessageModel : BaseModel
    {
        public string Text { get; set; } = default!;
        public int FromUserId { get; set; }
        public PersonModel FromUser { get; set; } = default!;
        public int ToUserId { get; set; }
        public PersonModel ToUser { get; set; } = default!;
    }
}
