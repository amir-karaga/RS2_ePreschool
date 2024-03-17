using AutoMapper;
using ePreschool.Core.Models;
using ePreschool.Infrastructure.UnitOfWork;

namespace ePreschool.Services
{
    public class ApplicationUserRolesService:IApplicationUserRolesService
    {
        public readonly UnitOfWork _unitOfWork;
        public readonly IMapper _mapper;

        public ApplicationUserRolesService(IUnitOfWork unitOfWork, IMapper mapper)
        {
            _unitOfWork = (UnitOfWork)unitOfWork;
            _mapper = mapper;
        }

        public async Task<IEnumerable<ApplicationUserRoleModel>> GetByUserId(int pUserId)
        {
            return _mapper.Map<IEnumerable<ApplicationUserRoleModel>>
                (await _unitOfWork.ApplicationUserRolesRepository.GetByUserId(pUserId));
        }
    }
}
