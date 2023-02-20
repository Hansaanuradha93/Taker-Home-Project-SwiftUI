//
//  CreateView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-17.
//

import SwiftUI

struct CreateView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var viewModel = CreateViewModel()
    
    let successfulAction: () -> Void
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                BackgroundView()
                
                Form {
                    
                    firstName
                    
                    lastName
                    
                    job

                    Section {
                        
                        submitButton
                    }
                }
                .disabled(viewModel.submissionState == .submitting)
                
            }
            .navigationTitle("Create")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    dismissButton
                }
            }
            .onChange(of: viewModel.submissionState) { formState in
                if formState == .successful {
                    dismiss()
                    successfulAction()
                }
            }
            .alert(isPresented: $viewModel.hasError,
                    error: viewModel.error) {
                okButton
            }
            .overlay {
                if viewModel.submissionState == .submitting {
                    ProgressView()
                }
            }
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView(successfulAction: {})
    }
}

// MARK: - CreateView
private extension CreateView {
    
    var firstName: some View {
        TextField("First name", text: $viewModel.newUser.firstName)
    }
    
    var lastName: some View {
        TextField("Last name", text: $viewModel.newUser.lastName)
    }
    
    var job: some View {
        TextField("Job", text: $viewModel.newUser.job)
    }
    
    var submitButton: some View {
        Button("Submit") {
            viewModel.create()
        }
    }
    
    var dismissButton: some View {
        ToolbarButton(title: "Dismiss") {
            dismiss()
        }
    }
    
    var okButton: some View {
        Button("OK") {}
    }
}

