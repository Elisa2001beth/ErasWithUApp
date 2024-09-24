import 'dart:io';

import 'package:eraswithu/model.dart';
import 'package:eraswithu/views/hideseek/i_seek_page_view.dart';
import 'package:file_picker/file_picker.dart';

class PresenterSeekPage {
  final ISeekPageView view;
  final Model model;

  PresenterSeekPage(this.view, this.model);

  Future<void> getHints(String eventID) async {
    UserHints hints = await model.getSomeUserHintsFromEvent(eventID);

    view.hint1 = hints.hint1;
    view.hint2 = hints.hint2;
    view.hint3 = hints.hint3;
  }

  Future<void> onUploadImageButton() async {
    PlatformFile? pickedFile;

    //get file
    final result = await model.selectFile();
    if (result == null)
      return;

    pickedFile = result.files.first;

    //upload file
    final path = 'images/(${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = model.getGeneralImgPath(path);
    var uploadTask = ref.putFile(file);

    final snapshot = await uploadTask.whenComplete(() => null);
    final urlDownload = await snapshot.ref.getDownloadURL();

    await model.uploadPeopleInEventImg(view.getEventID(), urlDownload);

    view.showSnackBar('Your image is uploaded!');
  }
}