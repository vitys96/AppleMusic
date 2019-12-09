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

protocol TrackMovingDelegate: class {
    func moveBackForPreviousTrack() -> Songs?
    func moveForwardForNextTrack() -> Songs?
}

class TrackDetailView: UIView {
    
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitleLabel: UILabel!
    @IBOutlet weak var authorTitleLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    let imageScale: CGFloat = 0.8

    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    weak var delegate: TrackMovingDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        trackImageView.transform = CGAffineTransform(scaleX: imageScale, y: imageScale)
        trackImageView.layer.cornerRadius = 15
        
    }

    func configure(with data: Songs) {
        let largeImageUrl = data.songIconUrl100?.replacingOccurrences(of: "100x100", with: "600x600")
        guard let url = URL(string: largeImageUrl ?? "") else { return }
        trackImageView.sd_setImage(with: url, completed: nil)
        playTrack(previewUrl: data.songm4p)
        trackTitleLabel.text = data.trackName
        authorTitleLabel.text = data.artistName
        checkingStartTime()
        observePlayerCurrentTime()
    }

    private func playTrack(previewUrl: String?) {
        guard let url = URL(string: previewUrl ?? "") else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
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
    

    @IBAction func handleCurrentTimeSlider(_ sender: Any) {
        guard let duration = player.currentItem?.duration else { return }
        let currentSliderValue = currentTimeSlider.value
        let durationInSeconds = CMTimeGetSeconds(duration)
        let seekTimeInSeconds = Float64(currentSliderValue) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)

    }
    @IBAction func handleVolumeSlider(_ sender: Any) {
        player.volume = volumeSlider.value
    }

    @IBAction func dragDownButtonTapped(_ sender: Any) {

        self.removeFromSuperview()
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
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            largingTrackImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            reduceTrackImageView()
        }

    }
}
