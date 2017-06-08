/**
 * ------------------------
 * Importing these Actions:
 * 
 * Action constants are used in both the controller (to dispatch to the correct reducer) 
 * as well as the service (where the reducer lives).
 * These can be imported using * and then aliased (such as action) such that
 * they can be referenced from multiple places as action.TOGGLE_EDITCOMMENT.
 * The naming convention is slightly different for UI actions and server actions.
 * ------------------------
 * Server Based Actions:
 * 
 * A server action example would be any object CRUD like SAVE_COMMENT, DELETE_PRODUCT, ETC.
 * A server action also has a third part added: Requested | Success | Fail so the action may be
 * dispatched as SAVE_COMMENT_REQUESTED but would be returned as SAVE_COMMENT_SUCCESS or SAVE_COMMENT_FAILED.
 * ------------------------
 * UI Based Actions:
 * 
 * UI actions do not include the REQUESTED|SUCCESS|FAILED part because they are simple enough that
 * they should not do anything other than success.
 */

//UI based actions
export const TOGGLE_EDITCOMMENT = "TOGGLE_EDITCOMMENT";

export const TOGGLE_BATCHLISTING  = "TOGGLE_BATCHLISTING";

export const SETUP_BATCHDETAIL  = "SETUP_BATCHDETAIL";

export const SETUP_ORDERDELIVERYATTRIBUTES  = "SETUP_ORDERDELIVERYATTRIBUTES";

// Server based actions.
export const DELETE_COMMENT_REQUESTED  = "DELETE_COMMENT_REQUESTED";
export const DELETE_COMMENT_SUCCESS  = "DELETE_COMMENT_SUCCESS";
export const DELETE_COMMENT_FAILURE  = "DELETE_COMMENT_FAILURE";

export const SAVE_COMMENT_REQUESTED  = "SAVE_COMMENT_REQUESTED";
export const SAVE_COMMENT_SUCCESS  = "SAVE_COMMENT_SUCCESS";
export const SAVE_COMMENT_FAILURE  = "SAVE_COMMENT_FAILURE";

export const CREATE_FULFILLMENT_REQUESTED  = "CREATE_FULFILLMENT_REQUESTED";
export const CREATE_FULFILLMENT_SUCCESS  = "CREATE_FULFILLMENT_SUCCESS";
export const CREATE_FULFILLMENT_FAILURE  = "CREATE_FULFILLMENT_FAILURE";

export const PRINT_PICKINGLIST_REQUESTED  = "PRINT_PICKINGLIST_REQUESTED";
export const PRINT_PICKINGLIST_SUCCESS  = "PRINT_PICKINGLIST_SUCCESS";
export const PRINT_PICKINGLIST_FAILURE  = "PRINT_PICKINGLIST_FAILURE";




