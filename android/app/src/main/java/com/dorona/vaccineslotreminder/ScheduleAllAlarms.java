package com.dorona.vaccineslotreminder;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

public class ScheduleAllAlarms extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        long currentTime= System.currentTimeMillis();
        for(int i=0;i<200;i++){
            Intent intent3=new Intent(context,MyAlarmBroadcastReceiver.class);
            PendingIntent pendingIntent3=PendingIntent.getBroadcast(context,i,intent3,0);
            AlarmManager alarmManager3=(AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                alarmManager3.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,currentTime+(i*30000),pendingIntent3);
            }

        }
    }
}
