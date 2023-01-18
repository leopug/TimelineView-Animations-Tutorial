import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TimelineView(.animation) { context in
                VStack {
                    WaveView()
                        .frame(width: 405, height: 200)
                    WaveView()
                        .frame(width: 200, height: 150)
                    WaveView()
                        .frame(width: 50, height: 100)
                    
                    MyCustomView(timeInterval: context.date.timeIntervalSince1970)
                }
            }
        }
        .padding()
    }
}

struct MyCustomView: View {
    var timeInterval: TimeInterval
    @Namespace private var namespace
    
    var body: some View {
        Group {
            let isCircleCentered = floor(timeInterval.truncatingRemainder(dividingBy: 2)) == 0
            
            if isCircleCentered {
                Circle()
                    .matchedGeometryEffect(id: "shape", in: namespace)
                    .frame(width: 200, height: 200)
            }
            
            Spacer()
            
            if !isCircleCentered {
                HStack {
                    Spacer()
                    Circle()
                        .matchedGeometryEffect(id: "shape", in: namespace)
                    .frame(width: 80, height: 80)
                }
            }
        }.animation(.linear, value: timeInterval)
    }
}

struct WaveView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let angle = Angle.degrees(timeline.date.timeIntervalSinceReferenceDate.remainder(dividingBy: 4) * 180)
                let cos = (cos(angle.radians)) * 25
                let sin = (sin(angle.radians)) * 19
                
                let width = size.width
                let height = size.height
                
                context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white))
                
                let path = Path { path in
                    path.move(to: CGPoint(x: 0 , y: size.height/2 ))
                    path.addCurve(to: CGPoint(x: width, y: size.height/2),
                                  control1: CGPoint(x: width * 0.4 , y: height * 0.2 - cos),
                                  control2: CGPoint(x: width * 0.6 , y: height * 0.8 + sin))
                }
                
                context.stroke(
                    path,
                    with: .linearGradient(Gradient(colors: [.red, .blue]),
                                          startPoint: .zero ,
                                          endPoint: CGPoint(x: size.width, y: size.height)
                                         ), lineWidth: 2
                )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
