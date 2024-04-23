bool isValidUrl(String? url) {
  if (url == null) return false;
  return Uri.parse(url).isAbsolute;
}
