// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class AppVideoPlayer extends StatefulWidget {
//   final String videoUrl;

//   const AppVideoPlayer({
//     Key? key,
//     required this.videoUrl,
//   }) : super(key: key);

//   @override
//   State<AppVideoPlayer> createState() => _AppVideoPlayerState();
// }

// class _AppVideoPlayerState extends State<AppVideoPlayer> {
//   late InAppWebViewController _webViewController;
//   bool _isLoading = true;

//   // HTML 템플릿 생성
//   String _generateHtmlContent() {
//     return '''
//       <!DOCTYPE html>
//       <html>
//         <head>
//           <meta name="viewport" content="width=device-width, initial-scale=1.0">
//           <style>
//             body {
//               margin: 0;
//               padding: 0;
//               background-color: black;
//               display: flex;
//               justify-content: center;
//               align-items: center;
//               height: 100vh;
//             }
//             video {
//               max-width: 100%;
//               max-height: 100%;
//               object-fit: contain;
//             }
//           </style>
//         </head>
//         <body>
//           <video 
//             controls 
//             playsinline
//             preload="metadata"
//             poster="">
//             <source src="${widget.videoUrl}" type="video/mp4">
//             Your browser does not support the video tag.
//           </video>
//           <script>
//             document.addEventListener('DOMContentLoaded', function() {
//               const video = document.querySelector('video');
//               video.addEventListener('loadedmetadata', function() {
//                 window.flutter_inappwebview.callHandler('onVideoLoaded');
//               });
//               video.addEventListener('error', function() {
//                 window.flutter_inappwebview.callHandler('onVideoError');
//               });
//             });
//           </script>
//         </body>
//       </html>
//     ''';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         InAppWebView(
//           initialData: InAppWebViewInitialData(
//             data: _generateHtmlContent(),
//             mimeType: 'text/html',
//             encoding: 'utf-8',
//           ),
//           initialOptions: InAppWebViewGroupOptions(
//             crossPlatform: InAppWebViewOptions(
//               mediaPlaybackRequiresUserGesture: false,
//               transparentBackground: true,
//               useShouldOverrideUrlLoading: true,
//               javaScriptEnabled: true,
//             ),
//           ),
//           onWebViewCreated: (InAppWebViewController controller) {
//             _webViewController = controller;
//             _webViewController.addJavaScriptHandler(
//               handlerName: 'onVideoLoaded',
//               callback: (args) {
//                 setState(() {
//                   _isLoading = false;
//                 });
//               },
//             );
//             _webViewController.addJavaScriptHandler(
//               handlerName: 'onVideoError',
//               callback: (args) {
//                 setState(() {
//                   _isLoading = false;
//                 });
//                 // 에러 처리를 추가할 수 있습니다
//               },
//             );
//           },
//           onLoadError: (controller, url, code, message) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//         ),
//         if (_isLoading)
//           const Center(
//             child: CircularProgressIndicator(),
//           ),
//       ],
//     );
//   }
// }
