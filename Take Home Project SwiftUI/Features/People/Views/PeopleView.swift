//
//  PeopleView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-11.
//

import SwiftUI

struct PeopleView: View {
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 2)
    
    @StateObject private var viewModel = PeopleViewModel()
    @State private var shouldShowCreate = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                BackgroundView()
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            
                            ForEach(viewModel.users, id: \.id) { user in
                                
                                NavigationLink {
                                    UserDetailsView(userId: user.id)
                                } label: {
                                    PersonItemView(user: user)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    createButton
                }
            }
            .onAppear {
                viewModel.fetchUsers()
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView()
            }
            .alert(isPresented: $viewModel.hasError,
                   error: viewModel.error) {
                retryButton
            }
        }
    }
}

struct PeopleView_Previews: PreviewProvider {
    static var previews: some View {
        PeopleView()
    }
}

// MARK: - PeopleView
private extension PeopleView {
    
    var createButton: some View {
        
        ToolbarButton(image: Symbols.plus) {
            shouldShowCreate.toggle()
        }
        .disabled(viewModel.isLoading)
    }
    
    var retryButton: some View {
        Button("Retry") {}
    }
}
