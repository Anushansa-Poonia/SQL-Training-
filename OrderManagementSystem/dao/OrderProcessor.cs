using OrderManagementSystem.entity;
using OrderManagementSystem.exception;
using OrderManagementSystem.util;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace OrderManagementSystem.dao
{
    public class OrderProcessor : IOrderManagementRepository
    {
        private SqlConnection conn;

        public OrderProcessor()
        {
            conn = DBConnUtil.GetDBConnection();
        }

        public void CreateOrder(User user, List<Product> products)
        {
            if (!UserExists(user.UserId))
                throw new UserNotFoundException("User not found.");

            // Insert order into the Orders table
            using (SqlCommand cmd = new SqlCommand("INSERT INTO Orders (UserId) VALUES (@UserId); SELECT SCOPE_IDENTITY();", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", user.UserId);
                var orderId = Convert.ToInt32(cmd.ExecuteScalar());

                // Insert each product into OrderDetails
                foreach (var product in products)
                {
                    using (SqlCommand detailCmd = new SqlCommand("INSERT INTO OrderDetails (OrderId, ProductId, Quantity, PriceAtOrder) VALUES (@OrderId, @ProductId, @Quantity, @PriceAtOrder)", conn))
                    {
                        detailCmd.Parameters.AddWithValue("@OrderId", orderId);
                        detailCmd.Parameters.AddWithValue("@ProductId", product.ProductId);
                        detailCmd.Parameters.AddWithValue("@Quantity", product.QuantityInStock); // Use actual quantity
                        detailCmd.Parameters.AddWithValue("@PriceAtOrder", product.Price);

                        detailCmd.ExecuteNonQuery();
                    }
                }
            }

            Console.WriteLine("Order created successfully.");
        }

        public void CancelOrder(int userId, int orderId)
        {
            if (!UserExists(userId))
                throw new UserNotFoundException("User not found.");

            if (!OrderExists(orderId))
                throw new OrderNotFoundException("Order not found.");

            using (SqlCommand cmd = new SqlCommand("DELETE FROM Orders WHERE OrderId = @OrderId", conn))
            {
                cmd.Parameters.AddWithValue("@OrderId", orderId);
                cmd.ExecuteNonQuery();
            }

            Console.WriteLine("Order cancelled successfully.");
        }

        public void CreateProduct(User user)
        {
            if (user.Role != "Admin")
                throw new UnauthorizedAccessException("Only admins can create products.");

            // Gather product details from user input
            Console.Write("Enter Product Name: ");
            string productName = Console.ReadLine();

            Console.Write("Enter Description: ");
            string description = Console.ReadLine();

            Console.Write("Enter Price: ");
            double price = Convert.ToDouble(Console.ReadLine());

            Console.Write("Enter Quantity In Stock: ");
            int quantityInStock = Convert.ToInt32(Console.ReadLine());

            Console.Write("Enter Type (Electronics/Clothing): ");
            string type = Console.ReadLine();

            string brand = null;
            int? warrantyPeriod = null;
            string size = null;
            string color = null;

            // Handle product-specific details
            if (type.Equals("Electronics", StringComparison.OrdinalIgnoreCase))
            {
                Console.Write("Enter Brand: ");
                brand = Console.ReadLine();

                Console.Write("Enter Warranty Period (in months): ");
                warrantyPeriod = Convert.ToInt32(Console.ReadLine());
            }
            else if (type.Equals("Clothing", StringComparison.OrdinalIgnoreCase))
            {
                Console.Write("Enter Size: ");
                size = Console.ReadLine();

                Console.Write("Enter Color: ");
                color = Console.ReadLine();
            }

            string sql = "INSERT INTO Products (ProductName, Description, Price, QuantityInStock, Type, Brand, WarrantyPeriod, Size, Color) " +
                         "VALUES (@ProductName, @Description, @Price, @QuantityInStock, @Type, @Brand, @WarrantyPeriod, @Size, @Color)";

            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@ProductName", productName);
                cmd.Parameters.AddWithValue("@Description", description);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@QuantityInStock", quantityInStock);
                cmd.Parameters.AddWithValue("@Type", type);

                // Handle Electronics
                if (type.Equals("Electronics", StringComparison.OrdinalIgnoreCase))
                {
                    cmd.Parameters.AddWithValue("@Brand", (object)brand ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@WarrantyPeriod", (object)warrantyPeriod ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Size", DBNull.Value); // Electronics do not have size
                    cmd.Parameters.AddWithValue("@Color", DBNull.Value); // Electronics do not have color
                }
                // Handle Clothing
                else if (type.Equals("Clothing", StringComparison.OrdinalIgnoreCase))
                {
                    cmd.Parameters.AddWithValue("@Brand", DBNull.Value); // Clothing do not have brand
                    cmd.Parameters.AddWithValue("@WarrantyPeriod", DBNull.Value); // Clothing do not have warranty period
                    cmd.Parameters.AddWithValue("@Size", (object)size ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Color", (object)color ?? DBNull.Value);
                }

                cmd.ExecuteNonQuery(); // Execute the command
            }

            Console.WriteLine("Product created successfully.");
        }

        public void CreateUser(User user)
        {
            using (SqlCommand cmd = new SqlCommand("INSERT INTO Users (Username, Password, Role) VALUES (@Username, @Password, @Role)", conn))
            {
                cmd.Parameters.AddWithValue("@Username", user.Username);
                cmd.Parameters.AddWithValue("@Password", user.Password);
                cmd.Parameters.AddWithValue("@Role", user.Role);
                cmd.ExecuteNonQuery();
            }

            Console.WriteLine("User created successfully.");
        }

        public List<Product> GetAllProducts()
        {
            List<Product> products = new List<Product>();
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM Products", conn))
            {
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        // Create base product
                        Product product = new Product
                        {
                            ProductId = (int)reader["ProductId"],
                            ProductName = (string)reader["ProductName"],
                            Description = (string)reader["Description"],
                            Price = (double)reader["Price"],
                            QuantityInStock = (int)reader["QuantityInStock"],
                            Type = (string)reader["Type"]
                        };

                        // Identify if it's a derived type
                        if (product.Type == "Electronics")
                        {
                            product = new Electronics
                            {
                                ProductId = product.ProductId,
                                ProductName = product.ProductName,
                                Description = product.Description,
                                Price = product.Price,
                                QuantityInStock = product.QuantityInStock,
                                Type = product.Type,
                                Brand = (string)reader["Brand"],
                                WarrantyPeriod = (int)reader["WarrantyPeriod"]
                            };
                        }
                        else if (product.Type == "Clothing")
                        {
                            product = new Clothing
                            {
                                ProductId = product.ProductId,
                                ProductName = product.ProductName,
                                Description = product.Description,
                                Price = product.Price,
                                QuantityInStock = product.QuantityInStock,
                                Type = product.Type,
                                Size = (string)reader["Size"],
                                Color = (string)reader["Color"]
                            };
                        }

                        products.Add(product);
                    }
                }
            }

            return products;
        }

        public List<Order> GetOrderByUser(User user)
        {
            List<Order> orders = new List<Order>();
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM Orders WHERE UserId = @UserId", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", user.UserId);
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        // Create Order object from reader
                        Order order = new Order
                        {
                            OrderId = (int)reader["OrderId"],
                            UserId = (int)reader["UserId"],
                            OrderDate = (DateTime)reader["OrderDate"],
                            Products = new List<Product>() // Retrieve and populate products as needed
                        };
                        orders.Add(order);
                    }
                }
            }

            return orders;
        }

        private bool UserExists(int userId)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE UserId = @UserId", conn))
            {
                cmd.Parameters.AddWithValue("@UserId", userId);
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        private bool OrderExists(int orderId)
        {
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Orders WHERE OrderId = @OrderId", conn))
            {
                cmd.Parameters.AddWithValue("@OrderId", orderId);
                return (int)cmd.ExecuteScalar() > 0;
            }
        }

        void IOrderManagementRepository.CreateProduct(User user, Product product)
        {
            throw new NotImplementedException();
        }
    }
}
