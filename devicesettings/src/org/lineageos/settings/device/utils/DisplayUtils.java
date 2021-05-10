package org.lineageos.settings.device.utils;

import org.lineageos.settings.device.Constants;
import org.lineageos.settings.device.utils.FileUtils;

public class DisplayUtils {
    public static void setDcDimmingStatus(boolean enabled) {
        FileUtils.writeLine(Constants.DISPPARAM_NODE, enabled ? Constants.DISPPARAM_DC_ON : Constants.DISPPARAM_DC_OFF);

        // Update the brightness node so dc dimming updates its state
        FileUtils.writeLine(Constants.BRIGHTNESS_NODE, FileUtils.readOneLine(Constants.BRIGHTNESS_NODE));
    }
}
