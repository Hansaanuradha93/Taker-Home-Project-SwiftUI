//
//  UserDetailView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-12.
//

import SwiftUI

struct UserDetailsView: View {
    
    var userId: Int
    
    @StateObject private var viewModel = UserDetailsViewModel()
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    
                    VStack(alignment: .leading, spacing: 18) {
                        
                        PersonAvatarImageView(userInfo: viewModel.userInfo)
                        
                        Group {
                            // Detail
                            PersonDetialFormView(user: viewModel.userInfo?.data)
                            
                            // Support URL
                            LinkView(userInfo: viewModel.userInfo)
                            
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                        .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                    }
                    .padding()
                }
            }
            
        }
        .navigationTitle("Details")
        .task {
            await viewModel.fetchUserDetailsAsync(for: userId)
        }
        .alert(isPresented: $viewModel.hasError,
               error: viewModel.error) {
            okButton
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    
    static var previewUserId: Int {
        let userInfo = try! StaticJSONMapper.decode(file: "UserDetailsStaticData", type: UserDetailsResponse.self)
        return userInfo.data.id
    }
    
    static var previews: some View {
        NavigationView {
            UserDetailsView(userId: previewUserId)
        }
    }
}

// MARK: - UserDetailsView
private extension UserDetailsView {
    
    var okButton: some View {
        Button("Retry") {
            Task {
                await viewModel.fetchUserDetailsAsync(for: userId)
            }
        }
    }
}

// MARK: - PersonAvatarImageView
struct PersonAvatarImageView: View {
    
    let userInfo: UserDetailsResponse?
    
    var body: some View {
        
        if let avatarAbsoluteString = userInfo?.data.avatar,
           let avatarURL = URL(string: avatarAbsoluteString) {
            
            AsyncImage(url: avatarURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }
}

// MARK: - FirstNameView
struct PersonDetailView: View {
    
    var label: String
    var value: String
    
    var body: some View {
        
        Text("\(label)")
            .font(.system(.body, design: .rounded, weight: .semibold))
        
        Text("\(value)")
            .font(.system(.subheadline, design: .rounded))
    }
}

// MARK: - PersonDetialFormView
struct PersonDetialFormView: View {
    
    let user: User?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            
            PillView(id: (user?.id ?? 0))
            
            // first name
            PersonDetailView(label: "First Name", value: "\(user?.firstName ?? "--")")
            
            Divider()
            
            // last name
            PersonDetailView(label: "Last Name", value: "\(user?.lastName ?? "--")")
            
            Divider()
            
            // email
            PersonDetailView(label: "Email", value: "\(user?.email ?? "--")")
            
        }
    }
}

// MARK: - LinkView
struct LinkView: View {
    
    let userInfo: UserDetailsResponse?
        
    var body: some View {
        
        if let supportAbsoluteString = userInfo?.support.url,
           let supportURL = URL(string: supportAbsoluteString),
           let supportText = userInfo?.support.text {
            
            Link(destination: supportURL) {
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(supportText)
                            .foregroundColor(Theme.text)
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .multilineTextAlignment(.leading)
                        
                        Text("\(supportAbsoluteString)")
                            .font(.system(.subheadline, design: .rounded))
                        
                    }
                    
                    Spacer()
                    
                    Symbols
                        .link
                        .font(.system(.title3, design: .rounded))
                }
            }
        }
    }
}
