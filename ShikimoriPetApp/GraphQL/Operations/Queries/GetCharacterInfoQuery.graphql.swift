// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension ShikimoriSchema {
  nonisolated struct GetCharacterInfoQuery: GraphQLQuery {
    static let operationName: String = "GetCharacterInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetCharacterInfo($ids: String) { characters(ids: $ids) { __typename id name russian japanese isAnime isManga isRanobe poster { __typename originalUrl } description topic { __typename id } } }"#
      ))

    public var ids: GraphQLNullable<String>

    public init(ids: GraphQLNullable<String>) {
      self.ids = ids
    }

    @_spi(Unsafe) public var __variables: Variables? { ["ids": ids] }

    nonisolated struct Data: ShikimoriSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("characters", [Character].self, arguments: ["ids": .variable("ids")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetCharacterInfoQuery.Data.self
      ] }

      var characters: [Character] { __data["characters"] }

      /// Character
      ///
      /// Parent Type: `Character`
      nonisolated struct Character: ShikimoriSchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Character }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ShikimoriSchema.ID.self),
          .field("name", String.self),
          .field("russian", String?.self),
          .field("japanese", String?.self),
          .field("isAnime", Bool.self),
          .field("isManga", Bool.self),
          .field("isRanobe", Bool.self),
          .field("poster", Poster?.self),
          .field("description", String?.self),
          .field("topic", Topic?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetCharacterInfoQuery.Data.Character.self
        ] }

        var id: ShikimoriSchema.ID { __data["id"] }
        var name: String { __data["name"] }
        var russian: String? { __data["russian"] }
        var japanese: String? { __data["japanese"] }
        var isAnime: Bool { __data["isAnime"] }
        var isManga: Bool { __data["isManga"] }
        var isRanobe: Bool { __data["isRanobe"] }
        var poster: Poster? { __data["poster"] }
        var description: String? { __data["description"] }
        var topic: Topic? { __data["topic"] }

        /// Character.Poster
        ///
        /// Parent Type: `Poster`
        nonisolated struct Poster: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Poster }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("originalUrl", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetCharacterInfoQuery.Data.Character.Poster.self
          ] }

          var originalUrl: String { __data["originalUrl"] }
        }

        /// Character.Topic
        ///
        /// Parent Type: `Topic`
        nonisolated struct Topic: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Topic }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetCharacterInfoQuery.Data.Character.Topic.self
          ] }

          var id: ShikimoriSchema.ID? { __data["id"] }
        }
      }
    }
  }

}