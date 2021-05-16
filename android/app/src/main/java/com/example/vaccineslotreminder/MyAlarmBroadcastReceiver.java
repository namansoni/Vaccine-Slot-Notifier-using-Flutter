package com.example.vaccineslotreminder;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.os.Build;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.toolbox.StringRequest;
import com.android.volley.toolbox.Volley;
import com.example.vaccineslotreminder.data.MyDbHandler;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class MyAlarmBroadcastReceiver extends BroadcastReceiver {

    int i=0;
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("BroadCAST RECEIVED");
        Format f = new SimpleDateFormat("dd-MM-yyyy");
        String strDate = f.format(new Date());
//        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "147")
//                .setContentTitle("Vaccine Slot Finder")
//                .setSmallIcon(R.mipmap.ic_launcher)
//                .setColor(Color.rgb(128, 131, 224))
//                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
//                .setStyle(new NotificationCompat.BigTextStyle()
//                        .bigText("Fetching data from API"))
//                .setPriority(NotificationCompat.PRIORITY_HIGH);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationChannel channel = new NotificationChannel("147", "963", NotificationManager.IMPORTANCE_HIGH);
//            NotificationManager notificationManager = (NotificationManager) context.getSystemService(NotificationManager.class);
//            notificationManager.createNotificationChannel(channel);
//        }
//        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
//        notificationManagerCompat.notify(1234569,builder.build());

        i=0;
        MyDbHandler dbHandler=new MyDbHandler(context);
        List<Map<String,String>> remindersList=dbHandler.getAllReminders();

        for(i=0;i<remindersList.size();i++){
            System.out.println(remindersList.get(i).get("id"));
            int availableCapacity=0;
            RequestQueue queue = Volley.newRequestQueue(context);
            String url ="https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode="+remindersList.get(i).get("id")+"&date="+strDate;
            System.out.println(url);
            StringRequest stringRequest = new StringRequest(Request.Method.GET, url,
                    new Response.Listener<String>() {
                        @Override
                        public void onResponse(String response) {
                            try {
                                JSONObject obj=new JSONObject(response);
                                JSONArray centersList= (JSONArray) obj.get("centers");
                                int pincodeAvailableCapacity=0;
                                String notificationText="";
                                for(int j=0;j<centersList.length();j++){
                                    JSONObject center=(JSONObject)centersList.get(j);
                                    JSONArray sessionsList =(JSONArray) center.get("sessions");
                                    int centersAvailableCapacity=0;
                                    for(int k=0;k<sessionsList.length();k++){
                                        JSONObject session=(JSONObject)sessionsList.get(k);
                                        centersAvailableCapacity=centersAvailableCapacity + session.getInt("available_capacity");
                                    }

                                   pincodeAvailableCapacity=pincodeAvailableCapacity+centersAvailableCapacity;
                                    System.out.println("Centers: "+centersAvailableCapacity);
                                    if(centersAvailableCapacity>0){
                                        notificationText=center.getString("name")+"\nVaccine Available: "+String.valueOf(centersAvailableCapacity)+"\n";
                                        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "147")
                                                .setContentTitle("Vaccine Available | "+String.valueOf(center.getInt("pincode")))
                                                .setSmallIcon(R.mipmap.ic_launcher)
                                                .setColor(Color.rgb(128, 131, 224))
                                                .setCategory(NotificationCompat.CATEGORY_MESSAGE)
                                                .setStyle(new NotificationCompat.BigTextStyle()
                                                        .bigText(notificationText))
                                                .setPriority(NotificationCompat.PRIORITY_HIGH);
                                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                            NotificationChannel channel = new NotificationChannel("147", "963", NotificationManager.IMPORTANCE_HIGH);
                                            NotificationManager notificationManager = (NotificationManager) context.getSystemService(NotificationManager.class);
                                            notificationManager.createNotificationChannel(channel);
                                        }
                                        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
                                        notificationManagerCompat.notify(center.getInt("center_id"),builder.build());
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


    }
}
