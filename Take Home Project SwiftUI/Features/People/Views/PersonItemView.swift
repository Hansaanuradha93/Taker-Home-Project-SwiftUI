//
//  PersonItemView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import SwiftUI

struct PersonItemView: View {
    
    let user: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Rectangle()
                .fill(.blue)
                .frame(height: 130)
            
            VStack(alignment: .leading) {
                
                PillView(id: user)
                
                Text("<First name> <Last name>")
                    .foregroundColor(Theme.text)
                    .font(.system(.body, design: .rounded))
            }
            .padding(.horizontal, 8)
            
            
        }
        .background(Theme.detailBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Theme.text.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.vertical, 5)
    }
}

struct PersonItemView_Previews: PreviewProvider {
    static var previews: some View {
        PersonItemView(user: 5)
            .frame(width: 200)
    }
}
