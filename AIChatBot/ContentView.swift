//
//  ContentView.swift
//  AIChatBot
//
//  Created by Ashish Langhe on 08/11/23.
//

import SwiftUI
import OpenAISwift

final class ViewModel: ObservableObject {
    
    init() {}
    
    private var client: OpenAISwift?
    
    func setup() {
        client = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: "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"))
    }
    
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 500, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(output)
            case .failure:
                break
            }
        })
    }
}

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @State var text = ""
    @State var models = [String]()
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(models.indices, id: \.self) { index in
                Text(models[index])
            }
            
            Spacer()
            
            HStack {
                TextField("Type here...", text: $text)
                Button("Send") {
                    send()
                }
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
        viewModel.send(text: text) { response in
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
