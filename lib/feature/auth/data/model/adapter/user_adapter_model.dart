import 'package:hive/hive.dart';
import 'package:notion_app/feature/auth/data/model/user_model.dart';

class UserAdapter extends TypeAdapter<UserModel> {
  @override
  UserModel read(BinaryReader reader) {
    final data = reader.readList();

    return UserModel(
      userId: data[0] as String,
      email: data[1] as String,
      username: data[2] as String,
    );
  }

  @override
  final typeId = 0;

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeList([
      obj.userId,
      obj.email,
      obj.username,
    ]);
  }

}