using ePreschool.Core.Models;

namespace ePreschool.Api.Services
{
    public interface IEnumManager
    {
        List<EntityItemModel> DrivingLicenses();
        List<EntityItemModel> Genders();
        List<EntityItemModel> Positions();
        List<EntityItemModel> MarriageStatuses();
        List<EntityItemModel> Qualifications();
        Task<List<EntityItemModel>> Companies();
        Task<List<EntityItemModel>> Cities();
    }
}