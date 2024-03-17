namespace ePreschool.Core.Models
{
    public class MessageUpsertModel : BaseUpsertModel
    {
        public string Text { get; set; } = default!;
        public int FromUserId { get; set; }
        public int ToUserId { get; set; }
    }
}
