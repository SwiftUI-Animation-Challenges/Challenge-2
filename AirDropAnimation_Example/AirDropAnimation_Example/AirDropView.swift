//
//  AirDropView.swift
//  AirDropAnimation_Example
//
//  Created by Shanmukh Phulari on 05/08/22.
//

import SwiftUI

//Progress status Enum
enum ProgressStatus {
    case none, notconnected, connecting, connected, started, completed
}

struct AirDropView: View {
    let size : CGSize
    let personName : String
    let personImage : UIImage
    let deviceName : String
    let progress : Double
    let progressStatus : ProgressStatus;
    
    //State variable
    @State var blinking = false;
    @State private var progressStatusText : String = getProgressStatusText(progress: .notconnected)
    @State private var progressStatusTextColor : Color = defaultProgressStatusTextColor
    @State private var backgroundProgressStrokeColor = progressGrayColor
    @State private var foregroundProgressStrokeColor = progressBlueColor
    @State private var imageBorderStrokeColor = progressBlackColor
    
    //Timer to do animation
    @State private var blinkTimer = Timer.publish(every: .infinity, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
    
    var body: some View {
        VStack {
            ZStack{
                //default progress circle
                Circle()
                    .stroke(backgroundProgressStrokeColor, lineWidth: size.width*stokeWidthRatio)
                    .background(Circle().fill(backgroundProgressColor))
                
                //progress circle
                Circle()
                    .trim(from: 0.0, to:progress)
                    .stroke(foregroundProgressStrokeColor, lineWidth: size.width*stokeWidthRatio)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration:progress), value: progress)
                
                //person image border
                Circle()
                    .inset(by: (size.width*stokeWidthRatio)/3)
                    .stroke(imageBorderStrokeColor, lineWidth: (size.width*stokeWidthRatio)/3)
                
                //persone image
                Image(uiImage: personImage)
                    .resizable()
                    .scaledToFit()
                
            }.padding()
            
            //Device name
            Text(deviceName)
                .font(.headline)
                .foregroundColor(defaultProgressStatusTextColor)
            
            //Progress status
            Text(progressStatusText)
                .font(.headline)
                .foregroundColor(progressStatusTextColor)
                .opacity(blinking ? 0 : 1)
                .animation(blinking ? .easeIn(duration: blinkTimerValue ) : .easeOut(duration: blinkTimerValue), value: blinking)
                .onReceive(blinkTimer, perform: { _ in
                    blinking = !blinking;
                })
            }
        .onChange(of: progressStatus, perform: { newValue in

            switch newValue {
                case .notconnected:
                    onNotConnected(status: newValue)
                case .connecting:
                    onConnecting(status: newValue)
                case .connected:
                    break
                case .started:
                    onStarted(status: newValue)
                case .completed:
                    //Adding delay to complete animation
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                        onFinish(status: newValue)
                    }
                case .none:
                    break
            }
        })
        .frame(width: size.width, height: size.height, alignment: .center)
    }
    
    private func onNotConnected(status:ProgressStatus) {
        
        //iphone connected
        progressStatusText = AirDropView.getProgressStatusText(progress: status) + personName;
        
        progressStatusTextColor = defaultProgressStatusTextColor
    
        //reset stroke color
        backgroundProgressStrokeColor = progressGrayColor
        foregroundProgressStrokeColor = progressBlueColor
        imageBorderStrokeColor = progressBlackColor
                
        //reset blinking
        blinkTimer.upstream.connect().cancel()
        blinkTimer = Timer.publish(every: .infinity, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()

    }
    
    private func onConnecting(status:ProgressStatus) {

        progressStatusText = AirDropView.getProgressStatusText(progress: status);
        
        progressStatusTextColor = defaultProgressStatusTextColor
        
        //reset blinking
        blinkTimer.upstream.connect().cancel()
        blinkTimer = Timer.publish(every: blinkTimerValue, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
    }
    
    private func onStarted(status:ProgressStatus) {
        
        //Stop blinking
        blinking = false;
        blinkTimer.upstream.connect().cancel()
        
        //iphone started sending
        progressStatusText = AirDropView.getProgressStatusText(progress: status);
         
        progressStatusTextColor = defaultProgressStatusTextColor
    }
    
    private func onFinish(status:ProgressStatus) {
        
        //iphone completes sending
        progressStatusText = AirDropView.getProgressStatusText(progress: status);
                
        progressStatusTextColor = completedProgressStatusTextColor
        
        withAnimation(Animation.easeOut(duration: 0.3).delay(1)) {
            backgroundProgressStrokeColor = Color.clear
            foregroundProgressStrokeColor = Color.clear
            imageBorderStrokeColor = Color.clear
        }
    }
    
    static func getProgressStatusText(progress:ProgressStatus) -> String {
        var returnValue = "";
        switch progress {
            case .notconnected:
                returnValue = "from ";
            case .connecting:
                returnValue = "Waiting...";
            case .connected:
                returnValue = "Connected";
            case .started:
                returnValue = "Sending..."
            case .completed:
                returnValue = "Sent"
            case .none:
                returnValue = ""
        }
        return returnValue;
    }

}

struct AirDropView_Previews: PreviewProvider {
    static var previews: some View {
        AirDropView(size: CGSize.zero, personName: "Amos", personImage: UIImage(named: "person")!, deviceName: "iPhone", progress: 0, progressStatus: .notconnected)
    }
}
