import 'dart:math';

import 'package:zippy/domain/model/content.dart';

List<Content> shuffle(List<Content> elements,
    [int start = 0, int? end, Random? random]) {
  random ??= Random();
  end ??= elements.length;
  var length = end - start;
  while (length > 1) {
    var pos = random.nextInt(length);
    length--;
    var tmp1 = elements[start + pos];
    elements[start + pos] = elements[start + length];
    elements[start + length] = tmp1;
  }
  return elements;
}
