//
//  ContentView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                
                print("🧑‍🎨 Users Response")
                
                dump(
                    try? StaticJSONMapper.decode(file: "UserDetailsStaticData",
                                            type: UserDetailsResponse.self)
                )
            }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
