import SwiftUI

struct SettingsView: View {
    
    @AppStorage("countOfRandomAPODs") var countOfRandomAPODs: Int = 12
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("remainingRequest") var remainingRequest: Int = 50
    
    var numbersOfAPODsArray = [2, 6, 10, 12, 16, 20, 24]
    
    var body: some View {
        NavigationStack {
            
            Form {
                Section(header: Text("How many random images (APODs) do you want to fetch? Need fast internet connection.")) {
                    
                    Picker("Numbers of random images:", selection: $countOfRandomAPODs) {
                        ForEach(numbersOfAPODsArray, id: \.self) { number in
                            Text(number, format: .number)
                        }
                    }
                }
                
                Section(header: Text("Enter here you own NASA API-key for fast images downloading.")) {
                    
                    HStack {
                        Text("API-key: ")
                        TextField("Your own NASA API-key", text: $userAPIKey)
                            .font(.footnote)
                            .foregroundColor((userAPIKey == "DEMO_KEY") ? .red : .gray)
                    }
                    
                    // Stepper here for debug -> change to Text
                    // planing to get remainingRequest by inspecting the X-RateLimit-Limit and X-RateLimit-Remaining HTTP headers
                    Stepper("Request today: \(remainingRequest)", value: $remainingRequest)
                    
                    if userAPIKey == "DEMO_KEY" {
                        
                        Text("\"DEMO_KEY\" is default API-key that have some restrictions:")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        
                        Text("""
DEMO_KEY Rate Limits

In documentation examples, the special DEMO_KEY api key is used. This API key can be used for initially exploring APIs prior to signing up, but it has much lower rate limits, so you’re encouraged to signup for your own API key if you plan to use the API (signup is quick and easy). The rate limits for the DEMO_KEY are:

Hourly Limit: 30 requests per IP address per hour
Daily Limit: 50 requests per IP address per day
""").font(.footnote).foregroundColor(.gray)
                        
                        Text("How to get you own NASA API-key without restrictions?")
                            .multilineTextAlignment(.center)
                        Text("Go to: https://api.nasa.gov and take it easy.")
                    }
                    
                    Text("""
Web Service Rate Limits

Limits are placed on the number of API requests you may make using your API key. Rate limits may vary by service, but the defaults are:

Hourly Limit: 1,000 requests per hour

For each API key, these limits are applied across all api.nasa.gov API requests. Exceeding these limits will lead to your API key being temporarily blocked from making further requests. The block will automatically be lifted by waiting an hour. If you need higher rate limits, contact us.

""").font(.footnote).foregroundColor(.gray)
                }
            }
            
            Text("Powered by NASA API.\nCreated by AndSwiftUs@gmail.com, 2022.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Spacer()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
