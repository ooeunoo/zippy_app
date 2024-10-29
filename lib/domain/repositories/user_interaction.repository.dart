import 'package:zippy/data/sources/user_interaction.source.dart';

abstract class UserInteractionRepository {}

class UserInteractionRepositoryImpl implements UserInteractionRepository {
  final UserInteractionDatasource datasource;

  UserInteractionRepositoryImpl(this.datasource);
}
