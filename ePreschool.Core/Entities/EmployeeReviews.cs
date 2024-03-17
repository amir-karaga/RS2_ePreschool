using ePreschool.Core.Entities.Base;
namespace ePreschool.Core.Entities
{
    public class EmployeeReviews : BaseEntity
    {
        public int ReviewRating { get; set; }
        public string? ReviewComment { get; set; }
        public int ParentReviewerId { get; set; }
        public Parent ParentReviewer { get; set; }
        public int EmployeeId { get; set; }
        public Employee Employee { get; set; }
    }
}
