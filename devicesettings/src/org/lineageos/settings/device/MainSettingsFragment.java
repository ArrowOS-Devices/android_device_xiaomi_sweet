/*
 * Copyright (C) 2020 The LineageOS Project
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

import android.os.Bundle;
import android.provider.Settings;
import android.widget.TextView;
import androidx.preference.PreferenceFragment;
import androidx.preference.Preference;
import androidx.preference.SwitchPreference;

import org.lineageos.settings.device.Constants;
import org.lineageos.settings.device.R;
import org.lineageos.settings.device.utils.DisplayUtils;

public class MainSettingsFragment extends PreferenceFragment {

    private Preference mPrefRefreshRateInfo;
    private SwitchPreference mPrefMinRefreshRate;
    private SwitchPreference mPrefDcDimming;

    @Override
    public void onActivityCreated(Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        getActivity().getActionBar().setDisplayHomeAsUpEnabled(true);
    }

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.main_settings);
        mPrefMinRefreshRate = (SwitchPreference) findPreference(Constants.KEY_MIN_REFRESH_RATE);
        mPrefMinRefreshRate.setOnPreferenceChangeListener(PrefListener);
        mPrefRefreshRateInfo = (Preference) findPreference(Constants.KEY_REFRESH_RATE_INFO);
        mPrefDcDimming = (SwitchPreference) findPreference(Constants.KEY_DC_DIMMING);
        mPrefDcDimming.setOnPreferenceChangeListener(PrefListener);
        setupPreferences();
        updateSummary();
    }

    private Preference.OnPreferenceChangeListener PrefListener =
        new Preference.OnPreferenceChangeListener() {
            @Override
            public boolean onPreferenceChange(Preference preference, Object value) {
                final String key = preference.getKey();

                if (Constants.KEY_MIN_REFRESH_RATE.equals(key)) {
                    setHz(Constants.REFRESH_RATES[(boolean) value ? 1 : 0]);
                } else if (Constants.KEY_DC_DIMMING.equals(key)) {
                    DisplayUtils.setDcDimmingStatus((boolean) value);
                }

                return true;
            }
        };

    private void setupPreferences() {
        float hz = getCurrentHz();

        if (hz == Constants.REFRESH_RATES[0]) {
            mPrefMinRefreshRate.setChecked(false);
        } else if (hz == Constants.REFRESH_RATES[1]) {
            mPrefMinRefreshRate.setChecked(true);
        }
    }

    private float getCurrentHz() {
        return Settings.System.getFloat(getContext().getContentResolver(),
            Settings.System.MIN_REFRESH_RATE, Constants.DEFAULT_REFRESH_RATE);
    }

    private void setHz(float hz) {
        Settings.System.putFloat(getContext().getContentResolver(),
            Settings.System.MIN_REFRESH_RATE, hz);
        updateSummary();
    }

    private void updateSummary() {
        mPrefRefreshRateInfo.setSummary(
            String.format(getString(R.string.current_refresh_rate_info),
                String.valueOf(Math.round(getCurrentHz()))));
    }
}
