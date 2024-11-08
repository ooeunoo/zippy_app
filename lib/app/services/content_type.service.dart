import 'package:get/get.dart';
import 'package:zippy/domain/model/content_type.model.dart';
import 'package:zippy/domain/usecases/get_content_types.usecase.dart';

class ContentTypeService extends GetxService {
  final GetContentTypes getContentTypes = Get.find();

  final RxList<ContentType> contentTypes = RxList<ContentType>([]);

  @override
  void onInit() {
    super.onInit();
    _fetchContentTypes();
  }

  Future<void> _fetchContentTypes() async {
    final result = await getContentTypes.execute();
    result.fold((l) => null, (r) {
      contentTypes.value = r;
    });
    print(contentTypes.toList());
  }
}
