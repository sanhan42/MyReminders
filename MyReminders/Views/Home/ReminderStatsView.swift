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
                        .foregroundColor(iconColor)
                        .font(.title)
                    Text(title)
                        .bold()
                        .opacity(0.8)
                }
                Spacer()
                if let count {
                    Text("\(count)")
                        .font(.largeTitle)
                }
            }.padding(10)
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray3)) // TODO: 위에 글자색과 함께 조정 필요
                .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
        }
    }
}

struct ReminderStatsView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderStatsView(icon: "calendar", title: "오늘", count: 9)
    }
}
