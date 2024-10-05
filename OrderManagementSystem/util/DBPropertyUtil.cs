using System.IO;
using Newtonsoft.Json.Linq;

namespace OrderManagementSystem.util
{
    public static class DBPropertyUtil
    {
        public static string GetConnectionString(string propertyFileName)
        {
            string json = File.ReadAllText(propertyFileName);
            JObject jsonObject = JObject.Parse(json);
            return jsonObject["ConnectionString"].ToString();
        }
    }
}
