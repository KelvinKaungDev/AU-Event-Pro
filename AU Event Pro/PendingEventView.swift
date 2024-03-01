import SwiftUI
import FirebaseAuth

struct PendingEventView: View {
    
    @State var events = [Events]()
    @State private var currentUser = UserDefaults.standard.string(forKey: "UserID")
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
        
                    ForEach(events, id: \.id) { event in
                        if event.isApproved == false {
                            HStack {
                                Text(event.name)
                                    .font(.system(size:15))
                                
                                Spacer()
                                Button(action: {
                                    print(currentUser)
                                    EventViewModel.shared.approveEvent(id: event.id, adminId: currentUser ?? "No user found")
                                }) {
                                    Text("Approve")
                                        .padding()
                                        .frame(width: 100, height: 40)
                                        .background(Color.green)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(8)
                                }
                                
                                Button(action: {
                                    // Action for the second button
                                }) {
                                    Text("Reject")
                                        .padding()
                                        .frame(width: 100, height: 40)
                                        .background(Color.red)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(8)
                                }
                            }
                            .padding()
                        }
                    }
                }
                    .padding(.top, 20)
            }
            .navigationTitle("Pending Event Lists")
        }
        .onAppear {
            EventViewModel.shared.fetchEvent { events in
                self.events = events
            }
        }
    }
}

#Preview {
    PendingEventView()
}
