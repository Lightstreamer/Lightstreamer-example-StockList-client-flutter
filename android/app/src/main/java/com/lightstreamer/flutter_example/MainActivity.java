package com.lightstreamer.flutter_example;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StringCodec;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Handler;
import android.os.Looper;

import com.google.mlkit.common.sdkinternal.TaskQueue;

import com.lightstreamer.client.ClientListener;
import com.lightstreamer.client.LightstreamerClient;
import com.lightstreamer.client.Subscription;
import com.lightstreamer.client.SubscriptionListener;
import com.lightstreamer.client.ItemUpdate;


import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.lightstreamer.flutter/LightstreamerClient";

    private static final LightstreamerClient ls = new LightstreamerClient("https://push.lightstreamer.com/", "WELCOME");

    //the list of items that will be subscribed to the lightstreamer server
    private static final String[] itemList = {  "item2"  };

    //the list of fields that will be subscribed to the lightstreamer server
    private static final  String[] fieldList = { "stock_name", "last_price", "time" };

    public static int currentSessions = -1;

    private static BasicMessageChannel<String> clientstatus_channel;

    private static BasicMessageChannel<String> realtimedata_channel;

    private ConcurrentHashMap<String, Subscription> activeSubs = new ConcurrentHashMap<String, Subscription>();

    private int getBatteryLevel() {
        int batteryLevel = -1;
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            BatteryManager batteryManager = (BatteryManager) getSystemService(BATTERY_SERVICE);
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
        } else {
            Intent intent = new ContextWrapper(getApplicationContext()).
                    registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            batteryLevel = (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100) /
                    intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
        }

        return batteryLevel;
    }

    @Override protected void onStart() {
        super.onStart();
    }

    @Override public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        clientstatus_channel = new BasicMessageChannel<String>(
                flutterEngine.getDartExecutor().getBinaryMessenger(), "com.lightstreamer.flutter.clientStatus_channel", StringCodec.INSTANCE);

        realtimedata_channel = new BasicMessageChannel<String>(
                flutterEngine.getDartExecutor().getBinaryMessenger(), "com.lightstreamer.flutter.realtime_channel", StringCodec.INSTANCE);

        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                                if (call.method.equals("getBatteryLevel")) {
                                    int batteryLevel = getBatteryLevel();

                                    if (batteryLevel != -1) {
                                        result.success(batteryLevel);
                                    } else {
                                        result.error("UNAVAILABLE", "Battery level not available.", null);
                                    }
                                } else if (call.method.equals("connect")) {

                                    if (!ls.getStatus().startsWith("CONNECTED:")) {
                                        ls.addListener(new MyClientListener());
                                        ls.connect();
                                        System.out.println("Try connect ... ");

                                        result.success(0);
                                    } else {
                                        System.out.println(" ... " + ls.getStatus());

                                        result.success(1);
                                    }
                                } else if (call.method.equals("disconnect")) {

                                    if (ls.getStatus().startsWith("CONNECTED:")) {
                                        ls.disconnect();

                                        result.success(0);
                                    } else {
                                        System.out.println(" ... " + ls.getStatus());

                                        result.success(1);
                                    }
                                } else if (call.method.equals("subscribe")) {
                                    String items = call.argument("Items");
                                    if (items.length()>1) {
                                        if (activeSubs.containsKey(items)) {
                                            ls.unsubscribe(activeSubs.get(items));
                                            activeSubs.remove(items);

                                            result.success(0);
                                        } else {
                                            Subscription monitoringSubscription = new Subscription("MERGE", items, fieldList);
                                            monitoringSubscription.setDataAdapter("STOCKS");
                                            monitoringSubscription.setRequestedSnapshot("yes");
                                            monitoringSubscription.setRequestedMaxFrequency("1");
                                            monitoringSubscription.addListener(new MySubListener());

                                            ls.subscribe(monitoringSubscription);
                                            activeSubs.put(items, monitoringSubscription);

                                            result.success(1);
                                        }
                                    }
                                } else {
                                    result.notImplemented();
                                }
                        }
                );
    }

    private class MySubListener implements SubscriptionListener {

        @Override
        public void onClearSnapshot(String itemName, int itemPos) {
            System.out.println("Server has cleared the current status of the chat");
        }

        @Override
        public void onCommandSecondLevelItemLostUpdates(int lostUpdates, String key) {
            //not on this subscription
        }

        @Override
        public void onCommandSecondLevelSubscriptionError(int code, String message, String key) {
            //not on this subscription
        }

        @Override
        public void onEndOfSnapshot(String arg0, int arg1) {
            System.out.println("Snapshot is now fully received, from now on only real-time messages will be received");
        }

        @Override
        public void onItemLostUpdates(String itemName, int itemPos, int lostUpdates) {
            System.out.println(lostUpdates + " messages were lost");
        }

        @Override
        public void onItemUpdate(ItemUpdate update) {

            System.out.println("====UPDATE====> " + update.getItemName());

            Iterator<Entry<String,String>> changedValues = update.getChangedFields().entrySet().iterator();
            while(changedValues.hasNext()) {
                Entry<String,String> field = changedValues.next();

                String uValue = field.getValue();
                String uKey = field.getKey();
                String uItem = update.getItemName();

                System.out.println("Field " + uKey + " changed: " + uValue);

                try {
                    new Handler(Looper.getMainLooper()).post(new Runnable() {
                        @Override
                        public void run() {
                            realtimedata_channel.send(uItem + "|" + uKey + "|" + uValue);
                        }
                    });

                } catch (Exception e) {
                    System.out.println("ERROR: " + e.getMessage());
                }

                System.out.println("<====UPDATE====");
            }
        }

        @Override
        public void onListenEnd(Subscription subscription) {
            System.out.println("Stop listeneing to subscription events");
        }

        @Override
        public void onListenStart(Subscription subscription) {
            System.out.println("Start listeneing to subscription events");
        }

        @Override
        public void onSubscription() {
            System.out.println("Now subscribed to the chat item, messages will now start coming in");
        }

        @Override
        public void onSubscriptionError(int code, String message) {
            System.out.println("Cannot subscribe because of error " + code + ": " + message);
        }

        @Override
        public void onUnsubscription() {
            System.out.println("Now unsubscribed from chat item, no more messages will be received");
        }

        @Override
        public void onRealMaxFrequency(String frequency) {
            System.out.println("Frequency is " + frequency);
        }
    }

    private class MyClientListener implements ClientListener {
        @Override
        public void onListenEnd(LightstreamerClient client) {
            // ...
        }

        @Override
        public void onListenStart(LightstreamerClient client) {
            // ...
        }

        @Override
        public void onServerError(int errorCode, String errorMessage) {
            // ...
        }

        @Override
        public void onStatusChange(String status) {

            System.out.println("Status changed: " + status);
            try {
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        clientstatus_channel.send(status + "");
                    }
                });

            } catch (Exception e) {
                System.out.println("ERROR: " + e.getMessage());
            }
        }

        @Override
        public void onPropertyChange(String property) {
            // ...
        }
    }
}
