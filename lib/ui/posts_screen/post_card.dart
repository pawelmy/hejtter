import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_emoji/dart_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hejtter/models/post.dart';
import 'package:hejtter/services/hejto_api.dart';
import 'package:hejtter/ui/post_screen/picture_preview.dart';
import 'package:hejtter/ui/posts_screen/comment_in_post_card.dart';
import 'package:hejtter/ui/post_screen/post_screen.dart';
import 'package:hejtter/ui/posts_screen/posts_screen.dart';
import 'package:hejtter/ui/user_screen/user_screen.dart';
import 'package:hejtter/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    required this.item,
    Key? key,
  }) : super(key: key);

  final Post item;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard>
    with AutomaticKeepAliveClientMixin {
  late Post item;

  _goToUserScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          userName: item.author?.username,
        ),
      ),
    );
  }

  String _addEmojis(String text) {
    final parser = EmojiParser();
    return parser.emojify(text);
  }

  _setTimeAgoLocale() {
    timeago.setLocaleMessages('pl', timeago.PlMessages());
  }

  _refreshPost() async {
    final newItem = await hejtoApi.getPostDetails(
      postSlug: item.slug,
      context: context,
    );

    if (newItem != null) {
      setState(() {
        item = newItem;
      });
    }
  }

  _likePost() async {
    if (item.slug == null) return;

    final postLiked = await hejtoApi.likePost(
      postSlug: item.slug!,
      context: context,
    );

    if (postLiked) {
      final refreshedPost = await hejtoApi.getPostDetails(
        postSlug: item.slug,
        context: context,
      );

      if (refreshedPost != null) {
        setState(() {
          item = refreshedPost;
        });
      }
    }
  }

  _unlikePost() async {
    if (item.slug == null) return;

    final postUnliked = await hejtoApi.unlikePost(
      postSlug: item.slug!,
      context: context,
    );

    if (postUnliked) {
      final refreshedPost = await hejtoApi.getPostDetails(
        postSlug: item.slug,
        context: context,
      );

      if (refreshedPost != null) {
        setState(() {
          item = refreshedPost;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _setTimeAgoLocale();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return PostScreen(
              post: item,
              refreshCallback: _refreshPost,
            );
          }));
        },
        child: Material(
          color: backgroundColor,
          child: Card(
            color: backgroundColor,
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(50),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUsernameAndRank(),
                            const SizedBox(height: 3),
                            _buildCommunityAndDate(),
                          ],
                        ),
                      ),
                      _buildHotIcon(),
                      const SizedBox(width: 20),
                      Text(
                        item.numLikes != null
                            ? item.numLikes.toString()
                            : 'null',
                        style: TextStyle(
                          color: item.isLiked == true
                              ? const Color(0xffFFC009)
                              : null,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5),
                        child: IconButton(
                          onPressed:
                              item.isLiked == true ? _unlikePost : _likePost,
                          icon: Icon(
                            Icons.bolt,
                            color: item.isLiked == true
                                ? const Color(0xffFFC009)
                                : null,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildContent(),
                    _buildTags(),
                    _buildPicture(),
                    const SizedBox(height: 20),
                    _buildComments(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPicture() {
    if (item.images == null ||
        item.images!.isEmpty ||
        item.images![0].urls?.the1200X900 == null) {
      return const SizedBox();
    }

    final bool multiplePics = item.images!.length > 1;

    return PicturePreview(
      imageUrl: item.images![0].urls!.the1200X900!,
      multiplePics: multiplePics,
      nsfw: item.nsfw ?? false,
      imagesUrls: item.images,
    );
  }

  Widget _buildHotIcon() {
    return Column(
      children: [
        SizedBox(width: item.hot == true ? 5 : 0),
        item.hot == true
            ? const Icon(
                Icons.local_fire_department_outlined,
                color: Color(0xff2295F3),
              )
            : const SizedBox(),
      ],
    );
  }

  //TODO: widget.item should be just item (get post details returns empty comments section)
  Widget _buildComments() {
    if (widget.item.comments != null && widget.item.comments!.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withAlpha(50),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 15),
            CommentInPostCard(
              comment: widget.item.comments![0],
              postItem: widget.item,
              refreshCallback: _refreshPost,
            ),
            SizedBox(height: widget.item.comments!.length > 1 ? 10 : 0),
            widget.item.comments!.length > 1
                ? CommentInPostCard(
                    comment: widget.item.comments![1],
                    postItem: widget.item,
                    refreshCallback: _refreshPost,
                  )
                : const SizedBox(),
            SizedBox(height: widget.item.comments!.length > 2 ? 10 : 0),
            widget.item.comments!.length > 2
                ? CommentInPostCard(
                    comment: widget.item.comments![2],
                    postItem: widget.item,
                    refreshCallback: _refreshPost,
                  )
                : const SizedBox(),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildTags() {
    if (item.tags != null && item.tags!.isNotEmpty) {
      List<Widget> tags = List.empty(growable: true);

      for (var tag in item.tags!) {
        if (tag.name != null) {
          tags.add(GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostsScreen(
                    tagName: tag.name!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
              child: Text(
                '#${tag.name!} ',
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ));
        }
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Wrap(
          children: tags,
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MarkdownBody(
        data: _addEmojis(item.content.toString()),
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
          blockquoteDecoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        selectable: true,
        onTapText: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return PostScreen(
              post: item,
              refreshCallback: _refreshPost,
            );
          }));
        },
        onTapLink: (text, href, title) {
          launchUrl(
            Uri.parse(href.toString()),
            mode: LaunchMode.externalApplication,
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    final avatarUrl = item.author?.avatar?.urls?.the100X100;

    return GestureDetector(
      onTap: _goToUserScreen,
      child: SizedBox(
        height: 36,
        width: 36,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: avatarUrl ?? defaultAvatar,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameAndRank() {
    return GestureDetector(
      onTap: _goToUserScreen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    item.author != null
                        ? item.author!.username.toString()
                        : 'null',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(width: item.author?.sponsor == true ? 5 : 0),
                item.author?.sponsor == true
                    ? Transform.rotate(
                        angle: 180,
                        child: const Icon(
                          Icons.mode_night_rounded,
                          color: Colors.brown,
                          size: 16,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(width: 5),
                _buildRankPlate(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankPlate() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        item.author != null ? item.author!.currentRank.toString() : 'null',
        style: TextStyle(
          fontSize: 11,
          color: item.author?.currentColor != null
              ? Color(
                  int.parse(
                    item.author!.currentColor!.replaceAll('#', '0xff'),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  Row _buildCommunityAndDate() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text('w '),
        Flexible(
          child: GestureDetector(
            onTap: (() {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostsScreen(
                    communityName: item.community!.name,
                    communitySlug: item.community!.slug,
                  ),
                ),
              );
            }),
            child: Text(
              item.community?.name != null
                  ? item.community!.name.toString()
                  : 'null',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          item.createdAt != null
              ? timeago.format(DateTime.parse(item.createdAt.toString()),
                  locale: 'pl')
              : 'null',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
