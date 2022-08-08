#define LOG_TAG "libsdmcore-shim"

#define __CLASS__ "HWDeviceDRM"

#define LIBSDMCORE "/vendor/lib64/libsdmcore.so"
#define POPULATE_ATTRS_SYMBOL "_ZN3sdm11HWDeviceDRM25PopulateDisplayAttributesEj"

#include "hw_device_drm.h"

#include <dlfcn.h>

#include <log/log.h>

namespace sdm {
    DisplayError HWDeviceDRM::PopulateDisplayAttributes(uint32_t index) {
        ALOGI("Running custom PopulateDisplayAttributes");

        // Open libsdmcore
        void *handle = dlopen(LIBSDMCORE, RTLD_LOCAL | RTLD_LAZY);

        if (!handle) {
            ALOGE("Failed to open the library %s", LIBSDMCORE);
            return kErrorNotSupported;
        }

        // Load the default PopulateDisplayAttributes function
        typedef void (*populateAttrsOrig_t)(HWDeviceDRM*, uint32_t index);
        populateAttrsOrig_t populateAttrsOrig = (populateAttrsOrig_t) dlsym(handle, POPULATE_ATTRS_SYMBOL);

        if (dlerror()) {
            ALOGE("Failed to load the symbol %s", POPULATE_ATTRS_SYMBOL);
            return kErrorNotSupported;
        }

        // Call the original PopulateDisplayAttributes function
        populateAttrsOrig(this, index);

        // Set the correct x/y dpi
        display_attributes_[index].x_dpi /= 10;
        display_attributes_[index].y_dpi /= 10;

        ALOGI("Successfully set the panel DPI");

        // Close libsdmcore
        dlclose(handle);

        return kErrorNone;
    }
}

