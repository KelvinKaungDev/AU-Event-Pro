
import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct SignInWithGoogleView: View {
    @StateObject private var vm = FirebAuthViewModel()
    @State private var isRegistered = false
    @State private var showRegistration = false
    @State private var errorMessage: String? = nil
//    @ObservedObject private var userViewModel = UserViewModel()
    
    var body: some View {
        VStack {
            if isRegistered {
                PendingEventView()
            } else {
                loginViewContent
            }
        }
    }

    private var loginViewContent: some View {
        VStack {
            Text("events.au")
                .fontWeight(.bold)
                .font(.system(size: 24))
                .overlay(
                    LinearGradient(gradient: Gradient(colors: [Color("red_primary"), Color("red_secondary")]), startPoint: .top, endPoint: .bottom)
                        .mask(Text("events.au").fontWeight(.bold).font(.system(size: 24)))
                )
            
            
            Image("OnBoardingPhoto")
                .resizable()
                .frame(width: 400, height: 400)
             
            HStack{
                Text("By clicking the continue with google button, you’re agree to events.au’s ").font(.system(size: 15))
                    + Text("Terms and Service").bold().font(.system(size: 15))
                    + Text(" and acknowledge the ").font(.system(size: 15))
                    + Text("Privacy and Policy.").bold()
                    .font(.system(size: 15))
            }
            .padding()
                
            
            Button{
                signInWithGoogle()
            }label: {
                ZStack{
                    Rectangle()
                        .foregroundColor(.white)
                        .cornerRadius(30)
                        .shadow(color: .gray, radius: 6, x: 0, y: 6)
                        .frame(maxWidth: 350, maxHeight: 60)
                        .padding()
                    HStack{
                        Image("google")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 50, maxHeight: 50)
                        Text("Sign In with Google")
                            .tint(Color.black)
                            .font(.title3)
                            .fontWeight(.bold)
                    }
                }
            }
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding(.top, 52)
    }

    private func signInWithGoogle() {
        vm.signInWithGoogle(presenting: Application_utility.rootViewController) { error, isNewUser in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }
                if isNewUser {
                    self.showRegistration = true
                } else {
                    self.isRegistered = true
                }
            }
        }
    }
}

#Preview {
    SignInWithGoogleView()
}
