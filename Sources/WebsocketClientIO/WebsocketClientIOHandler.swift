import Foundation
import SimpleFunctional
import WebSocket

/**
 Handles WebSocketClientIO.

 This is not thread-safe. handle(output:) should be called in-order on the same thread.
 */
final class WebSocketClientIOHandler: BaseIOHandler<WebSocketClientIO> {
    typealias IOType = WebSocketClientIO
    
    override func handle(output: Output) {
        switch output {
        case let .createAndOpenSocket(config):
            let id = nextId
            nextId += 1
            
            runInput(.socketCreated(id: id, config: config))
            
            guard let socket = createConnectedSocket(hostname: config.hostname, port: config.port, authorizationHeader: config.authorizationHeader) else {
                runInput(.socketUpdated(id: id, event: .didError(message: "Could not open socket.")))
                return
            }
            
            socketForId[id] = socket
            
            socket.onClose.always { [weak self] in
                self?.runInput(.socketUpdated(id: id, event: .didClose))
                self?.socketForId[id] = nil
            }
            
            socket.onBinary({ [weak self] (_, data) in
                self?.runInput(.socketUpdated(id: id, event: .receivedBytes(Array(data))))
            })
            
            socket.onError { [weak self] _, err in
                self?.runInput(.socketUpdated(id: id, event: .didError(message: err.localizedDescription)))
            }
            
            runInput(.socketUpdated(id: id, event: .didOpen))
            
        case let .closeSocket(id): socketForId[id]?.close()
        case let .sendBytes(bytes, socketId): socketForId[socketId]?.send(Data(bytes))
        }
    }
    
    
    // MARK: - Private
    
    private var nextId: UInt = 0
    private var socketForId = [UInt: WebSocket]()
    private let worker = MultiThreadedEventLoopGroup(numberOfThreads: 2)
    
    private func createConnectedSocket(hostname: String, port: Int?, authorizationHeader: String?) -> WebSocket? {
        var headers = HTTPHeaders()
        
        if let authHeader = authorizationHeader {
            headers.add(name: .authorization, value: authHeader)
        }
        
        let socketFuture = HTTPClient.webSocket(hostname: hostname, port: port, headers: headers, maxFrameSize: 512, on: worker)
        
        var socket: WebSocket? = nil
        do { try socket = socketFuture.wait() } catch {}
        
        return socket
    }
}
