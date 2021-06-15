/*
 * Copyright (C) 2021 ArrowOS
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

package org.lineageos.settings.device.color.model;

import android.content.Context;
import android.util.AttributeSet;

import androidx.preference.Preference;
import androidx.preference.Preference.OnPreferenceChangeListener;
import androidx.preference.SeekBarPreference;

import android.os.Handler;
import android.os.Looper;

import org.lineageos.settings.device.utils.KcalUtils;

public class KcalSeekBarPreference extends SeekBarPreference implements
        OnPreferenceChangeListener {

    private Handler mHandler = new Handler(Looper.getMainLooper());

    public KcalSeekBarPreference(Context context, AttributeSet attrs) {
        super(context, attrs);
        setOnPreferenceChangeListener(this);
        setUpdatesContinuously(true);
        setMin(KcalUtils.getMin(getKey()));

        mHandler.post(() -> updateSummary(getValue()));
    }

    public KcalSeekBarPreference(Context context) {
        this(context, null);
    }

    private void updateSummary(int value) {
        setSummary(String.valueOf(value));
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        KcalUtils.writeCurrentSettings(getSharedPreferences());
        updateSummary((Integer) newValue);
        return true;
    }
}
