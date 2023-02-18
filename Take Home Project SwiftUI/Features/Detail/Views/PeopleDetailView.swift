//
//  PeopleDetailView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-12.
//

import SwiftUI

struct PeopleDetailView: View {
    
    var userId: Int
    @State var userInfo: UserDetailsResponse?
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 18) {
                    
                    PersonAvatarImageView(userInfo: userInfo)
                    
                    Group {
                        // Detail
                        PersonDetialFormView(user: userInfo?.data)
                        
                        // Support URL
                        LinkView(userInfo: userInfo)
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                }
                .padding()
                
            }
        }
        .navigationTitle("Details")
        .onAppear {
//            do {
//                let userInfo = try StaticJSONMapper.decode(file: "UserDetailsStaticData", type: UserDetailsResponse.self)
//                self.userInfo = userInfo
//            } catch (let error) {
//                // TODO: handle errors
//                print("‼️ Error: \(error)")
//            }
            
            NetworkManager.shared.request(endPoint: .userDetails(id: userId), type: UserDetailsResponse.self) { result in
                
                switch result {
                    
                case .success(let response):
                    self.userInfo = response
                    
                case .failure(let error):
                    print("🔴 error: \(error)")
                }
            }
        }
    }
}

struct PeopleDetailView_Previews: PreviewProvider {
    
    static var previewUserInfo: UserDetailsResponse {
        let userInfo = try! StaticJSONMapper.decode(file: "UserDetailsStaticData", type: UserDetailsResponse.self)
        return userInfo
    }
    
    static var previews: some View {
        NavigationView {
            PeopleDetailView(userId: 1, userInfo: previewUserInfo)
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
