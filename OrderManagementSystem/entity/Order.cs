namespace OrderManagementSystem.entity
{
    using System;
    using System.Collections.Generic;

    public class Order
    {
        public int OrderId { get; set; }
        public int UserId { get; set; }
        public DateTime OrderDate { get; set; }
        public List<Product> Products { get; set; } = new List<Product>(); // Initialize list to prevent null reference
    }
}
