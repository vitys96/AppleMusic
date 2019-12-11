//
//  TrackDetailView.swift
//  AppleMusic
//
//  Created by TOOK on 06.12.2019.
//  Copyright © 2019 Vitaly. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit
import MediaPlayer

class TrackDetailView: UIView {
    
    @IBOutlet weak var maximizedStackView: UIStackView!
    @IBOutlet weak var miniTrackView: UIView!
    @IBOutlet weak var miniPlayPauseButton: UIButton!
    @IBOutlet weak var miniTrackTitleLabel: UILabel!
    @IBOutlet weak var pmVolumeView: PMVolumeView!
    @IBOutlet weak var topStackView: UIStackView!
    @IBOutlet weak var miniTrackImageView: UIImageView!
    @IBOutlet weak var miniGoForwardButton: UIButton!
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    private let imageScale: CGFloat = 0.8

    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    weak var delegate: TrackMovingDelegate?
    weak var tabBarDelegate: MainTabBarControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        trackImageView.layer.cornerRadius = 15
        miniPlayPauseButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        setupGestures()
        NotificationCenter.default.addObserver(self, selector: #selector(trackIsFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func configure(with data: Songs) {
        miniTrackTitleLabel.text = data.trackName
        let largeImageUrl = data.songIconUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: largeImageUrl ?? "") else { return }
        miniTrackImageView.sd_setImage(with: url, completed: nil)
        trackImageView.sd_setImage(with: url, completed: nil)
        playTrack(previewUrl: data.songm4p)
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        trackTitleLabel.text = data.trackName
        authorTitleLabel.text = data.artistName
        checkingStartTime()
        observePlayerCurrentTime()
    }

    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        
//        player.volume = AVAudioSession.sharedInstance().outputVolume
        player.play()
    }
    
    private func checkingStartTime() {
        let time = CMTimeMake(value: 1, timescale: 3)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: .main) { [weak self] in
            guard let self = self else { return }
            self.largingTrackImageView()
        }
    }
    private func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTimeLabel.text = time.toDisplayString()
            let durationTime = self.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1)
            let durationText = ((durationTime ) - time).toDisplayString()
            self.durationLabel.text = "-\(durationText)"
            self.updateCurrentTimeSlider(duration: durationTime)
        }
    }
    
    private func updateCurrentTimeSlider(duration: CMTime) {
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(duration)
        self.currentTimeSlider.value = Float(currentTimeSeconds / durationSeconds)
    }
    
    private func largingTrackImageView() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.trackImageView.transform = .identity
        }, completion: nil)
    }
    
    private func reduceTrackImageView() {
       UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
        self.trackImageView.transform = CGAffineTransform(scaleX: self.imageScale, y: self.imageScale)
        }, completion: nil)
    }
    
    private func setupGestures() {
        miniTrackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximized)))
        miniTrackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        topStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissPan)))
    }
    
    @objc private func handleTapMaximized() {
        self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
    }
    
    @objc private func handleDismissPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        switch gesture.state {
        case .changed:
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        case .ended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.maximizedStackView.transform = .identity
                if translation.y > 50 {
                    self.tabBarDelegate?.minimazeTrackDetailController()
                }
            }, completion: nil)
         @unknown default:
            print ("lalal")
        }
}
    
    @objc private func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            handlePanChanged(gesture: gesture)
        case .ended:
            handlePanEnded(gesture: gesture)
         @unknown default:
            print ("lalal")
        }
    }
    
    @objc private func trackIsFinished(note: NSNotification) {
        let nextCell = delegate?.moveForwardForNextTrack()
        guard let nextSong = nextCell else { return }
        self.configure(with: nextSong)
    }
    
    private func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        let newAlpha = 1 + translation.y / 200
        self.miniTrackView.alpha = newAlpha < 0 ? 0 : newAlpha
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    private func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -500 {
                self.tabBarDelegate?.maximizeTrackDetailController(viewModel: nil)
            } else {
                self.miniTrackView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }, completion: nil)
    }
    
    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        
        guard let duration = player.currentItem?.duration else { return }
        let currentSliderValue = currentTimeSlider.value
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(currentSliderValue) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 8)
        player.seek(to: seekTime)
    }

    @IBAction func dragDownButtonTapped(_ sender: Any) {
        self.tabBarDelegate?.minimazeTrackDetailController()
    }

    @IBAction func previousTrack(_ sender: Any) {
        let previousCell = delegate?.moveBackForPreviousTrack()
        guard let previousSong = previousCell else { return }
        self.configure(with: previousSong)
    }

    @IBAction func nextTrack(_ sender: Any) {
        let nextCell = delegate?.moveForwardForNextTrack()
        guard let nextSong = nextCell else { return }
        self.configure(with: nextSong)
    }

    @IBAction func playPauseAction(_ sender: Any) {
        if player.timeControlStatus == .paused {
            player.play()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            largingTrackImageView()
        } else {
            player.pause()
            miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }

    }
}
