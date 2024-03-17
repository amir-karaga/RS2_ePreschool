using ePreschool.Core.Entities.Base;

namespace ePreschool.Core.Entities
{
    public class Country:BaseEntity
    {
        public string Name { get; set; }
        public string Abrv { get; set; }
        public bool IsActive { get; set; }
    }
}
