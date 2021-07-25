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

package com.arrow.cutoutringservice.sweet;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.BroadcastReceiver;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ContentResolver;
import android.content.pm.PackageManager;
import android.content.SharedPreferences;
import android.database.ContentObserver;
import android.os.Handler;
import android.graphics.PixelFormat;
import android.hardware.camera2.CameraManager;
import android.util.Log;
import android.view.View;
import android.view.Gravity;
import android.view.OrientationEventListener;
import android.view.WindowManager;
import android.widget.ImageView;

import com.arrow.cutoutringservice.sweet.R;

import static android.view.Surface.ROTATION_0;
import static android.view.Surface.ROTATION_90;
import static android.view.Surface.ROTATION_180;
import static android.view.Surface.ROTATION_270;

import static android.view.View.VISIBLE;
import static android.view.View.INVISIBLE;

import android.hardware.display.DisplayManager;

public class CutoutRingService extends BroadcastReceiver {

    private static final String TAG = "CutoutRingServiceSweet";
    private static final String FRONT_CAMERA_ID = "1";

    private static final int RING_SIZE = 64;
    private static final int Y_OFFSET = 20;
    private static final int X_OFFSET = 0;
    private static final int X_OFFSET_HORIZONTAL = Y_OFFSET;
    private static final int ANIMATION_DURATION = 1000;

    private final WindowManager.LayoutParams mRingParams = new WindowManager.LayoutParams();

    private ImageView mRingView;

    private CameraManager mCameraManager;
    private DisplayManager mDisplayManager;
    private WindowManager mWindowManager;

    @Override
    public void onReceive(final Context context, Intent intent) {
        mWindowManager = context.getSystemService(WindowManager.class);
        mCameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
        mDisplayManager = (DisplayManager) context.getSystemService(Context.DISPLAY_SERVICE);

        mRingParams.height = RING_SIZE;
        mRingParams.width = RING_SIZE;
        mRingParams.y = Y_OFFSET;
        mRingParams.format = PixelFormat.TRANSLUCENT;

        mRingParams.type = WindowManager.LayoutParams.TYPE_SECURE_SYSTEM_OVERLAY;
        mRingParams.flags = WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE |
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN;
        mRingParams.setTitle("CutoutRing");
        mRingParams.layoutInDisplayCutoutMode =
            WindowManager.LayoutParams.LAYOUT_IN_DISPLAY_CUTOUT_MODE_ALWAYS;

        adjustParamsToOrientation(mWindowManager.getDefaultDisplay().getOrientation());

        mRingView = new ImageView(context);
        mRingView.setImageResource(R.drawable.ring);

        mWindowManager.addView(mRingView, mRingParams);

        DisplayManager.DisplayListener orientationListener = new DisplayManager.DisplayListener() {
            @Override
            public void onDisplayAdded(int displayId) {
            }

            @Override
            public void onDisplayRemoved(int displayId) {
            }

            @Override
            public void onDisplayChanged(int displayId) {
                adjustParamsToOrientation(mWindowManager.getDefaultDisplay().getRotation());
                mWindowManager.updateViewLayout(mRingView, mRingParams);
            }
        };
        mDisplayManager.registerDisplayListener(orientationListener, Handler.getMain());

        CameraManager.AvailabilityCallback camCallback = new CameraManager.AvailabilityCallback() {
            @Override
            public void onCameraAvailable(String cameraId) {
                if (cameraId.equals(FRONT_CAMERA_ID)) {
                    setVisibility(false);
                }
            }

            @Override
            public void onCameraUnavailable(String cameraId) {
                if (cameraId.equals(FRONT_CAMERA_ID)) {
                    setVisibility(true);
                }
            }
        };
        mCameraManager.registerAvailabilityCallback(camCallback, Handler.getMain());
    }

    private void adjustParamsToOrientation(int orientation) {
        int gravity = Gravity.CENTER;
        int x = X_OFFSET;

        Log.i(TAG, "Adjusting to orientation " + orientation);

        switch (orientation) {
            case ROTATION_0:
                gravity |= Gravity.TOP;
                break;
            case ROTATION_90:
                gravity = Gravity.CENTER_VERTICAL | Gravity.LEFT;
                x = X_OFFSET_HORIZONTAL;
                break;
            case ROTATION_180:
                gravity |= Gravity.BOTTOM;
                break;
            case ROTATION_270:
                gravity = Gravity.CENTER_VERTICAL | Gravity.RIGHT;
                x = X_OFFSET_HORIZONTAL;
                break;
            default:
                Log.w(TAG, "Unknown orientation " + orientation);
        }

        mRingParams.x = x;
        mRingParams.gravity = gravity;

    }

    private void setVisibility(boolean shown) {
        Handler.getMain().postDelayed(() ->
            mRingView.setVisibility(shown ? VISIBLE : INVISIBLE), shown ? 0 : ANIMATION_DURATION);

        float scale = shown ? 1.0f : 0.1f;
        AnimatorSet sizeAnimation = new AnimatorSet();
        ObjectAnimator scaleX = ObjectAnimator.ofFloat(mRingView, "scaleX", scale);
        ObjectAnimator scaleY = ObjectAnimator.ofFloat(mRingView, "scaleY", scale);

        scaleX.setDuration(ANIMATION_DURATION);
        scaleY.setDuration(ANIMATION_DURATION);

        sizeAnimation.play(scaleX).with(scaleY);
        sizeAnimation.start();
    }
}
