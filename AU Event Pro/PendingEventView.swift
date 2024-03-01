import SwiftUI
import FirebaseAuth

struct PendingEventView: View {
    
    @State var events = [Events]()
    @State private var isSignedOut: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(events, id: \.id) { event in
                            if !event.isApproved {
                                HStack {
                                    Text(event.name)
                                        .font(.system(size: 15))
                                    
                                    Spacer()
                                    Button(action: {
                                        EventViewModel.shared.approveEvent(id: event.id, adminId: UserDefaults.standard.string(forKey: "UserID")!)
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
                Button(action: {
                    isSignedOut = true
                }) {
                    Text("Sign Out")
                }
                .alert("Are you sure you want to sign out?", isPresented: $isSignedOut) {
                    Button("OK") {
                        UserDefaults.standard.removeObject(forKey: "UserID")
                        do {
                            try Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "signIn")
                        } catch let signOutError as NSError {
                            print("Error signing out: \(signOutError)")
                        }
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
        .onAppear {
            EventViewModel.shared.fetchEvent { events in
                self.events = events
            }
        }
    }
}


//struct PendingEventView: View {
//    
//    @State var events = [Events]()
//    @State private var currentUser = UserDefaults.standard.string(forKey: "UserID")
//    @State private var isSignedOut: Bool = false
//    @State private var storedUserId: String = ""
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                ScrollView {
//                    VStack {
//                        ForEach(events, id: \.id) { event in
//                            if event.isApproved == false {
//                                HStack {
//                                    Text(event.name)
//                                        .font(.system(size:15))
//                                    
//                                    Spacer()
//                                    Button(action: {
//                                        print(currentUser ?? "no user")
//                                        EventViewModel.shared.approveEvent(id: event.id, adminId: currentUser ?? "No user found")
//                                    }) {
//                                        Text("Approve")
//                                            .padding()
//                                            .frame(width: 100, height: 40)
//                                            .background(Color.green)
//                                            .foregroundColor(Color.white)
//                                            .cornerRadius(8)
//                                    }
//                                    
//                                    Button(action: {
//                                        // Action for the second button
//                                    }) {
//                                        Text("Reject")
//                                            .padding()
//                                            .frame(width: 100, height: 40)
//                                            .background(Color.red)
//                                            .foregroundColor(Color.white)
//                                            .cornerRadius(8)
//                                    }
//                                    
//                                }
//                                .padding()
//                            }
//                        }
//                    }
//                    .padding(.top, 20)
//                }
//                Button{
//                    UserDefaults.standard.removeObject(forKey: "UserID")
//                    do{
//                        try Auth.auth().signOut()
//                        UserDefaults.standard.set(false, forKey: "signIn")
//                    }catch let signOutError as NSError {
//                        print("Error signing out: %@", signOutError)
//                    }
//                }label: {
//                    Text("Sign Out")
//                }
//            }
//        }
//        .onAppear {
//            EventViewModel.shared.fetchEvent { events in
//                self.events = events
//            }
//        }
//    }
//}

#Preview {
    PendingEventView()
}
