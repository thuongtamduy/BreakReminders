import SwiftUI

struct MovingGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [.teal, .blue, .purple]),
            startPoint: animate ? .topLeading : .bottomLeading,
            endPoint: animate ? .bottomTrailing : .topTrailing
        )
        .ignoresSafeArea()
        .onAppear {
            withAnimation(Animation.linear(duration: 10.0).repeatForever(autoreverses: true)) {
                animate.toggle()
            }
        }
    }
}

struct EyeExerciseView: View {
    @State private var t: Double = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        // Lemniscate of Bernoulli (Infinity Symbol ♾️)
        let a: CGFloat = 300 // Scale factor
        let x = (a * cos(t)) / (1 + pow(sin(t), 2))
        let y = (a * sin(t) * cos(t)) / (1 + pow(sin(t), 2))
        
        return Circle()
            .fill(Color.white)
            .frame(width: 16, height: 16)
            .shadow(color: .teal, radius: 10)
            .shadow(color: .blue, radius: 20)
            .offset(x: x, y: y)
            .onAppear {
                // OPTIMIZATION: Use a local timer that starts on appear and stops on disappear
                // to prevent background CPU usage when the window is closed.
                timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                    t += 0.015
                    if t > 2 * .pi {
                        t = 0
                    }
                }
            }
            .onDisappear {
                timer?.invalidate()
                timer = nil
            }
    }
}

struct BreakView: View {
    @EnvironmentObject var timerEngine: TimerEngine
    @AppStorage("enableEffects") var enableEffects: Bool = true
    @AppStorage("enableEyeExercise") var enableEyeExercise: Bool = true
    
    var body: some View {
        ZStack {
            if enableEffects {
                MovingGradientBackground()
            } else {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
            }
            
            VisualEffectView(material: .hudWindow, blendingMode: .withinWindow)
                .ignoresSafeArea()
            
            // Eye exercise dot moving in the background
            if enableEyeExercise {
                EyeExerciseView()
            }
            
            VStack(spacing: 40) {
                Text("Time to Rest")
                    .font(.system(size: 48, weight: .thin, design: .rounded))
                    .foregroundColor(.white)
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.1), lineWidth: 10)
                        .frame(width: 200, height: 200)
                    
                    Circle()
                        .trim(from: 0, to: CGFloat(timerEngine.breakRemaining) / CGFloat(timerEngine.breakDuration))
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.teal, .blue, .purple, .teal]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 10, lineCap: .round)
                        )
                        .frame(width: 200, height: 200)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1.0), value: timerEngine.breakRemaining)
                    
                    Text("\(timerEngine.breakRemaining)")
                        .font(.system(size: 64, weight: .light, design: .rounded))
                        .foregroundColor(.white)
                }
                
                VStack(spacing: 10) {
                    Text("Look away 20 feet into the distance.")
                        .font(.system(size: 20, weight: .light, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    
                    if enableEyeExercise {
                        Text("Keep your head still and follow the moving dot with your eyes.")
                            .font(.system(size: 16, weight: .light, design: .rounded))
                            .foregroundColor(.teal)
                    }
                }
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
