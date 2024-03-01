
import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import FirebaseFirestore

class FirebAuthViewModel: ObservableObject {
    
    init() {
        // Initialization
    }
    
    private func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: "UserID")
        print("User ID saved to UserDefaults: \(userId)")
    }
    
    func postUserId(userId: String) {
        guard let url = URL(string: "https://events-au.vercel.app/admin/signInWithGoogle") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["id": userId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                print(response)
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let message = jsonResponse["message"] as? [String: Any],
                           let userId = message["_id"] as? String {
                            //                            self.saveUserId(userId: userId)
                            self.saveUserId(userId)
                            print("Got the user id: \(userId)")
                        } else {
                            print("Error 403")
                        }
                    } catch {
                        print("Error 402")
                    }
                } else {
                    print("Error 401")
                }
            }
        }.resume()
    }
    
    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Error?, Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: Application_utility.rootViewController) { user, error in
            if let error = error {
                // Handle the error if Google Sign-In failed
                DispatchQueue.main.async {
                    completion(error, false)
                }
                return
            }
            
            guard let user = user?.user, let idToken = user.idToken else {
                // If user is nil, it means the user cancelled the Google Sign-In
                // Do not proceed with Firebase authentication
                DispatchQueue.main.async {
                    completion(nil, false)
                }
                return
            }
            
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            // Continue with Firebase authentication
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    DispatchQueue.main.async {
                        completion(error, false)
                    }
                    return
                }
                
                guard let authResult = authResult else {
                    DispatchQueue.main.async {
                        completion(NSError(domain: "FirebaseAuthError", code: -1, userInfo: nil), false)
                    }
                    return
                }
                
                let isNewUser = authResult.additionalUserInfo?.isNewUser ?? false
                DispatchQueue.main.async {
                    completion(nil, isNewUser)
                }
                
                if !isNewUser{
                    UserDefaults.standard.set(true, forKey: "signIn")
                    // Post Google Auth Current User ID
                    let userId = authResult.user.uid
                    self.postUserId(userId: userId)
                    
                }
            }
        }
    }
}

