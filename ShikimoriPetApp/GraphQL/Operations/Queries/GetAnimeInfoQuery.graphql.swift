// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

extension ShikimoriSchema {
  nonisolated struct GetAnimeInfoQuery: GraphQLQuery {
    static let operationName: String = "GetAnimeInfo"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetAnimeInfo($ids: String) { animes(ids: $ids) { __typename id name russian score kind poster { __typename originalUrl } status episodes episodesAired duration airedOn { __typename year } genres { __typename russian kind } releasedOn { __typename year } nextEpisodeAt studios { __typename imageUrl } personRoles { __typename id rolesRu rolesEn person { __typename id name poster { __typename originalUrl } japanese russian isSeyu } } characterRoles { __typename id rolesRu rolesEn character { __typename id name russian poster { __typename originalUrl } } } related { __typename id anime { __typename id name russian poster { __typename originalUrl } } manga { __typename id name russian poster { __typename originalUrl } } relationKind relationText } screenshots { __typename id originalUrl x166Url x332Url } videos { __typename id url name kind playerUrl imageUrl } scoresStats { __typename score count } statusesStats { __typename status count } description topic { __typename id } } }"#
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
        .field("animes", [Anime].self, arguments: ["ids": .variable("ids")]),
      ] }
      static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        GetAnimeInfoQuery.Data.self
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
          .field("kind", GraphQLEnum<ShikimoriSchema.AnimeKindEnum>?.self),
          .field("poster", Poster?.self),
          .field("status", GraphQLEnum<ShikimoriSchema.AnimeStatusEnum>?.self),
          .field("episodes", Int.self),
          .field("episodesAired", Int.self),
          .field("duration", Int?.self),
          .field("airedOn", AiredOn?.self),
          .field("genres", [Genre]?.self),
          .field("releasedOn", ReleasedOn?.self),
          .field("nextEpisodeAt", ShikimoriSchema.ISO8601DateTime?.self),
          .field("studios", [Studio].self),
          .field("personRoles", [PersonRole]?.self),
          .field("characterRoles", [CharacterRole]?.self),
          .field("related", [Related]?.self),
          .field("screenshots", [Screenshot].self),
          .field("videos", [Video].self),
          .field("scoresStats", [ScoresStat]?.self),
          .field("statusesStats", [StatusesStat]?.self),
          .field("description", String?.self),
          .field("topic", Topic?.self),
        ] }
        static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
          GetAnimeInfoQuery.Data.Anime.self
        ] }

        var id: ShikimoriSchema.ID { __data["id"] }
        var name: String { __data["name"] }
        var russian: String? { __data["russian"] }
        var score: Double? { __data["score"] }
        var kind: GraphQLEnum<ShikimoriSchema.AnimeKindEnum>? { __data["kind"] }
        var poster: Poster? { __data["poster"] }
        var status: GraphQLEnum<ShikimoriSchema.AnimeStatusEnum>? { __data["status"] }
        var episodes: Int { __data["episodes"] }
        var episodesAired: Int { __data["episodesAired"] }
        var duration: Int? { __data["duration"] }
        var airedOn: AiredOn? { __data["airedOn"] }
        var genres: [Genre]? { __data["genres"] }
        var releasedOn: ReleasedOn? { __data["releasedOn"] }
        var nextEpisodeAt: ShikimoriSchema.ISO8601DateTime? { __data["nextEpisodeAt"] }
        var studios: [Studio] { __data["studios"] }
        var personRoles: [PersonRole]? { __data["personRoles"] }
        var characterRoles: [CharacterRole]? { __data["characterRoles"] }
        var related: [Related]? { __data["related"] }
        var screenshots: [Screenshot] { __data["screenshots"] }
        var videos: [Video] { __data["videos"] }
        var scoresStats: [ScoresStat]? { __data["scoresStats"] }
        var statusesStats: [StatusesStat]? { __data["statusesStats"] }
        var description: String? { __data["description"] }
        var topic: Topic? { __data["topic"] }

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
            GetAnimeInfoQuery.Data.Anime.Poster.self
          ] }

          var originalUrl: String { __data["originalUrl"] }
        }

        /// Anime.AiredOn
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
            GetAnimeInfoQuery.Data.Anime.AiredOn.self
          ] }

          var year: Int? { __data["year"] }
        }

        /// Anime.Genre
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
            GetAnimeInfoQuery.Data.Anime.Genre.self
          ] }

          var russian: String { __data["russian"] }
          var kind: GraphQLEnum<ShikimoriSchema.GenreKindEnum> { __data["kind"] }
        }

        /// Anime.ReleasedOn
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
            GetAnimeInfoQuery.Data.Anime.ReleasedOn.self
          ] }

          var year: Int? { __data["year"] }
        }

        /// Anime.Studio
        ///
        /// Parent Type: `Studio`
        nonisolated struct Studio: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Studio }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("imageUrl", String?.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAnimeInfoQuery.Data.Anime.Studio.self
          ] }

          var imageUrl: String? { __data["imageUrl"] }
        }

        /// Anime.PersonRole
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
            GetAnimeInfoQuery.Data.Anime.PersonRole.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var rolesRu: [String] { __data["rolesRu"] }
          var rolesEn: [String] { __data["rolesEn"] }
          var person: Person { __data["person"] }

          /// Anime.PersonRole.Person
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
              GetAnimeInfoQuery.Data.Anime.PersonRole.Person.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var poster: Poster? { __data["poster"] }
            var japanese: String? { __data["japanese"] }
            var russian: String? { __data["russian"] }
            var isSeyu: Bool { __data["isSeyu"] }

            /// Anime.PersonRole.Person.Poster
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
                GetAnimeInfoQuery.Data.Anime.PersonRole.Person.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }
        }

        /// Anime.CharacterRole
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
            GetAnimeInfoQuery.Data.Anime.CharacterRole.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var rolesRu: [String] { __data["rolesRu"] }
          var rolesEn: [String] { __data["rolesEn"] }
          var character: Character { __data["character"] }

          /// Anime.CharacterRole.Character
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
              GetAnimeInfoQuery.Data.Anime.CharacterRole.Character.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Anime.CharacterRole.Character.Poster
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
                GetAnimeInfoQuery.Data.Anime.CharacterRole.Character.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }
        }

        /// Anime.Related
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
            GetAnimeInfoQuery.Data.Anime.Related.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var anime: Anime? { __data["anime"] }
          var manga: Manga? { __data["manga"] }
          var relationKind: GraphQLEnum<ShikimoriSchema.RelationKindEnum> { __data["relationKind"] }
          var relationText: String { __data["relationText"] }

          /// Anime.Related.Anime
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
              GetAnimeInfoQuery.Data.Anime.Related.Anime.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Anime.Related.Anime.Poster
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
                GetAnimeInfoQuery.Data.Anime.Related.Anime.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }

          /// Anime.Related.Manga
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
              GetAnimeInfoQuery.Data.Anime.Related.Manga.self
            ] }

            var id: ShikimoriSchema.ID { __data["id"] }
            var name: String { __data["name"] }
            var russian: String? { __data["russian"] }
            var poster: Poster? { __data["poster"] }

            /// Anime.Related.Manga.Poster
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
                GetAnimeInfoQuery.Data.Anime.Related.Manga.Poster.self
              ] }

              var originalUrl: String { __data["originalUrl"] }
            }
          }
        }

        /// Anime.Screenshot
        ///
        /// Parent Type: `Screenshot`
        nonisolated struct Screenshot: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Screenshot }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID.self),
            .field("originalUrl", String.self),
            .field("x166Url", String.self),
            .field("x332Url", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAnimeInfoQuery.Data.Anime.Screenshot.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var originalUrl: String { __data["originalUrl"] }
          var x166Url: String { __data["x166Url"] }
          var x332Url: String { __data["x332Url"] }
        }

        /// Anime.Video
        ///
        /// Parent Type: `Video`
        nonisolated struct Video: ShikimoriSchema.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: any ApolloAPI.ParentType { ShikimoriSchema.Objects.Video }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ShikimoriSchema.ID.self),
            .field("url", String.self),
            .field("name", String?.self),
            .field("kind", GraphQLEnum<ShikimoriSchema.VideoKindEnum>.self),
            .field("playerUrl", String.self),
            .field("imageUrl", String.self),
          ] }
          static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
            GetAnimeInfoQuery.Data.Anime.Video.self
          ] }

          var id: ShikimoriSchema.ID { __data["id"] }
          var url: String { __data["url"] }
          var name: String? { __data["name"] }
          var kind: GraphQLEnum<ShikimoriSchema.VideoKindEnum> { __data["kind"] }
          var playerUrl: String { __data["playerUrl"] }
          var imageUrl: String { __data["imageUrl"] }
        }

        /// Anime.ScoresStat
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
            GetAnimeInfoQuery.Data.Anime.ScoresStat.self
          ] }

          var score: Int { __data["score"] }
          var count: Int { __data["count"] }
        }

        /// Anime.StatusesStat
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
            GetAnimeInfoQuery.Data.Anime.StatusesStat.self
          ] }

          var status: GraphQLEnum<ShikimoriSchema.UserRateStatusEnum> { __data["status"] }
          var count: Int { __data["count"] }
        }

        /// Anime.Topic
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
            GetAnimeInfoQuery.Data.Anime.Topic.self
          ] }

          var id: ShikimoriSchema.ID? { __data["id"] }
        }
      }
    }
  }

}