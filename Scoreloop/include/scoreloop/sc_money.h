/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2012 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @file        sc_money.h
 * @brief       Structure that represents an amount of game-specific currency.
 *
 * @addtogroup  SC_Money
 * @{
 *
 * Instances of \ref SC_Money are used to represent an amount of
 * game-specific currency.
 *
 * Game-specific currencies are represented using a 3-character code.
 * Scoreloop generates the code when the game is registered at https://developer.scoreloop.com along with the game ID and game secret.
 *
 * The amount of currency represented by the \ref SC_Money instance
 * must be given in cents.
 *
 * Basic Use:
 * -# Optional: Use the session object's SC_Session_GetBalance() to check if the user has enough balance to create a challenge.
 * -# Use the \ref SC_Client instance to create an \ref SC_Money object by calling SC_Client_CreateMoney().
 * -# Use this \ref SC_Money object as the stake to create a challenge by calling SC_Client_CreateChallenge()
 */

#ifndef __SC_MONEY_H__
#define __SC_MONEY_H__

/*-------------------------------------------------------------------------------------*
 * Includes
 *-------------------------------------------------------------------------------------*/

#include <scoreloop/sc_object.h>
#include <scoreloop/sc_errors.h>
#include <scoreloop/sc_string.h>

#ifdef __cplusplus
extern "C" {
#endif

/*-------------------------------------------------------------------------------------*
 * Data Types
 *-------------------------------------------------------------------------------------*/

/** Opaque Money object handle 
 *
 * @since 10.0.0
 */
typedef struct SC_Money_tag* SC_Money_h;

/** Type descriptors for SC_Money. 
 *
 * @since 10.0.0
 */
SC_TYPEINFO(SC_Money);

/*-------------------------------------------------------------------------------------*
 * Methods
 *-------------------------------------------------------------------------------------*/

/**
 * @brief Increments the object's reference count
 *
 * This method increments the reference count of the SC_Money
 * instance.
 *
 * @param self An opaque handle for the SC_Money instance.
 *
 * @since 10.0.0
 */
SC_PUBLISHED void SC_Money_Retain(SC_Money_h self);

/**
 * @brief Decrements the object's reference count, and deletes the object if the counter reaches 0.
 *
 * This method decrements the reference count of the SC_Money instance.
 * The instance will be automatically deleted when the reference count
 * reaches 0.
 *
 * Please note that this method is NULL pointer safe. That is, NULL as an argument will
 * not cause an exception.
 *
 * @param self An opaque handle for the SC_Money instance.
 *
 * @since 10.0.0
 */
SC_PUBLISHED void SC_Money_Release(SC_Money_h self);

/**
 * @brief Returns the amount of game-specific currency represented by the money object.
 *
 * This method returns the amount of currency represented by the
 * instance of SC_Money.
 *
 * @param self An opaque handle for the SC_Money instance.
 * @return unsigned int The amount of currency.
 *
 * @since 10.0.0
 */
SC_PUBLISHED unsigned int SC_Money_GetAmount(SC_Money_h self);

/**
 * @brief Returns the currency represented by the money object.
 *
 * This function returns the 3-character code
 * for the game-specific currency represented by the SC_Money
 * instance. This code is generated by Scoreloop when the
 * game is registered on
 * <a href="https://developer.scoreloop.com">https://developer.scoreloop.com
 * </a> and should be included in the property list of the application.
 * If no game-specific currency has been defined, this function will
 * return the code for the default currency of Scoreloop coins (SLD).
 *
 * @param self An opaque handle for the current SC_Money instance.
 * @return SC_String_h The 3-character code for the currency being used.
 *
 * @since 10.2.0
 */
SC_PUBLISHED SC_String_h SC_Money_GetCurrency(SC_Money_h self);

#ifdef __cplusplus
}
#endif

#endif /* __SC_MONEY_H__ */

/*! @} */
