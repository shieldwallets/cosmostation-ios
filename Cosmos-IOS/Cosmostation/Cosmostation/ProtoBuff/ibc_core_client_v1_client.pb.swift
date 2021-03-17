// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: ibc/core/client/v1/client.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

/// IdentifiedClientState defines a client state with an additional client
/// identifier field.
struct Ibc_Core_Client_V1_IdentifiedClientState {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// client identifier
  var clientID: String = String()

  /// client state
  var clientState: Google_Protobuf2_Any {
    get {return _clientState ?? Google_Protobuf2_Any()}
    set {_clientState = newValue}
  }
  /// Returns true if `clientState` has been explicitly set.
  var hasClientState: Bool {return self._clientState != nil}
  /// Clears the value of `clientState`. Subsequent reads from it will return its default value.
  mutating func clearClientState() {self._clientState = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _clientState: Google_Protobuf2_Any? = nil
}

/// ConsensusStateWithHeight defines a consensus state with an additional height field.
struct Ibc_Core_Client_V1_ConsensusStateWithHeight {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// consensus state height
  var height: Ibc_Core_Client_V1_Height {
    get {return _height ?? Ibc_Core_Client_V1_Height()}
    set {_height = newValue}
  }
  /// Returns true if `height` has been explicitly set.
  var hasHeight: Bool {return self._height != nil}
  /// Clears the value of `height`. Subsequent reads from it will return its default value.
  mutating func clearHeight() {self._height = nil}

  /// consensus state
  var consensusState: Google_Protobuf2_Any {
    get {return _consensusState ?? Google_Protobuf2_Any()}
    set {_consensusState = newValue}
  }
  /// Returns true if `consensusState` has been explicitly set.
  var hasConsensusState: Bool {return self._consensusState != nil}
  /// Clears the value of `consensusState`. Subsequent reads from it will return its default value.
  mutating func clearConsensusState() {self._consensusState = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _height: Ibc_Core_Client_V1_Height? = nil
  fileprivate var _consensusState: Google_Protobuf2_Any? = nil
}

/// ClientConsensusStates defines all the stored consensus states for a given
/// client.
struct Ibc_Core_Client_V1_ClientConsensusStates {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// client identifier
  var clientID: String = String()

  /// consensus states and their heights associated with the client
  var consensusStates: [Ibc_Core_Client_V1_ConsensusStateWithHeight] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// ClientUpdateProposal is a governance proposal. If it passes, the client is
/// updated with the provided header. The update may fail if the header is not
/// valid given certain conditions specified by the client implementation.
struct Ibc_Core_Client_V1_ClientUpdateProposal {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// the title of the update proposal
  var title: String = String()

  /// the description of the proposal
  var description_p: String = String()

  /// the client identifier for the client to be updated if the proposal passes
  var clientID: String = String()

  /// the header used to update the client if the proposal passes
  var header: Google_Protobuf2_Any {
    get {return _header ?? Google_Protobuf2_Any()}
    set {_header = newValue}
  }
  /// Returns true if `header` has been explicitly set.
  var hasHeader: Bool {return self._header != nil}
  /// Clears the value of `header`. Subsequent reads from it will return its default value.
  mutating func clearHeader() {self._header = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _header: Google_Protobuf2_Any? = nil
}

/// Height is a monotonically increasing data type
/// that can be compared against another Height for the purposes of updating and
/// freezing clients
///
/// Normally the RevisionHeight is incremented at each height while keeping RevisionNumber
/// the same. However some consensus algorithms may choose to reset the
/// height in certain conditions e.g. hard forks, state-machine breaking changes
/// In these cases, the RevisionNumber is incremented so that height continues to
/// be monitonically increasing even as the RevisionHeight gets reset
struct Ibc_Core_Client_V1_Height {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// the revision that the client is currently on
  var revisionNumber: UInt64 = 0

  /// the height within the given revision
  var revisionHeight: UInt64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

/// Params defines the set of IBC light client parameters.
struct Ibc_Core_Client_V1_Params {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// allowed_clients defines the list of allowed client state types.
  var allowedClients: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "ibc.core.client.v1"

extension Ibc_Core_Client_V1_IdentifiedClientState: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".IdentifiedClientState"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
    2: .standard(proto: "client_state"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.clientID)
      case 2: try decoder.decodeSingularMessageField(value: &self._clientState)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 1)
    }
    if let v = self._clientState {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_IdentifiedClientState, rhs: Ibc_Core_Client_V1_IdentifiedClientState) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs._clientState != rhs._clientState {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Ibc_Core_Client_V1_ConsensusStateWithHeight: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ConsensusStateWithHeight"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "height"),
    2: .standard(proto: "consensus_state"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._height)
      case 2: try decoder.decodeSingularMessageField(value: &self._consensusState)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._height {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if let v = self._consensusState {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_ConsensusStateWithHeight, rhs: Ibc_Core_Client_V1_ConsensusStateWithHeight) -> Bool {
    if lhs._height != rhs._height {return false}
    if lhs._consensusState != rhs._consensusState {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Ibc_Core_Client_V1_ClientConsensusStates: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ClientConsensusStates"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "client_id"),
    2: .standard(proto: "consensus_states"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.clientID)
      case 2: try decoder.decodeRepeatedMessageField(value: &self.consensusStates)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 1)
    }
    if !self.consensusStates.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.consensusStates, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_ClientConsensusStates, rhs: Ibc_Core_Client_V1_ClientConsensusStates) -> Bool {
    if lhs.clientID != rhs.clientID {return false}
    if lhs.consensusStates != rhs.consensusStates {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Ibc_Core_Client_V1_ClientUpdateProposal: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ClientUpdateProposal"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "description"),
    3: .standard(proto: "client_id"),
    4: .same(proto: "header"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.title)
      case 2: try decoder.decodeSingularStringField(value: &self.description_p)
      case 3: try decoder.decodeSingularStringField(value: &self.clientID)
      case 4: try decoder.decodeSingularMessageField(value: &self._header)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 1)
    }
    if !self.description_p.isEmpty {
      try visitor.visitSingularStringField(value: self.description_p, fieldNumber: 2)
    }
    if !self.clientID.isEmpty {
      try visitor.visitSingularStringField(value: self.clientID, fieldNumber: 3)
    }
    if let v = self._header {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_ClientUpdateProposal, rhs: Ibc_Core_Client_V1_ClientUpdateProposal) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.description_p != rhs.description_p {return false}
    if lhs.clientID != rhs.clientID {return false}
    if lhs._header != rhs._header {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Ibc_Core_Client_V1_Height: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Height"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "revision_number"),
    2: .standard(proto: "revision_height"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt64Field(value: &self.revisionNumber)
      case 2: try decoder.decodeSingularUInt64Field(value: &self.revisionHeight)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.revisionNumber != 0 {
      try visitor.visitSingularUInt64Field(value: self.revisionNumber, fieldNumber: 1)
    }
    if self.revisionHeight != 0 {
      try visitor.visitSingularUInt64Field(value: self.revisionHeight, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_Height, rhs: Ibc_Core_Client_V1_Height) -> Bool {
    if lhs.revisionNumber != rhs.revisionNumber {return false}
    if lhs.revisionHeight != rhs.revisionHeight {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Ibc_Core_Client_V1_Params: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Params"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "allowed_clients"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeRepeatedStringField(value: &self.allowedClients)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.allowedClients.isEmpty {
      try visitor.visitRepeatedStringField(value: self.allowedClients, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Ibc_Core_Client_V1_Params, rhs: Ibc_Core_Client_V1_Params) -> Bool {
    if lhs.allowedClients != rhs.allowedClients {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
