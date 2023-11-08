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
//            ForEach (models, id:\.self) { string in
//                Text(string)
//            }
//            
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

        models.append("Me: \(text)")
        viewModel.send(text: text) { response in
            DispatchQueue.main.async {
                print("API Response: \(response)") // Print the response
                self.models.append("ChatGPT: \(response)")
                self.text = ""
            }
        }
    }
}

#Preview {
    ContentView()
}
