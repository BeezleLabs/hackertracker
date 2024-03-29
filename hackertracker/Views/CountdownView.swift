//
//  CountdownView.swift
//  hackertracker
//
//  Created by Seth Law on 7/3/23.
//

import SwiftUI

struct CountdownView: View {
    let start: Date
    @State private var countdownTimer: CountdownComps?

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("\(countdownTimer?.days ?? 0)").font(.title).foregroundColor(ThemeColors.pink)
                Text("days").font(.caption).foregroundColor(.primary)

                Text("\(countdownTimer?.hours ?? 0)").font(.title).foregroundColor(ThemeColors.blue)
                Text("hours").font(.caption).foregroundColor(.primary)

                Text("\(countdownTimer?.minutes ?? 0)").font(.title).foregroundColor(ThemeColors.green)
                Text("min").font(.caption).foregroundColor(.primary)

                Text("\(countdownTimer?.seconds ?? 0)").font(.title).foregroundColor(ThemeColors.red)
                Text("sec").font(.caption).foregroundColor(.primary)
            }
        }.frame(maxWidth: .infinity)
            .accentColor(.primary)
            .background(Color(.systemGray5))
            .cornerRadius(5)
            .onAppear {
                countdownTimer = getCountdown(start: start)
            }
            .onReceive(timer) { _ in
                withAnimation {
                    countdownTimer = getCountdown(start: start)
                }
            }
    }
}

struct CountdownComps {
    var days: Int
    var hours: Int
    var minutes: Int
    var seconds: Int
}

func getCountdown(start: Date) -> CountdownComps {
    let timeUntilConfStart = start.timeIntervalSinceNow

    let day = timeUntilConfStart / (24 * 60 * 60)
    let hour = day.truncatingRemainder(dividingBy: 1) * 24
    let min = hour.truncatingRemainder(dividingBy: 1) * 60
    let sec = min.truncatingRemainder(dividingBy: 1) * 60

    return CountdownComps(
        days: Int(day.rounded(.down)),
        hours: Int(hour.rounded(.down)),
        minutes: Int(min.rounded(.down)),
        seconds: Int(sec.rounded(.down))
    )
}

struct Countdown_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(start: getPreviewStart())
    }
}

func getPreviewStart() -> Date {
    let newFormatter = ISO8601DateFormatter()
    let date = newFormatter.date(from: "2022-08-11T00:00:00-0700")
    return date ?? Date()
}
