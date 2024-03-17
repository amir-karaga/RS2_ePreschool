namespace ePreschool.Core.Models
{
    public class EmployeeReviewsUpsertModel : BaseUpsertModel
    {
        public int ReviewRating { get; set; }
        public string ReviewComment { get; set; }
        public int ParentReviewerId { get; set; }
        public int EmployeeId { get; set; }
    }
}
