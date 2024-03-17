namespace ePreschool.Core.SearchObjects
{
    public class MonthlyPaymentSearchObject : BaseSearchObject
    {
        public int? CompanyId { get; set; }
        public int? ParentId { get; set; }
        public int? ChildId { get; set; }
        public bool? IsPaid { get; set; }
    }
}
