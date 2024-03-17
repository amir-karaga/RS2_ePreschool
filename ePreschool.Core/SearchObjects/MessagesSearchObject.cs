namespace ePreschool.Core.SearchObjects
{
    public class MessagesSearchObject : BaseSearchObject
    {
        public int? FromUserId { get; set; }
        public int? ToUserId { get; set; }
        public bool IsSender { get; set; }
    }
}
