#define LOG_TAG "libsdmcore-shim"

#define __CLASS__ "HWDeviceDRM"

#define LIBSDMCORE "/vendor/lib64/libsdmcore.so"
#define INIT_CONFIGS_SYMBOL "_ZN3sdm11HWDeviceDRM17InitializeConfigsEv"

#include "hw_device_drm.h"

#include <dlfcn.h>

#include <log/log.h>

namespace sdm {
    void HWDeviceDRM::InitializeConfigs() {
        ALOGI("Running custom InitializeConfigs");

        // Open libsdmcore
        void *handle = dlopen(LIBSDMCORE, RTLD_LOCAL | RTLD_LAZY);

        if (!handle) {
            ALOGE("Failed to open the library %s", LIBSDMCORE);
            return;
        }

        // Load the default InitializeConfigs function
        typedef void (*initConfigsOrig_t)(HWDeviceDRM*);
        initConfigsOrig_t initConfigsOrig = (initConfigsOrig_t) dlsym(handle, INIT_CONFIGS_SYMBOL);

        if (dlerror()) {
            ALOGE("Failed to load the symbol %s", INIT_CONFIGS_SYMBOL);
            return;
        }

        // Call the original InitializeConfigs function
        initConfigsOrig(this);

        // Set the correct x/y dpi
        display_attributes_[current_mode_index_].x_dpi /= 10;
        display_attributes_[current_mode_index_].y_dpi /= 10;

        ALOGI("Successfully set the panel DPI");

        // Close libsdmcore
        dlclose(handle);
    }
}

