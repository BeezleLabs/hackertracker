//
//  OrgView.swift
//  hackertracker
//
//  Created by Seth W Law on 7/10/23.
//

import MarkdownUI
import SwiftUI
import Kingfisher

struct OrgView: View {
    var org: Organization
    @EnvironmentObject var theme: Theme

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(org.name)
                        .font(.title)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                .background(Color(.systemGray6))
                .cornerRadius(15)
                Divider()
                if org.media.count > 0 {
                    HStack {
                        ForEach(org.media, id: \.assetId) { m in
                            if let url = URL(string: m.url) {
                                KFImage(url)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .infinity)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
                Markdown(org.description)
                Divider()
                if org.links.count > 0 {
                    showLinks(links: org.links)
                }
            }
        }
        .padding(5)
    }
}

struct showLinks: View {
    var links: [Link]
    @Environment(\.openURL) private var openURL
    @State private var collapsed = false
    @EnvironmentObject var theme: Theme

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                collapsed.toggle()
            }, label: {
                HStack {
                    Text("Links")
                        .font(.headline).padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    collapsed ? Image(systemName: "chevron.right") : Image(systemName: "chevron.down")
                }
            }).buttonStyle(BorderlessButtonStyle()).foregroundColor(.white)
            if !collapsed {
                VStack(alignment: .leading) {
                    ForEach(links, id: \.label) { link in
                        if let url = URL(string: link.url) {
                            Button {
                                openURL(url)
                            } label: {
                                if link.label != "" {
                                    Label(link.label, systemImage: "arrow.up.right.square")
                                } else {
                                    Label(link.url, systemImage: "link")
                                }
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(theme.carousel())
                            .cornerRadius(15)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct OrgView_Preview: PreviewProvider {
    static var previews: some View {
        DocumentView(title_text: "Title of Document", body_text: "Go ahead and add *markdown* to make things interesting if you want")
    }
}