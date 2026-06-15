// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

nonisolated protocol ShikimoriSchema_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ShikimoriSchema.SchemaMetadata {}

nonisolated protocol ShikimoriSchema_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ShikimoriSchema.SchemaMetadata {}

nonisolated protocol ShikimoriSchema_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ShikimoriSchema.SchemaMetadata {}

nonisolated protocol ShikimoriSchema_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ShikimoriSchema.SchemaMetadata {}

extension ShikimoriSchema {
  typealias SelectionSet = ShikimoriSchema_SelectionSet

  typealias InlineFragment = ShikimoriSchema_InlineFragment

  typealias MutableSelectionSet = ShikimoriSchema_MutableSelectionSet

  typealias MutableInlineFragment = ShikimoriSchema_MutableInlineFragment

  nonisolated enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    private static let objectTypeMap: [String: ApolloAPI.Object] = [
      "Anime": ShikimoriSchema.Objects.Anime,
      "Character": ShikimoriSchema.Objects.Character,
      "CharacterRole": ShikimoriSchema.Objects.CharacterRole,
      "Genre": ShikimoriSchema.Objects.Genre,
      "IncompleteDate": ShikimoriSchema.Objects.IncompleteDate,
      "Manga": ShikimoriSchema.Objects.Manga,
      "Person": ShikimoriSchema.Objects.Person,
      "PersonRole": ShikimoriSchema.Objects.PersonRole,
      "Poster": ShikimoriSchema.Objects.Poster,
      "Query": ShikimoriSchema.Objects.Query,
      "Related": ShikimoriSchema.Objects.Related,
      "ScoreStat": ShikimoriSchema.Objects.ScoreStat,
      "Screenshot": ShikimoriSchema.Objects.Screenshot,
      "StatusStat": ShikimoriSchema.Objects.StatusStat,
      "Studio": ShikimoriSchema.Objects.Studio,
      "Topic": ShikimoriSchema.Objects.Topic,
      "Video": ShikimoriSchema.Objects.Video
    ]

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      objectTypeMap[typename]
    }
  }

  nonisolated enum Objects {}
  nonisolated enum Interfaces {}
  nonisolated enum Unions {}

}