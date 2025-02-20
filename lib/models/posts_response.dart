import 'dart:convert';

import 'package:hejtter/models/post.dart';

PostsResponse postFromJson(String str) =>
    PostsResponse.fromJson(json.decode(str));

class PostsResponse {
  PostsResponse({
    this.page,
    this.limit,
    this.pages,
    this.total,
    this.links,
    this.embedded,
  });

  final int? page;
  final int? limit;
  final int? pages;
  final int? total;
  final PostLinks? links;
  final Embedded? embedded;

  factory PostsResponse.fromJson(Map<String, dynamic> json) {
    return PostsResponse(
      page: json["page"],
      limit: json["limit"],
      pages: json["pages"],
      total: json["total"],
      links: json["_links"] == null ? null : PostLinks.fromJson(json["_links"]),
      embedded: json["_embedded"] == null
          ? null
          : Embedded.fromJson(json["_embedded"]),
    );
  }
}

class Embedded {
  Embedded({
    this.items,
  });

  final List<Post>? items;

  factory Embedded.fromJson(Map<String, dynamic> json) => Embedded(
        items: json["items"] == null
            ? null
            : List<Post>.from(json["items"].map((x) => Post.fromJson(x))),
      );
}

class ItemAuthor {
  ItemAuthor({
    this.username,
    this.avatar,
    this.background,
    this.status,
    this.currentRank,
    this.currentColor,
    this.verified,
    this.sponsor,
    this.createdAt,
    this.links,
  });

  final String? username;
  final CommunityAvatar? avatar;
  final CommunityBackground? background;
  final String? status;
  final String? currentRank;
  final String? currentColor;
  final bool? verified;
  final bool? sponsor;
  final DateTime? createdAt;
  final AuthorLinks? links;

  factory ItemAuthor.fromJson(Map<String, dynamic> json) => ItemAuthor(
        username: json["username"],
        avatar: json["avatar"] == null
            ? null
            : CommunityAvatar.fromJson(json["avatar"]),
        background: json["background"] == null
            ? null
            : CommunityBackground.fromJson(json["background"]),
        status: json["status"],
        currentRank: json["current_rank"],
        currentColor: json["current_color"],
        verified: json["verified"],
        sponsor: json["sponsor"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        links: json["_links"] == null
            ? null
            : AuthorLinks.fromJson(json["_links"]),
      );
}

class CommunityAvatar {
  CommunityAvatar({
    this.urls,
    this.uuid,
    this.alt,
  });

  final AvatarUrls? urls;
  final String? uuid;
  final String? alt;

  factory CommunityAvatar.fromJson(Map<String, dynamic> json) =>
      CommunityAvatar(
        urls: AvatarUrls.fromJson(json["urls"]),
        uuid: json["uuid"],
        alt: json["alt"],
      );
}

class AvatarUrls {
  AvatarUrls({
    this.the100X100,
    this.the250X250,
  });

  final String? the100X100;
  final String? the250X250;

  factory AvatarUrls.fromJson(Map<String, dynamic> json) => AvatarUrls(
        the100X100: json["100x100"],
        the250X250: json["250x250"],
      );
}

class CommunityBackground {
  CommunityBackground({
    this.urls,
    this.uuid,
    this.alt,
  });

  final BackgroundUrls? urls;
  final String? uuid;
  final String? alt;

  factory CommunityBackground.fromJson(Map<String, dynamic> json) =>
      CommunityBackground(
        urls: BackgroundUrls.fromJson(json["urls"]),
        uuid: json["uuid"],
        alt: json["alt"],
      );
}

class BackgroundUrls {
  BackgroundUrls({
    this.the400X300,
    this.the1200X900,
  });

  final String? the400X300;
  final String? the1200X900;

  factory BackgroundUrls.fromJson(Map<String, dynamic> json) => BackgroundUrls(
        the400X300: json["400x300"],
        the1200X900: json["1200x900"],
      );
}

class AuthorLinks {
  AuthorLinks({
    this.self,
    this.follows,
  });

  final First? self;
  final First? follows;

  factory AuthorLinks.fromJson(Map<String, dynamic> json) => AuthorLinks(
        self: First.fromJson(json["self"]),
        follows: First.fromJson(json["follows"]),
      );
}

class First {
  First({
    this.href,
  });

  final String? href;

  factory First.fromJson(Map<String, dynamic> json) => First(
        href: json["href"],
      );
}

class CommentAuthor {
  CommentAuthor({
    this.username,
    this.avatar,
    this.background,
    this.status,
    this.currentRank,
    this.currentColor,
    this.verified,
    this.sponsor,
    this.createdAt,
    this.links,
  });

  final String? username;
  final PurpleAvatar? avatar;
  final PurpleBackground? background;
  final String? status;
  final String? currentRank;
  final String? currentColor;
  final bool? verified;
  final bool? sponsor;
  final DateTime? createdAt;
  final AuthorLinks? links;

  factory CommentAuthor.fromJson(Map<String, dynamic> json) => CommentAuthor(
        username: json["username"],
        avatar: json["avatar"] == null
            ? null
            : PurpleAvatar.fromJson(json["avatar"]),
        background: json["background"] == null
            ? null
            : PurpleBackground.fromJson(json["background"]),
        status: json["status"],
        currentRank: json["current_rank"],
        currentColor: json["current_color"],
        verified: json["verified"],
        sponsor: json["sponsor"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        links: json["_links"] == null
            ? null
            : AuthorLinks.fromJson(json["_links"]),
      );
}

class PurpleAvatar {
  PurpleAvatar({
    this.urls,
    this.uuid,
  });

