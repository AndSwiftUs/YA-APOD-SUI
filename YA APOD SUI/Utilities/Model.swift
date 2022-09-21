import Foundation

public struct APODInstance: Codable, Hashable {
    var copyright: String?
    var date: String
    var explanation: String
    var hdurl: String?
    var media_type: String
    var service_version: String
    var title: String
    var url: String
}

extension APODInstance {
    static var dummy: APODInstance {
        .init(copyright: "Min Xie",
              date: "2020-02-21",
              explanation: "The silhouette of an intriguing dark nebula inhabits this cosmic scene. Lynds' Dark Nebula (LDN) 1622 appears against a faint background of glowing hydrogen gas only visible in long telescopic exposures of the region. In contrast, the brighter reflection nebula vdB 62 is more easily seen, just above and right of center. LDN 1622 lies near the plane of our Milky Way Galaxy, close on the sky to Barnard's Loop, a large cloud surrounding the rich complex of emission nebulae found in the Belt and Sword of Orion. With swept-back outlines, the obscuring dust of LDN 1622 is thought to lie at a similar distance, perhaps 1,500 light-years away. At that distance, this 1 degree wide field of view would span about 30 light-years. Young stars do lie hidden within the dark expanse and have been revealed in Spitzer Space telescope infrared images. Still, the foreboding visual appearance of LDN 1622 inspires its popular name, the Boogeyman Nebula.",
              hdurl: "https://apod.nasa.gov/apod/image/2002/ldn1622MinXie.jpg",
              media_type: "image",
              service_version: "v1",
              title: "LDN 1622: Dark Nebula in Orion",
              url: "https://apod.nasa.gov/apod/image/2002/ldn1622MinXie1024c.jpg")
    }
    
    static var loading: APODInstance {
        .init(copyright: "copyright will be here.",
              date: "1900-01-01",
              explanation: "Connecting\nto NASA servers\nto load data...",
              hdurl: "nasa-logo.svg",
              media_type: "image",
              service_version: "v1",
              title: "NASA logo",
              url: "nasa-logo.svg")
    }
}
