//
//  GlobalSearchView.swift
//  hackertracker
//
//  Created by Caleb Kinney on 7/4/23.
//

import SwiftUI

struct GlobalSearchView: View {
    let viewModel: InfoViewModel
    @State private var searchText = ""
    @EnvironmentObject var theme: Theme
    @FetchRequest(sortDescriptors: []) var bookmarks: FetchedResults<Bookmarks>

    var body: some View {
            List {
                if !searchText.isEmpty {
                    Section(header: Text("Events")) {
                        ForEach(viewModel.events.search(text: searchText), id: \.id) { event in
                            NavigationLink(destination: EventDetailView(eventId: event.id, bookmarks: bookmarks.map { $0.id })) {
                                EventCell(event: event, bookmarks: bookmarks.map { $0.id })
                            }
                        }
                    }

                    Section(header: Text("Speakers")) {
                        ForEach(viewModel.speakers.search(text: searchText).sorted {
                            $0.name < $1.name
                        }, id: \.id) { speaker in
                            NavigationLink(destination: SpeakerDetailView(id: speaker.id)) {
                                SpeakerRow(speaker: speaker, themeColor: theme.carousel())
                            }
                        }
                    }

                    if let ott = self.viewModel.tagtypes.first(where: { $0.category == "orga" }) {
                        ForEach(ott.tags, id: \.id) { tag in
                            Section(header: Text(tag.label)) {
                                ForEach(self.viewModel.orgs.filter { $0.tag_ids.contains(tag.id) }.search(text: searchText).sorted {
                                    $0.name < $1.name
                                }, id: \.id) { org in
                                    NavigationLink(destination: DocumentView(title_text: org.name, body_text: org.description)) {
                                        orgSearchRow(org: org, themeColor: theme.carousel())
                                    }
                                }
                            }
                        }
                    }

                    if viewModel.faqs.count > 0 {
                        Section(header: Text("FAQ")) {
                            ForEach(self.viewModel.faqs.search(text: searchText)) { faq in
                                faqRow(faq: faq)
                            }
                        }
                    }

                    if viewModel.news.count > 0 {
                        Section(header: Text("News")) {
                            ForEach(self.viewModel.news.search(text: searchText).sorted {
                                $0.updatedAt < $1.updatedAt
                            }) { article in
                                articleRow(article: article)
                            }
                        }
                    }
                }
        }
            .listStyle(SidebarListStyle())
        .navigationTitle("Global Search")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}
