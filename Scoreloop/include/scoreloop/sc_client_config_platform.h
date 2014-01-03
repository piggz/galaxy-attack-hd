/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2013 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @file        sc_client_config.h
 * @brief       Android specific initialisation of SC_Client.
 *
 * The configuration parameters should
 * match the parameters assigned by Scoreloop when the game was registered on
 * <a href="https://developer.scoreloop.com">https://developer.scoreloop.com</a>.
 *
 * @addtogroup  SC_ClientConfig
 * @{
 */

#ifndef __SC_CLIENT_CONFIG_PLATFORM_H__
#define __SC_CLIENT_CONFIG_PLATFORM_H__

/*-------------------------------------------------------------------------------------*
 * Includes
 *-------------------------------------------------------------------------------------*/

#include <scoreloop/sc_errors.h>
#include <scoreloop/sc_string.h>
#include <scoreloop/sc_platform.h>
#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif

/*-------------------------------------------------------------------------------------*
 * Types
 *-------------------------------------------------------------------------------------*/

/** Opaque SC_ClientConfig handle */
typedef struct SC_ClientConfig_tag* SC_ClientConfig_h;

/**
 * The type of possible runloop kinds.
 */
typedef enum SC_RunLoopType_tag
{
    SC_RUN_LOOP_TYPE_MAIN_LOOPER = 0,
    SC_RUN_LOOP_TYPE_CUSTOM
} SC_RunLoopType_t;

/**
 * The type of event notifiers.
 * @sa SC_InitData_t, SC_InitData_t.eventNotifier
 */
typedef void (*SC_EventNotifier_t)(void *eventNotifierContext);

/*-------------------------------------------------------------------------------------*
 * Methods
 *-------------------------------------------------------------------------------------*/

/**
 * @brief Set the type of runloop for the Scoreloop client
 *
 * The thread where your run loop is hosted is the thread all API
 * calls will have to be issued as well as all callbacks will take place.
 *
 * If you wish to use Scoreloop on the Android main (UI) thread, set this
 * to SC_RUN_LOOP_TYPE_MAIN_LOOPER.
 *
 * In case you are using your own runloop on a different thread and want
 * to use Scoreloop there, you have to pass SC_RUN_LOOP_TYPE_CUSTOM here
 * and call SC_HandleCustomEvents from your runloop, either on every frame
 * or you can use the EventNotifier mechanism to be notified when there
 * are events to handle.
 *
 * @param self Opaque handle for the current client config instance.
 * @param runLoopType the desired runloop type
 * @return A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED SC_Error_t SC_ClientConfig_SetRunLoopType(SC_ClientConfig_h self, SC_RunLoopType_t runLoopType);

/**
 * If you use the run loop type SC_RUN_LOOP_TYPE_CUSTOM, you can specify a method here which
 * gets called to indicate that you should call SC_HandleCustomEvent soon.
 * Note that this method gets called on a different thread than the scoreloop thread on which you have to
 * call SC_HandleCustomEvent. This is an advanced feature and should only be used if you understand
 * the threading implications.
 *
 * @param self Opaque handle for the current client config instance.
 * @param notifier Pointer to a function to be called when SC_HandleCustomEvents should be invoked
 * @return A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED SC_Error_t SC_ClientConfig_SetEventNotifier(SC_ClientConfig_h self, SC_EventNotifier_t notifier);

/**
 * If you use the run loop type SC_RUN_LOOP_TYPE_CUSTOM, and have set an EventNotifier function,
 * you can specify a pointer that gets passed to invocations of the event notifier. You have to take care
 * of memory management of this pointer by yourself. This context is undefined if not set explicitly.
 *
 * @param self Opaque handle for the current client config instance.
 * @param context Pointer to be passed as an argument to the EventNotifier function
 * @return A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED SC_Error_t SC_ClientConfig_SetEventNotifierContext(SC_ClientConfig_h self, void* context);


/**
 * You have to pass a pointer to an Android Context object to the client config here.
 *
 * When using NativeActivity, the "clazz" member of ANativeActivity should be passed here.
 * If you are using your own Activity, pass a pointer to any Activity or ApplicationContext.
 *
 * @param self Opaque handle for the current client config instance.
 * @param context JNI pointer to the Android Context
 * @return A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED SC_Error_t SC_ClientConfig_SetAndroidContext(SC_ClientConfig_h self, jobject context);

/**
 * @brief Continue processing of Scoreloop code when using SC_RUN_LOOP_TYPE_CUSTOM
 *
 * You have to call this method regularly in your own run loop so that Scoreloop
 * callbacks can be invoked when asynchronous replies come in from the servers.
 * Your event loop should look like this:
 *
 * @code
 * for (;;) {
 *      // Scoreloop event handling
 *      SC_HandleCustomEvent(clientConfig);
 *
 *      // Other event handling here
 *      ...
 * }
 * @endcode
 *
 * @param clientConfig      A pointer to the scoreloop clientConfig
 *
 */
SC_PUBLISHED void SC_HandleCustomEvents(SC_ClientConfig_h clientConfig);

#ifdef __cplusplus
}
#endif

#endif /* __SC_CLIENT_CONFIG_H__ */

/*! @} */
