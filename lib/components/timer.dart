import 'package:flutter/material.dart';
import 'package:gympa/theme.dart';
import 'package:gympa/timer_service.dart';
import 'package:intl/intl.dart';

class Timer extends StatefulWidget {
  final Color color;
  final AssetImage icon;

  Timer(Color color, AssetImage icon) : 
    this.color = color, 
    this.icon = icon;

  @override
  _Timer createState() => _Timer(color, icon);
}

class _Timer extends State<Timer> {
  final Color color;
  final AssetImage icon;
  final timerService = TimerService();
  final format = new DateFormat("mm:SS");

  DateTime startTime;

  _Timer(Color color, AssetImage icon) : 
    this.color = color, 
    this.icon = icon;

  _toggleTimer() {
    !timerService.isRunning ? timerService.start() : timerService.stop();
  }

  _formatDuration(Duration duration) {
      twoDigits(int n) {
        if (n >= 10) return "$n";
        return "0$n";
      }

      final twoDigitMinutes = twoDigits(duration.inMinutes);
      final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return TimerServiceProvider(
      service: timerService,
      child: OutlineButton(
        onPressed: _toggleTimer,
        borderSide: BorderSide(color: color, width: 1.0),
        child: AnimatedBuilder(
          animation: timerService,
          builder: (context, child) => Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: icon, height: 20.0), 
              Container(width: 20.0),
              Text(_formatDuration(timerService.currentDuration), style: TextStyles.fixed(context, fontSize: 16.0))
            ],
          ),
        ),
      ),
    );
  }
}