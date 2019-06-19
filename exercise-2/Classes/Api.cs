using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Net.Http;
using System.Net.Http.Headers;

namespace exercise_2.Classes
{
    public static class Api
    {
        public static List<string> Get(string endpoint)
        {
            using (HttpClient client = new HttpClient())
            {
                    client.BaseAddress = new Uri ("http://exercise2_exercise1:80");
                    
                    MediaTypeWithQualityHeaderValue contentType = new MediaTypeWithQualityHeaderValue("application/json");
                    
                    client.DefaultRequestHeaders.Accept.Add(contentType);
                    
                    HttpResponseMessage response = client.GetAsync("/api/" + endpoint).Result;
                    
                    string stringData = response.Content.ReadAsStringAsync().Result;

                    return JsonConvert.DeserializeObject<List<string>>(stringData);
            }
        }
    }
}