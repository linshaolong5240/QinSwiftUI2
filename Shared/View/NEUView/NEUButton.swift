//
//  NEUButton.swift
//  Qin
//
//  Created by 林少龙 on 2020/9/14.
//

import SwiftUI

#if DEBUG
struct NEUButton: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct NEUButton_Previews: PreviewProvider {
    static var previews: some View {
        NEUButton()
    }
}
#endif

struct NEUBackwardButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            NEUButtonView(systemName: "chevron.backward" ,size: .medium)
        }
        .buttonStyle(NEUButtonStyle(shape: Circle()))
    }
}

struct NEUEditButton: View {
    @Environment(\.editMode) var editModeBinding:  Binding<EditMode>?
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if editModeBinding?.wrappedValue.isEditing ?? false {
                editModeBinding?.wrappedValue = .inactive
                action()
            }else {
                editModeBinding?.wrappedValue = .active
            }
        }) {
            NEUButtonView(systemName: "square.and.pencil", size: .small, active: editModeBinding?.wrappedValue.isEditing ?? false)
        }
        .buttonStyle(NEUButtonToggleStyle(isHighlighted: editModeBinding?.wrappedValue.isEditing ?? false, shape: Circle()))
    }
}