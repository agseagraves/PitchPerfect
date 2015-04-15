//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Anita Seagraves on 4/6/15.
//  Copyright (c) 2015 Anita Seagraves. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var audioPlayerEffect : AVAudioPlayer!
    var receiveAudio : RecordedAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    
    
    // Task 3 - stop and reset audio engine
    func StopResetEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    // try playing sound with echo using 2 players and a delay
    @IBAction func playEcho(sender: AnyObject) {
        audioPlayer.stop()
        StopResetEngine()
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
        var timeInterval:NSTimeInterval
        timeInterval = audioPlayerEffect.deviceCurrentTime + 0.15
        audioPlayerEffect.stop()
        audioPlayerEffect.volume = 0.6
        audioPlayerEffect.currentTime = 0.0
        audioPlayerEffect.playAtTime(timeInterval)
    }
    
    // Play slow by setting the rate to 0.5
    @IBAction func PlaySlowAudio(sender: AnyObject) {
        audioPlayer.stop()
        
        StopResetEngine()
        
        setRate(0.5)
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // Play fast by setting the rate to 1.5
    @IBAction func PlayFastAudio(sender: AnyObject) {
        audioPlayer.stop()
        
        StopResetEngine()
        
        setRate(1.5)
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    // common code for changing the speed/rate of playback
    func setRate(newRate: Float) {
        audioPlayer.rate = newRate
    }
    
    // Action for stopping the audio
    @IBAction func StopAudio(sender: AnyObject) {
        audioPlayer.stop()
    }
    
    // Set up the audio since the view loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receiveAudio.filePathUrl,  error: nil)
        
        // initialize audio player
        audioPlayer = AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        // initialize audio player for echo effect
        audioPlayerEffect = AVAudioPlayer(contentsOfURL: receiveAudio.filePathUrl, error: nil)
        audioPlayerEffect.enableRate = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Action for the chipmunk sound effect
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    // Action for the Darthvader sound effect
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    // Function for playing sound with variable effect
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var pitchPlayer = AVAudioPlayerNode()
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        
        audioEngine.attachNode(pitchPlayer)
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(pitchPlayer, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        pitchPlayer.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        pitchPlayer.play()
    }
    
    
}
