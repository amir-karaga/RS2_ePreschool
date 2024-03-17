using ePreschool.Core.Models;

namespace ePreschool.Services
{
    public interface IRecommenderSystemsService
    {
        Task<List<EntityItemModel>> RecommendEmployeesAsync(int companyId, int parentReviewerId);
    }
}
