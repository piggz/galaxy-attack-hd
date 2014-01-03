/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2012 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @brief       Platform-specific definitions for Android
 *
 * @file        sc_platform.h
 * @addtogroup  SC_Platform_Android
 * 
 * @{
 */

#ifndef __SC_PLATFORM_H__
#define __SC_PLATFORM_H__


#ifdef __cplusplus
extern "C" {
#endif

/*-------------------------------------------------------------------------------------*
 * Constants
 *-------------------------------------------------------------------------------------*/

/** Type of the platform */
#ifndef SC_PLATFORM_ANDROID
#   define SC_PLATFORM_ANDROID      (1)
#endif

/** Social providers implementation not available */
#define SC_HAS_SOCIAL_PROVIDERS     (0)

/** The original SC_INIT is not available */
#define SC_HAS_INITDATA             (0)

/** Enabled object tracing across the platform memory allocations */
#ifndef SC_TRACK_ALLOCS
    #define SC_TRACK_ALLOCS         (1)
#endif

/**
 * Macro for marking the Scoreloop CoreSocial public API.
 * SC_PUBLISHED API has default visibility on this platform.
 */
#define SC_PUBLISHED                __attribute__((visibility("default")))

/**
 *  Macro for marking the Scoreloop CoreSocial deprecated APIs.
 */
#ifdef SC_DISABLE_DEPRECATION
#   define SC_DEPRECATED
#else
#   define SC_DEPRECATED            __attribute__ ((deprecated))
#endif

/**
 * Scoreloop CoreSocial is not platform global on android - so no need for weak symbols.
 */
#define SC_PUBLISHED_WEAKLY         SC_PUBLISHED

#ifdef __cplusplus
}
#endif

#endif /* __SC_PLATFORM_H__ */

/*! @} */
