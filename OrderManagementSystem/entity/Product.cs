namespace OrderManagementSystem.entity
{
    public class Product
    {
        public int ProductId { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public double Price { get; set; }
        public int QuantityInStock { get; set; }
        public string Type { get; set; } // "Electronics" or "Clothing"
    }
}
