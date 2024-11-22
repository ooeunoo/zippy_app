# 1. Flutter 클린
flutter clean                     # Flutter 빌드 캐시 삭제
rm -rf pubspec.lock              # pubspec.lock 파일 삭제
rm -rf .dart_tool/               # Dart 도구 캐시 삭제
rm -rf .flutter-plugins          # Flutter 플러그인 캐시 삭제
rm -rf .flutter-plugins-dependencies # Flutter 플러그인 의존성 캐시 삭제

# 2. iOS 클린
cd ios                          # iOS 디렉토리로 이동
rm -rf Pods/                    # Pods 디렉토리 삭제
rm -rf Podfile.lock             # Podfile.lock 삭제
rm -rf .symlinks/              # Symlinks 삭제
rm -rf ~/Library/Developer/Xcode/DerivedData/*  # Xcode DerivedData 삭제

# 3. 프로젝트 재설정
flutter pub get                 # Flutter 패키지 재설치
cd ios                         # iOS 디렉토리로 이동
pod install --repo-update      # Pod 재설치 (cocoapods 캐시 업데이트 포함)

# 4. Xcode 클린 (터미널에서)
xcodebuild clean -workspace Runner.xcworkspace -scheme Runner # Xcode 프로젝트 클린