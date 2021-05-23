package com.dorona.vaccineslotreminder;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.media.RingtoneManager;
import android.net.Uri;
import android.os.Build;
import android.widget.RemoteViews;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.dorona.vaccineslotreminder.data.MyDbHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MyAlarmBroadcastReceiver extends BroadcastReceiver {

    int i = 0;

    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("BroadCAST RECEIVED");
        Intent intent1=new Intent(context,MyAlarmBroadcastReceiver.class);
        PendingIntent pendingIntent1=PendingIntent
                .getBroadcast(context.getApplicationContext(),123456,intent1,0);
        AlarmManager alarmManager1=(AlarmManager)context.getSystemService(Context.ALARM_SERVICE);
        alarmManager1
                .setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,System.currentTimeMillis()+30000,pendingIntent1);
        System.out.println("NEW ALARM SET");
        i = 0;
        MyDbHandler dbHandler = new MyDbHandler(context);
        List<Map<String, String>> remindersList = dbHandler.getAllReminders();
        for (i = 0; i < remindersList.size(); i++) {
            int availableCapacity = 0;
            RequestQueue queue = Volley.newRequestQueue(context);
            String url = "https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode=" + remindersList.get(i).get("pincode") + "&date=" + getCurrentDate();
            System.out.println(url);
            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                    new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response) {
                            try {
                                System.out.println("I=" + String.valueOf(i));

                                JSONObject obj = new JSONObject(response);
                                JSONArray centersList = (JSONArray) obj.get("centers");
                                int pincodeAvailableCapacity = 0;
                                String notificationText = "";
                                for (int j = 0; j < centersList.length(); j++) {
                                    JSONObject center = (JSONObject) centersList.get(j);
                                    JSONArray sessionsList = (JSONArray) center.get("sessions");
                                    int centersAvailableCapacityFor18Plus = 0;
                                    int centersAvailableCapacityFor45Plus = 0;
                                    // System.out.println("MINIMUM AGE LIMIT: " + minimumAgeLimit);
                                    int minimumAgeLimit=0;
                                    Map<String,Boolean> miniAgeLimitMap=new HashMap<String,Boolean>();
                                    miniAgeLimitMap.put("18",false);
                                    miniAgeLimitMap.put("45",false);
                                    for (int k = 0; k < sessionsList.length(); k++) {
                                        JSONObject session = (JSONObject) sessionsList.get(k);
                                        minimumAgeLimit = getMinimumAgeLimit(String.valueOf(center.getInt("pincode")) + String.valueOf(session.getInt("min_age_limit")), remindersList);
                                        if(session.getInt("min_age_limit")==18 && minimumAgeLimit==18){
                                            miniAgeLimitMap.put("18",true);
                                        }else if(session.getInt("min_age_limit")==45 && minimumAgeLimit==45){
                                            miniAgeLimitMap.put("45",true);
                                        }
                                        System.out.println("MINIMUM AGE LIMIT: " + minimumAgeLimit);
                                        if (minimumAgeLimit == 45) {
                                            if (session.getInt("min_age_limit") == 45) {
                                                centersAvailableCapacityFor45Plus = centersAvailableCapacityFor45Plus + session.getInt("available_capacity");
                                            }

                                        } else if (minimumAgeLimit == 18) {
                                            if (session.getInt("min_age_limit") == 18) {
                                                centersAvailableCapacityFor18Plus = centersAvailableCapacityFor18Plus + session.getInt("available_capacity");
                                            }
                                        }

                                    }
                                    if (miniAgeLimitMap.get("45")) {
                                        if (centersAvailableCapacityFor45Plus > 0) {
                                            notificationText = center.getString("name") + "\nVaccine Available: " + String.valueOf(centersAvailableCapacityFor45Plus) + "\n";
                                            showNotification(context, notificationText, center, centersAvailableCapacityFor45Plus, 45);
                                        }

                                    }
                                    if (miniAgeLimitMap.get("18")) {
                                        if (centersAvailableCapacityFor18Plus > 0) {
                                            notificationText = center.getString("name") + "\nVaccine Available: " + String.valueOf(centersAvailableCapacityFor18Plus) + "\n";
                                            showNotification(context, notificationText, center, centersAvailableCapacityFor18Plus, 18);
                                        }
                                    }

                                }

                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }, new Response.ErrorListener() {
                @Override
                public void onErrorResponse(VolleyError error) {

                }
            });

// Add the request to the RequestQueue.
            queue.add(stringRequest);
        }

