//
//  PeopleDetailView.swift
//  Take Home Project SwiftUI
//
//  Created by Hansa Anuradha on 2023-02-12.
//

import SwiftUI

struct PeopleDetailView: View {
    
    var user: User
    
    var body: some View {
        
        ZStack {
            BackgroundView()
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 18) {
                    AsyncImage(url: .init(string: user.avatar)) { image in
                        image
                            .resizable()
                            .frame(height: 230)
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Group {
                        // Detail
                        PersonDetialFormView(user: user)
                        
                        // Link
                        LinkView(link: "https://reqres.in/#support-heading")
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 10)
                    .background(Theme.detailBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    
                }
                .padding()

            }
        }
        
    }
}

struct PeopleDetailView_Previews: PreviewProvider {
    
    static var previewUser: User {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self).data
        return users.first!
    }
    
    static var previews: some View {
        PeopleDetailView(user: previewUser)
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
    
    let user: User
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            
            PillView(id: user.id)
            
            // first name
            PersonDetailView(label: "First Name", value: "\(user.firstName)")
            
            Divider()
            
            // last name
            PersonDetailView(label: "Last Name", value: "\(user.lastName)")
            
            Divider()
            
            // email
            PersonDetailView(label: "Email", value: "\(user.email)")
            
        }
    }
}

// MARK: - LinkView
struct LinkView: View {
    
    let link: String
    
    var body: some View {
        
        Link(destination: .init(string: link)!) {
            HStack(alignment: .top) {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Support Reqres")
                        .foregroundColor(Theme.text)
                        .font(.system(.body, design: .rounded, weight: .semibold))
                    
                    Text("\(link)")
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
