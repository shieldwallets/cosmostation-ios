// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: cosmos/auth/v1beta1/auth.proto
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

/// BaseAccount defines a base account type. It contains all the necessary fields
/// for basic account functionality. Any custom account type should extend this
/// type for additional functionality (e.g. vesting).
struct Cosmos_Auth_V1beta1_BaseAccount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var address: String = String()

  var pubKey: Google_Protobuf2_Any {
    get {return _pubKey ?? Google_Protobuf2_Any()}
    set {_pubKey = newValue}
  }
  /// Returns true if `pubKey` has been explicitly set.
  var hasPubKey: Bool {return self._pubKey != nil}
  /// Clears the value of `pubKey`. Subsequent reads from it will return its default value.
  mutating func clearPubKey() {self._pubKey = nil}

  var accountNumber: UInt64 = 0

  var sequence: UInt64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _pubKey: Google_Protobuf2_Any? = nil
}

/// ModuleAccount defines an account for modules that holds coins on a pool.
struct Cosmos_Auth_V1beta1_ModuleAccount {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var baseAccount: Cosmos_Auth_V1beta1_BaseAccount {
    get {return _baseAccount ?? Cosmos_Auth_V1beta1_BaseAccount()}
    set {_baseAccount = newValue}
  }
  /// Returns true if `baseAccount` has been explicitly set.
  var hasBaseAccount: Bool {return self._baseAccount != nil}
  /// Clears the value of `baseAccount`. Subsequent reads from it will return its default value.
  mutating func clearBaseAccount() {self._baseAccount = nil}

  var name: String = String()

  var permissions: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _baseAccount: Cosmos_Auth_V1beta1_BaseAccount? = nil
}

/// Params defines the parameters for the auth module.
struct Cosmos_Auth_V1beta1_Params {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var maxMemoCharacters: UInt64 = 0

  var txSigLimit: UInt64 = 0

  var txSizeCostPerByte: UInt64 = 0

  var sigVerifyCostEd25519: UInt64 = 0

  var sigVerifyCostSecp256K1: UInt64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "cosmos.auth.v1beta1"

extension Cosmos_Auth_V1beta1_BaseAccount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".BaseAccount"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "address"),
    2: .standard(proto: "pub_key"),
    3: .standard(proto: "account_number"),
    4: .same(proto: "sequence"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self.address)
      case 2: try decoder.decodeSingularMessageField(value: &self._pubKey)
      case 3: try decoder.decodeSingularUInt64Field(value: &self.accountNumber)
      case 4: try decoder.decodeSingularUInt64Field(value: &self.sequence)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.address.isEmpty {
      try visitor.visitSingularStringField(value: self.address, fieldNumber: 1)
    }
    if let v = self._pubKey {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    }
    if self.accountNumber != 0 {
      try visitor.visitSingularUInt64Field(value: self.accountNumber, fieldNumber: 3)
    }
    if self.sequence != 0 {
      try visitor.visitSingularUInt64Field(value: self.sequence, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Auth_V1beta1_BaseAccount, rhs: Cosmos_Auth_V1beta1_BaseAccount) -> Bool {
    if lhs.address != rhs.address {return false}
    if lhs._pubKey != rhs._pubKey {return false}
    if lhs.accountNumber != rhs.accountNumber {return false}
    if lhs.sequence != rhs.sequence {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Auth_V1beta1_ModuleAccount: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ModuleAccount"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "base_account"),
    2: .same(proto: "name"),
    3: .same(proto: "permissions"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularMessageField(value: &self._baseAccount)
      case 2: try decoder.decodeSingularStringField(value: &self.name)
      case 3: try decoder.decodeRepeatedStringField(value: &self.permissions)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._baseAccount {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.name.isEmpty {
      try visitor.visitSingularStringField(value: self.name, fieldNumber: 2)
    }
    if !self.permissions.isEmpty {
      try visitor.visitRepeatedStringField(value: self.permissions, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Auth_V1beta1_ModuleAccount, rhs: Cosmos_Auth_V1beta1_ModuleAccount) -> Bool {
    if lhs._baseAccount != rhs._baseAccount {return false}
    if lhs.name != rhs.name {return false}
    if lhs.permissions != rhs.permissions {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Cosmos_Auth_V1beta1_Params: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Params"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "max_memo_characters"),
    2: .standard(proto: "tx_sig_limit"),
    3: .standard(proto: "tx_size_cost_per_byte"),
    4: .standard(proto: "sig_verify_cost_ed25519"),
    5: .standard(proto: "sig_verify_cost_secp256k1"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularUInt64Field(value: &self.maxMemoCharacters)
      case 2: try decoder.decodeSingularUInt64Field(value: &self.txSigLimit)
      case 3: try decoder.decodeSingularUInt64Field(value: &self.txSizeCostPerByte)
      case 4: try decoder.decodeSingularUInt64Field(value: &self.sigVerifyCostEd25519)
      case 5: try decoder.decodeSingularUInt64Field(value: &self.sigVerifyCostSecp256K1)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.maxMemoCharacters != 0 {
      try visitor.visitSingularUInt64Field(value: self.maxMemoCharacters, fieldNumber: 1)
    }
    if self.txSigLimit != 0 {
      try visitor.visitSingularUInt64Field(value: self.txSigLimit, fieldNumber: 2)
    }
    if self.txSizeCostPerByte != 0 {
      try visitor.visitSingularUInt64Field(value: self.txSizeCostPerByte, fieldNumber: 3)
    }
    if self.sigVerifyCostEd25519 != 0 {
      try visitor.visitSingularUInt64Field(value: self.sigVerifyCostEd25519, fieldNumber: 4)
    }
    if self.sigVerifyCostSecp256K1 != 0 {
      try visitor.visitSingularUInt64Field(value: self.sigVerifyCostSecp256K1, fieldNumber: 5)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Cosmos_Auth_V1beta1_Params, rhs: Cosmos_Auth_V1beta1_Params) -> Bool {
    if lhs.maxMemoCharacters != rhs.maxMemoCharacters {return false}
    if lhs.txSigLimit != rhs.txSigLimit {return false}
    if lhs.txSizeCostPerByte != rhs.txSizeCostPerByte {return false}
    if lhs.sigVerifyCostEd25519 != rhs.sigVerifyCostEd25519 {return false}
    if lhs.sigVerifyCostSecp256K1 != rhs.sigVerifyCostSecp256K1 {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
