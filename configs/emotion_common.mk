#
# emotion_common.mk: set up our common configuration
# Copyright (C) 2015-2016 The PAC-ROM Project
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

# EMOTION version
EMOTIONVERSION := $(shell echo $(EMOTION_VERSION) | sed -e 's/^[ \t]*//;s/[ \t]*$$//;s/ /-/g')
BOARD := $(subst emotion_,,$(TARGET_PRODUCT))
EMOTION_BUILD_VERSION := Emotion-$(PLATFORM_VERSION)-$(EMOTIONVERSION)-$(BOARD)
PRODUCT_NAME := $(TARGET_PRODUCT)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.emotion.version=$(EMOTIONVERSION) \
    ro.emotion.branch=nougat \
    ro.emotion.releasetype=$(EMOTION_VERSION_MAINTENANCE) \
    ro.emotion.device=$(EMOTION_DEVICE) \
    ro.modversion=$(EMOTIONVERSION) \
    emotion.ota.version=$(EMOTION_BUILD_VERSION)

# needed for statistics
PRODUCT_PROPERTY_OVERRIDES += \
    ro.romstats.url=http://emotion.esy.es/ \
    ro.romstats.name=Emotion \
    ro.romstats.buildtype=$(EMOTION_VERSION_MAINTENANCE) \
    ro.romstats.version=$(EMOTION_VERSION_MAJOR) \
    ro.romstats.tframe=1 \
    ro.romstats.askfirst=1 \
    ro.romstats.ga=UA-76534441-1

# Lower RAM devices
ifeq ($(EMOTION_LOW_RAM_DEVICE),true)
MALLOC_IMPL := dlmalloc
TARGET_BOOTANIMATION_TEXTURE_CACHE := false

PRODUCT_PROPERTY_OVERRIDES += \
    config.disable_atlas=true \
    dalvik.vm.jit.codecachesize=0 \
    persist.sys.force_highendgfx=true \
    ro.config.low_ram=true \
    ro.config.max_starting_bg=8 \
    ro.sys.fw.bg_apps_limit=16
endif

# Disable ADB authentication and set root access to Apps and ADB
ifeq ($(DISABLE_ADB_AUTH),true)
    ADDITIONAL_DEFAULT_PROPERTIES += \
        ro.adb.secure=3 \
        persist.sys.root_access=3
endif
