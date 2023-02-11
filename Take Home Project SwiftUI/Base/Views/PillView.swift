//
//  PillView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import SwiftUI

struct PillView: View {
    
    let id: Int
    
    var body: some View {
        VStack {
            
            Text("#\(id)")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 9)
                .padding(.vertical, 4)
                .background(Theme.pill, in: Capsule())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct PillView_Previews: PreviewProvider {
    static var previews: some View {
        PillView(id: 3)
    }
}
