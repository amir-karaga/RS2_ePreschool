using AutoMapper;
using ePreschool.Core.Enumerations;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;

namespace ePreschool.Api.Services
{
    public class EnumManager : IEnumManager
    {
        private readonly ICitiesService _citiesService;
        private readonly ICompaniesService _companiesService;
        private readonly IMapper _mapper;

        public EnumManager(IMapper mapper, ICitiesService citiesService, ICompaniesService companiesService)
        {
            _mapper = mapper;
            _citiesService = citiesService;
            _companiesService = companiesService;
        }

        public List<EntityItemModel> DrivingLicenses()
        {
            var drivingLicences = Enum.GetValues(typeof(DrivingLicence)).Cast<DrivingLicence>().ToList();
            var drivingLicenseItems = new List<EntityItemModel>();
            drivingLicenseItems = drivingLicences.Select(x => new EntityItemModel { Id = (int)x, Label = x.ToString() }).ToList();

            return drivingLicenseItems;
        }

        public async Task<List<EntityItemModel>> Cities()
        {
            var cities = await _citiesService.GetPagedAsync(new CountriesCitiesSearchObject { PageNumber = 1, PageSize = 999 });
            return _mapper.Map<PagedList<EntityItemModel>>(cities).Items;
        }

        public async Task<List<EntityItemModel>> Companies()
        {
            var companies = await _companiesService.GetPagedAsync(new BaseSearchObject { PageNumber = 1, PageSize = 999 });
            return _mapper.Map<PagedList<EntityItemModel>>(companies).Items;
        }
        public List<EntityItemModel> Genders()
        {
            var genders = Enum.GetValues(typeof(Gender)).Cast<Gender>().ToList();
            var genderItems = new List<EntityItemModel>();
            genderItems = genders.Select(x => new EntityItemModel { Id = (int)x, Label = x.ToString() }).ToList();

            return genderItems;
        }
        public List<EntityItemModel> Positions()
        {
            var positions = Enum.GetValues(typeof(Position)).Cast<Position>().ToList();
            var positionItems = new List<EntityItemModel>();
            positionItems = positions.Select(x => new EntityItemModel { Id = (int)x, Label = x.ToString() }).ToList();

            return positionItems;
        }

        public List<EntityItemModel> MarriageStatuses()
        {
            var marriageStatuses = Enum.GetValues(typeof(MarriageStatus)).Cast<MarriageStatus>().ToList();
            var marriageStatusItems = new List<EntityItemModel>();
            marriageStatusItems = marriageStatuses.Select(x => new EntityItemModel { Id = (int)x, Label = x.ToString() }).ToList();

            return marriageStatusItems;
        }

        public List<EntityItemModel> Qualifications()
        {
            var qualifications = Enum.GetValues(typeof(Qualification)).Cast<Qualification>().ToList();
            var qualificationItems = new List<EntityItemModel>();
            qualificationItems = qualifications.Select(x => new EntityItemModel { Id = (int)x, Label = x.ToString() }).ToList();

            return qualificationItems;
        }


    }
}
