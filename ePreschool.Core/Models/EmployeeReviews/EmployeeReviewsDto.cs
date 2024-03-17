using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ePreschool.Core.Models.EmployeeReviews
{
    public class EmployeeReviewsDto
    {
        public int Id { get; set; }
        public int ReviewRating { get; set; }
        public string ReviewComment { get; set; }
        public int ParentReviewerId { get; set; }
        public int EmployeeId { get; set; }
        public List<int> YearsOfAge { get; set; } = new List<int>();
    }
}
