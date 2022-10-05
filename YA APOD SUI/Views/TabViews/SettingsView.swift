import SwiftUI

struct SettingsView: View {
    
    @AppStorage("countOfRandomAPODs") var countOfRandomAPODs: Int = 8
    @AppStorage("searchGridLayoutState") var searchGridLayoutState: Int = 1
    @AppStorage("userAPIKey") var userAPIKey: String = "DEMO_KEY"
    @AppStorage("isHapticFeedback") var isHapticFeedback: Bool = true
    @EnvironmentObject var appPrefs: AppPrefs
    @State private var newApiKey: String = ""
    
    var numbersOfAPODsArray = [2, 8, 10, 12, 20, 30, 40]
    var numersOfSearchLayoutColumns = [1,2,3]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Interface")) {
                    Group {
                        Picker("Random images: ", selection: $countOfRandomAPODs) {
                            ForEach(numbersOfAPODsArray, id: \.self) { number in
                                Text(number, format: .number)
                            }
                        }
                        
                        Stepper(value: $searchGridLayoutState, in: 1...3) {
                            HStack {
                                Text("Сolumns in search:")
                                Spacer()
                                Text("\(searchGridLayoutState)")
                            }
                        }
                        
                        Toggle("HapticFeedback", isOn: $isHapticFeedback)
                    }
                }
                
                Section(header: Text("NASA API-key")) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Your API-key is:")
                                .font(.callout)
                                .bold()
                            Text(" \(userAPIKey)")
                                .font(.footnote)
                                .textSelection(.enabled)
                        }
                        if userAPIKey == "DEMO_KEY" {
                            TextField("Your own NASA API-key", text: $newApiKey, prompt: Text("Required"))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .font(.footnote)
                                .foregroundColor((userAPIKey == "DEMO_KEY") ? .red : .gray)
                                .onSubmit {
                                    if newApiKey.count == AppConstants.NASA.countOfApiKeySymbols {
                                        userAPIKey = newApiKey
                                    }
                                }
                        }
                    }
                    
                    HStack {
                        Text("Requests today: ")
                        Spacer()
                        Text("\(appPrefs.requestRemaining) of \(appPrefs.requestLimit).")
                    }
                    
                    if userAPIKey == "DEMO_KEY" {
                        
                        Text("\"DEMO_KEY\" is default API-key that have some restrictions:")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.red)
                        
                        Text("""
DEMO_KEY Rate Limits

The special DEMO_KEY api key is used. This API key can be used for initially exploring APIs prior to signing up, but it has much lower rate limits, so you’re encouraged to signup for your own API key (signup is quick and easy). The rate limits for the DEMO_KEY are:

Daily Limit: 40 requests per IP address per day
""").font(.footnote).foregroundColor(.gray)
                        
                        Text("How to get you own NASA API-key without restrictions?")
                            .multilineTextAlignment(.center)
                        Text("Go to: https://api.nasa.gov and take it easy.")
                    }
                    
                    Text("""
Web Service Rate Limits

Limits are placed on the number of API requests you may make using your API key. Rate limits may vary by service, but the defaults are:

Daily Limit: 2,000 requests per IP address per day

For each API key, these limits are applied across all api.nasa.gov API requests. Exceeding these limits will lead to your API key being temporarily blocked from making further requests. The block will automatically be lifted by waiting an hour. If you need higher rate limits, contact us.

""").font(.footnote).foregroundColor(.gray)
                }
                
                if userAPIKey != "DEMO_KEY" {
                    Button {
                        userAPIKey = "DEMO_KEY"
                        appPrefs.requestLimit = "?"
                        appPrefs.requestRemaining = "?"
                    } label: {
                        Text("Reset API-KEY to \"DEMO_KEY\"")
                    }
                }
            }
            
            Text("Powered by NASA API.\nCreated by AndSwiftUs@gmail.com, 2022.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            
            Spacer()
                .navigationTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    Color.init(uiColor: (userAPIKey == "DEMO_KEY")
                               ? AppConstants.NASA.redUIColor : .gray),
                    for: .navigationBar
                )
                .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppPrefs())
    }
}
