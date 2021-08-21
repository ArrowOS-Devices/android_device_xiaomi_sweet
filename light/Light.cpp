/*
 * Copyright (C) 2018-2019 The LineageOS Project
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

#include "Light.h"

#include <fstream>

#define LCD_LED         "/sys/class/backlight/panel0-backlight/"

#define BRIGHTNESS      "brightness"
#define MAX_BRIGHTNESS  "max_brightness"

namespace {
/*
 * Write value to path and close file.
 */
static void set(std::string path, std::string value) {
    std::ofstream file(path);

    if (!file.is_open()) {
        LOG(WARNING) << "failed to write " << value.c_str() << " to " << path.c_str();
        return;
    }

    file << value;
}

static void set(std::string path, int value) {
    set(path, std::to_string(value));
}

/*
 * Read max brightness from path and close file.
 */
static int getMaxBrightness(std::string path) {
    std::ifstream file(path);
    int value;

    if (!file.is_open()) {
        LOG(WARNING) << "failed to read from " << path.c_str();
        return 0;
    }

    file >> value;
    return value;
}

static uint32_t getBrightness(const HwLightState& state) {
    uint32_t color = state.color;

    return ((77 *  ((color>>16) & 0x00ff)) +
           (150 * ((color>>8) & 0x00ff)) +
           (29 * (color & 0x00ff))) >> 8;
}

static inline uint32_t scaleBrightness(uint32_t brightness, uint32_t maxBrightness) {
    if (brightness == 0) {
        return 0;
    }

    return (brightness - 1) * (maxBrightness - 1) / (0xFF - 1) + 1;
}

static inline uint32_t getScaledBrightness(const HwLightState& state, uint32_t maxBrightness) {
    return scaleBrightness(getBrightness(state), maxBrightness);
}

static void handleBacklight(const HwLightState& state) {
    uint32_t brightness = getScaledBrightness(state, getMaxBrightness(LCD_LED MAX_BRIGHTNESS));
    set(LCD_LED BRIGHTNESS, brightness);
}

/* Keep sorted in the order of importance. */
static std::vector<LightType> backends = {
    LightType::BACKLIGHT,
};

}  // anonymous namespace

namespace aidl {
namespace android{
namespace hardware {
namespace light {

ndk::ScopedAStatus Lights::setLightState(int id, const HwLightState& state) {
    switch(id) {
        case (int) LightType::BACKLIGHT:
            handleBacklight(state);
            return ndk::ScopedAStatus::ok();
        default:
            return ndk::ScopedAStatus::fromExceptionCode(EX_UNSUPPORTED_OPERATION);
    }
}

ndk::ScopedAStatus Lights::getLights(std::vector<HwLight>* lights) {
    int i = 0;

    for (const LightType& backend : backends) {
        HwLight hwLight;
        hwLight.id = (int) backend;
        hwLight.type = backend;
        hwLight.ordinal = i;
        lights->push_back(hwLight);
        i++;
    }

    return ndk::ScopedAStatus::ok();
}

}  // namespace light
}  // namespace hardware
}  // namespace android
}  // namespace aidl
