// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension ShikimoriSchema {
  nonisolated struct GetMangaInfoQuery: GraphQLQuery {
    static let operationName: String = "GetMangaInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetMangaInfo($ids: String) { mangas(ids: $ids) { __typename id name russian score kind poster { __typename originalUrl } status chapters volumes airedOn { __typename year } releasedOn { __typename year } licensors personRoles { __typename id rolesRu rolesEn person { __typename id name poster { __typename originalUrl } japanese russian isSeyu } } characterRoles { __typename id rolesRu rolesEn character { __typename id name russian poster { __typename originalUrl id } } } related { __typename id anime { __typename id name russian poster { __typename originalUrl } } manga { __typename id name russian poster { __typename originalUrl } } relationKind relationText } scoresStats { __typename score count } statusesStats { __typename status count } description genres { __typename russian kind } topic { __typename id } } }"#
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
        .field("mangas", [Manga].self, arguments: ["ids": .variable("ids")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetMangaInfoQuery.Data.self
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
          .field("kind", GraphQLEnum<ShikimoriSchema.MangaKindEnum>?.self),
          .field("poster", Poster?.self),
          .field("status", GraphQLEnum<ShikimoriSchema.MangaStatusEnum>?.self),
          .field("chapters", Int.self),
          .field("volumes", Int.self),
          .field("airedOn", AiredOn?.self),
          .field("releasedOn", ReleasedOn?.self),
          .field("licensors", [String]?.self),
          .field("personRoles", [PersonRole]?.self),
          .field("characterRoles", [CharacterRole]?.self),
          .field("related", [Related]?.self),
          .field("scoresStats", [ScoresStat]?.self),
          .field("statusesStats", [StatusesStat]?.self),
          .field("description", String?.self),
          .field("genres", [Genre]?.self),
          .field("topic", Topic?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetMangaInfoQuery.Data.Manga.self
        ] }

        var id: ShikimoriSchema.ID { __data["id"] }
        var name: String { __data["name"] }
        var russian: String? { __data["russian"] }
        var score: Double? { __data["score"] }
        var kind: GraphQLEnum<ShikimoriSchema.MangaKindEnum>? { __data["kind"] }
        var poster: Poster? { __data["poster"] }
        var status: GraphQLEnum<ShikimoriSchema.MangaStatusEnum>? { __data["status"] }
        var chapters: Int { __data["chapters"] }
        var volumes: Int { __data["volumes"] }
        var airedOn: AiredOn? { __data["airedOn"] }
        var releasedOn: ReleasedOn? { __data["releasedOn"] }
        var licensors: [String]? { __data["licensors"] }
        var personRoles: [PersonRole]? { __data["personRoles"] }
        var characterRoles: [CharacterRole]? { __data["characterRoles"] }
        var related: [Related]? { __data["related"] }
        var scoresStats: [ScoresStat]? { __data["scoresStats"] }
        var statusesStats: [StatusesStat]? { __data["statusesStats"] }
        var description: String? { __data["description"] }
        var genres: [Genre]? { __data["genres"] }
        var topic: Topic? { __data["topic"] }

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
            GetMangaInfoQuery.Data.Manga.Poster.self
          ] }

          var originalUrl: String { __data["originalUrl"] }
        }

        /// Manga.AiredOn
        ///
        /// Parent Type: `IncompleteDate`
        nonisolated struct AiredOn: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.IncompleteDate }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("year", Int?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.AiredOn.self
          ] }

          var year: Int? { __data["year"] }
        }

        /// Manga.ReleasedOn
        ///
        /// Parent Type: `IncompleteDate`
        nonisolated struct ReleasedOn: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.IncompleteDate }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("year", Int?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.ReleasedOn.self
          ] }

          var year: Int? { __data["year"] }
        }

        /// Manga.PersonRole
        ///
        /// Parent Type: `PersonRole`
        nonisolated struct PersonRole: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.PersonRole }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID.self),
            .field("rolesRu", [String].self),
            .field("rolesEn", [String].self),
            .field("person", Person.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.PersonRole.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var rolesRu: [String] { __data["rolesRu"] }
          var rolesEn: [String] { __data["rolesEn"] }
          var person: Person { __data["person"] }

          /// Manga.PersonRole.Person
          ///
          /// Parent Type: `Person`
          nonisolated struct Person: ShikimoriSchema.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Person }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", ShikimoriSchema.ID.self),
              .field("name", String.self),
              .field("poster", Poster?.self),
              .field("japanese", String?.self),
              .field("russian", String?.self),
              .field("isSeyu", Bool.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetMangaInfoQuery.Data.Manga.PersonRole.Person.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var poster: Poster? { __data["poster"] }
            var japanese: String? { __data["japanese"] }
            var russian: String? { __data["russian"] }
            var isSeyu: Bool { __data["isSeyu"] }

            /// Manga.PersonRole.Person.Poster
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
                GetMangaInfoQuery.Data.Manga.PersonRole.Person.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }
        }

        /// Manga.CharacterRole
        ///
        /// Parent Type: `CharacterRole`
        nonisolated struct CharacterRole: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.CharacterRole }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID.self),
            .field("rolesRu", [String].self),
            .field("rolesEn", [String].self),
            .field("character", Character.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.CharacterRole.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var rolesRu: [String] { __data["rolesRu"] }
          var rolesEn: [String] { __data["rolesEn"] }
          var character: Character { __data["character"] }

          /// Manga.CharacterRole.Character
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
              .field("poster", Poster?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetMangaInfoQuery.Data.Manga.CharacterRole.Character.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Manga.CharacterRole.Character.Poster
            ///
            /// Parent Type: `Poster`
            nonisolated struct Poster: ShikimoriSchema.SelectionSet {
              let __data: DataDict
              init(_dataDict: DataDict) { __data = _dataDict }

              static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Poster }
              static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("originalUrl", String.self),
                .field("id", ShikimoriSchema.ID.self),
              ] }
              static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
                GetMangaInfoQuery.Data.Manga.CharacterRole.Character.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
              var id: ShikimoriSchema.ID { __data["id"] }
            }
          }
        }

        /// Manga.Related
        ///
        /// Parent Type: `Related`
        nonisolated struct Related: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Related }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID.self),
            .field("anime", Anime?.self),
            .field("manga", Manga?.self),
            .field("relationKind", GraphQLEnum<ShikimoriSchema.RelationKindEnum>.self),
            .field("relationText", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.Related.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var anime: Anime? { __data["anime"] }
          var manga: Manga? { __data["manga"] }
          var relationKind: GraphQLEnum<ShikimoriSchema.RelationKindEnum> { __data["relationKind"] }
          var relationText: String { __data["relationText"] }

          /// Manga.Related.Anime
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
              .field("poster", Poster?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetMangaInfoQuery.Data.Manga.Related.Anime.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Manga.Related.Anime.Poster
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
                GetMangaInfoQuery.Data.Manga.Related.Anime.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }

          /// Manga.Related.Manga
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
              .field("poster", Poster?.self),
            ] }
            static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
              GetMangaInfoQuery.Data.Manga.Related.Manga.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Manga.Related.Manga.Poster
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
                GetMangaInfoQuery.Data.Manga.Related.Manga.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }
        }

        /// Manga.ScoresStat
        ///
        /// Parent Type: `ScoreStat`
        nonisolated struct ScoresStat: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.ScoreStat }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("score", Int.self),
            .field("count", Int.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.ScoresStat.self
          ] }

          var score: Int { __data["score"] }
          var count: Int { __data["count"] }
        }

        /// Manga.StatusesStat
        ///
        /// Parent Type: `StatusStat`
        nonisolated struct StatusesStat: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.StatusStat }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("status", GraphQLEnum<ShikimoriSchema.UserRateStatusEnum>.self),
            .field("count", Int.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.StatusesStat.self
          ] }

          var status: GraphQLEnum<ShikimoriSchema.UserRateStatusEnum> { __data["status"] }
          var count: Int { __data["count"] }
        }

        /// Manga.Genre
        ///
        /// Parent Type: `Genre`
        nonisolated struct Genre: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Genre }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("russian", String.self),
            .field("kind", GraphQLEnum<ShikimoriSchema.GenreKindEnum>.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetMangaInfoQuery.Data.Manga.Genre.self
          ] }

          var russian: String { __data["russian"] }
          var kind: GraphQLEnum<ShikimoriSchema.GenreKindEnum> { __data["kind"] }
        }

        /// Manga.Topic
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
            GetMangaInfoQuery.Data.Manga.Topic.self
          ] }

          var id: ShikimoriSchema.ID? { __data["id"] }
        }
      }
    }
  }

}