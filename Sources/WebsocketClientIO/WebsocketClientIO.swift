import Foundation
import SimpleFunctional

/// IO type for a simple web socket client.
struct WebSocketClientIO: IO {
    enum Input {
        enum SocketEvent {
            case didOpen
            case didClose
            case receivedBytes([UInt8])
            case didError(message: String)
        }
        
        case socketCreated(id: UInt, config: SocketConfig)
        case socketUpdated(id: UInt, event: SocketEvent)
    }
    
    enum Output {
        case createAndOpenSocket(config: SocketConfig)
        case closeSocket(id: UInt)
        case sendBytes(_ bytes: [UInt8], socketId: UInt)
    }
    
    struct SocketConfig {
        let hostname: String
        let port: Int?
        let authorizationHeader: String?
    }
}


// MARK: - Helpers

extension WebSocketClientIO.SocketConfig: Equatable {
    static func create(hostname: String,
                       port: Int? = nil,
                       authorizationHeader: String? = nil) -> Self {
        .init(hostname: hostname, port: port, authorizationHeader: authorizationHeader)
    }
}
