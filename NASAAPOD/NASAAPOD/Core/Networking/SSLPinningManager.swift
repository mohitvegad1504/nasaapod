import Foundation

final class SSLPinningManager: NSObject {
    
    static let shared = SSLPinningManager()
    
    private override init() {}
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: nil)
    }()
}

extension SSLPinningManager: URLSessionDelegate {
    
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0),
              let localCertPath = Bundle.main.path(forResource: "nasa_cert", ofType: "cer") else {
            print("SSL Pinning failed: missing certificate or server trust")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }

        do {
            let localCertificateData = try Data(contentsOf: URL(fileURLWithPath: localCertPath))
            let serverCertificateData = SecCertificateCopyData(serverCertificate) as Data

            if serverCertificateData == localCertificateData {
                let credential = URLCredential(trust: serverTrust)
                completionHandler(.useCredential, credential)
            } else {
                print("SSL Pinning failed: certificate mismatch")
                completionHandler(.cancelAuthenticationChallenge, nil)
            }

        } catch {
            print("SSL Pinning failed: could not load local certificate – \(error)")
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }

}
