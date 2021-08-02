package org.lineageos.settings.device;

public class Constants {
    public static final String KEY_DC_DIMMING = "pref_dc_dimming";

    public static final String DISPPARAM_NODE = "/sys/devices/platform/soc/ae00000.qcom,mdss_mdp/drm/card0/card0-DSI-1/disp_param";
    public static final String BRIGHTNESS_NODE = "/sys/devices/platform/soc/ae00000.qcom,mdss_mdp/backlight/panel0-backlight/brightness";

    public static final String DISPPARAM_DC_ON = "0x40000";
    public static final String DISPPARAM_DC_OFF = "0x50000";
}
