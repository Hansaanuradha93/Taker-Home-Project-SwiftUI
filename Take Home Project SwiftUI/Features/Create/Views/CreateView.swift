//
//  CreateView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-17.
//

import SwiftUI

struct CreateView: View {
    var body: some View {
        
        Form {
            
            firstName
            
            lastName
            
            job

            Section {
                
                submit
            }
            
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

// MARK: - CreateView
private extension CreateView {
    
    var firstName: some View {
        TextField("First name", text: .constant(""))
    }
    
    var lastName: some View {
        TextField("Last name", text: .constant(""))
    }
    
    var job: some View {
        TextField("Job", text: .constant(""))
    }
    
    var submit: some View {
        Button("Submit") {
            // TODO: Handle action
        }
    }
}

