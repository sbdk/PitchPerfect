//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Li Yin on 9/1/15.
//  Copyright (c) 2015 Li Yin. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine! //global object
    var audioFile:AVAudioFile!
    var audioPlayerNode:AVAudioPlayerNode!
    var audioPlayerReverb:AVAudioUnitReverb!
    var audioPlayerEcho:AVAudioUnitDelay!
    
    func stopAllAudio () {
        
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
    }
    
    func playAudioAtRate(playRate: Float) {
        //"float_t" also works here. But "float" cause error.
        
        stopAllAudio()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
        
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithReverbEffect(percentage: Float){
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeReverbEffect = AVAudioUnitReverb()
        changeReverbEffect.wetDryMix = percentage
        audioEngine.attachNode(changeReverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeReverbEffect, format: nil)
        audioEngine.connect(changeReverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithEchoEffect(seconds: NSTimeInterval){
        
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changeEchoEffect = AVAudioUnitDelay()
        changeEchoEffect.delayTime = seconds
        audioEngine.attachNode(changeEchoEffect)
        
        audioEngine.connect(audioPlayerNode, to: changeEchoEffect, format: nil)
        audioEngine.connect(changeEchoEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, fileTypeHint: AVFileTypeMPEGLayer3)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine() //initialize aduioEngine
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, commonFormat: AVAudioCommonFormat.PCMFormatFloat32, interleaved: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playSoundSlow(sender: UIButton) {
        
        playAudioAtRate(0.5)
      
    }

    @IBAction func playSoundFast(sender: UIButton) {
        
        playAudioAtRate(2)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton) {
        
        playAudioWithEchoEffect(1)
    }
    
    
    @IBAction func playReverbAudio(sender: UIButton) {
        
        playAudioWithReverbEffect(50.0)
    }
    
    @IBAction func stopPlaySound(sender: UIButton) {
        
        stopAllAudio()
    }

}
