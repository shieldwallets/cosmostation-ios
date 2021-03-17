//
// DO NOT EDIT.
//
// Generated by the protocol buffer compiler.
// Source: akash/audit/v1beta1/query.proto
//

//
// Copyright 2018, gRPC Authors All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
import GRPC
import NIO
import SwiftProtobuf


/// Query defines the gRPC querier service
///
/// Usage: instantiate `Akash_Audit_V1beta1_QueryClient`, then call methods of this protocol to make API calls.
internal protocol Akash_Audit_V1beta1_QueryClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Akash_Audit_V1beta1_QueryClientInterceptorFactoryProtocol? { get }

  func allProvidersAttributes(
    _ request: Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>

  func providerAttributes(
    _ request: Akash_Audit_V1beta1_QueryProviderAttributesRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryProviderAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>

  func providerAuditorAttributes(
    _ request: Akash_Audit_V1beta1_QueryProviderAuditorRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryProviderAuditorRequest, Akash_Audit_V1beta1_QueryProvidersResponse>

  func auditorAttributes(
    _ request: Akash_Audit_V1beta1_QueryAuditorAttributesRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryAuditorAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>
}

extension Akash_Audit_V1beta1_QueryClientProtocol {
  internal var serviceName: String {
    return "akash.audit.v1beta1.Query"
  }

  /// AllProvidersAttributes queries all providers
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  ///
  /// - Parameters:
  ///   - request: Request to send to AllProvidersAttributes.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func allProvidersAttributes(
    _ request: Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse> {
    return self.makeUnaryCall(
      path: "/akash.audit.v1beta1.Query/AllProvidersAttributes",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAllProvidersAttributesInterceptors() ?? []
    )
  }

  /// ProviderAttributes queries all provider signed attributes
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  ///
  /// - Parameters:
  ///   - request: Request to send to ProviderAttributes.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func providerAttributes(
    _ request: Akash_Audit_V1beta1_QueryProviderAttributesRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryProviderAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse> {
    return self.makeUnaryCall(
      path: "/akash.audit.v1beta1.Query/ProviderAttributes",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeProviderAttributesInterceptors() ?? []
    )
  }

  /// ProviderAuditorAttributes queries provider signed attributes by specific auditor
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  ///
  /// - Parameters:
  ///   - request: Request to send to ProviderAuditorAttributes.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func providerAuditorAttributes(
    _ request: Akash_Audit_V1beta1_QueryProviderAuditorRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryProviderAuditorRequest, Akash_Audit_V1beta1_QueryProvidersResponse> {
    return self.makeUnaryCall(
      path: "/akash.audit.v1beta1.Query/ProviderAuditorAttributes",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeProviderAuditorAttributesInterceptors() ?? []
    )
  }

  /// AuditorAttributes queries all providers signed by this auditor
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  ///
  /// - Parameters:
  ///   - request: Request to send to AuditorAttributes.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  internal func auditorAttributes(
    _ request: Akash_Audit_V1beta1_QueryAuditorAttributesRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Akash_Audit_V1beta1_QueryAuditorAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse> {
    return self.makeUnaryCall(
      path: "/akash.audit.v1beta1.Query/AuditorAttributes",
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeAuditorAttributesInterceptors() ?? []
    )
  }
}

internal protocol Akash_Audit_V1beta1_QueryClientInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when invoking 'allProvidersAttributes'.
  func makeAllProvidersAttributesInterceptors() -> [ClientInterceptor<Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when invoking 'providerAttributes'.
  func makeProviderAttributesInterceptors() -> [ClientInterceptor<Akash_Audit_V1beta1_QueryProviderAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when invoking 'providerAuditorAttributes'.
  func makeProviderAuditorAttributesInterceptors() -> [ClientInterceptor<Akash_Audit_V1beta1_QueryProviderAuditorRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when invoking 'auditorAttributes'.
  func makeAuditorAttributesInterceptors() -> [ClientInterceptor<Akash_Audit_V1beta1_QueryAuditorAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]
}

internal final class Akash_Audit_V1beta1_QueryClient: Akash_Audit_V1beta1_QueryClientProtocol {
  internal let channel: GRPCChannel
  internal var defaultCallOptions: CallOptions
  internal var interceptors: Akash_Audit_V1beta1_QueryClientInterceptorFactoryProtocol?

  /// Creates a client for the akash.audit.v1beta1.Query service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  internal init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Akash_Audit_V1beta1_QueryClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// Query defines the gRPC querier service
///
/// To build a server, implement a class that conforms to this protocol.
internal protocol Akash_Audit_V1beta1_QueryProvider: CallHandlerProvider {
  var interceptors: Akash_Audit_V1beta1_QueryServerInterceptorFactoryProtocol? { get }

  /// AllProvidersAttributes queries all providers
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  func allProvidersAttributes(request: Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Akash_Audit_V1beta1_QueryProvidersResponse>

  /// ProviderAttributes queries all provider signed attributes
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  func providerAttributes(request: Akash_Audit_V1beta1_QueryProviderAttributesRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Akash_Audit_V1beta1_QueryProvidersResponse>

  /// ProviderAuditorAttributes queries provider signed attributes by specific auditor
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  func providerAuditorAttributes(request: Akash_Audit_V1beta1_QueryProviderAuditorRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Akash_Audit_V1beta1_QueryProvidersResponse>

  /// AuditorAttributes queries all providers signed by this auditor
  /// buf:lint:ignore RPC_REQUEST_RESPONSE_UNIQUE
  /// buf:lint:ignore RPC_RESPONSE_STANDARD_NAME
  func auditorAttributes(request: Akash_Audit_V1beta1_QueryAuditorAttributesRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Akash_Audit_V1beta1_QueryProvidersResponse>
}

extension Akash_Audit_V1beta1_QueryProvider {
  internal var serviceName: Substring { return "akash.audit.v1beta1.Query" }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  internal func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "AllProvidersAttributes":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest>(),
        responseSerializer: ProtobufSerializer<Akash_Audit_V1beta1_QueryProvidersResponse>(),
        interceptors: self.interceptors?.makeAllProvidersAttributesInterceptors() ?? [],
        userFunction: self.allProvidersAttributes(request:context:)
      )

    case "ProviderAttributes":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Akash_Audit_V1beta1_QueryProviderAttributesRequest>(),
        responseSerializer: ProtobufSerializer<Akash_Audit_V1beta1_QueryProvidersResponse>(),
        interceptors: self.interceptors?.makeProviderAttributesInterceptors() ?? [],
        userFunction: self.providerAttributes(request:context:)
      )

    case "ProviderAuditorAttributes":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Akash_Audit_V1beta1_QueryProviderAuditorRequest>(),
        responseSerializer: ProtobufSerializer<Akash_Audit_V1beta1_QueryProvidersResponse>(),
        interceptors: self.interceptors?.makeProviderAuditorAttributesInterceptors() ?? [],
        userFunction: self.providerAuditorAttributes(request:context:)
      )

    case "AuditorAttributes":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Akash_Audit_V1beta1_QueryAuditorAttributesRequest>(),
        responseSerializer: ProtobufSerializer<Akash_Audit_V1beta1_QueryProvidersResponse>(),
        interceptors: self.interceptors?.makeAuditorAttributesInterceptors() ?? [],
        userFunction: self.auditorAttributes(request:context:)
      )

    default:
      return nil
    }
  }
}

internal protocol Akash_Audit_V1beta1_QueryServerInterceptorFactoryProtocol {

  /// - Returns: Interceptors to use when handling 'allProvidersAttributes'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAllProvidersAttributesInterceptors() -> [ServerInterceptor<Akash_Audit_V1beta1_QueryAllProvidersAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when handling 'providerAttributes'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeProviderAttributesInterceptors() -> [ServerInterceptor<Akash_Audit_V1beta1_QueryProviderAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when handling 'providerAuditorAttributes'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeProviderAuditorAttributesInterceptors() -> [ServerInterceptor<Akash_Audit_V1beta1_QueryProviderAuditorRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]

  /// - Returns: Interceptors to use when handling 'auditorAttributes'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeAuditorAttributesInterceptors() -> [ServerInterceptor<Akash_Audit_V1beta1_QueryAuditorAttributesRequest, Akash_Audit_V1beta1_QueryProvidersResponse>]
}
