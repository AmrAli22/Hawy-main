//
//  AuctionLiveVideo+AgoraKit.swift
//  Hawy
//
//  Created by Amr Ali on 16/01/2023.
//

import UIKit
import Alamofire
import PusherSwift
import AgoraRtcKit
import Alamofire
import AVFoundation

extension AuctionLiveVideo: AgoraRtcEngineDelegate {
    // Callback called when a new host joins the channel
    func rtcEngine(_ engine: AgoraRtcEngineKit, didJoinedOfUid uid: UInt, elapsed: Int) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine.setupRemoteVideo(videoCanvas)
    }
    
    
    func setupRemoteVideo(uid: UInt) {
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = uid
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        agoraEngine.setupRemoteVideo(videoCanvas)
    }
    
    func setupLocalVideo() {
        // Enable the video module
        agoraEngine.enableVideo()
        // Start the local video preview
        agoraEngine.startPreview()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = remoteView
        // Set the local video view
        agoraEngine.setupLocalVideo(videoCanvas)
    }
    
    
    func joinChannel(u_id:UInt) {
        if !self.checkForPermissions() {
            showMessage(title: "Error", text: "Permissions were not granted")
            return
        }
        
        let option = AgoraRtcChannelMediaOptions()
        
//        if self.userRole == .broadcaster {
//            option.clientRoleType = .broadcaster
//            setupLocalVideo()
//        } else {
//            option.clientRoleType = .audience
//            setupRemoteVideo(uid: u_id)
//        }
//        option.clientRoleType = .broadcaster
//        setupRemoteVideo(uid: u_id)
//        setupLocalVideo()
        // For a video call scenario, set the channel profile as communication.
        option.channelProfile = .communication

        
        let result = agoraEngine.joinChannel(
            byToken: token, channelId: channelName, uid: u_id, mediaOptions: option,
            joinSuccess: { (channel, uid, elapsed) in
                self.agoraEngine.setEnableSpeakerphone(true)
                UIApplication.shared.isIdleTimerDisabled = true
            }
        )
        // Check if joining the channel was successful and set joined Bool accordingly
        if (result == 0) {
            joined = true
            showMessage(title: "Success", text: "Successfully joined the channel as \(self.userRole)")
        }
}
    
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        //leaveChannel()
        deleteUserAuctionVideo()
        videoStatus(status: "off")
        self.navigationController?.popViewController(animated: true)
    }
    
    func leaveChannel() {
        agoraEngine.stopPreview()
        let result = agoraEngine.leaveChannel(nil)
        // Check if leaving the channel was successful and set joined Bool accordingly
        if (result == 0) { joined = false }
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        
        self.agoraEngine.muteLocalAudioStream(!muteMic)
        muteMic = !muteMic
        
    }
    
    @IBAction func didClickVideoMuteButton(_ sender: UIButton) {
        if VideoStatues {
            videoStatus(status: "off")
        }else{
            videoStatus(status: "on")
        }
        
       // VideoStatues = !VideoStatues
    }
    
    @IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
        sender.isSelected.toggle()
        agoraEngine.switchCamera()
    }
    
    
}
     

extension AuctionLiveVideo {

    func initializeAgoraEngine() {
        let config = AgoraRtcEngineConfig()
        // Pass in your App ID here.
        config.appId = AppID
        // Use AgoraRtcEngineDelegate for the following delegate parameter.
        agoraEngine = AgoraRtcEngineKit.sharedEngine(with: config, delegate: self)

        agoraEngine.setChannelProfile(.communication)
               let clientRoleOptions = AgoraClientRoleOptions()
               clientRoleOptions.audienceLatencyLevel = .lowLatency
        
        agoraEngine.setClientRole(.broadcaster, options: clientRoleOptions)
        agoraEngine.setDefaultAudioRouteToSpeakerphone(true)
        agoraEngine.enableAudioVolumeIndication(500, smooth: 1, reportVad: true)
        
        agoraEngine.setVideoEncoderConfiguration(AgoraVideoEncoderConfiguration(size: AgoraVideoDimension640x480, frameRate: .fps15, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode: .disabled)) //disabled
    }
    
}


extension AuctionLiveVideo {
    func checkForPermissions() -> Bool {
        var hasPermissions = false

        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestCameraAccess()
        }
        // Break out, because camera permissions have been denied or restricted.
        if !hasPermissions { return false }
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
            case .authorized: hasPermissions = true
            default: hasPermissions = requestAudioAccess()
        }
        return hasPermissions
    }

    func requestCameraAccess() -> Bool {
        var hasCameraPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            hasCameraPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasCameraPermission
    }

    func requestAudioAccess() -> Bool {
        var hasAudioPermission = false
        let semaphore = DispatchSemaphore(value: 0)
        AVCaptureDevice.requestAccess(for: .audio, completionHandler: { granted in
            hasAudioPermission = granted
            semaphore.signal()
        })
        semaphore.wait()
        return hasAudioPermission
    }
    func showMessage(title: String, text: String, delay: Int = 2) -> Void {
        let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
        self.present(alert, animated: true)
        let deadlineTime = DispatchTime.now() + .seconds(delay)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    
}

extension AuctionLiveVideo {
    func setupViewForParticipane() {
        micMuteButton.isHidden = true
        emojUiImage.isHidden = true
        BidingStatues.isHidden = true
        if HelperConstant.getCurrency() == "K.D" {
            self.currencyBidLabel.text = "KWD"
        }else{
            self.currencyBidLabel.text = "USD"
        }
    }
    func setupViewForConductor() {
      //  micMuteButton.isHidden = true
//        emojUiImage.isHidden = true
//        BidingStatues.isHidden = true
    }
}
