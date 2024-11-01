import SwiftUI
import AVFoundation
import Speech

struct CH1View: View {
    @State private var recognizedText = "請按下按鈕開始錄音..."
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?

    private let audioFilename: URL = {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("recording.m4a")
    }()

    init() {
        requestMicrophonePermission()
        requestSpeechRecognitionPermission()
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("語音自我介紹")
                .font(.largeTitle)
                .padding()

            Text(recognizedText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .frame(height: 200)
                .padding()

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
            setupAudioRecorder()
        }
    }

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

    private func requestSpeechRecognitionPermission() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("已獲得語音辨識權限")
            case .denied:
                print("語音辨識權限被拒絕")
            case .restricted, .notDetermined:
                print("語音辨識權限受限或未決定")
            @unknown default:
                break
            }
        }
    }

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

    private func startRecording() {
        audioRecorder?.record()
        recognizedText = "正在錄音..."
    }

    private func stopRecording() {
        audioRecorder?.stop()
        recognizedText = "錄音已停止，正在轉換為文字..."
        transcribeAudio() // 停止錄音後自動轉換為文字
    }

    private func playRecording() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer?.play()
            recognizedText = "正在播放錄音..."
        } catch {
            recognizedText = "播放錄音時出現錯誤: \(error.localizedDescription)"
        }
    }

    // 將錄音轉換為文字
    private func transcribeAudio() {
        // 設定語音辨識器為繁體中文
        let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
        let request = SFSpeechURLRecognitionRequest(url: audioFilename)
        
        recognizer?.recognitionTask(with: request) { result, error in
            if let result = result {
                self.recognizedText = result.bestTranscription.formattedString
            } else if let error = error {
                self.recognizedText = "轉換錄音時出現錯誤: \(error.localizedDescription)"
            }
        }
    }
}
