//
//  ContentView.swift
//  AIChatBot
//
//  Created by Ashish Langhe on 08/11/23.
//

import SwiftUI
import OpenAISwift

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ChatView(models: models)
            Spacer()
            MessageInputView(text: $text) {
                send()
            }
        }
        .onAppear(){
            viewModel.setup()
        }
        .padding()
    }
    
    func send() {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        models.append("\nMe: \(text)")
        viewModel.sendMessage(text: text) { response in
            DispatchQueue.main.async {
                print("\nAPI Response: \(response)") // Print the response
                self.models.append("\nChatGPT: \(response)")
                self.text = ""
            }
        }
    }
}

#Preview {
    ContentView()
}
