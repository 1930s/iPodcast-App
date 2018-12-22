//
//  PlayerDetailsView.swift
//  iPodcast
//
//  Created by sanket kumar on 08/12/18.
//  Copyright © 2018 sanket kumar. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer


class PlayerDetailsView: UIView {
    
    fileprivate let scale : CGFloat = 0.7
   
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            episodeImageView.layer.cornerRadius = 8
            episodeImageView.clipsToBounds = true
        }
    }
    
    @IBAction func handleTimeSliderChange(_ sender: Any) {
        let percentage = currentTimeSlider.value
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSecond = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSecond, preferredTimescale: 1)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTime
        player.seek(to: seekTime)
        
    }
    
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToTime(by: -15)
    }

    @IBAction func handleFastForward(_ sender: Any) {
        seekToTime(by: 15)
    }
    
    fileprivate func seekToTime(by time : Int64) {
        let fifteenSecond = CMTimeMake(value: time, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSecond)
        player.seek(to: seekTime)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    //MARK:- IBOutlet and IBAction
    
    @IBOutlet weak var miniFastForward: UIButton! {
        didSet {
            miniFastForward.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    @IBOutlet weak var miniEpisodeImageView: UIImageView! {
        didSet{
            miniEpisodeImageView.layer.cornerRadius = 4
        }
    }
    @IBOutlet weak var miniTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayPauseBtn: UIButton! {
        didSet {
            miniPlayPauseBtn.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
            miniPlayPauseBtn.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthorLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            miniPlayPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            enlargeEpisodeImageView()
            self.setupElapsedTime(playbackRate: 1)
        }
        else {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            shrinkEpisodeImageView()
            self.setupElapsedTime(playbackRate: 0)
        }
    }
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
        })
    }
    
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.episodeImageView.transform = .identity
        })
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTime(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self](time) in
            
            self?.currentTimeLabel.text = time.toCorrectTimeFormat()
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toCorrectTimeFormat()
            self?.updateCurrentTimeSlider()
            
        }
    }
    
    
    
    fileprivate func updateCurrentTimeSlider() {
        let currentTimeSecond = CMTimeGetSeconds(player.currentTime())
        let durationSecond = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        let percentage = currentTimeSecond / durationSecond
        self.currentTimeSlider.value = Float(percentage)
        
    }
    
    var panGesture : UIPanGestureRecognizer!
    
    fileprivate func setupGestures() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        miniPlayerView.addGestureRecognizer(panGesture)
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan)))
    }
    
    @objc fileprivate func handleDismissPan(gesture : UIPanGestureRecognizer) {
        print("dismiss pan gesture")
        let translate = gesture.translation(in: self.superview)
        if gesture.state == .changed {
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translate.y)
        }
        else if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
                
                if translate.y > 80 {
                    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
                    mainTabBarController.minimizePlayerDetail()
                }
                
            })
        }
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionErr {
            print("Failed to ativate session ,\(sessionErr)")
        }
    }
    
    fileprivate func setRemoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.play()
            self.playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            self.miniPlayPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            self.setupElapsedTime(playbackRate: 1)
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.player.pause()
            self.playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            self.miniPlayPauseBtn.setImage(UIImage(named: "play"), for: .normal)
            self.setupElapsedTime(playbackRate: 0)
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (_) -> MPRemoteCommandHandlerStatus in
            self.handlePlayPause()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(handleCommandCenterNextTrack))
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(handleCommandCenterPreviousTrack))
        
    }
    
    var playlistEpisodes = [Episode]()
    //MARK:- Command Center previous and next track
    @objc fileprivate func handleCommandCenterPreviousTrack() {
        if playlistEpisodes.count == 0 {
            return
        }
        let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.author == ep.author
        }
        guard let index = currentEpisodeIndex else { return }
        let nextEpisode : Episode
        
        if index == 0 {
            nextEpisode = playlistEpisodes[playlistEpisodes.count - 1]
        }
        else {
            nextEpisode = playlistEpisodes[index - 1]
        }
        
        self.episode = nextEpisode
    }
    
    @objc fileprivate func handleCommandCenterNextTrack() {
        
        if playlistEpisodes.count == 0 {
            return
        }
        
        let currentEpisodeIndex = playlistEpisodes.firstIndex { (ep) -> Bool in
            return self.episode.title == ep.title && self.episode.author == ep.author
        }
        
        guard let index = currentEpisodeIndex else { return }
        let nextEpisode : Episode
        
        if index == playlistEpisodes.count - 1 {
            nextEpisode = playlistEpisodes[0]
        }
        else {
            nextEpisode = playlistEpisodes[index + 1]
        }
        
        self.episode = nextEpisode
        
        
    }
    
    
    fileprivate func setupElapsedTime(playbackRate : Float) {
    
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyPlaybackRate] = playbackRate
    }
    
    fileprivate func observeBoundaryTime() {
        let time = CMTime(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {[weak self] in
            print("Episode started playing...")
            self?.enlargeEpisodeImageView()
            self?.setupLockScreenTime()
        }
    }
    
    fileprivate func setupLockScreenTime() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
        
        guard let currentItem = player.currentItem else { return }
        let durationInSecond = CMTimeGetSeconds(currentItem.duration)
        
        nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSecond
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setRemoteControl()
        
        setupGestures()
        
        setupInteruptionObserver()
        
        observePlayerCurrentTime()
        observeBoundaryTime()
    
    }
    
    fileprivate func setupInteruptionObserver() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    @objc fileprivate func handleInterruption(notification : Notification) {
        
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSession.InterruptionType.began.rawValue {
            print("Interruption began...")
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
            miniPlayPauseBtn.setImage(UIImage(named: "play"), for: .normal)
        }
        else {
            print("Interruption ended...")
            
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else { return }
            
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
                miniPlayPauseBtn.setImage(UIImage(named: "pause"), for: .normal)
            }
        }
        
    }
    
    @objc func handlePanGesture(gesture : UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
            
        }
        else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    fileprivate func handlePanChanged(gesture : UIPanGestureRecognizer) {
        let translate = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translate.y)
        
        self.miniPlayerView.alpha = 1 + translate.y / 200
        self.maximizedStackView.alpha = -translate.y / 200
    }
    
    fileprivate func handlePanEnded(gesture : UIPanGestureRecognizer) {
        let translate = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translate.y < -200 || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetail(episode: nil)
            }
            else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
            
        })
    }
    
    @objc fileprivate func handleTapMaximize() {
        UIApplication.mainTabBarController()?.maximizePlayerDetail(episode: nil)
    }
    
    static func initFromNib() -> PlayerDetailsView {
        return  Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    let player : AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    @IBAction func handleDismiss(_ sender: Any) {
        UIApplication.mainTabBarController()?.minimizePlayerDetail()
    }
    
    var episode : Episode! {
        didSet {
            
            episodeTitleLabel.text = episode.title
            episodeAuthorLabel.text = episode.author
            miniTitleLabel.text = episode.title
            
            setupNowPlayingInfo()
            setupAudioSession()
            playEpisode()
            
            let imageUrl = episode.imageUrl ?? ""
            let secureImageUrl = imageUrl.toSecureHTTPs()
            guard let url = URL(string: secureImageUrl) else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
            
            // miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            
            miniEpisodeImageView.sd_setImage(with: url) { (image, _, _, _) in
                guard let image = image else { return }
                
                // locked screen artwork
                var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo
                
                let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_) -> UIImage in
                    return image
                })
                nowPlayingInfo?[MPMediaItemPropertyArtwork] = artwork
                MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            }
            
            
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        
    }
    
    
    fileprivate func playEpisode() {
    
        if episode.fileUrl != nil {
            playEpisodeUsingFileUrl()
        }
        else {
            print("Playing episode from url ",episode.streamUrl)
            guard let url = URL(string: episode.streamUrl.toSecureHTTPs()) else { return }
            let playerItem = AVPlayerItem(url: url)
            player.replaceCurrentItem(with: playerItem)
            player.play()
        }
        
    }
    
    
    fileprivate func playEpisodeUsingFileUrl() {
        print("Attempt to play with fileUrl..")
        
        guard let fileUrl = URL(string: episode.fileUrl ?? "") else { return }
        let fileName = fileUrl.lastPathComponent
        
        guard var trueLocation = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return  }
        trueLocation.appendPathComponent(fileName)
        
        let playerItem = AVPlayerItem(url: trueLocation)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    
    
    
    
    
}
