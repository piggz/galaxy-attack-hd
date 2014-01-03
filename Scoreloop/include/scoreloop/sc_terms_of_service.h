/*-------------------------------------------------------------------------------------*
 * Copyright (C) 2013 Scoreloop AG. All rights reserved.
 *-------------------------------------------------------------------------------------*/

/**
 * @file        sc_terms_of_service.h
 * @brief       A model object for the Terms Of Service
 *
 * @addtogroup  SC_TermsOfService
 */

#ifndef __SC_TERMS_OF_SERVICE__
#define __SC_TERMS_OF_SERVICE__

/*-------------------------------------------------------------------------------------*
 * Includes
 *-------------------------------------------------------------------------------------*/

#include <scoreloop/sc_object.h>
#include <scoreloop/sc_errors.h>

#ifdef __cplusplus
extern "C" {
#endif


/*-------------------------------------------------------------------------------------*
 * Data Types
 *-------------------------------------------------------------------------------------*/

/** Opaque SC_TermsOfService object handle */
typedef struct SC_TermsOfService_tag* SC_TermsOfService_h;

/** Type descriptors for SC_TermsOfService. */
SC_TYPEINFO(SC_TermsOfService);
    
/**
 * List of the TOS states.
 */
typedef enum SC_TermsOfServiceStatus_tag
{
    SC_TOS_STATE_UNSET, /**< User did not accept or decline yet */
    SC_TOS_STATE_ACCEPTED, /**< User accepted TOS */
    SC_TOS_STATE_REJECTED /**< User declined TOS, Scoreloop functionality is unavailable. */
} SC_TermsOfServiceState_t;


/*-------------------------------------------------------------------------------------*
 * Methods
 *-------------------------------------------------------------------------------------*/

/**
 * @brief Increments the object's reference count.
 *
 * This method increments the reference count by one.
 *
 * @param self An opaque handle for the current TermsOfService instance.
 */
SC_PUBLISHED void SC_TermsOfService_Retain(SC_TermsOfService_h self);

/**
 * @brief Decrements the object's reference count, and deletes the object if the counter reaches 0.
 *
 * This method decrements the reference count by one. The SC_TermsOfService_h instance
 * will be automatically deleted when the counter reaches 0.
 *
 * Please note that this method is NULL pointer safe. That is, NULL as an argument will
 * not cause an exception.
 *
 * @param self An opaque handle for the current TermsOfService instance.
 */
SC_PUBLISHED void SC_TermsOfService_Release(SC_TermsOfService_h self);

/** 
 * @brief: The current state of Terms Of Service
 * @param self An opaque handle for the current TermsOfService instance 
 * @return SC_TermsOfServiceState_t the value of state 
 */
SC_PUBLISHED SC_TermsOfServiceState_t SC_TermsOfService_GetState( SC_TermsOfService_h self );
 
#ifdef __cplusplus
}
#endif

#endif /* __SC_TERMS_OF_SERVICE__ */

/*! @} */

