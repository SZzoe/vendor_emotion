# Copyright (C) 2012 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

LOCAL_PATH := $(call my-dir)

#
# Prebuilt APKs
#
include $(CLEAR_VARS)
LOCAL_MODULE := LatinImeDictionaryPack
LOCAL_MODULE_OWNER := emotion
LOCAL_SRC_FILES := common/app/$(LOCAL_MODULE).apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := VerizonSSO
LOCAL_MODULE_OWNER := emotion
LOCAL_SRC_FILES := vzw/app/$(LOCAL_MODULE).apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := libGoogleAnalyticsV2
LOCAL_SRC_FILES := common/lib/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := KernelAdiutor
LOCAL_MODULE_OWNER := emotion
LOCAL_SRC_FILES := common/app/$(LOCAL_MODULE).apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := AdAway
LOCAL_MODULE_OWNER := emotion
LOCAL_SRC_FILES := common/app/$(LOCAL_MODULE).apk
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .apk
LOCAL_MODULE_CLASS := APPS
LOCAL_CERTIFICATE := PRESIGNED
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := Substratum
LOCAL_MODULE_OWNER := emotion
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := APPS
LOCAL_BUILT_MODULE_STEM := Substratum.apk
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_DEX_PREOPT := false
LOCAL_SRC_FILES := common/app/$(LOCAL_MODULE).apk
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := retrofit
LOCAL_SRC_FILES := common/jar/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := converter-gson
LOCAL_SRC_FILES := common/jar/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := okhttp3
LOCAL_SRC_FILES := common/jar/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := okio
LOCAL_SRC_FILES := common/jar/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := gson2
LOCAL_SRC_FILES := common/jar/$(LOCAL_MODULE).jar
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .jar
LOCAL_MODULE_CLASS := JAVA_LIBRARIES
include $(BUILD_PREBUILT)
