import Foundation
import SimpleFunctional

/// IO type for a simple web socket client.
public struct WebSocketClientIO: IO {
    public enum Input {
        public enum SocketEvent {
            case didOpen
            case didClose
            case receivedBytes([UInt8])
            case didError(message: String)
        }
        
        case socketCreated(id: UInt, config: SocketConfig)
        case socketUpdated(id: UInt, event: SocketEvent)
    }
    
    public enum Output {
        case createAndOpenSocket(config: SocketConfig)
        case closeSocket(id: UInt)
        case sendBytes(_ bytes: [UInt8], socketId: UInt)
    }
    
    public struct SocketConfig: Equatable {
        let hostname: String
        let port: Int?
        let authorizationHeader: String?
    }
}


// MARK: - Helpers

public extension WebSocketClientIO.SocketConfig {
    static func create(hostname: String,
                       port: Int? = nil,
                       authorizationHeader: String? = nil) -> Self {
        .init(hostname: hostname, port: port, authorizationHeader: authorizationHeader)
    }
}
