// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: sifnode/clp/v1/types.proto
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

struct Sifnode_Clp_V1_Asset {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var symbol: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Sifnode_Clp_V1_Pool {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var externalAsset: Sifnode_Clp_V1_Asset {
    get {return _externalAsset ?? Sifnode_Clp_V1_Asset()}
    set {_externalAsset = newValue}
  }
  /// Returns true if `externalAsset` has been explicitly set.
  var hasExternalAsset: Bool {return self._externalAsset != nil}
  /// Clears the value of `externalAsset`. Subsequent reads from it will return its default value.
  mutating func clearExternalAsset() {self._externalAsset = nil}

  var nativeAssetBalance: String = String()

  var externalAssetBalance: String = String()

  var poolUnits: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _externalAsset: Sifnode_Clp_V1_Asset? = nil
}

struct Sifnode_Clp_V1_LiquidityProvider {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var asset: Sifnode_Clp_V1_Asset {
    get {return _asset ?? Sifnode_Clp_V1_Asset()}
    set {_asset = newValue}
  }
  /// Returns true if `asset` has been explicitly set.
  var hasAsset: Bool {return self._asset != nil}
  /// Clears the value of `asset`. Subsequent reads from it will return its default value.
  mutating func clearAsset() {self._asset = nil}

  var liquidityProviderUnits: String = String()

  var liquidityProviderAddress: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _asset: Sifnode_Clp_V1_Asset? = nil
}

struct Sifnode_Clp_V1_WhiteList {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var validatorList: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct Sifnode_Clp_V1_LiquidityProviderData {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var liquidityProvider: Sifnode_Clp_V1_LiquidityProvider {
    get {return _liquidityProvider ?? Sifnode_Clp_V1_LiquidityProvider()}
    set {_liquidityProvider = newValue}
  }
  /// Returns true if `liquidityProvider` has been explicitly set.
  var hasLiquidityProvider: Bool {return self._liquidityProvider != nil}
  /// Clears the value of `liquidityProvider`. Subsequent reads from it will return its default value.
  mutating func clearLiquidityProvider() {self._liquidityProvider = nil}

  var nativeAssetBalance: String = String()

  var externalAssetBalance: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _liquidityProvider: Sifnode_Clp_V1_LiquidityProvider? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "sifnode.clp.v1"

extension Sifnode_Clp_V1_Asset: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Asset"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "symbol"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.symbol) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.symbol.isEmpty {
      try visitor.visitSingularStringField(value: self.symbol, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sifnode_Clp_V1_Asset, rhs: Sifnode_Clp_V1_Asset) -> Bool {
    if lhs.symbol != rhs.symbol {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sifnode_Clp_V1_Pool: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Pool"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "external_asset"),
    2: .standard(proto: "native_asset_balance"),
    3: .standard(proto: "external_asset_balance"),
    4: .standard(proto: "pool_units"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._externalAsset) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.nativeAssetBalance) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.externalAssetBalance) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.poolUnits) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._externalAsset {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.nativeAssetBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.nativeAssetBalance, fieldNumber: 2)
    }
    if !self.externalAssetBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.externalAssetBalance, fieldNumber: 3)
    }
    if !self.poolUnits.isEmpty {
      try visitor.visitSingularStringField(value: self.poolUnits, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sifnode_Clp_V1_Pool, rhs: Sifnode_Clp_V1_Pool) -> Bool {
    if lhs._externalAsset != rhs._externalAsset {return false}
    if lhs.nativeAssetBalance != rhs.nativeAssetBalance {return false}
    if lhs.externalAssetBalance != rhs.externalAssetBalance {return false}
    if lhs.poolUnits != rhs.poolUnits {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sifnode_Clp_V1_LiquidityProvider: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LiquidityProvider"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "asset"),
    2: .standard(proto: "liquidity_provider_units"),
    3: .standard(proto: "liquidity_provider_address"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._asset) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.liquidityProviderUnits) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.liquidityProviderAddress) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._asset {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.liquidityProviderUnits.isEmpty {
      try visitor.visitSingularStringField(value: self.liquidityProviderUnits, fieldNumber: 2)
    }
    if !self.liquidityProviderAddress.isEmpty {
      try visitor.visitSingularStringField(value: self.liquidityProviderAddress, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sifnode_Clp_V1_LiquidityProvider, rhs: Sifnode_Clp_V1_LiquidityProvider) -> Bool {
    if lhs._asset != rhs._asset {return false}
    if lhs.liquidityProviderUnits != rhs.liquidityProviderUnits {return false}
    if lhs.liquidityProviderAddress != rhs.liquidityProviderAddress {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sifnode_Clp_V1_WhiteList: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".WhiteList"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "validator_list"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedStringField(value: &self.validatorList) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.validatorList.isEmpty {
      try visitor.visitRepeatedStringField(value: self.validatorList, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sifnode_Clp_V1_WhiteList, rhs: Sifnode_Clp_V1_WhiteList) -> Bool {
    if lhs.validatorList != rhs.validatorList {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Sifnode_Clp_V1_LiquidityProviderData: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LiquidityProviderData"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "liquidity_provider"),
    2: .standard(proto: "native_asset_balance"),
    3: .standard(proto: "external_asset_balance"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._liquidityProvider) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.nativeAssetBalance) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.externalAssetBalance) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._liquidityProvider {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    }
    if !self.nativeAssetBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.nativeAssetBalance, fieldNumber: 2)
    }
    if !self.externalAssetBalance.isEmpty {
      try visitor.visitSingularStringField(value: self.externalAssetBalance, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Sifnode_Clp_V1_LiquidityProviderData, rhs: Sifnode_Clp_V1_LiquidityProviderData) -> Bool {
    if lhs._liquidityProvider != rhs._liquidityProvider {return false}
    if lhs.nativeAssetBalance != rhs.nativeAssetBalance {return false}
    if lhs.externalAssetBalance != rhs.externalAssetBalance {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
