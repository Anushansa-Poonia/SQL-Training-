using OrderManagementSystem.entity;
using System.Collections.Generic;

namespace OrderManagementSystem.dao
{
    public interface IOrderManagementRepository
    {
        void CreateOrder(User user, List<Product> products);
        void CancelOrder(int userId, int orderId);
        void CreateProduct(User user, Product product);
        void CreateUser(User user);
        List<Product> GetAllProducts();
        List<Order> GetOrderByUser(User user);
    }
}
