//
//  BackgroundView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-12.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        Theme.background
            .ignoresSafeArea(edges: .all)
    }
}

struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