  final AvatarUrls? urls;
  final String? uuid;

  factory PurpleAvatar.fromJson(Map<String, dynamic> json) => PurpleAvatar(
        urls: AvatarUrls.fromJson(json["urls"]),
        uuid: json["uuid"],
      );
}

class PurpleBackground {
  PurpleBackground({
    this.urls,
    this.uuid,
  });

  final BackgroundUrls? urls;
  final String? uuid;

  factory PurpleBackground.fromJson(Map<String, dynamic> json) =>
      PurpleBackground(
        urls: BackgroundUrls.fromJson(json["urls"]),
        uuid: json["uuid"],
      );
}

class CommentInteractions {
  CommentInteractions({
    this.isLiked,
    this.isReported,
  });

  final bool? isLiked;
  final bool? isReported;

  factory CommentInteractions.fromJson(Map<String, dynamic> json) =>
      CommentInteractions(
        isLiked: json["is_liked"],
        isReported: json["is_reported"],
      );
}

class CommentLinks {
  CommentLinks({
    this.self,
    this.likes,
  });

  final First? self;
  final First? likes;

  factory CommentLinks.fromJson(Map<String, dynamic> json) => CommentLinks(
        self: First.fromJson(json["self"]),
        likes: First.fromJson(json["likes"]),
      );
}

class CommentStats {
  CommentStats({
    this.numLikes,
    this.numReports,
  });

  final int? numLikes;
  final int? numReports;

  factory CommentStats.fromJson(Map<String, dynamic> json) => CommentStats(
        numLikes: json["num_likes"],
        numReports: json["num_reports"],
      );
}

class CommunityShort {
  CommunityShort({
    this.name,
    this.slug,
    this.avatar,
    this.background,
  });

  final String? name;
  final String? slug;
  final CommunityAvatar? avatar;
  final CommunityBackground? background;

  factory CommunityShort.fromJson(Map<String, dynamic> json) => CommunityShort(
        name: json["name"],
        slug: json["slug"],
        avatar: json["avatar"] == null
            ? null
            : CommunityAvatar.fromJson(json["avatar"]),
        background: json["background"] == null
            ? null
            : CommunityBackground.fromJson(json["background"]),
      );
}

class CommunityTopic {
  CommunityTopic({
    this.name,
    this.slug,
  });

  final String? name;
  final String? slug;

  factory CommunityTopic.fromJson(Map<String, dynamic> json) => CommunityTopic(
        name: json["name"],
        slug: json["slug"],
      );
}

class PostImage {
  PostImage({
    this.urls,
    this.uuid,
    this.position,
  });

  final ImageUrls? urls;
  final String? uuid;
  final int? position;

  factory PostImage.fromJson(Map<String, dynamic> json) => PostImage(
        urls: ImageUrls.fromJson(json["urls"]),
        uuid: json["uuid"],
        position: json["position"],
      );
}

class ImageUrls {
  ImageUrls({
    this.the250X250,
    this.the500X500,
    this.the1200X900,
  });

  final String? the250X250;
  final String? the500X500;
  final String? the1200X900;

  factory ImageUrls.fromJson(Map<String, dynamic> json) => ImageUrls(
        the250X250: json["250x250"],
        the500X500: json["500x500"],
        the1200X900: json["1200x900"],
      );
}

class ItemStats {
  ItemStats({
    this.numLikes,
    this.numComments,
    this.numFavorites,
    this.hotness,
  });

  final int? numLikes;
  final int? numComments;
  final int? numFavorites;
  final int? hotness;

  factory ItemStats.fromJson(Map<String, dynamic> json) => ItemStats(
        numLikes: json["num_likes"],
        numComments: json["num_comments"],
        numFavorites: json["num_favorites"],
        hotness: json["hotness"],
      );
}

class Tag {
  Tag({
    this.name,
    this.links,
  });

  final String? name;
  final TagLinks? links;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json["name"],
        links: TagLinks.fromJson(json["_links"]),
      );
}

class TagLinks {
  TagLinks({
    this.self,
    this.follows,
    this.blocks,
  });

  final First? self;
  final First? follows;
  final First? blocks;

  factory TagLinks.fromJson(Map<String, dynamic> json) => TagLinks(
        self: First.fromJson(json["self"]),
        follows: First.fromJson(json["follows"]),
        blocks: First.fromJson(json["blocks"]),
      );
}

class ItemLinks {
  ItemLinks({
    this.self,
    this.comments,
    this.likes,
    this.favorites,
  });

  final First? self;
  final First? comments;
  final First? likes;
  final First? favorites;

  factory ItemLinks.fromJson(Map<String, dynamic> json) => ItemLinks(
        self: First.fromJson(json["self"]),
        comments: First.fromJson(json["comments"]),
        likes: First.fromJson(json["likes"]),
        favorites: First.fromJson(json["favorites"]),
      );
}

class PostLinks {
  PostLinks({
    this.self,
    this.first,
    this.last,
    this.next,
  });

  final First? self;
  final First? first;
  final First? last;
  final First? next;

  factory PostLinks.fromJson(Map<String, dynamic> json) => PostLinks(
        self: First.fromJson(json["self"]),
        first: First.fromJson(json["first"]),
        last: First.fromJson(json["last"]),
        next: First.fromJson(json["next"]),
      );
}
