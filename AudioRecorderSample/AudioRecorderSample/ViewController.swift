//
//  ViewController.swift
//  AudioRecorderSample
//
//  Created by vijay vir on 11/8/17.
//  Copyright © 2017 vijay vir. All rights reserved.
//

import UIKit
import Foundation
class ViewController: UIViewController  {
    
	@IBOutlet weak var lblTime: UILabel!
    
	let leoAudioPlayerAndRecorder = LeoAudioPlayerAndRecorder()
	
    override func viewDidLoad() {
        
		super.viewDidLoad()
        
		leoAudioPlayerAndRecorder.configure { ( isComplete ) in
             print(isComplete)
            
		}
        
        
		leoAudioPlayerAndRecorder.closureDidPauseAudioRecording = { isPause in
			print("🍩P🍩a🍩u🍩s🍩e")
		}
        
        
		leoAudioPlayerAndRecorder.closureDidFinisedAudioRecording = { (isFinish  ,path )in
			print("🍩isFinish🍩ed" , path ?? "NG")
		}
        
        
		leoAudioPlayerAndRecorder.closureDidStartAudioRecording = { (isStart,path ) in
			print("🍩isStart🍩ed" , path ?? "NG")
		}
        
	}
    
    
	@IBAction func actionStart(_ sender: UIButton) {
		leoAudioPlayerAndRecorder.startRecording({ second in
        self.lblTime.text = "\(second)"
		})
	}
    
    
	@IBAction func actionPause(_ sender: UIButton) {
		leoAudioPlayerAndRecorder.pauseRecording()
	}
    
    
	@IBAction func actionStop(_ sender: UIButton) {
        
    leoAudioPlayerAndRecorder.finishRecording()
        
	}
    @IBAction func actionAllRecoding(_ sender: UIButton) {
      
        let some = LeoAudioPlayerAndRecorder.getAllRecording()
        
        print(some)
        
    }
}
