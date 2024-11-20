// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:get/get.dart';
// import 'package:uuid/uuid.dart';
// import 'package:zippy/app/services/article.service.dart';
// import 'package:zippy/app/styles/color.dart';
// import 'package:zippy/app/styles/dimens.dart';
// import 'package:zippy/app/styles/font.dart';
// import 'package:zippy/app/styles/theme.dart';
// import 'package:zippy/app/utils/share.dart';
// import 'package:zippy/app/widgets/app_divider.dart';
// import 'package:zippy/app/widgets/app_header.dart';
// import 'package:zippy/app/widgets/app_spacer_h.dart';
// import 'package:zippy/app/widgets/app_spacer_v.dart';
// import 'package:zippy/app/widgets/app_text.dart';
// import 'package:zippy/data/sources/user_bookmark.source.dart';
// import 'package:zippy/domain/model/user_bookmark.model.dart';
// import 'package:zippy/domain/model/user_bookmark_folder.model.dart';

// class BookmarkPage extends StatefulWidget {
//   const BookmarkPage({super.key});

//   @override
//   State<BookmarkPage> createState() => _BookmarkPageState();
// }

// class _BookmarkPageState extends State<BookmarkPage> {
//   final ArticleService articleService = Get.find();
//   String selectedFolderId = UserBookmarkKey.all.name;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _buildAppBar(context),
//       body: Column(
//         children: [
//           _buildFolderList(context),
//           Expanded(child: _buildBookmarkList(context)),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showCreateFolderDialog(context),
//         backgroundColor: AppColor.blue500,
//         child: const Icon(Icons.create_new_folder, color: AppColor.white),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return AppHeader(
//       backgroundColor: AppColor.transparent,
//       automaticallyImplyLeading: true,
//       title: AppText(
//         "저장한 콘텐츠",
//         style: Theme.of(context).textTheme.textXL.copyWith(
//             color: AppColor.gray100, fontWeight: AppFontWeight.medium),
//       ),
//     );
//   }

//   Widget _buildFolderList(BuildContext context) {
//     return Container(
//       height: AppDimens.height(85),
//       margin: EdgeInsets.symmetric(
//         vertical: AppDimens.height(8),
//         horizontal: AppDimens.width(16),
//       ),
//       child: Obx(() => ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: articleService.userBookmarkFolders.length + 1,
//             itemBuilder: (context, index) {
//               if (index == 0) {
//                 return _buildFolderItem(
//                   context,
//                   UserBookmarkKey.all.name,
//                   UserBookmarkKey.all.name,
//                   null,
//                   true,
//                 );
//               }
//               final folder = articleService.userBookmarkFolders[index - 1];
//               return _buildFolderItem(
//                 context,
//                 folder.id,
//                 folder.name,
//                 folder.description,
//                 false,
//               );
//             },
//           )),
//     );
//   }

//   Widget _buildFolderItem(
//     BuildContext context,
//     String folderId,
//     String name,
//     String? description,
//     bool isAll,
//   ) {
//     final isSelected = selectedFolderId == folderId;

