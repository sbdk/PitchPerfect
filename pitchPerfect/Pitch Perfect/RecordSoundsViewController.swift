//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Li Yin on 8/29/15.
//  Copyright (c) 2015 Li Yin. All rights reserved.
//

import UIKit
import AVFoundation

//make sure app is only running in Portait view.
extension UINavigationController{
    public override func supportedInterfaceOrientations() -> Int {
        return visibleViewController.supportedInterfaceOrientations()
    }
}

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecordLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pausedLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
 
    //make sure app is only running in Portait view.
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
    
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
        pausedLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func recordAudio(sender: UIButton) {
        tapToRecordLabel.hidden = true
        recordingLabel.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        stopButton.hidden = false;
        recordButton.enabled = false
        
        //Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as! String
       
        var recordingName = "my_audio.wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        /*setup audio session and set the audio output default route to sepaker when the app is running on an actual iPhone.*/
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, withOptions: AVAudioSessionCategoryOptions.DefaultToSpeaker, error: nil)
        
        //initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseButton(sender: UIButton) {
        
        recordingLabel.hidden = true
        pausedLabel.hidden = false
        audioRecorder.pause()
        
    }
    
    @IBAction func resumeButton(sender: UIButton) {
        
        audioRecorder.record()
        pausedLabel.hidden = true
        recordingLabel.hidden = false
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
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
        recordingLabel.hidden = true;
        recordButton.enabled = true;
        
        //stop recording the user's voice
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

