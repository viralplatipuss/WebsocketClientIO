# WebsocketClientIO

Websocket Client IO type and handler for use with the SimpleFunctional library.

Provides a very basic IO handler for establishing a websocket client. Will be extended as needed to handle more complex features.

This is powered using [Vapor's WebSocketKit library](https://github.com/vapor/websocket-kit.git), which means it is a multi-platform IO handler. Linux, Mac, iOS

```swift
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

```
