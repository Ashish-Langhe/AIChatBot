//
//  MessageInputView.swift
//  AIChatBot
//
//  Created by Ashish Langhe on 09/11/23.
//

import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    var send: () -> Void
    
    var body: some View {
        HStack {
            TextField("Type here...", text: $text)
            Button("Send") {
                send()
            }
        }
    }
}
