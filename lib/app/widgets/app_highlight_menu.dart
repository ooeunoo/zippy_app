// import 'package:flutter/material.dart';
// import 'package:highlightable_text/highlightable_text.dart';
// import 'package:zippy/app/styles/color.dart';

// class AppHighlightMenu extends StatelessWidget {
//   final Highlight? highlight;
//   final VoidCallback onHighlight;
//   final VoidCallback onNote;
//   final VoidCallback onDelete;

//   const AppHighlightMenu({
//     super.key,
//     this.highlight,
//     required this.onHighlight,
//     required this.onNote,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       elevation: 8,
//       borderRadius: BorderRadius.circular(8),
//       color: AppColor.graymodern950,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (highlight == null) ...[
//             IconButton(
//               icon: const Icon(Icons.check_box, color: Colors.white),
//               onPressed: onHighlight,
//               tooltip: '하이라이트',
//               constraints: const BoxConstraints(minWidth: 40),
//             ),
//           ],
//           IconButton(
//             icon: Icon(
//               highlight?.note?.isNotEmpty == true
//                   ? Icons.edit_note
//                   : Icons.note_add,
//               color: Colors.white,
//             ),
//             onPressed: onNote,
//             tooltip: highlight?.note?.isNotEmpty == true ? '메모 수정' : '메모 추가',
//             constraints: const BoxConstraints(minWidth: 40),
//           ),
//           if (highlight != null) ...[
//             IconButton(
//               icon: const Icon(Icons.delete, color: AppColor.rose800),
//               onPressed: onDelete,
//               tooltip: '삭제',
//               constraints: const BoxConstraints(minWidth: 40),
//             ),
//           ],
//         ],
//       ),
//     );
//   }
// }
