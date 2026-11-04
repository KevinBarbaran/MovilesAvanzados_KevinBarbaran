//
//  apple_lab11_02_SwiftUI_SwiftDataApp.swift
//  apple_lab11_02_SwiftUI_SwiftData
//
//  Created by Tecsup on 4/11/26.
//

import SwiftUI
import SwiftData

@main
struct AlumnosApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(ModelContainerProvider.shared.container)
        }
    }
}
