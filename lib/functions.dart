String formattedDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minuts = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  return '$hours:$minuts';
}
