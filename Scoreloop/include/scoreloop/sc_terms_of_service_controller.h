/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2013 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @ingroup     CoreSocial
 * @file        sc_terms_of_service_controller.h
 * @brief       SC_TermsOfServiceController Controller to handle User Terms of Service
 *
 * @addtogroup  SC_TermsOfServiceController
 * @{
 *
 * \ref SC_TermsOfServiceController manages the user Terms of Service(TOS) which is required 
 * to be accepted to continue using the Scoreloop services.
 *
 * A Terms of Service dialog will pop up whenever a user establishes a connection with 
 * Scoreloop for the first time.  The user is required to accept it to be able to use 
 * the various Scoreloop features. Note that the TOS is per Game. If the user has 
 * accepted the TOS once for a particular game, the dialog will not be shown
 * again for the same game. However, it is required to accept it again in another game. 
 * The user will not be allowed to continue interacting with Scoreloop if the TOS is 
 * rejected. Game developers must ensure that the users accept the TOS.
 *
 */

#ifndef __SC_TERMS_OF_SERVICE_CONTROLLER_H__
#define __SC_TERMS_OF_SERVICE_CONTROLLER_H__

/*-------------------------------------------------------------------------------------*
 * Includes
 *-------------------------------------------------------------------------------------*/

#include <scoreloop/sc_errors.h>
#include <scoreloop/sc_object.h>
#include <scoreloop/sc_terms_of_service.h>
#include <scoreloop/sc_completion_callback.h>

#ifdef __cplusplus
extern "C" {
#endif

/*-------------------------------------------------------------------------------------*
 * Data Types
 *-------------------------------------------------------------------------------------*/

/** Opaque SC_ScoresController object handle. */
typedef struct SC_TermsOfServiceController_tag* SC_TermsOfServiceController_h;

/** Type descriptors for SC_ScoresController. */
SC_TYPEINFO(SC_TermsOfServiceController);

/*-------------------------------------------------------------------------------------*
 * Methods
 *-------------------------------------------------------------------------------------*/

/**
 * @brief Prompts the user to accept the TOS, if they have not accepted yet. Callback will be triggered.
 *
 * @param   self        SC_TermsOfServiceController instance
 * @return  SC_Error_t  A return code (a value of SC_OK indicates success, any other value indicates an error).
 */
SC_PUBLISHED SC_Error_t SC_TermsOfServiceController_Ask(SC_TermsOfServiceController_h self);

/**
 * @brief Returns the current TOS acceptance status
 *
 * @param   self                    SC_TermsOfServiceController instance
 * @return  SC_TermsOfService_h     TermsOfService model object
 */
SC_PUBLISHED SC_TermsOfService_h SC_TermsOfServiceController_GetTermsOfService(SC_TermsOfServiceController_h self);

/**
 * @brief Increments the object's reference count.
 *
 * This method increments the reference count of the current instance by 1.
 *
 * @param   self        SC_TermsOfServiceController instance handle
 */
SC_PUBLISHED void SC_TermsOfServiceController_Retain(SC_TermsOfServiceController_h self);

/**
 * @brief Decrements the object's reference count, and deletes the object if the counter reaches 0.
 *
 * This method decrements the reference count for the current instance by 1. 
 * The current controller instance will be automatically deleted when the reference count equals 0.
 *
 * Please note that this method is @c NULL pointer safe. That is, @c NULL as an argument will
 * not cause an exception.
 *
 * @param   self        SC_TermsOfServiceController instance handle
 */
SC_PUBLISHED void SC_TermsOfServiceController_Release(SC_TermsOfServiceController_h self);

#ifdef __cplusplus
}
#endif

#endif /* __SC_TERMS_OF_SERVICE_CONTROLLER_H__ */

/*! @} */