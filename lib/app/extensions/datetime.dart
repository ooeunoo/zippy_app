extension DateTimeExtension on DateTime {
  String timeAgo() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}년 전';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}개월 전';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else if (difference.inSeconds > 0) {
      return '${difference.inSeconds}초 전';
    } else {
      return '방금 전';
    }
  }

  // 더 자세한 표시가 필요한 경우를 위한 함수
  String timeAgoDetail() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      final months = ((difference.inDays % 365) / 30).floor();
      if (months > 0) {
        return '$years년 $months개월 전';
      }
      return '$years년 전';
    }

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      final days = difference.inDays % 30;
      if (days > 0) {
        return '$months개월 $days일 전';
      }
      return '$months개월 전';
    }

    if (difference.inDays > 0) {
      final hours = difference.inHours % 24;
      if (hours > 0) {
        return '${difference.inDays}일 $hours시간 전';
      }
      return '${difference.inDays}일 전';
    }

    if (difference.inHours > 0) {
      final minutes = difference.inMinutes % 60;
      if (minutes > 0) {
        return '${difference.inHours}시간 $minutes분 전';
      }
      return '${difference.inHours}시간 전';
    }

    if (difference.inMinutes > 0) {
      final seconds = difference.inSeconds % 60;
      if (seconds > 0) {
        return '${difference.inMinutes}분 $seconds초 전';
      }
      return '${difference.inMinutes}분 전';
    }

    if (difference.inSeconds > 0) {
      return '${difference.inSeconds}초 전';
    }

    return '방금 전';
  }

  // 오늘 날짜면 시간만 표시, 아니면 날짜 표시
  String timeOrDate() {
    final now = DateTime.now();
    if (now.year == year && now.month == month && now.day == day) {
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (now.year == year) {
      return '${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
    } else {
      return '${year.toString().substring(2)}/${month.toString().padLeft(2, '0')}/${day.toString().padLeft(2, '0')}';
    }
  }

  // 시간 분만 표기 format kst return 형식: 오늘 11:11 (kst로 변경 후 표기)
  String timeOnly() {
    final kst = this.toUtc().add(const Duration(hours: 9));
    return '${kst.hour.toString().padLeft(2, '0')}시 ${kst.minute.toString().padLeft(2, '0')}분';
  }
}