//     return Container(
//       width: AppDimens.width(70),
//       margin: EdgeInsets.only(right: AppDimens.width(8)),
//       child: GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedFolderId = folderId;
//           });
//         },
//         child: Stack(
//           alignment: Alignment.topCenter,
//           children: [
//             // 폴더 탭 부분
//             Container(
//               height: AppDimens.height(8),
//               width: AppDimens.width(35),
//               margin: EdgeInsets.only(
//                 top: AppDimens.height(2),
//                 right: AppDimens.width(4),
//               ),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColor.blue500 : AppColor.graymodern800,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(AppDimens.radius(4)),
//                   topRight: Radius.circular(AppDimens.radius(4)),
//                 ),
//               ),
//             ),
//             // 폴더 메인 부분
//             Container(
//               margin: EdgeInsets.only(top: AppDimens.height(8)),
//               padding: EdgeInsets.symmetric(
//                 horizontal: AppDimens.width(6),
//                 vertical: AppDimens.height(8),
//               ),
//               decoration: BoxDecoration(
//                 color: isSelected ? AppColor.blue500 : AppColor.graymodern800,
//                 borderRadius: BorderRadius.circular(AppDimens.radius(8)),
//                 boxShadow: [
//                   if (isSelected)
//                     BoxShadow(
//                       color: AppColor.blue500.withOpacity(0.3),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                 ],
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     isAll ? Icons.folder : Icons.folder_outlined,
//                     size: AppDimens.size(24),
//                     color: isSelected ? AppColor.white : AppColor.graymodern400,
//                   ),
//                   AppSpacerV(value: AppDimens.height(4)),
//                   Tooltip(
//                     message:
//                         '$name${description != null ? '\n$description' : ''}',
//                     textStyle: Theme.of(context).textTheme.textSM.copyWith(
//                           color: AppColor.white,
//                         ),
//                     decoration: BoxDecoration(
//                       color: AppColor.graymodern800,
//                       borderRadius: BorderRadius.circular(AppDimens.radius(4)),
//                     ),
//                     child: Column(
//                       children: [
//                         AppText(
//                           name,
//                           align: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: Theme.of(context).textTheme.textXS.copyWith(
//                                 color: isSelected
//                                     ? AppColor.white
//                                     : AppColor.graymodern400,
//                                 fontWeight: isSelected
//                                     ? AppFontWeight.medium
//                                     : FontWeight.normal,
//                               ),
//                         ),
//                         if (description != null && description.isNotEmpty) ...[
//                           AppSpacerV(value: AppDimens.height(2)),
//                           AppText(
//                             description,
//                             align: TextAlign.center,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context).textTheme.textXXS.copyWith(
//                                   color: isSelected
//                                       ? AppColor.white.withOpacity(0.8)
//                                       : AppColor.graymodern600,
//                                 ),
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // 폴더 내 콘텐츠 수 표시
//             if (!isAll)
//               Positioned(
//                 top: 0,
//                 right: 0,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppDimens.width(4),
//                     vertical: AppDimens.height(1),
//                   ),
//                   decoration: BoxDecoration(
//                     color: isSelected ? AppColor.white : AppColor.blue400,
//                     borderRadius: BorderRadius.circular(AppDimens.radius(8)),
//                   ),
//                   child: Obx(() {
//                     final count = articleService.userBookmarks
//                         .where((bookmark) => bookmark.folderId == folderId)
//                         .length;
//                     return AppText(
//                       count.toString(),
//                       style: Theme.of(context).textTheme.textXXS.copyWith(
//                             color:
//                                 isSelected ? AppColor.blue500 : AppColor.white,
//                             fontWeight: AppFontWeight.bold,
//                           ),
//                     );
//                   }),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBookmarkList(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeInOut,
//       margin: EdgeInsets.only(
//         top: AppDimens.height(8),
//       ),
//       decoration: BoxDecoration(
//         color: AppColor.graymodern900,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(AppDimens.radius(20)),
//           topRight: Radius.circular(AppDimens.radius(20)),
//         ),
//         border: Border.all(
//           color: AppColor.graymodern800,
//           width: 1,
//         ),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(AppDimens.radius(20)),
//           topRight: Radius.circular(AppDimens.radius(20)),
//         ),
//         child: Obx(() {
//           final bookmarks = selectedFolderId == UserBookmarkKey.all.name
//               ? articleService.userBookmarks
//               : articleService.userBookmarks
//                   .where((bookmark) => bookmark.folderId == selectedFolderId)
//                   .toList();

//           if (bookmarks.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.bookmark_border,
//                     size: AppDimens.size(48),
//                     color: AppColor.graymodern600,
//                   ),
//                   AppSpacerV(value: AppDimens.height(16)),
//                   AppText(
//                     '저장된 콘텐츠가 없습니다',
//                     style: Theme.of(context).textTheme.textMD.copyWith(
//                           color: AppColor.graymodern600,
//                         ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return ListView.builder(
//             itemCount: bookmarks.length,
//             padding: EdgeInsets.only(top: AppDimens.height(16)),
//             itemBuilder: (BuildContext context, int index) {
//               final bookmark = bookmarks[index];
//               final isLastItem = index == bookmarks.length - 1;

//               return Padding(
//                 padding: EdgeInsets.symmetric(horizontal: AppDimens.width(5)),
//                 child: _buildBookmarkItem(
//                   context,
//                   bookmark,
//                   isLastItem,
//                   articleService.onHandleDeleteUserBookmark,
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }

