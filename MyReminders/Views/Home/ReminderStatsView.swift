//
//  ReminderStatsView.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/15.
//

import SwiftUI

struct ReminderStatsView: View {
    
    let icon: String
    var title: String
    var count: Int?
    var iconColor: Color = .blue
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: icon)
                        .dynamicTypeSize(.xSmall)
                        .foregroundColor(Color(.white))
                        .font(.title)
                        .padding(8)
                        .background {
                            Circle()
                                .foregroundColor(iconColor)
                        }
                    Text(title)
                        .font(.title3)
                        .bold()
                        .opacity(0.8)
                        .padding([.leading], 4)
                }
                Spacer()
                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }.padding(12)
                .frame(maxWidth: .infinity)
                .foregroundColor(Color(.label))
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        }
    }
}

struct ReminderStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderStatsView(icon: "calendar", title: "오늘", count: 9)
    }
}
