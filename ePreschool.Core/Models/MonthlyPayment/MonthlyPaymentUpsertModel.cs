using ePreschool.Core.Enumerations;

namespace ePreschool.Core.Models
{
    public class MonthlyPaymentUpsertModel:BaseUpsertModel
    {
        public bool IsPaid { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public int ParentId { get; set; }
        public int ChildId { get; set; }
        public float Price { get; set; }
        public float Discount { get; set; }
        public string Note { get; set; }
        public StatusPayment Status { get; set; }
    }
}
