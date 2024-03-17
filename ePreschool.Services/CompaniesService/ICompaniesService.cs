using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;

namespace ePreschool.Services
{
    public interface ICompaniesService : IBaseService<int, CompanyModel, CompanyUpsertModel, BaseSearchObject>
    {
    }
}
