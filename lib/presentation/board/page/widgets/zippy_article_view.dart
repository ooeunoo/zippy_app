import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zippy/app/styles/color.dart';
import 'package:zippy/app/styles/theme.dart';
import 'package:zippy/domain/model/article.model.dart';

class ZippyArticleView extends StatefulWidget {
  final Article article;

  const ZippyArticleView({Key? key, required this.article}) : super(key: key);

  @override
  _ZippyArticleViewState createState() => _ZippyArticleViewState();
}

class _ZippyArticleViewState extends State<ZippyArticleView> {
  bool _isCommentsOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSection(),
            _buildKeyPointsAndSummary(),
            _buildContent(),
            _buildKeywords(),
          ],
        ),
      ),
      bottomSheet: _isCommentsOpen ? _buildCommentSection() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        '뉴스',
        style: Theme.of(context).textTheme.textXL,
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainImage(),
          SizedBox(height: 16),
          Text(
            widget.article.title,
            style: Theme.of(context)
                .textTheme
                .textXL
                .copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            widget.article.subtitle ?? '',
            style: Theme.of(context)
                .textTheme
                .textSM
                .copyWith(color: AppColor.graymodern600),
          ),
          SizedBox(height: 16),
          _buildEngagementSection(),
        ],
      ),
    );
  }

  Widget _buildMainImage() {
    return Container(
      height: 200,
      width: double.infinity,
      child: CachedNetworkImage(
        imageUrl:
            widget.article.images.isNotEmpty ? widget.article.images[0] : '',
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(color: Colors.grey[300]),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }

  Widget _buildEngagementSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(widget.article.author),
            SizedBox(width: 8),
            Text(widget.article.published.toString()),
          ],
        ),
        Row(
          children: [
            Icon(Icons.remove_red_eye, size: 16),
            SizedBox(width: 4),
            Text(widget.article.metadata?.viewCount.toString() ?? '0'),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () => setState(() => _isCommentsOpen = true),
              child: Row(
                children: [
                  Icon(Icons.chat_bubble_outline, size: 16),
                  SizedBox(width: 4),
                  Text(widget.article.metadata?.commentCount.toString() ?? '0'),
                ],
              ),
            ),
            SizedBox(width: 16),
            Icon(Icons.share, size: 16),
          ],
        ),
      ],
    );
  }

  Widget _buildKeyPointsAndSummary() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('주요 포인트', style: Theme.of(context).textTheme.textXL),
          SizedBox(height: 8),
          Column(
            children: widget.article.keyPoints
                    ?.map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Expanded(child: Text(point)),
                            ],
                          ),
                        ))
                    .toList() ??
                [],
          ),
          SizedBox(height: 16),
          Text('요약', style: Theme.of(context).textTheme.textXL),
          SizedBox(height: 8),
          Text(widget.article.summary ?? ''),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(widget.article.content ?? ''),
    );
  }

  Widget _buildKeywords() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.article.keywords
                ?.map((keyword) => Chip(
                      label: Text('#$keyword'),
                      backgroundColor: Colors.grey[200],
                    ))
                .toList() ??
            [],
      ),
    );
  }

  Widget _buildCommentSection() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          _buildCommentHeader(),
          Expanded(child: _buildCommentList()),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildCommentHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('댓글', style: Theme.of(context).textTheme.textXL),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() => _isCommentsOpen = false),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    // Implement comment list here
    return ListView();
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: '댓글 달기...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
