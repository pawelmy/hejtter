import 'package:hejtter/models/comments_response.dart';
import 'package:hejtter/models/posts_response.dart';

class Post {
  Post({
    this.comments,
    this.type,
    this.title,
    this.slug,
    this.content,
    this.contentPlain,
    this.excerpt,
    this.status,
    this.hot,
    this.images,
    this.tags,
    this.author,
    this.community,
    this.nsfw,
    this.controversial,
    this.commentsEnabled,
    this.favoritesEnabled,
    this.likesEnabled,
    this.reportsEnabled,
    this.sharesEnabled,
    this.createdAt,
    this.discr,
    this.links,
    this.communityTopic,
    this.link,
    this.updatedAt,
    this.numLikes,
    this.isLiked,
    this.isFavorited,
    this.isCommented,
  });

  final List<CommentItem>? comments;
  final String? type;
  final String? title;
  final String? slug;
  final String? content;
  final String? contentPlain;
  final String? excerpt;
  final String? status;
  final bool? hot;
  final List<PostImage>? images;
  final List<Tag>? tags;
  final ItemAuthor? author;
  final CommunityShort? community;
  final bool? nsfw;
  final bool? controversial;
  final bool? commentsEnabled;
  final bool? favoritesEnabled;
  final bool? likesEnabled;
  final bool? reportsEnabled;
  final bool? sharesEnabled;
  final DateTime? createdAt;
  final String? discr;
  final ItemLinks? links;
  final CommunityTopic? communityTopic;
  final String? link;
  final DateTime? updatedAt;
  final int? numLikes;
  final bool? isLiked;
  final bool? isFavorited;
  final bool? isCommented;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        comments: json["comments"] == null
            ? null
            : List<CommentItem>.from(
                json["comments"].map((x) => CommentItem.fromJson(x))),
        type: json["type"],
        title: json["title"],
        slug: json["slug"],
        content: json["content"],
        contentPlain: json["content_plain"],
        excerpt: json["excerpt"],
        status: json["status"],
        hot: json["hot"],
        images: json["images"] == null
            ? null
            : List<PostImage>.from(
                json["images"].map((x) => PostImage.fromJson(x))),
        tags: json["tags"] == null
            ? null
            : List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        author:
            json["author"] == null ? null : ItemAuthor.fromJson(json["author"]),
        community: json["community"] == null
            ? null
            : CommunityShort.fromJson(json["community"]),
        nsfw: json["nsfw"],
        controversial: json["controversial"],
        commentsEnabled: json["comments_enabled"],
        favoritesEnabled: json["favorites_enabled"],
        likesEnabled: json["likes_enabled"],
        reportsEnabled: json["reports_enabled"],
        sharesEnabled: json["shares_enabled"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        discr: json["discr"],
        links:
            json["_links"] == null ? null : ItemLinks.fromJson(json["_links"]),
        communityTopic: json["community_topic"] == null
            ? null
            : CommunityTopic.fromJson(json["community_topic"]),
        link: json["link"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        numLikes: json["num_likes"],
        isLiked: json["is_liked"],
        isFavorited: json["is_favorited"],
        isCommented: json["is_commented"],
      );
}
