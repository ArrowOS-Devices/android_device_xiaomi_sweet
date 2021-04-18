/*
 * Copyright (C) 2018 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings.device;

import android.provider.Settings;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;

public class BootCompletedReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(final Context context, Intent intent) {
        try {
            // We need to reset this setting to trigger an update in display service
            final float refreshRate = Settings.System.getFloat(context.getContentResolver(),
                Settings.System.MIN_REFRESH_RATE, 120.0f);
            Thread.sleep(500);
            Settings.System.putFloat(context.getContentResolver(),
                Settings.System.MIN_REFRESH_RATE, 120.0f);
            Thread.sleep(500);
            Settings.System.putFloat(context.getContentResolver(),
                Settings.System.MIN_REFRESH_RATE, refreshRate);
        } catch (Exception e) {
            // Ignore
        }
    }

}