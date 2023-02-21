//
//  SettingsView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-21.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage(UserDefaultsKeys.hapticsEnabled) private var isHapticsEnabled: Bool = true
    
    var body: some View {
        NavigationView {
            Form {
                haptics
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

// MARK: - SettingsView
extension SettingsView {
    
    private var haptics: some View {
        Toggle("Enable Haptics", isOn: $isHapticsEnabled)
    }
}



