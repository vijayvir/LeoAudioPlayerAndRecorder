#  LeoAudioPlayerAndRecorder 
In this class , developer can record and play the recording .



## Following are the features of this class for Recorder 


* Start , play , stop the recording.
* Track of the recording states through following closures.
* Get the list of all recording.
* Remove all recording.
* Get the audio file address at start of recording and end of recording. 

## How to use ?

 *  Add following line in `.plist` to get the premission of recording from the device  user.   
  
   ```swift  
 	  <key>NSMicrophoneUsageDescription</key>
   		<string>Need microphone access for uploading videos</string>
   ```


 *  Make an object of `LeoAudioPlayerAndRecorder()`

 ```swift 
 	let leoAudioPlayerAndRecorder = LeoAudioPlayerAndRecorder()
 ```
 * Configure the object 
 
 ```swift
 	leoAudioPlayerAndRecorder.configure { ( isComplete ) in
             print(isComplete)
            
		} 
 ```
* Next steps add the states changing closure for the object.

```swift 

 // Start of recrding , Here path will recived .
		leoAudioPlayerAndRecorder.closureDidStartAudioRecording = { (isStart,path ) in
			print("🍩isStart🍩ed" , path ?? "NG")
		}
		
 //  Pause the recoding 
		leoAudioPlayerAndRecorder.closureDidPauseAudioRecording = { isPause in
			print("🍩P🍩a🍩u🍩s🍩e")
		}
        
         //  finish  the recoding .   Here path will recived .
		leoAudioPlayerAndRecorder.closureDidFinisedAudioRecording = { (isFinish  ,path )in
			print("🍩isFinish🍩ed" , path ?? "NG")
		}
``` 
 
  * Various action for reording 
     * Start of recording 
     
       ```swift 
          leoAudioPlayerAndRecorder.startRecording({ second in
          
          // Here time will recived in seconds , To show how much the recording is done. 
            self.lblTime.text = "\(second)"
            
		     })
		

       ```
    
     * Pause of recording.
     
       ```swift 
       
          leoAudioPlayerAndRecorder.pauseRecording()
		
       ```
       
          
     * Finish  of recording. 
     
       ```swift 
       
          leoAudioPlayerAndRecorder.finishRecording()
		

       ```
     
     
 * Get list of all recording.
 
   ```
              let some = LeoAudioPlayerAndRecorder.getAllRecording()
        
        print(some)
        
   ```
 
 * Remove all recording. 
 
   ```
        removeCache()
         
   ```