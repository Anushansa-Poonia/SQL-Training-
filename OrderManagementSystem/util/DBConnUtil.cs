using System;
using System.Data.SqlClient;

namespace OrderManagementSystem.util
{
    public static class DBConnUtil
    {
        public static SqlConnection GetDBConnection()
        {
            string connectionString = DBPropertyUtil.GetConnectionString("appSettings.json");
            SqlConnection conn = new SqlConnection(connectionString);
            conn.Open();
            return conn;
        }
    }
}
