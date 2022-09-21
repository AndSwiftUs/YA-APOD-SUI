//
//  YA_APOD_SUIApp.swift
//  YA APOD SUI
//
//  Created by Andrew Us on 21.09.2022.
//

import SwiftUI

@main
struct YA_APOD_SUIApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
//            CoreDataContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
