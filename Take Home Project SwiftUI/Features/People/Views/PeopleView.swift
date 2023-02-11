//
//  PeopleView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import SwiftUI

struct PeopleView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ZStack {
                PeopleViewBackground()
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        
                        ForEach(0...5, id: \.self) { item in
                            
                            PersonItemView(user: item)

                        }
                    }
                    .padding()
                }
                
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    
                    ToolBarPlusButton {
                        print("create user")
                    }
                }
            }
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

// MARK: -  PeopleViewBackground
struct PeopleViewBackground: View {
    
    var body: some View {
        Theme.background
            .ignoresSafeArea(edges: .all)
    }
}

// MARK: - ToolBarPlusButton
struct ToolBarPlusButton: View {
    
    var action: (() -> Void)?
    
    var body: some View {
        
        Button {
            action?()
        } label: {
            Symbols.plus
                .font(.system(.headline, design: .rounded, weight: .bold))
        }
    }
}
