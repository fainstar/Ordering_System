//
//  CH1.swift
//  Ordering_System
//
//  Created by 蔡尚儒 on 2024/10/23.
//

import SwiftUI
import AVFoundation

struct CH1View: View {
    @State private var recognizedText = "請按下按鈕開始錄音..."
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?  // 將 audioRecorder 改為 @State
    @State private var audioPlayer: AVAudioPlayer?      // 將 audioPlayer 改為 @State

    private let audioFilename: URL = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("recording.m4a")
    }()

    init() {
        requestMicrophonePermission()  // 請求麥克風權限
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("語音自我介紹")
                .font(.largeTitle)
                .padding()

            // 顯示錄音狀態
            Text(recognizedText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(height: 200)
                .padding()

            // 開始/停止錄音按鈕
            Button(action: {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
                isRecording.toggle()
            }) {
                Text(isRecording ? "停止錄音" : "開始錄音")
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // 播放錄音按鈕
            Button(action: {
                playRecording()
            }) {
                Text("播放錄音")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .onAppear {
            setupAudioRecorder()  // 在出現時初始化錄音器
        }
    }

    // 請求麥克風權限
    private func requestMicrophonePermission() {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            print("已獲得麥克風權限")
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .audio) { granted in
                if granted {
                    print("麥克風權限獲得")
                } else {
                    print("麥克風權限被拒絕")
                }
            }
        case .denied:
            print("麥克風權限被拒絕")
        case .restricted:
            print("麥克風權限受限")
        @unknown default:
            break
        }
    }

    // 設定音訊會話及錄音器
    private func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try audioSession.setActive(true)

            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            print("錄音文件路徑: \(audioFilename)")
        } catch {
            print("錄音器初始化失敗: \(error.localizedDescription)")
            audioRecorder = nil
        }
    }

    // 開始錄音
    private func startRecording() {
        audioRecorder?.record()
        recognizedText = "正在錄音..."
    }

    // 停止錄音
    private func stopRecording() {
        audioRecorder?.stop()
        recognizedText = "錄音已停止，您可以播放錄音。"
    }

    // 播放錄音
    private func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
            recognizedText = "正在播放錄音..."
        } catch {
            recognizedText = "播放錄音時出現錯誤: \(error.localizedDescription)"
        }
    }
}
