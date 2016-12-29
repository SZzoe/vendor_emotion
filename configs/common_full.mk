# Inherit common EMOTION stuff
$(call inherit-product, vendor/emotion/configs/common.mk)

PRODUCT_SIZE := full

# Include Emotion LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/emotion/overlay/dictionaries

PRODUCT_PACKAGES += \
    VideoEditor \
    libvideoeditor_jni \
    libvideoeditor_core \
    libvideoeditor_osal \
    libvideoeditor_videofilters \
    libvideoeditorplayer

# Themes
PRODUCT_PACKAGES += \
    HexoLibre

# Recorder
PRODUCT_PACKAGES += \
    Recorder
