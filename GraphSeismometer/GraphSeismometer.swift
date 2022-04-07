import SwiftUI

struct GraphSeismometer: View {
    @StateObject private var detector = MotionDetector(updateInterval: 0.01)
    @State private var data = [Double]()
    let maxData = 1000

    let graphMaxValue = 1.0
    let graphMinValue = -1.0

    var body: some View {
        VStack {
            Spacer()
            LineGraph(data: data, maxData: maxData)
                .clipped()
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(20)
                .padding()
                .aspectRatio(1, contentMode: .fit)
            
            Spacer()
            
            Text("Set your device on a flat surface to record vibrations using its motion sensors.")
                .padding()
            
            Spacer()
        }
        .onAppear() {
            detector.start()
            detector.onUpdate = {
                data.append(-detector.zAcceleration)
                if data.count > maxData {
                    data = Array(data.dropFirst())
                }
            }

        }
        .onDisappear {
            detector.stop()
        }
    }
}

struct GraphSeismometer_Previews: PreviewProvider {
    @StateObject static private var detector = MotionDetector(updateInterval: 0.01).started()

    static var previews: some View {
        GraphSeismometer()
            .environmentObject(detector)
    }
}
