//
//  ContentView.swift
//  AirDropAnimation_Example
//
//  Created by Shanmukh Phulari on 05/08/22.
//

import SwiftUI

struct ContentView: View {
    
    //State variable
    @State var startAirDropAnimation : Bool = false
    @State var progress : Double = 0.0
    @State private var progressStatus : ProgressStatus = .none; //Default: iphone not connected

    //Timer to do animation
    @State private var progressTimer = Timer.publish(every: 1, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
        
    var body: some View {
        ZStack {
            progressBlackColor.ignoresSafeArea()
            VStack {
                Text("Tap on icon to start animation").padding().foregroundColor(defaultProgressStatusTextColor)
                
                //AirDrop View
                AirDropView(size: CGSize.init(width: 200, height: 200),
                            personName: "Amos",
                            personImage: UIImage(named: "person")!,
                            deviceName: "iPhone",
                            progress: progress,
                            progressStatus: progressStatus)
                    .onReceive(progressTimer) { _ in
                        if(startAirDropAnimation) {
                            if(progressStatus == .started) {
                                if (progress <= 1) {
                                    progress += 0.05;
                                }else {
                                    //completes sending
                                    progressStatus = .completed;
                                    
                                    //Cancel progress timer
                                    progressTimer.upstream.connect().cancel();
                                    
                                    startAirDropAnimation = false
                                }
                            }else if(progressStatus == .notconnected) {
                                //connecting
                                progressStatus = .connecting;

                                //start waiting timer
                                progressTimer.upstream.connect().cancel()
                                progressTimer = Timer.publish(every: waitingTimerValue, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
                                
                            }else if(progressStatus == .connecting) {
                                //started sending data
                                progressStatus = .started;
                               
                                //start progress timer
                                progressTimer = Timer.publish(every: progressTimerValue, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
                            }
                        }
                    }
                    .padding()
                    .onTapGesture {

                        startAirDropAnimation = !startAirDropAnimation
                        
                        //reset values
                        progress = 0.0
                        progressStatus = .notconnected
                        progressTimer = Timer.publish(every: 1, tolerance: 0, on: .main, in: RunLoop.Mode.common, options: nil).autoconnect()
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
