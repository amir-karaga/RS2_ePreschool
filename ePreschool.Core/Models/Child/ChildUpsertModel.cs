using Microsoft.AspNetCore.Http;

namespace ePreschool.Core.Models
{
    public class ChildUpsertModel : PersonBaseModel
    {
        public int ParentId { get; set; }
        public IFormFile? File { get; set; }
        public DateTime DateOfEnrollment { get; set; }
        public string EmergencyContact { get; set; }
        public string SpecialNeeds { get; set; }
        public string Note { get; set; }
        public int EducatorId { get; set; }
        public int KindergartenId { get; set; }
    }
}
