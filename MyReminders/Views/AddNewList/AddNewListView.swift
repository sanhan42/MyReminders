//
//  AddNewListView.swift
//  MyReminder
//
//  Created by 한상민 on 2023/02/07.
//

import SwiftUI

struct AddNewListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var selectedColor: Color = .yellow
    
    let onSave: (String, UIColor) -> Void
    
    private var isFormValid: Bool {
        !name.isEmptyOrWhitespace
    }
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "line.3.horizontal.circle.fill")
                    .foregroundColor(selectedColor)
                    .font(.system(size: 100))
                TextField("목록 이름", text: $name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(30)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            
            ColorPickerView(selectedColor: $selectedColor)
            
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("새로운 목록")
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing ) {
                    Button("완료") {
                        onSave(name, UIColor(selectedColor))
                        dismiss()
                    }.disabled(!isFormValid)
                }
            }
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddNewListView { _, _ in
                
            }
        }
    }
}