//

    }

    private String getCurrentDate() {
        Format f = new SimpleDateFormat("dd-MM-yyyy");
        String strDate = f.format(new Date());
        return strDate;
    }

    private void showNotification(Context context, String notificationText, JSONObject center, int numberOfVaccine, int minimumAgeLimit) throws JSONException {
        RemoteViews expandedView = new RemoteViews(context.getPackageName(), R.layout.expanded_notification);
        RemoteViews collapsedView = new RemoteViews(context.getPackageName(), R.layout.activity_collapsed_notification);

        String pincode = String.valueOf(center.getInt("pincode"));
        String feeType = center.getString("fee_type");
        String centerName = center.getString("name");
        String centerAddres = center.getString("address");
        String titleText = "Vaccine Available\n" + String.valueOf(numberOfVaccine);
        String minimumAgeLimitString = String.valueOf(minimumAgeLimit);
        String blockName = center.getString("block_name");
        String districtName = center.getString("district_name");
        String stateName = center.getString("state_name");
        String fromTime = center.getString("from").substring(0, 5);
        String toTime = center.getString("to").substring(0, 5);
        String notificationDeliveryTime=getCurrentTime();
        collapsedView.setTextViewText(R.id.titleText, titleText);
        collapsedView.setTextViewText(R.id.pincodeText, "Pincode\n" + pincode);
        collapsedView.setTextViewText(R.id.centerAddress, centerName + ", " + centerAddres);
        collapsedView.setTextViewText(R.id.feeType, feeType);
        collapsedView.setTextViewText(R.id.minimumAgeLimit, minimumAgeLimitString + "+");
        collapsedView.setTextViewText(R.id.notificationTime,notificationDeliveryTime);

        expandedView.setTextViewText(R.id.titleText, titleText);
        expandedView.setTextViewText(R.id.pincodeText, "Pincode\n" + pincode);
        expandedView.setTextViewText(R.id.centerAddress, centerName + ", " + centerAddres);
        expandedView.setTextViewText(R.id.feeType, feeType);
        expandedView.setTextViewText(R.id.minimumAgeLimit, minimumAgeLimitString + "+");
        expandedView.setTextViewText(R.id.fullAddress, blockName + ", " + districtName + ", " + stateName);
        expandedView.setTextViewText(R.id.timings, "Timings: " + fromTime + " - " + toTime);
        expandedView.setTextViewText(R.id.notificationTime,notificationDeliveryTime);

        //set button action
        Intent openUrlIntent = new Intent(context, OpenUrlIntentService.class);


        if (feeType.equals("Free")) {
            collapsedView.setInt(R.id.feeType, "setBackgroundResource", R.drawable.rounded_textview_green);
            expandedView.setInt(R.id.feeType, "setBackgroundResource", R.drawable.rounded_textview_green);
        } else {
            collapsedView.setInt(R.id.feeType, "setBackgroundResource", R.drawable.rounded_textview_red);
            expandedView.setInt(R.id.feeType, "setBackgroundResource", R.drawable.rounded_textview_red);
        }


//        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "147")
//                .setContentTitle("Vaccine Available | "+String.valueOf(center.getInt("pincode")))
//                .setSmallIcon(R.mipmap.ic_launcher)
//                .setColor(Color.rgb(128, 131, 224))
//                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
//                .setStyle(new NotificationCompat.BigTextStyle()
//                        .bigText(notificationText))
//                .setPriority(NotificationCompat.PRIORITY_HIGH);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationChannel channel = new NotificationChannel("147", "963", NotificationManager.IMPORTANCE_HIGH);
//            NotificationManager notificationManager = (NotificationManager) context.getSystemService(NotificationManager.class);
//            notificationManager.createNotificationChannel(channel);
//        }
//        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
//        notificationManagerCompat.notify(center.getInt("center_id"),builder.build());

        Uri alarmSound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION);
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "147")
                .setContentTitle("Vaccine Available- " + String.valueOf(numberOfVaccine) + " | " + String.valueOf(center.getInt("pincode")) + " | " + feeType + " | " + minimumAgeLimitString)
                .setSmallIcon(R.drawable.ic_stat_name)
                .setStyle(new NotificationCompat.DecoratedCustomViewStyle())
                .setCustomContentView(collapsedView)
                .setCustomBigContentView(expandedView)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setVibrate(new long[]{1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000, 1000})
                .setSound(alarmSound)
                .setContentIntent(PendingIntent.getBroadcast(context, 0, openUrlIntent, 0))
                .setPriority(NotificationCompat.PRIORITY_HIGH);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel("147", "963", NotificationManager.IMPORTANCE_HIGH);
            NotificationManager notificationManager = (NotificationManager) context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
        notificationManagerCompat.notify(center.getInt("center_id")*100+minimumAgeLimit, builder.build());
    }

    private int getMinimumAgeLimit(String id, List<Map<String, String>> remindersList) {
        System.out.println("ID:"+id);
        for (int i = 0; i < remindersList.size(); i++) {
            if (id.equals(remindersList.get(i).get("id"))) {
                return Integer.parseInt(remindersList.get(i).get("minimumAgeLimit"));
            }
        }
        return 0;
    }

    private String getCurrentTime(){
        Formatter fmt = new Formatter();
        Calendar cal = Calendar.getInstance();
        fmt = new Formatter();
        fmt.format("%tl:%tM", cal, cal);
        return fmt.toString();
    }


}
