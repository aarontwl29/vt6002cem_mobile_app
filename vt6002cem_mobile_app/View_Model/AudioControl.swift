import AVFoundation
import Foundation
import SwiftUI
import AVKit

class AudioControl: NSObject, ObservableObject, AVAudioPlayerDelegate {
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var recordingURL: URL?
    
    @Published private(set) var isRecording: Bool = false
    @Published private(set) var isPlaying: Bool = false
    
    /// Track when recording started to ensure we don't produce 0-length files
    private var recordStartTime: Date?
    private let minimumRecordDuration: TimeInterval = 1.0  // e.g., 1 second
    
    override init() {
        super.init()
        setupAudioRecorder()
    }
    
    // MARK: - Set up the audio recorder
    private func setupAudioRecorder() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let documentDirectory = urls.first else {
            print("Error: No document directory found.")
            return
        }
        
        recordingURL = documentDirectory.appendingPathComponent("comment.m4a")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1, // Mono
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            guard let url = recordingURL else { return }
            audioRecorder = try AVAudioRecorder(url: url, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("Error setting up audio recorder: \(error)")
        }
    }
    
    // MARK: - Start recording
    func startRecording() {
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] allowed in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if allowed {
                    self.beginRecording()
                } else {
                    print("Microphone permission denied by user.")
                }
            }
        }
    }
    
    private func beginRecording() {
        guard let audioRecorder = audioRecorder else {
            print("Audio recorder not initialized.")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            audioRecorder.record()
            isRecording = true
            recordStartTime = Date()
            
            print("Recording started")
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    // MARK: - Stop recording
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        
        let recordedDuration = Date().timeIntervalSince(recordStartTime ?? Date())
        if recordedDuration < minimumRecordDuration {
            print("Warning: Recording was less than \(minimumRecordDuration) seconds.")
        }
        
        if let recordingURL = recordingURL {
            print("Recording stopped. File saved at: \(recordingURL)")
            do {
                let fileAttributes = try FileManager.default.attributesOfItem(atPath: recordingURL.path)
                print("File attributes: \(fileAttributes)")
            } catch {
                print("Error retrieving file attributes: \(error)")
            }
        }
    }
    
    // MARK: - Start playing
    func startPlaying() {
        guard isFileValid else {
            print("Audio file is too small or doesn't exist.")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session for playback: \(error)")
            return
        }
        
        do {
            guard let url = recordingURL else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            isPlaying = true
            print("Playing recording")
        } catch {
            print("Failed to play recording: \(error)")
        }
    }
    
    // MARK: - Stop playing
    func stopPlaying() {
        audioPlayer?.stop()
        isPlaying = false
        print("Stopped playing")
    }
    
    // MARK: - AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isPlaying = false
        print("Finished playing successfully? \(flag)")
    }
    
    // MARK: - Check if file is valid (non-empty)
    var isFileValid: Bool {
        guard let recordingURL = recordingURL,
              FileManager.default.fileExists(atPath: recordingURL.path)
        else {
            return false
        }
        
        // Check file size to ensure it's not just 0 or a few bytes
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: recordingURL.path)
            let fileSize = fileAttributes[.size] as? Int ?? 0
            return fileSize > 2000  // e.g., at least 2 KB
        } catch {
            print("Error checking file size: \(error)")
            return false
        }
    }
    
    // MARK: - Get the file URL
    func getRecordingURL() -> URL? {
        return recordingURL
    }
}







class MP3PlayerViewModel: ObservableObject {
    // 🔹 Tracks whether we're currently playing
    @Published var isPlaying: Bool = false
    
    private var audioPlayer: AVPlayer?
    
    // 🔸 Called when user taps "Play" or "Stop"
    func togglePlayback(urlString: String) {
        if isPlaying {
            stop()
        } else {
            play(from: urlString)
        }
    }
    
    // 🔹 Start playing an MP3 from your local server
    private func play(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print("❌ Invalid MP3 URL: \(urlString)")
            return
        }
        
        // 1) Create the AVPlayer
        audioPlayer = AVPlayer(url: url)
        
        // 2) Start playback
        audioPlayer?.play()
        isPlaying = true
        
        // 3) Observe finishing
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: audioPlayer?.currentItem,
            queue: .main
        ) { [weak self] _ in
            // When playback ends, reset
            self?.isPlaying = false
        }
        
        print("🎵 Playing MP3 from: \(urlString)")
    }
    
    // 🔹 Stop playback if currently playing
    private func stop() {
        audioPlayer?.pause()
        isPlaying = false
        print("🛑 Stopped playback")
    }
}
