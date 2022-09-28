import Foundation
import SwiftUI

class AppPrefs: ObservableObject {
    var requestLimit: String = "40"
    var requestRemaining: String = "0"
}

struct AppConstants {
        
    struct NASA {
        
        static let blueUIColor              = UIColor(red: 11 / 255, green: 61 / 255, blue: 145 / 255, alpha: 1)
        static let blueColor                = Color.init(uiColor: blueUIColor)

        static let greenUIColor             = UIColor(red: 0 / 255, green: 124 / 255, blue: 119 / 255, alpha: 1)
        static let greenColor               = Color.init(uiColor: greenUIColor)
        
        static let redUIColor               = UIColor(red: 252 / 255, green: 61 / 255, blue: 33 / 255, alpha: 1)
        static let redColor                 = Color.init(uiColor: redUIColor)
        
        static let countOfApiKeySymbols     = 40

        static let defaultNASALogo          = "nasa-logo.svg"

        static let defaultAPIKey            = "DEMO_KEY"
        static let defaultNASAUrl           = "https://api.nasa.gov/planetary/apod"
        static let myAPIKEY                 = "58EbYM2UDKh8ovgnnbwtoBBqJSGpANHhQ78Xbuds"
                                                // Iyr11lhLoWgdpfSr7Ull2IKhEbkiYGTmg4PvqFsm
     }
}
