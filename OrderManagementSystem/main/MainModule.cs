using OrderManagementSystem.entity;
using OrderManagementSystem.dao;
using OrderManagementSystem.exception;
using System;
using System.Collections.Generic;

namespace OrderManagementSystem.main
{
    class MainModule
    {
        static void Main(string[] args)
        {
            IOrderManagementRepository repository = new OrderProcessor();
            User currentUser = null;
            int choice;

            // Login System for Admin
            Console.WriteLine("=== Welcome to Order Management System ===");
            currentUser = AdminLogin();

            if (currentUser == null)
            {
                Console.WriteLine("Exiting the system.");
                return;
            }

            // Main Menu Loop
            do
            {
                Console.Clear();
                Console.WriteLine("=== Order Management System ===\n");
                Console.WriteLine("1. Create User");
                Console.WriteLine("2. Create Product (Admin Only)");
                Console.WriteLine("3. Create Order");
                Console.WriteLine("4. Cancel Order");
                Console.WriteLine("5. Get All Products");
                Console.WriteLine("6. Get Orders by User");
                Console.WriteLine("0. Exit");
                Console.Write("\nEnter your choice: ");
                choice = Convert.ToInt32(Console.ReadLine());

                switch (choice)
                {
                    case 1:
                        CreateUser(repository);
                        break;
                    case 2:
                        if (currentUser.Role == "Admin")
                        {
                            CreateProduct(repository, currentUser);
                        }
                        else
                        {
                            Console.WriteLine("Only Admins can create products.");
                        }
                        break;
                    case 3:
                        CreateOrder(repository, currentUser);
                        break;
                    case 4:
                        CancelOrder(repository);
                        break;
                    case 5:
                        GetAllProducts(repository);
                        break;
                    case 6:
                        GetOrdersByUser(repository, currentUser);
                        break;
                    case 0:
                        Console.WriteLine("Exiting the system.");
                        break;
                    default:
                        Console.WriteLine("Invalid choice. Please try again.");
                        break;
                }

                Console.WriteLine("\nPress any key to continue...");
                Console.ReadKey();
            }
            while (choice != 0);
        }

        // Admin Login Method
        static User AdminLogin()
        {
            Console.WriteLine("\n--- Admin Login ---");
            Console.Write("Enter Username: ");
            string username = Console.ReadLine();
            Console.Write("Enter Password: ");
            string password = Console.ReadLine();

            if (username == "admin" && password == "admin123")
            {
                Console.WriteLine("Login Successful. Welcome Admin!");
                return new User { UserId = 1, Username = "admin", Role = "Admin" };
            }
            else
            {
                Console.WriteLine("Invalid credentials! Exiting the system.");
                return null;
            }
        }

        // Create a new User
        static void CreateUser(IOrderManagementRepository repository)
        {
            Console.WriteLine("\n--- Create New User ---");
            Console.Write("Enter Username: ");
            string username = Console.ReadLine();
            Console.Write("Enter Password: ");
            string password = Console.ReadLine();

            User newUser = new User { Username = username, Password = password, Role = "User" };
            repository.CreateUser(newUser);
            Console.WriteLine("User created successfully.");
        }

        // Create a new Product (Admin-only)
        static void CreateProduct(IOrderManagementRepository repository, User currentUser)
        {
            Console.WriteLine("\n--- Create New Product ---");
            Console.Write("Enter Product Name: ");
            string productName = Console.ReadLine();
            Console.Write("Enter Description: ");
            string description = Console.ReadLine();
            Console.Write("Enter Price: ");
            double price = Convert.ToDouble(Console.ReadLine());
            Console.Write("Enter Quantity in Stock: ");
            int quantityInStock = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Product Type (Electronics/Clothing): ");
            string type = Console.ReadLine();

            Product newProduct = new Product
            {
                ProductName = productName,
                Description = description,
                Price = price,
                QuantityInStock = quantityInStock,
                Type = type
            };

            repository.CreateProduct(currentUser, newProduct);
            Console.WriteLine("Product created successfully.");
        }

        // Create a new Order
        static void CreateOrder(IOrderManagementRepository repository, User user)
        {
            Console.WriteLine("\n--- Create New Order ---");
            List<Product> products = repository.GetAllProducts();

            if (products.Count == 0)
            {
                Console.WriteLine("No products available to order.");
                return;
            }

            Console.WriteLine("Available Products:");
            for (int i = 0; i < products.Count; i++)
            {
                Console.WriteLine($"{i + 1}. {products[i].ProductName} - {products[i].Price} USD");
            }

            Console.Write("Select Product by number: ");
            int productIndex = Convert.ToInt32(Console.ReadLine()) - 1;

            if (productIndex < 0 || productIndex >= products.Count)
            {
                Console.WriteLine("Invalid selection.");
                return;
            }

            Console.Write("Enter Quantity: ");
            int quantity = Convert.ToInt32(Console.ReadLine());

            if (quantity > products[productIndex].QuantityInStock)
            {
                Console.WriteLine("Insufficient stock for the selected product.");
                return;
            }

            List<Product> orderProducts = new List<Product>
            {
                products[productIndex]
            };

            repository.CreateOrder(user, orderProducts);
            Console.WriteLine("Order placed successfully.");
        }

        // Cancel an existing Order
        static void CancelOrder(IOrderManagementRepository repository)
        {
            Console.WriteLine("\n--- Cancel Order ---");
            Console.Write("Enter User ID: ");
            int userId = Convert.ToInt32(Console.ReadLine());
            Console.Write("Enter Order ID: ");
            int orderId = Convert.ToInt32(Console.ReadLine());

            try
            {
                repository.CancelOrder(userId, orderId);
                Console.WriteLine("Order cancelled successfully.");
            }
            catch (UserNotFoundException ex)
            {
                Console.WriteLine(ex.Message);
            }
            catch (OrderNotFoundException ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        // Get All Products
        static void GetAllProducts(IOrderManagementRepository repository)
        {
            Console.WriteLine("\n--- All Products ---");
            List<Product> products = repository.GetAllProducts();

            if (products.Count == 0)
            {
                Console.WriteLine("No products available.");
            }
            else
            {
                foreach (var product in products)
                {
                    Console.WriteLine($"{product.ProductId}. {product.ProductName} - {product.Price} USD");
                }
            }
        }

        // Get Orders by User
        static void GetOrdersByUser(IOrderManagementRepository repository, User user)
        {
            Console.WriteLine("\n--- Orders by User ---");
            List<Order> orders = repository.GetOrderByUser(user);

            if (orders.Count == 0)
            {
                Console.WriteLine("No orders found for this user.");
            }
            else
            {
                foreach (var order in orders)
                {
                    Console.WriteLine($"Order ID: {order.OrderId}, Order Date: {order.OrderDate}");
                    foreach (var product in order.Products)
                    {
                        Console.WriteLine($"   - {product.ProductName}: {product.Price} USD");
                    }
                }
            }
        }
    }
}
