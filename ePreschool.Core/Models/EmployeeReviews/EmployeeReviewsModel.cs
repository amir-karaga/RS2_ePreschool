namespace ePreschool.Core.Models
{
    public class EmployeeReviewsModel:BaseModel
    {
        public int ReviewRating { get; set; }
        public string ReviewComment { get; set; }
        public int ParentReviewerId { get; set; }
        public ParentModel ParentReviewer { get; set; }
        public int EmployeeId { get; set; }
        public EmployeeModel Employee { get; set; }
    }
}
