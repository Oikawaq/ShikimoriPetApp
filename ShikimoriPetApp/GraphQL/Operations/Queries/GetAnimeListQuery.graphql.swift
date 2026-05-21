// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension ShikimoriSchema {
  nonisolated struct GetAnimeListQuery: GraphQLQuery {
    static let operationName: String = "GetAnimeList"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetAnimeList($page: PositiveInt, $limit: PositiveInt, $order: OrderEnum) { animes(page: $page, limit: $limit, order: $order) { __typename id name russian score poster { __typename originalUrl } } }"#
      ))

    public var page: GraphQLNullable<PositiveInt>
    public var limit: GraphQLNullable<PositiveInt>
    public var order: GraphQLNullable<GraphQLEnum<OrderEnum>>

    public init(
      page: GraphQLNullable<PositiveInt>,
      limit: GraphQLNullable<PositiveInt>,
      order: GraphQLNullable<GraphQLEnum<OrderEnum>>
    ) {
      self.page = page
      self.limit = limit
      self.order = order
    }

    @_spi(Unsafe) public var __variables: Variables? { [
      "page": page,
      "limit": limit,
      "order": order
    ] }

    nonisolated struct Data: ShikimoriSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("animes", [Anime].self, arguments: [
          "page": .variable("page"),
          "limit": .variable("limit"),
          "order": .variable("order")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetAnimeListQuery.Data.self
      ] }

      var animes: [Anime] { __data["animes"] }

      /// Anime
      ///
      /// Parent Type: `Anime`
      nonisolated struct Anime: ShikimoriSchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Anime }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ShikimoriSchema.ID.self),
          .field("name", String.self),
          .field("russian", String?.self),
          .field("score", Double?.self),
          .field("poster", Poster?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetAnimeListQuery.Data.Anime.self
        ] }

        var id: ShikimoriSchema.ID { __data["id"] }
        var name: String { __data["name"] }
        var russian: String? { __data["russian"] }
        var score: Double? { __data["score"] }
        var poster: Poster? { __data["poster"] }

        /// Anime.Poster
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
            GetAnimeListQuery.Data.Anime.Poster.self
          ] }

          var originalUrl: String { __data["originalUrl"] }
        }
      }
    }
  }

}