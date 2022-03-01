abstract class ChatUtils {
  static String getChatFormatTime(DateTime createdDateTime) {
    final hour = createdDateTime.hour > 9 ? '${createdDateTime.hour}' : '0${createdDateTime.hour}';
    final minute = createdDateTime.minute > 9 ? '${createdDateTime.minute}' : '0${createdDateTime.minute}';
    return '($hour:$minute)';
  }
}
