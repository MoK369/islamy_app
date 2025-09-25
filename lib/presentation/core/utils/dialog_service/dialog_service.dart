abstract class DialogService {
  Future<void> showBookMarkAlertDialog(
      {required String message, required void Function() okButtonFunction});
}
