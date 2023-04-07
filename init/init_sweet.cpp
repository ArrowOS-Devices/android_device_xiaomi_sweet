/*
   Copyright (C) 2020 The LineageOS Project.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are
   met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above
      copyright notice, this list of conditions and the following
      disclaimer in the documentation and/or other materials provided
      with the distribution.
    * Neither the name of The Linux Foundation nor the names of its
      contributors may be used to endorse or promote products derived
      from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
   WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
   ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
   BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
   BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
   WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
   OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
   IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include <vector>

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

using android::base::GetProperty;

std::vector<std::string> ro_props_default_source_order = {
    "",
    "odm.",
    "product.",
    "system.",
    "system_ext.",
    "vendor.",
    "vendor_dlkm.",
};

void property_override(char const prop[], char const value[], bool add = true)
{
    prop_info *pi;

    pi = (prop_info *) __system_property_find(prop);
    if (pi)
        __system_property_update(pi, value, strlen(value));
    else if (add)
        __system_property_add(prop, strlen(prop), value, strlen(value));
}

void set_ro_build_prop(const std::string &prop, const std::string &value) {
    for (const auto &source : ro_props_default_source_order) {
        auto prop_name = "ro." + source + "build." + prop;
        if (source == "")
            property_override(prop_name.c_str(), value.c_str());
        else
            property_override(prop_name.c_str(), value.c_str(), false);
    }
};

void set_ro_product_prop(const std::string &prop, const std::string &value) {
    for (const auto &source : ro_props_default_source_order) {
        auto prop_name = "ro.product." + source + prop;
        property_override(prop_name.c_str(), value.c_str(), false);
    }
};

void vendor_load_properties() {
    std::string region;
    std::string sku;
    region = GetProperty("ro.boot.hwc", "GLOBAL");
    sku = GetProperty("ro.boot.product.hardware.sku","pro");

    std::string model;
    std::string device;
    std::string fingerprint;
    std::string description;
    std::string mod_device;

    if (region == "GLOBAL") {
        model = "M2101K6G";
        device = "sweet";
        fingerprint = "Redmi/sweet_eea/sweet:13/TKQ1.221013.002/V14.0.2.0.TKFEUXM:user/release-keys";
        description = "sweet_eea-user 13 TKQ1.221013.002 V14.0.2.0.TKFEUXM release-keys";
        mod_device = "sweet_eea_global";
        property_override("ro.boot.product.hardware.sku", "sweet");
    } else if (region == "JAPAN") {
        model = "M2101K6R";
        device = "sweet";
        fingerprint = "Redmi/sweet_global/sweet:13/TKQ1.221013.002/V14.0.2.0.TKFMIXM:user/release-keys";
        description = "sweet_global-user 13 TKQ1.221013.002 V14.0.2.0.TKFMIXM release-keys";
        mod_device = "sweet_global";
        property_override("ro.boot.product.hardware.sku", "sweet");
    } else if (region == "INDIA") {
        if (sku == "std") {
            model = "M2101K6P";
            device = "sweetin";
            fingerprint = "Redmi/sweetin/sweetin:13/TKQ1.221013.002/V14.0.1.0.TKFINXM:user/release-keys";
            description = "sweetin-user 13 TKQ1.221013.002 V14.0.1.0.TKFINXM release-keys";
            mod_device = "sweetin_in_global";
        } else {
            model = "M2101K6I";
            device = "sweetin";
            fingerprint = "Redmi/sweetinpro/sweetin:13/TKQ1.221013.002/V14.0.1.0.TKFINXM:user/release-keys";
            description = "sweetinpro-user 13 TKQ1.221013.002 V14.0.1.0.TKFINXM release-keys";
            mod_device = "sweetin_in_global";
            }
    }

    set_ro_build_prop("fingerprint", fingerprint);
    set_ro_product_prop("device", device);
    set_ro_product_prop("model", model);
    property_override("ro.build.description", description.c_str());
    if (mod_device != "") {
        property_override("ro.product.mod_device", mod_device.c_str());
    }
}
