// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CancelTripMutation: GraphQLMutation {
  public static let operationName: String = "CancelTrip"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CancelTrip($id: ID!) { cancelTrip(launchId: $id) { __typename message success } }"#
    ))

  public var id: ID

  public init(id: ID) {
    self.id = id
  }

  public var __variables: Variables? { ["id": id] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("cancelTrip", CancelTrip.self, arguments: ["launchId": .variable("id")]),
    ] }

    public var cancelTrip: CancelTrip { __data["cancelTrip"] }

    /// CancelTrip
    ///
    /// Parent Type: `TripUpdateResponse`
    public struct CancelTrip: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.TripUpdateResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("message", String?.self),
        .field("success", Bool.self),
      ] }

      public var message: String? { __data["message"] }
      public var success: Bool { __data["success"] }
    }
  }
}
