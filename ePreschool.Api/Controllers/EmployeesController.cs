using AutoMapper;
using ePreschool.Api.Services.FileManager;
using ePreschool.Core.Models;
using ePreschool.Core.SearchObjects;
using ePreschool.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace ePreschool.Api.Controllers
{
    public class EmployeesController : BaseCrudController<EmployeeModel, EmployeeUpsertModel, EmployeeSearchObject, IEmployeesService>
    {
        private readonly IFileManager _fileManager;
        private readonly IEmployeesService EmployeesService;
        private readonly IMapper _mapper;
        private readonly IRecommenderSystemsService _recommenderSystemsService;
        public EmployeesController(IFileManager fileManager,
            IEmployeesService service,
            IMapper mapper,
            ILogger<EmployeesController> logger,
            IActivityLogsService activityLogs,
            IRecommenderSystemsService recommenderSystemsService
            ) : base(service, logger, activityLogs)
        {
            _fileManager = fileManager;
            EmployeesService = service;
            _mapper = mapper;
            _recommenderSystemsService = recommenderSystemsService;
        }

        [Authorize(AuthenticationSchemes = "Bearer")]
        [HttpPost]
        public override async Task<IActionResult> Post([FromForm] EmployeeUpsertModel entity, CancellationToken cancellationToken = default)
        {
            var file = entity.File;
            if (file != null)
            {
                entity.ProfilePhoto = await _fileManager.UploadFile(file);
            }
            var data = await EmployeesService.AddAsync(entity);
            return Ok(data);
        }

        [Authorize(AuthenticationSchemes = "Bearer")]
        [HttpPut]
        public override async Task<IActionResult> Put([FromForm] EmployeeUpsertModel entity, CancellationToken cancellationToken = default)
        {
            var file = entity.File;
            if (file != null)
            {
                entity.ProfilePhoto = await _fileManager.UploadFile(file);
            }
            await EmployeesService.UpdateAsync(entity);
            return Ok();
        }

        [HttpGet("RecommendByCompanyIdAndParentReviewerId/{companyId}/{parentReviewerId}")]
        public async Task<IActionResult> Recommend(int companyId, int parentReviewerId)
        {
            return Ok(await _recommenderSystemsService.RecommendEmployeesAsync(companyId, parentReviewerId));
        }
    }
}
