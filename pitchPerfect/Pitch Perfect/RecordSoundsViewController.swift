//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Li Yin on 8/29/15.
//  Copyright (c) 2015 Li Yin. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
 
    //make sure app is only running in Portait view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        // to hide the stop button and make sure tapToRecord label show here
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        tapToRecordLabel.hidden = false
        //pausedLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recordAudio(sender: UIButton) {
        tapToRecordLabel.hidden = false
        tapToRecordLabel.text = "Recording"
        tapToRecordLabel.textColor = UIColor.blueColor()
        pauseButton.hidden = false
        resumeButton.hidden = false
        stopButton.hidden = false;
        recordButton.enabled = false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] 
       
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        /*setup audio session and set the audio output default route to sepaker when the app is running on an actual iPhone.*/
        
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker)
        } catch _{
            
        }
        
        //initialize and prepare the recorder
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseButton(sender: UIButton) {
        
        tapToRecordLabel.text = "Paused"
        tapToRecordLabel.textColor = UIColor.blackColor()
        audioRecorder.pause()
        
    }
    
    @IBAction func resumeButton(sender: UIButton) {
        
        audioRecorder.record()
        tapToRecordLabel.text = "Resume Recording"
        tapToRecordLabel.textColor = UIColor.blueColor()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
        
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playsoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playsoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func stopButton(sender: UIButton) {
        tapToRecordLabel.text = "Tap to Record"
        tapToRecordLabel.textColor = UIColor.blackColor()
        recordButton.enabled = true;
        
        //stop recording the user's voice
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
}

