//
//  LeoAudioPlayerAndRecorder.swift
//  AudioRecorderSample
//
//  Created by vijay vir on 11/9/17.
//  Copyright © 2017 vijay vir. All rights reserved.
//

// Add this line to project pList to access contact with user  permisssions.
/*
<key>NSMicrophoneUsageDescription</key>
<string>Need microphone access for uploading videos</string>
*/

import UIKit
import Foundation
import AVFoundation

class LeoAudioPlayerAndRecorder : NSObject  {

    static let rootFolder: String = "\(NSTemporaryDirectory())LeoAudioFiles/"  
    
    static func removeCache() {
        
        let fileManger = FileManager.default
        
        // Delete 'subfolder' folder
        
        do {
            try fileManger.removeItem(atPath: LeoAudioPlayerAndRecorder.rootFolder)
            
        } catch let error as NSError {
            
            print("Ooops! Something went wrong: \(error)")
            
        }
    }

	static func openSettings() {
        
		UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:]) { (isSucess) in
		}
        
	}
    
    private class func audioPath() -> String {
        
        let fileManger = FileManager.default
        
        if !fileManger.fileExists(atPath: rootFolder) {
            do {
                try fileManger.createDirectory(atPath: "\(rootFolder)", withIntermediateDirectories: false, attributes: nil)
                
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        } else {
            print("file  exit ")
        }
        
        return rootFolder
    }
    

	static func getDocumentsDirectory() -> URL {
        
        let some  : URL = URL(fileURLWithPath: LeoAudioPlayerAndRecorder.audioPath())
        
		return some
	}
    static func getAllRecording() -> [String] {
        
        let enumerator = FileManager.default.enumerator(atPath:  LeoAudioPlayerAndRecorder.audioPath())
        
        let filePaths = enumerator?.allObjects as! [String]
        
        return filePaths
        
    }
    
    var timer: Timer?
	var second : Int =  0
	var recordingSession: AVAudioSession!
	var audioRecorder: AVAudioRecorder!
	var audioFilename  : URL?
    
	var closureDidStartAudioRecording :((Bool ,  URL?) -> Void)?
	var closureDidPauseAudioRecording :((Bool) -> Void)?
	var closureDidResumeAudioRecording :((Bool) -> Void)?
	var closureDidFinisedAudioRecording :(( _ reRecord :Bool ,  URL?) -> Void)?
    
    
	func configure( _ completionHandler : @escaping (Bool) -> Void  ){

		recordingSession = AVAudioSession.sharedInstance()

		do {

			try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)

			try recordingSession.setActive(true)

			recordingSession.requestRecordPermission() { [unowned self] allowed in

				DispatchQueue.main.async {

					completionHandler(allowed)

				}
			}
		} catch {
			// failed to record!

			completionHandler(false)

		}
	}

//MARK:  Actions related to Recording

	func path() -> URL? {
		return audioFilename
	}
	func finishRecording() {

			finishRecording(success: true)

			closureDidFinisedAudioRecording?(true , audioFilename)

	}
	func startRecording( _ time : @escaping (Int) -> Void , path : String? =  "\(NSUUID().uuidString)" , exten : String? =  ".m4a" ) {

		 audioFilename = LeoAudioPlayerAndRecorder.getDocumentsDirectory().appendingPathComponent("\(String(describing: path!))\(String(describing: exten!))")

		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]
		do {
			audioRecorder = try AVAudioRecorder(url: audioFilename!, settings: settings)
			audioRecorder.delegate = self
			audioRecorder.record()
			
			if timer != nil {
				 second = 0
	       timer?.invalidate()
				 timer = nil
			}

		  second = 0

			timer =  Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (currentTimer) in

				self.second += 1
				time(self.second)

			})

			closureDidStartAudioRecording?(true,audioFilename  )

		} catch {

			closureDidStartAudioRecording?(false , audioFilename)

			finishRecording(success: false)
		}
	}

	func pauseRecording(){

		audioRecorder.pause()
		closureDidPauseAudioRecording?(true)
	}

	func isRecording() -> Bool{
		return audioRecorder.isRecording
	}

	func finishRecording( success: Bool) {

		audioRecorder.stop()
		audioRecorder = nil

		if timer != nil {
			timer?.invalidate()
			timer = nil
		}

		if success {
			closureDidFinisedAudioRecording?(true , audioFilename)
		} else {
			closureDidFinisedAudioRecording?(false , audioFilename)
		}

	}
}
extension LeoAudioPlayerAndRecorder  : AVAudioRecorderDelegate {

	func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
		if !flag {
			finishRecording(success: false)
		} else {
		}
	}

}


