/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2013 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @file        sc_client_config.h
 * @brief       Class used for configuration of SC_Client.
 *
 * The configuration parameters should
 * match the parameters assigned by Scoreloop when the game was registered on
 * <a href="https://developer.scoreloop.com">https://developer.scoreloop.com</a>.
 *
 * @addtogroup  SC_ClientConfig
 * @{
 */

#ifndef __SC_CLIENT_CONFIG_H__
#define __SC_CLIENT_CONFIG_H__

/*-------------------------------------------------------------------------------------*
 * Includes
 *-------------------------------------------------------------------------------------*/

#include <scoreloop/sc_errors.h>
#include <scoreloop/sc_platform.h>
#include <scoreloop/sc_client_config_platform.h>

#ifdef __cplusplus
extern "C" {
#endif

/*-------------------------------------------------------------------------------------*
 * Methods
 *-------------------------------------------------------------------------------------*/

/**
 * @brief Creates a new instance of SC_ClientConfig.
 *
 * @param pSelf A pointer to opaque handle.
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_New(SC_ClientConfig_h* pSelf);

/**
 * @brief Deletes an instance of SC_ClientConfig.
 *
 * @param self Opaque handle for the current client instance.
 */
SC_PUBLISHED_WEAKLY void SC_ClientConfig_Delete(SC_ClientConfig_h self);

/**
 * @brief Sets identifier of the game.
 *
 * @param self Opaque handle for the current client instance.
 * @param identifier Identifier to set.
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_SetGameIdentifier(SC_ClientConfig_h self, const char* identifier);

/**
 * @brief Sets the secret of the game.
 * @param self Opaque handle for the current client instance.
 * @param secret Value of secret to set.
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_SetGameSecret(SC_ClientConfig_h self, const char* secret);

/**
 * @brief Sets the version of the game.
 *
 * @param self Opaque handle for the current client instance.
 * @param version Version value to set
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_SetGameVersion(SC_ClientConfig_h self, const char* version);

/**
 * @brief Sets the currency of the game.
 * @param self Opaque handle for the current client instance.
 * @param currency currency value to set
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_SetGameCurrency(SC_ClientConfig_h self, const char* currency);

/**
 * @brief Sets languages supported by the game.
 *
 * @param languages A comma-separated list of languages the game supports. e.g., for English, pass "en". This parameter is mandatory if the game supports localization of Awards.
 * The current language on the device is intersected with the given list and all Scoreloop supported languages. If an intersection is found, the intersected language will be used.
 * If there is no intersection the first language from the given list is used. English ("en") will be used if NULL is passed.
 * \n Example:\n
 * List of languages supported by game: ['en', 'en_US', 'de', 'pl']
 * <table>
 * <tr><td>Current Language of OS</td><td>Language used</td></tr>
 * <tr><td> 'en_US' </td><td>'en_US'</td></tr>
 * <tr><td> 'en_UK' </td><td>'en'</td></tr>
 * <tr><td> 'pl_PL' </td><td>'pl'</td></tr>
 * <tr><td> 'de' </td><td>'de'</td></tr>
 * <tr><td> 'it' </td><td>'en'</td></tr>
 * </table>
 * Note that the awards bundle needs to be localized to all given languages.
 * @param self Opaque handle for the current client instance.
 * @param languages A coma separated list of language codes.
 * @return SC_Error_t A return code (A value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED_WEAKLY SC_Error_t SC_ClientConfig_SetLanguages(SC_ClientConfig_h self, const char* languages);

#ifdef __cplusplus
}
#endif

#endif /* __SC_CLIENT_CONFIG_H__ */

/*! @} */
