import SwiftUI

struct OnboardingStep{
    var id = UUID()
    let image: String
    let title: Text
    let buttonText: String
    let tag: Int
}

private let onboardingSteps = [
    OnboardingStep(
        image: "onboarding_image1",
        title: Text("Find Your \nExcitement \nwith \(Text("events.au").foregroundColor(Color("text_color_red")))")
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.system(size: 40)),
        buttonText: "Get Started", tag: 1),
    
    OnboardingStep(
        image: "onboarding_image2",
        title: Text("Effortlessly \nPlan & Manage \nYour \(Text("events").foregroundColor(Color("text_color_red")))")
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.system(size: 40)),
        buttonText: "Next", tag: 2),
    OnboardingStep(
        image: "onboarding_image3",
        title: Text("Discover the \n\(Text("events").foregroundColor(Color("text_color_red"))) awaiting \ninside ")
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.system(size: 40)),
        buttonText: "Start Exploring", tag: 3)
]

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var shouldNavigateHome = false
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentStep){
                ZStack{
                    Image(onboardingSteps[currentStep].image)
                        .resizable()
                        .ignoresSafeArea()
                        .overlay {
                            LinearGradient(gradient: Gradient(colors: [Color("red_primary").opacity(0.5), .black.opacity(0.6), .black.opacity(0.6), .black.opacity(0.6)]),
                                           startPoint: .top,
                                           endPoint: .bottom)
                            .ignoresSafeArea()
                        }
                    
                    VStack {
                        Spacer()
                        onboardingSteps[currentStep].title
                            .offset(x: -30)
                        HStack{
                            ForEach(0..<onboardingSteps.count, id: \.self){ it in
                                if it == currentStep{
                                    Rectangle()
                                        .frame(width: 20, height: 10)
                                        .cornerRadius(10)
                                        .foregroundStyle(Color("red_primary"))
                                }
                                else{
                                    Circle()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.white)
                                }
                            }
                        }.offset(x: -130)
                        Spacer()
                        NavigationLink(destination: SignInWithGoogleView(), isActive: $shouldNavigateHome) {
                            Button(action: {
                                if self.currentStep < onboardingSteps.count - 1{
                                    self.currentStep += 1
                                } else{
                                    self.shouldNavigateHome = true
                                    UserDefaults.standard.set(true, forKey: "Is First Time User")
                                }
                                
                            }, label: {
                                RoundedRectangle(cornerRadius: 50)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color("red_primary"),
                                                     Color("red_secondary")],
                                            startPoint: .top,
                                            endPoint: .bottom)
                                    )
                                    .frame(width: 300, height: 50)
                                    .overlay(
                                        Text(onboardingSteps[currentStep].buttonText)
                                            .foregroundColor(.white)
                                        , alignment: .center
                                    )
                                
                            })
                        }
                        
                    }
                }
            }
            .ignoresSafeArea()
        }
        
    }
}

#Preview {
    OnboardingView()
}

