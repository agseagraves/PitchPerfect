//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anita Seagraves on 4/2/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import UIKit
import AVFoundation


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var pauseplayButton: UIButton!
    
    
    var audioRecorder : AVAudioRecorder!
    var recordedAudio : RecordedAudio!
    
    // additional functionality added for pause/resume
    @IBAction func pausePlay(sender: UIButton) {
        
        if (audioRecorder.recording)
        {
            pauseplayButton.setTitle("[Resume]", forState: UIControlState.Normal)
            audioRecorder.pause()
        }else{
            pauseplayButton.setTitle("[Pause]", forState: UIControlState.Normal)
            audioRecorder.record()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //initialiaize the stop recording button to hidden
        stopButton.hidden = true
        pauseplayButton.setTitle("", forState: UIControlState.Normal)
        recordLabel.text = "Tap Mic to Record" //Task 4: swith label text

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Set up the play view to receive the recording data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receiveAudio = data
        }
    }
    
    // Action on pressing the record button
    @IBAction func record(sender: UIButton) {
        
        recordLabel.text = "Recording" //Task 4: swith label text
        pauseplayButton.setTitle("[Pause]", forState: UIControlState.Normal)
        stopButton.hidden = false
        recordButton.enabled = false
        
        // Build the path to the document directory creating a timestamped wav file for the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Activate the audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        // Set up the recorder and use the filePath defined above for the recording file
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // Function is called when recording completes
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //Save the recorded audio using the initializer
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent!)
            
            //Move on to the next view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    
    // Action for stop recording button
    @IBAction func stopit(sender: UIButton) {
        // Reset the buttons and labels on stop of recording
        recordLabel.text = "Tap Mic to Record" //Task 4: swith label text

        stopButton.hidden = true
        recordButton.enabled = true
        
        audioRecorder.stop()
        
        // Deactivate the audio session
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }
}



