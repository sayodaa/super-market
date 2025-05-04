import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context) => BlocProvider.of(context);

  File? productImage;
  final picker = ImagePicker();
  Future<void> pickProductImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      productImage = File(pickedFile.path);
      // print(productImage);
      // print(productImage?.path ?? 'null profile image path');
      emit(GetproductImageSuccess());
    } else {
      // print('no image selected');
      emit(GetproductImageFailure());
    }
  }
}
