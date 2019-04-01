/**
 * ------------------------
 * Importing these Actions:
 * 
 * Action constants are used in both the controller (to dispatch to the correct reducer) 
 * as well as the service (where the reducer lives).
 * These can be imported using * and then aliased (such as action) such that
 * they can be referenced from multiple places as action.TOGGLE_EDITCOMMENT.
 * The naming convention is slightly different for UI actions and server actions.
 * ---
 * Server Based Actions:
 * 
 * A server action example would be any object CRUD like SAVE_COMMENT, DELETE_PRODUCT, ETC.
 * A server action also has a third part added: Requested | Success | Fail so the action may be
 * dispatched as SAVE_COMMENT_REQUESTED but would be returned as SAVE_COMMENT_SUCCESS or SAVE_COMMENT_FAILED.
 * ---
 * UI Based Actions:
 * 
 * UI actions do not include the REQUESTED|SUCCESS|FAILED part because they are simple enough that
 * they should not do anything other than success.
 * 
 */

/**
 * This action will toggle the comment edit and allow a user to start editing or stop editing a comment.
 */
export const TOGGLE_EDITCOMMENT = "TOGGLE_EDITCOMMENT";

/**
 * This action will toggle the page loader.
 */
export const TOGGLE_LOADER = "TOGGLE_LOADER";

/**
 * This will toggle the batch listing to its full or half size view.
 */
export const TOGGLE_BATCHLISTING  = "TOGGLE_BATCHLISTING";

/**
 * This will toggle the fulfillment listing between fulfillment and order items on the order fulfillments list screen
 */
export const TOGGLE_FULFILLMENT_LISTING  = "TOGGLE_FULFILLMENT_LISTING";

/**
 * This sets up all the state data on page start and should only be called once in a constructor.
 */
export const SETUP_BATCHDETAIL  = "SETUP_BATCHDETAIL";

/**
 * This updates all of the state for the batch detail page. 
 */
export const UPDATE_BATCHDETAIL  = "UPDATE_BATCHDETAIL";

/**
 * This will refresh all of the batch detail state.
 */
export const REFRESH_BATCHDETAIL  = "REFRESH_BATCHDETAIL";

/**
 * This will create a new batch by passing all batch data.
 */
export const ADD_BATCH  = "ADD_BATCH";

/**
 * This will add a box to a shipment.
 */
export const ADD_BOX  = "ADD_BOX";

/**
 * This will remove a box from a shipment.
 */
export const REMOVE_BOX  = "REMOVE_BOX";

/**
 * This will update the dimensions of a box on a shipment.
 */
export const UPDATE_BOX_DIMENSIONS  = "UPDATE_BOX_DIMENSIONS";

/**
 * This will set delivery quantities on a shipment.
 */
export const SET_DELIVERY_QUANTITIES  = "SET_DELIVERY_QUANTITIES";

/**
 * This will update the quantity on a container item.
 */
export const UPDATE_CONTAINER_ITEM_QUANTITY = "UPDATE_CONTAINER_ITEM_QUANTITIES";

/**
 * This will set the container for an unassigned container item.
 */
export const SET_UNASSIGNED_ITEM_CONTAINER = "SET_UNASSIGNED_ITEM_CONTAINER";

/**
 * This will fire when the current page records selected on a table are updated.
 */
export const CURRENT_PAGE_RECORDS_SELECTED  = "CURRENT_PAGE_RECORDS_SELECTED";

/**
 * This setups the page that displays the order delivery custom attributes and should only be called once.
 */
export const SETUP_ORDERDELIVERYATTRIBUTES  = "SETUP_ORDERDELIVERYATTRIBUTES";

/**
 * This will delete a comment permenently.
 */
export const DELETE_COMMENT_REQUESTED  = "DELETE_COMMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const DELETE_COMMENT_SUCCESS  = "DELETE_COMMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const DELETE_COMMENT_FAILURE  = "DELETE_COMMENT_FAILURE";

/**
 * This will delete a fulfillment batch item permenently and from the fulfillment batch.
 */
export const DELETE_FULFILLMENTBATCHITEM_REQUESTED  = "DELETE_FULFILLMENTBATCHITEM_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const DELETE_FULFILLMENTBATCHITEM_SUCCESS  = "DELETE_FULFILLMENTBATCHITEM_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const DELETE_FULFILLMENTBATCHITEM_FAILURE  = "DELETE_FULFILLMENTBATCHITEM_FAILURE";

/**
 * This will save a comment.
 */
export const SAVE_COMMENT_REQUESTED  = "SAVE_COMMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const SAVE_COMMENT_SUCCESS  = "SAVE_COMMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const SAVE_COMMENT_FAILURE  = "SAVE_COMMENT_FAILURE";

/**
 * This will fulfill the batch item if it has all needed information.
 */
export const CREATE_FULFILLMENT_REQUESTED  = "CREATE_FULFILLMENT_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const CREATE_FULFILLMENT_SUCCESS  = "CREATE_FULFILLMENT_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const CREATE_FULFILLMENT_FAILURE  = "CREATE_FULFILLMENT_FAILURE";

/**
 * This will print the picking list that the user has defined.
 */
export const PRINT_PICKINGLIST_REQUESTED  = "PRINT_PICKINGLIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const PRINT_PICKINGLIST_SUCCESS  = "PRINT_PICKINGLIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const PRINT_PICKINGLIST_FAILURE  = "PRINT_PICKINGLIST_FAILURE";

/**
 * This will print the packing list that the user has defined.
 */
export const PRINT_PACKINGLIST_REQUESTED  = "PRINT_PACKINGLIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const PRINT_PACKINGLIST_SUCCESS  = "PRINT_PACKINGLIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const PRINT_PACKINGLIST_FAILURE  = "PRINT_PACKINGLIST_FAILURE";

/**
 * This will return a list of print templates that are defined for fulfillment batches.
 */
export const PRINT_LIST_REQUESTED  = "PRINT_LIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const PRINT_LIST_SUCCESS  = "PRINT_LIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const PRINT_LIST_FAILURE  = "PRINT_LIST_FAILURE";

/**
 * This will return a list of emails that are defined for orderFulfillments
 */
export const EMAIL_LIST_REQUESTED  = "EMAIL_LIST_REQUESTED";
/** This action coming back from the reducer indicated that the action was a success. */
export const EMAIL_LIST_SUCCESS  = "EMAIL_LIST_SUCCESS";
/** This action coming back from the reducer indicated that the action was a failure. */
export const EMAIL_LIST_FAILURE  = "EMAIL_LIST_FAILURE";




