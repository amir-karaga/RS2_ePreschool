using ePreschool.Core.Entities;
using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public class EmployeeReviewsProfile : BaseProfile
    {
        public EmployeeReviewsProfile()
        {
            CreateMap<EmployeeReviews, EmployeeReviewsModel>().ReverseMap();
            CreateMap<EmployeeReviews, EmployeeReviewsUpsertModel>().ReverseMap();
        }
    }
}
