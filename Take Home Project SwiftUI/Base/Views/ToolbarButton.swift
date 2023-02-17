//
//  ToolbarButton.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-17.
//

import SwiftUI

struct ToolbarButton: View {
    
    var image: Image?
    var title: String?
    var action: (() -> Void)
    
    var body: some View {
        
        if let image = image {
            
            Button {
                action()
            } label: {
                image
                    .font(.system(.headline, design: .rounded, weight: .bold))
            }
        } else {
            
            Button(title ?? "") {
                action()

            }
        }
    }
}

struct ToolbarButton_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarButton(image: Symbols.plus) {}
    }
}
