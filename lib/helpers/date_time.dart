class DateTimeHelper {
  /*
  * Obtengo la hora actual
  */
  static String getTime() {
    String minuteStr = '';
    int minute = DateTime.now().minute;
    String secondsStr = '';
    int seconds = DateTime.now().second;

    if(minute < 10){
      minuteStr = '0$minute';
    } else {
      minuteStr = '$minute';
    }
    if(seconds < 10){
      secondsStr = '0$seconds';
    } else {
      secondsStr = '$seconds';
    }

    return '${DateTime.now().hour}:$minuteStr:$secondsStr';
  }

  /*
  * Obtengo la fecha actual
  */
  static String getDate() {
    String monthStr = '';
    int month = DateTime.now().month;
    String dayStr = '';
    int day = DateTime.now().day;

    if(month < 10){
      monthStr = '0$month';
    } else{
      monthStr = '$month';
    }
    if(day < 10){
      dayStr = '0$day';
    } else{
      dayStr = '$day';
    }

    return '$dayStr-$monthStr-${DateTime.now().year}';
  }
}