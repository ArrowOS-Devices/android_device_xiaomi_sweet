/*
   Copyright (c) 2015, The Linux Foundation. All rights reserved.
   Copyright (C) 2016 The CyanogenMod Project.
   Copyright (C) 2019-2020 The LineageOS Project.
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

#include <fstream>
#include <unistd.h>
#include <vector>

#include <android-base/properties.h>
#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

#include <fs_mgr_dm_linear.h>

using android::base::GetProperty;

struct model_data {
    std::string region;
    std::string model;
    std::string codename;
    std::string sku;
    std::string mod_device;
    std::string marketname;
};

const std::string MARKETNAME = "Redmi Note 10 Pro";
const std::string MARKETNAME_MAX = "Redmi Note 10 Pro Max";

const std::vector<model_data> MODEL_LIST {
    // region model codename sku mod_device marketname
    {"INDIA", "M2101K6P", "sweetin", "std", "sweetin_in_global", MARKETNAME},
    {"INDIA", "M2101K6I", "sweetin", "pro", "sweetin_in_global", MARKETNAME_MAX},
    {"GLOBAL", "M2101K6G", "sweet", "", "sweet_eea_global", MARKETNAME},
    {"JAPAN", "M2101K6R", "sweet", "", "sweet_global", MARKETNAME}
};

void property_override(char const prop[], char const value[], bool add = true) {
    prop_info *pi;

    pi = (prop_info *)__system_property_find(prop);
    if (pi) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void full_property_override(const std::string &prop, const char value[], const bool product) {
    const int prop_count = 6;
    const std::vector<std::string> prop_types
        {"", "odm.", "product.", "system.", "system_ext.", "vendor."};

    for (int i = 0; i < prop_count; i++) {
        std::string prop_name = (product ? "ro.product." : "ro.") + prop_types[i] + prop;
        property_override(prop_name.c_str(), value);
    }
}

void vendor_load_properties() {
    const std::string region = GetProperty("ro.boot.hwc", "UNKNOWN");
    const std::string sku = GetProperty("ro.boot.product.hardware.sku", "UNKNOWN");

    property_override("ro.boot.verifiedbootstate", "green");

    for (model_data data : MODEL_LIST) {
        if ((data.sku != "" && data.sku != sku) || data.region != region) {
            continue;
        }

        for (int product = 0; product <= 1; product++) {
            full_property_override("model", data.model.c_str(), product);
            full_property_override("device", data.codename.c_str(), product);
            full_property_override("name", data.codename.c_str(), product);
        }

        property_override("ro.product.marketname", data.marketname.c_str());
        property_override("ro.product.mod_device", data.mod_device.c_str());

        break;
    }

#ifdef __ANDROID_RECOVERY__
    std::string buildtype = GetProperty("ro.build.type", "userdebug");
    if (buildtype != "user") {
        property_override("ro.debuggable", "1");
        property_override("ro.adb.secure.recovery", "0");
    }

    android::fs_mgr::CreateLogicalPartitions("/dev/block/by-name/super");
#endif
}
