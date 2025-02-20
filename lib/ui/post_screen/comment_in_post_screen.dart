import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_emoji/dart_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:hejtter/models/comments_response.dart';
import 'package:hejtter/services/hejto_api.dart';
import 'package:hejtter/ui/post_screen/answer_button.dart';
import 'package:hejtter/ui/user_screen/user_screen.dart';
import 'package:hejtter/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class CommentInPostScreen extends StatefulWidget {
  const CommentInPostScreen({
    required this.comment,
    required this.respondToUser,
    super.key,
  });

  final CommentItem comment;
  final Function(String?) respondToUser;

  @override
  State<CommentInPostScreen> createState() => _CommentInPostScreenState();
}

class _CommentInPostScreenState extends State<CommentInPostScreen> {
  CommentItem? comment;

  _setTimeAgoLocale() {
    timeago.setLocaleMessages('pl', timeago.PlMessages());
  }

  String _addEmojis(String text) {
    final parser = EmojiParser();
    return parser.emojify(text);
  }

  _goToUserScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          userName: comment?.author?.username,
        ),
      ),
    );
  }

  _likeComment(BuildContext context) async {
    final result = await hejtoApi.likeComment(
      postSlug: comment?.postSlug,
      commentUUID: comment?.uuid,
      context: context,
    );
    if (result && mounted) {
      final newComment = await _refreshComment(context);

      setState(() {
        comment = newComment;
      });
    }
  }

  _unlikeComment(BuildContext context) async {
    final result = await hejtoApi.unlikeComment(
      postSlug: comment?.postSlug,
      commentUUID: comment?.uuid,
      context: context,
    );

    if (result && mounted) {
      final newComment = await _refreshComment(context);

      setState(() {
        comment = newComment;
      });
    }
  }

  Future<CommentItem?> _refreshComment(BuildContext context) async {
    return await hejtoApi.getCommentDetails(
      postSlug: comment?.postSlug,
      commentUUID: comment?.uuid,
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();

    comment = widget.comment;
  }

  @override
  Widget build(BuildContext context) {
    _setTimeAgoLocale();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  _buildAvatar(context),
                  const SizedBox(width: 8),
                  _buildUsernameAndDate(context),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            _buildLikes(comment?.numLikes, context),
          ],
        ),
        _buildContent(context),
        Padding(
          padding: const EdgeInsets.only(left: 26),
          child: AnswerButton(
            isSmaller: true,
            username: widget.comment.author?.username,
            respondToUser: widget.respondToUser,
          ),
        ),
        const SizedBox(height: 0),
      ],
    );
  }

  Row _buildContent(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 35),
        Expanded(
          child: MarkdownBody(
            data: _addEmojis('${comment?.content}'),
            styleSheet:
                MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              blockquoteDecoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            selectable: true,
            onTapLink: (text, href, title) {
              launchUrl(
                Uri.parse(href.toString()),
                mode: LaunchMode.externalApplication,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLikes(int? numLikes, BuildContext context) {
    return Row(
      children: [
        Text(
          numLikes != null ? numLikes.toString() : '0',
          style: TextStyle(
            fontSize: 12,
            color: comment?.isLiked == true ? const Color(0xffFFC009) : null,
          ),
        ),
        IconButton(
          onPressed: () => comment?.isLiked == true
              ? _unlikeComment(context)
              : _likeComment(context),
          icon: Icon(
            Icons.bolt,
            size: 20,
            color: comment?.isLiked == true ? const Color(0xffFFC009) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = comment?.author?.avatar?.urls?.the100X100;

    return GestureDetector(
      onTap: () => _goToUserScreen(context),
      child: SizedBox(
        height: 28,
        width: 28,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: CachedNetworkImage(
            imageUrl: avatarUrl ?? defaultAvatar,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameAndDate(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _goToUserScreen(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                comment?.author != null
                    ? comment!.author!.username.toString()
                    : 'null',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            SizedBox(width: comment?.author?.sponsor == true ? 5 : 0),
            comment?.author?.sponsor == true
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
            Text(
              comment?.createdAt != null
                  ? timeago.format(DateTime.parse('${comment?.createdAt}'),
                      locale: 'pl')
                  : 'null',
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
