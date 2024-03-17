using AutoMapper;
using ePreschool.Core.Models;
using ePreschool.Infrastructure.UnitOfWork;

namespace ePreschool.Services
{
    public class ApplicationRolesService:IApplicationRolesService
    {
        public readonly UnitOfWork _unitOfWork;
        public readonly IMapper _mapper;

        public ApplicationRolesService(IUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _mapper = mapper;
        }
        public async Task<ApplicationRoleModel> GetByRoleLevelIdOrName(int roleLeveleId, string roleName)
        {
            return _mapper.Map<ApplicationRoleModel>(await _unitOfWork.ApplicationRolesRepository.GetByRoleLevelOrName(roleLeveleId,roleName));
        }
    }
}
