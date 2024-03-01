import SwiftUI

@main
struct AU_Event_ProApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("signIn") var isSignIn = false
    @AppStorage("Is First Time User") var firstTimeUser = false
    
    var body: some Scene {
        WindowGroup {
            
            if !firstTimeUser{
                OnboardingView()
            }else{
                if isSignIn{
                    PendingEventView()
                }else{
                    SignInWithGoogleView()
                }
            }
        }
    }
}
