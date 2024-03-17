using ePreschool.Core.Entities.Base;
using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Entities
{
    public class MonthlyPayment : BaseEntity
    {
        public bool IsPaid { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public int ParentId { get; set; }
        public Parent Parent { get; set; }
        public int ChildId { get; set; }
        public Child Child { get; set; }
        public decimal Price { get; set; }
        public float? Discount { get; set; }
        public string? Note { get; set; }
        public StatusPayment? Status { get; set; }

    }
}
