//
//  EventDetailView.swift
//
//  Created by Caleb Kinney on 3/27/23.
//

import SwiftUI

struct EventDetailView2: View {
    let eventId: Int
    let bookmarks: [Int32]
    @EnvironmentObject var selected: SelectedConference
    @ObservedObject var viewModel = EventViewModel()
    var theme = Theme()
    // let event: Event

    @Environment(\.managedObjectContext) private var viewContext

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            if let event = viewModel.event {
                VStack(alignment: .leading) {
                    VStack(alignment: .center) {
                        Text(event.title).font(.largeTitle).bold()
                        VStack(alignment: .leading) {
                            HStack {
                                Circle().foregroundColor(event.type.swiftuiColor)
                                    .frame(width: 15, height: 15, alignment: .center)
                                Text(event.type.name).font(.subheadline).bold()
                            }
                            HStack {
                                Image(systemName: "clock")
                                Text("\(event.beginTimestamp.formatted(.dateTime.month().day().hour().minute())) - \(event.endTimestamp.formatted(.dateTime.month().day().hour().minute()))")
                                    .font(.subheadline).bold()
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.background)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                            HStack {
                                Image(systemName: "map")
                                Text(event.location.name).font(.subheadline).bold()
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.background)
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding()
                    .background(event.type.swiftuiColor.gradient)
                    .cornerRadius(15)
                }
                VStack(alignment: .leading) {
                    Text(event.description).padding()
                }
                VStack {
                    if event.speakers.count > 0 {
                        VStack(alignment: .center) {
                            Text("\(event.speakers.count > 1 ? "Speakers" : "Speaker")").font(.headline)
                        }.padding(.vertical)
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(event.speakers, id: \.id) { speaker in
                                NavigationLink(destination: SpeakerDetailView(id: speaker.id)) {
                                    Text(speaker.name)
                                        .padding(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(.foreground, lineWidth: 0.8)
                                        )
                                        .foregroundColor(theme.carousel())
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                
            } else {
                Text("...")
                    .onAppear {
                        viewModel.fetchData(code: selected.code, eventId: eventId)
                    }
            }
        }
        .toolbar {
            Button {
                if let event = viewModel.event {
                    if bookmarks.contains(Int32(event.id)) {
                        BookmarkUtility.deleteBookmark(context: viewContext, id: event.id)
                    } else {
                        BookmarkUtility.addBookmark(context: viewContext, id: event.id)
                    }
                }
            } label: {
                if let event = viewModel.event {
                    Image(systemName: bookmarks.contains(Int32(event.id)) ? "bookmark.fill" : "bookmark")
                }
            }
        }
        /* .toolbar {
            if let e = viewModel.event {
                ToolbarItem {
                    ShareView(event: e)
                }
                Button {
                    if bookmarks.contains(Int32(eventId)) {
                        BookmarkUtility.deleteBookmark(context: viewContext, id: eventId)
                    } else {
                        BookmarkUtility.addBookmark(context: viewContext, id: eventId)
                    }
                } label: {
                    if bookmarks.contains(Int32(eventId)) {
                        Image(systemName: "bookmark.fill")
                    } else {
                        Image(systemName: "bookmark")
                    }
                }
                MoreMenu(event: e)
            }
        } */
        .navigationBarTitle(Text(""), displayMode: .inline)
        .toolbar(.hidden, for: .tabBar)
                
    }
}

struct EventDetailView2_Previews: PreviewProvider {
    struct EventDetailPreview: View {
        let event = ScheduleViewModel().events[202]

        var body: some View {
            EventDetailView2(eventId: 48508, bookmarks: [1, 99]).preferredColorScheme(.dark)
        }
    }

    static var previews: some View {
        EventDetailPreview()
    }
}
