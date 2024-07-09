//
//  ContentView.swift
//  ChatBot
//
//  Created by Jeswanth Palleti on 08/07/24.
//

import SwiftUI

struct ChatView: View {
    @State var textInput = ""
    @State var logoAnimating = false
    @State var timer: Timer?
    @State var chatService = ChatService()
    
    var body: some View {
        VStack {
                HStack{
                    Spacer()
                    Image("bot.png")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 75)
                    Text("AI CHATBOT")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                        .foregroundStyle(Color.black)
                    Spacer()
                }
                // MARK: Chat message list
                ScrollViewReader(content: { proxy in
                    ScrollView(){
                        
                        ForEach(chatService.messages) { chatMessage in
                            // MARK: Chat message view
                            chatMessageView(chatMessage)
                            
                        }
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: chatService.messages) { _, _ in
                        guard let recentMessage = chatService.messages.last else { return }
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(recentMessage.id, anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: chatService.loadingResponse) { _, newValue in
                        if newValue {
                            startLoadingAnimation()
                        } else {
                            stopLoadingAnimation()
                        }
                    }
                })
                
                // MARK: Input fields
                HStack {
                    TextField("Search anything...", text: $textInput)
                        .foregroundStyle(Color.black)
                        .padding()
                        .overlay{
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5))
                                
                        }
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                }
            }
        
            .foregroundStyle(.white)
            .padding()
        }
    
        
        
        
        // MARK: Chat message view
        @ViewBuilder 
func chatMessageView(_ message: ChatMessage) -> some View {
    ChatBubble(direction: message.role == .model ? .left : .right) {
        Text(message.message)
            .font(.system(size: 16))
            .padding(.all, 15)
            .foregroundStyle(.white)
            .background(message.role == .model ? Color.blue : Color.green)
            .textSelection(.enabled)
    }
}
        
        // MARK: Fetch response
        func sendMessage() {
            chatService.sendMessage(textInput)
            textInput = ""
        }
        // MARK: Response loading animation
        func startLoadingAnimation() {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { timer in
                logoAnimating.toggle()
            })
        }
        
        func stopLoadingAnimation() {
            logoAnimating = false
            timer?.invalidate()
            timer = nil
        }
    }


#Preview {
    ChatView()
}