//   Widget _buildBookmarkItem(
//     BuildContext context,
//     UserBookmark bookmark,
//     bool isLastItem,
//     Function delete,
//   ) {
//     return Slidable(
//       key: ValueKey(bookmark.id),
//       startActionPane: ActionPane(
//         motion: const ScrollMotion(),
//         children: [
//           SlidableAction(
//             onPressed: (BuildContext context) => delete(bookmark),
//             backgroundColor: AppColor.rose700.withOpacity(0.9),
//             foregroundColor: AppColor.white,
//             icon: Icons.delete,
//             label: 'Delete',
//           ),
//           SlidableAction(
//             onPressed: (BuildContext context) async {
//               await toShare(bookmark.link, bookmark.title);
//             },
//             backgroundColor: AppColor.brand600.withOpacity(0.9),
//             foregroundColor: AppColor.white,
//             icon: Icons.share,
//             label: 'Share',
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           AppSpacerV(value: AppDimens.size(5)),
//           ListTile(
//             leading: SizedBox(
//               height: AppDimens.size(40),
//               width: AppDimens.size(40),
//               child: CircleAvatar(
//                 radius: AppDimens.size(16),
//                 backgroundImage: bookmark.images != null
//                     ? NetworkImage(bookmark.images!)
//                     : null,
//               ),
//             ),
//             title: AppText(
//               bookmark.title.trim(),
//               maxLines: 2,
//               style: Theme.of(context).textTheme.textMD.copyWith(
//                     color: AppColor.graymodern100,
//                   ),
//             ),
//             onTap: () => articleService.onHandleClickUserBookmark(bookmark),
//             minLeadingWidth: bookmark.images != null ? 30 : 0,
//           ),
//           AppSpacerV(value: AppDimens.size(5)),
//           if (!isLastItem) const AppDivider(),
//         ],
//       ),
//     );
//   }

//   void _showCreateFolderDialog(BuildContext context) {
//     final nameController = TextEditingController();
//     final descriptionController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: AppColor.graymodern900,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppDimens.radius(12)),
//           ),
//           title: Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(AppDimens.width(8)),
//                 decoration: BoxDecoration(
//                   color: AppColor.blue500.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(AppDimens.radius(8)),
//                 ),
//                 child: Icon(
//                   Icons.create_new_folder,
//                   color: AppColor.blue400,
//                   size: AppDimens.size(20),
//                 ),
//               ),
//               AppSpacerH(value: AppDimens.width(12)),
//               AppText(
//                 '새 폴더 만들기',
//                 style: Theme.of(context).textTheme.textLG.copyWith(
//                       color: AppColor.graymodern100,
//                       fontWeight: AppFontWeight.bold,
//                     ),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               TextField(
//                 controller: nameController,
//                 autofocus: true,
//                 style: Theme.of(context).textTheme.textMD.copyWith(
//                       color: AppColor.graymodern200,
//                     ),
//                 decoration: InputDecoration(
//                   hintText: '폴더 이름',
//                   hintStyle: Theme.of(context).textTheme.textMD.copyWith(
//                         color: AppColor.graymodern600,
//                       ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: AppColor.graymodern700),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: AppColor.blue400),
//                   ),
//                 ),
//               ),
//               AppSpacerV(value: AppDimens.height(20)),
//               TextField(
//                 controller: descriptionController,
//                 style: Theme.of(context).textTheme.textMD.copyWith(
//                       color: AppColor.graymodern200,
//                     ),
//                 decoration: InputDecoration(
//                   hintText: '폴더 설명 (선택)',
//                   hintStyle: Theme.of(context).textTheme.textMD.copyWith(
//                         color: AppColor.graymodern600,
//                       ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: AppColor.graymodern700),
//                   ),
//                   focusedBorder: UnderlineInputBorder(
//                     borderSide: BorderSide(color: AppColor.blue400),
//                   ),
//                 ),
//               ),
//               AppSpacerV(value: AppDimens.height(8)),
//               AppText(
//                 '북마크를 구분하는데 도움이 되는 설명을 추가해보세요',
//                 style: Theme.of(context).textTheme.textXS.copyWith(
//                       color: AppColor.graymodern500,
//                       height: 1.4,
//                     ),
//               ),
//             ],
//           ),
//           actionsPadding: EdgeInsets.symmetric(
//             horizontal: AppDimens.width(16),
//             vertical: AppDimens.height(16),
//           ),
//           actions: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: AppText(
//                     '취소',
//                     style: Theme.of(context).textTheme.textMD.copyWith(
//                           color: AppColor.graymodern400,
//                         ),
//                   ),
//                 ),
//                 FilledButton(
//                   onPressed: () {
//                     if (nameController.text.isNotEmpty) {
//                       articleService.onHandleCreateUserBookmarkFolder(
//                         UserBookmarkFolder(
//                           id: const Uuid().v4(),
//                           name: nameController.text,
//                           description: descriptionController.text.isNotEmpty
//                               ? descriptionController.text
//                               : null,
//                           createdAt: DateTime.now(),
//                         ),
//                       );
//                       Navigator.pop(context);
//                     }
//                   },
//                   style: FilledButton.styleFrom(
//                     backgroundColor: AppColor.blue500,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(AppDimens.radius(8)),
//                     ),
//                   ),
//                   child: AppText(
//                     '생성',
//                     style: Theme.of(context).textTheme.textMD.copyWith(
//                           color: AppColor.white,
//                           fontWeight: AppFontWeight.bold,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
