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
    @State private var shouldShowSuccess: Bool = false
    @State private var hasAppeared: Bool = false
    
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
                                        .task {
                                            
                                            if viewModel.hasReachedEnd(of: user) && !viewModel.isFetching {
                                                await viewModel.fetchNextSetOfUsersAsync()
                                            }
                                        }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("People")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    refreshButton
                }
                
                ToolbarItem(placement: .primaryAction) {
                    createButton
                }
            }
            .task {
                if !hasAppeared {
                    await viewModel.fetchUsersAsync()
                    hasAppeared = true
                }
            }
            .sheet(isPresented: $shouldShowCreate) {
                CreateView {
                    haptic(.success)
                    withAnimation(.spring().delay(0.25)) {
                        self.shouldShowSuccess.toggle()
                    }
                }
            }
            .alert(isPresented: $viewModel.hasError,
                   error: viewModel.error) {
                retryButton
            }
            .overlay {
                if shouldShowSuccess {
                    CheckmarkPopoverView()
                        .transition(.scale.combined(with: .opacity))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.spring()) {
                                    self.shouldShowSuccess.toggle()
                                }
                            }
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

// MARK: - PeopleView
private extension PeopleView {
    
    var createButton: some View {
        
        ToolbarButton(image: Symbols.plus) {
            shouldShowCreate.toggle()
        }
        .disabled(viewModel.isLoading)
    }
    
    var refreshButton: some View {
        
        ToolbarButton(image: Symbols.refresh) {
            Task {
                await viewModel.fetchUsersAsync()
            }
        }
        .disabled(viewModel.isLoading)
    }
    
    var retryButton: some View {
        Button("Retry") {
            Task {
                await viewModel.fetchUsersAsync()
            }
        }
    }
}
