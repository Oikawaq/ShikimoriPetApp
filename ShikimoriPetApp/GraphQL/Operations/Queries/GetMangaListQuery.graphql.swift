// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension ShikimoriSchema {
  nonisolated struct GetMangaListQuery: GraphQLQuery {
    static let operationName: String = "GetMangaList"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetMangaList($page: PositiveInt, $limit: PositiveInt, $order: OrderEnum, $status: MangaStatusString, $kind: MangaKindString) { mangas(page: $page, limit: $limit, order: $order, status: $status, kind: $kind) { __typename id name russian score poster { __typename originalUrl } } }"#
      ))

    public var page: GraphQLNullable<PositiveInt>
    public var limit: GraphQLNullable<PositiveInt>
    public var order: GraphQLNullable<GraphQLEnum<OrderEnum>>
    public var status: GraphQLNullable<MangaStatusString>
    public var kind: GraphQLNullable<MangaKindString>

    public init(
      page: GraphQLNullable<PositiveInt>,
      limit: GraphQLNullable<PositiveInt>,
      order: GraphQLNullable<GraphQLEnum<OrderEnum>>,
      status: GraphQLNullable<MangaStatusString>,
      kind: GraphQLNullable<MangaKindString>
    ) {
      self.page = page
      self.limit = limit
      self.order = order
      self.status = status
      self.kind = kind
    }

    @_spi(Unsafe) public var __variables: Variables? { [
      "page": page,
      "limit": limit,
      "order": order,
      "status": status,
      "kind": kind
    ] }

    nonisolated struct Data: ShikimoriSchema.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("mangas", [Manga].self, arguments: [
          "page": .variable("page"),
          "limit": .variable("limit"),
          "order": .variable("order"),
          "status": .variable("status"),
          "kind": .variable("kind")
        ]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetMangaListQuery.Data.self
      ] }

      var mangas: [Manga] { __data["mangas"] }

      /// Manga
      ///
      /// Parent Type: `Manga`
      nonisolated struct Manga: ShikimoriSchema.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Manga }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ShikimoriSchema.ID.self),
          .field("name", String.self),
          .field("russian", String?.self),
          .field("score", Double?.self),
          .field("poster", Poster?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMangaListQuery.Data.Manga.self
        ] }

        var id: ShikimoriSchema.ID { __data["id"] }
        var name: String { __data["name"] }
        var russian: String? { __data["russian"] }
        var score: Double? { __data["score"] }
        var poster: Poster? { __data["poster"] }

        /// Manga.Poster
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
            GetMangaListQuery.Data.Manga.Poster.self
          ] }

          var originalUrl: String { __data["originalUrl"] }
        }
      }
    }
  }

}