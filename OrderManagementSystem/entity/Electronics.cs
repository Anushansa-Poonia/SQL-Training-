namespace OrderManagementSystem.entity
{
    public class Electronics : Product
    {
        public string Brand { get; set; }
        public int? WarrantyPeriod { get; set; } // Make this nullable
    }
}
