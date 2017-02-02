/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="HibachiService" persistent="false" accessors="true" output="false" {

	property name="paymentDAO" type="any";

	property name="currencyService" type="any";
	property name="integrationService" type="any";
	property name="settingService" type="any";

	// ===================== START: Logical Methods ===========================

	public any function getUncapturedPreAuthorizations( required any payment ) {
		var authorizations = [];
		var sortedAuths = [];
		var thisData = {};
		var thisDataAdded = false;
		var sortedFound = false;

		for(var paymentTransaction in arguments.payment.getPaymentTransactions()) {

			thisData = {};

			if(paymentTransaction.getTransactionType() eq 'authorize' &&
				!isNull(paymentTransaction.getAuthorizationCode()) &&
				len(paymentTransaction.getAuthorizationCode()) &&
				!isNull(paymentTransaction.getAmountAuthorized()) &&
				paymentTransaction.getAmountAuthorized() gt 0 &&
				(isNull(paymentTransaction.getAuthorizationCodeInvalidFlag()) || !paymentTransaction.getAuthorizationCodeInvalidFlag())) {

					thisData.createdDateTime = paymentTransaction.getCreatedDateTime();
					thisData.authorizationCode = paymentTransaction.getAuthorizationCode();
					thisData.amountAuthorized = paymentTransaction.getAmountAuthorized();
					thisData.amountReceived = 0;
					thisData.providerTransactionID = "";
					if(!isNull(paymentTransaction.getProviderTransactionID())) {
						thisData.providerTransactionID = paymentTransaction.getProviderTransactionID();
					}

			} else if(paymentTransaction.getTransactionType() eq 'chargePreAuthorization' &&
				!isNull(paymentTransaction.getAuthorizationCodeUsed()) &&
				len(paymentTransaction.getAuthorizationCodeUsed()) &&
				!isNull(paymentTransaction.getAmountReceived()) &&
				paymentTransaction.getAmountReceived() gt 0) {

					thisData.createdDateTime = paymentTransaction.getCreatedDateTime();
					thisData.providerTransactionID = paymentTransaction.getProviderTransactionID();
					thisData.authorizationCode = paymentTransaction.getAuthorizationCodeUsed();
					thisData.amountAuthorized = 0;
					thisData.amountReceived = paymentTransaction.getAmountReceived();
					thisData.providerTransactionID = "";
					if(!isNull(paymentTransaction.getProviderTransactionID())) {
						thisData.providerTransactionID = paymentTransaction.getProviderTransactionID();
					}

			}

			if(structKeyExists(thisData, "authorizationCode")) {
				thisDataAdded = false;
				for(var a=1; a<=arrayLen(authorizations); a++) {
					if(thisData.authorizationCode eq authorizations[a].authorizationCode) {
						if(thisData.createdDateTime lt authorizations[a].createdDateTime) {
							authorizations[a].createdDateTime = thisData.createdDateTime;
							authorizations[a].providerTransactionID = thisData.providerTransactionID;
						}
						authorizations[a].amountAuthorized = getService('HibachiUtilityService').precisionCalculate(authorizations[a].amountAuthorized + thisData.amountAuthorized);
						authorizations[a].amountReceived = getService('HibachiUtilityService').precisionCalculate(authorizations[a].amountReceived + thisData.amountReceived);
						thisDataAdded = true;
						break;
					}
				}
				if(!thisDataAdded) {
					arrayAppend(authorizations, thisData);
				}
			}
		}

		for(var a=1; a<=arrayLen(authorizations); a++) {
			if(authorizations[a].amountAuthorized gt authorizations[a].amountReceived) {
				sortedFound = false;
				authorizations[a].chargeableAmount = getService('HibachiUtilityService').precisionCalculate(authorizations[a].amountAuthorized - authorizations[a].amountReceived);
				for(var s=1; s<=arrayLen(sortedAuths); s++) {
					if(sortedAuths[s].createdDateTime gt authorizations[a].createdDateTime) {
						arrayInsertAt(sortedAuths, s, authorizations[a]);
						sortedFound = true;
						break;
					}
				}
				if(!sortedFound) {
					arrayAppend(sortedAuths, authorizations[a]);
				}
			}
		}

		return sortedAuths;
	}

	public any function getEligiblePaymentMethodDetailsForOrder(required any order) {
		var paymentMethodMaxAmount = {};
		var eligiblePaymentMethodDetails = [];

		// Verify that this account has eligiblePaymentMethods
		if(!isNull(arguments.order.getAccount()) && len(arguments.order.getAccount().setting('accountEligiblePaymentMethods'))) {

			// Get the smartList for all the eligible payment methods for this account
			var paymentMethodSmartList = this.getPaymentMethodSmartList();

			paymentMethodSmartList.addFilter('activeFlag', 1);
			paymentMethodSmartList.addOrder('sortOrder|ASC');
			if(!isNull(arguments.order.getAccount())) {
				paymentMethodSmartList.addInFilter('paymentMethodID', arguments.order.getAccount().setting('accountEligiblePaymentMethods'));
			}
			var activePaymentMethods = paymentMethodSmartList.getRecords();
			for(var i=1; i<=arrayLen(arguments.order.getOrderItems()); i++) {
				var epmList = arguments.order.getOrderItems()[i].getSku().setting("skuEligiblePaymentMethods");
				for(var x=1; x<=listLen( epmList ); x++) {
					var thisPaymentMethodID = listGetAt(epmList, x);
					if(!structKeyExists(paymentMethodMaxAmount, thisPaymentMethodID)) {
						paymentMethodMaxAmount[thisPaymentMethodID] = arguments.order.getFulfillmentChargeAfterDiscountTotal();
					}
					paymentMethodMaxAmount[thisPaymentMethodID] = getService('HibachiUtilityService').precisionCalculate(paymentMethodMaxAmount[thisPaymentMethodID] + (arguments.order.getOrderItems()[i].getExtendedPriceAfterDiscount() + arguments.order.getOrderItems()[i].getTaxAmount()));
				}
			}

			// Loop over and update the maxAmounts on these payment methods based on the skus for each
			for(var i=1; i<=arrayLen(activePaymentMethods); i++) {
				if( structKeyExists(paymentMethodMaxAmount, activePaymentMethods[i].getPaymentMethodID()) && paymentMethodMaxAmount[ activePaymentMethods[i].getPaymentMethodID() ] gt 0 ) {

					// Define the maximum amount
					var maximumAmount = paymentMethodMaxAmount[ activePaymentMethods[i].getPaymentMethodID() ];

					var maxOrderPercentage = activePaymentMethods[i].setting('paymentMethodMaximumOrderTotalPercentageAmount');
					var maxAmountViaOrderPercentage = arguments.order.getTotal() * (maxOrderPercentage / 100);
					if(maxOrderPercentage lt 100 && maximumAmount > maxAmountViaOrderPercentage) {
						maximumAmount = maxAmountViaOrderPercentage;
					}

					// If the maximumAmount is more than we need for this order, then just set it to the amount needed
					if(maximumAmount > arguments.order.getOrderPaymentChargeAmountNeeded()) {
						maximumAmount = arguments.order.getOrderPaymentChargeAmountNeeded();
					}

					// If this is a termPayment type, then we need to check the account on the order to verify the max that it can use.
					if(activePaymentMethods[i].getPaymentMethodType() eq "termPayment") {

						// Make sure that we have enough credit limit on the account
						if(!isNull(arguments.order.getAccount()) && arguments.order.getAccount().getTermAccountAvailableCredit() > 0) {

							var paymentTerm = this.getPaymentTerm(arguments.order.getAccount().setting('accountPaymentTerm'));

							if(!isNull(paymentTerm)) {
								if(arguments.order.getAccount().getTermAccountAvailableCredit() < maximumAmount) {
									maximumAmount = arguments.order.getAccount().getTermAccountAvailableCredit();
								}

								arrayAppend(eligiblePaymentMethodDetails, {paymentMethod=activePaymentMethods[i], maximumAmount=maximumAmount, paymentTerm=paymentTerm});
							}
						}
					} else {
						arrayAppend(eligiblePaymentMethodDetails, {paymentMethod=activePaymentMethods[i], maximumAmount=maximumAmount});
					}
				}
			}
		}

		return eligiblePaymentMethodDetails;
	}

	public string function getCreditCardTypeFromNumber(required string creditCardNumber) {
		if(isNumeric(arguments.creditCardNumber)) {
			var n = arguments.creditCardNumber;
			var l = len(trim(arguments.creditCardNumber));
			if( (l == 13 || l == 16) && left(n,1) == 4 ) {
				return 'Visa';
			} else if ( l == 16 && left(n,2) >= 51 && left(n,2) <= 55 ) {
				return 'MasterCard';
			} else if ( l == 16 && left(n,2) == 35 ) {
				return 'JCB';
			} else if ( l == 15 && (left(n,4) == 2014 || left(n,4) == 2149) ) {
				return 'EnRoute';
			} else if ( l == 16 && (left(n,4) == 6011 || left(n,2) == 65)) {
				return 'Discover';
			} else if ( l == 14 && left(n,3) >= 300 && left(n,3) <= 305) {
				return 'CarteBlanche';
			} else if ( l == 14 && (left(n,2) == 30 || left(n,2) == 36 || left(n,2) == 38) ) {
				return 'Diners Club';
			} else if ( l == 15 && (left(n,2) == 34 || left(n,2) == 37) ) {
				return 'American Express';
			}
		}

		return 'Invalid';
	}

	public string function getAllActivePaymentMethodIDList() {
		var returnList = "";
		var apmSL = this.getPaymentMethodSmartList();
		apmSL.addFilter('activeFlag', 1);
		apmSL.addSelect('paymentMethodID', 'paymentMethodID');
		var records = apmSL.getRecords();
		for(var i=1; i<=arrayLen(records); i++) {
			returnList = listAppend(returnList, records[i]['paymentMethodID']);
		}
		return returnList;
	}

	public string function getAllActivePaymentTermIDList() {
		var returnList = "";
		var apmSL = this.getPaymentTermSmartList();
		apmSL.addFilter('activeFlag', 1);
		apmSL.addSelect('paymentTermID', 'paymentTermID');
		var records = apmSL.getRecords();
		for(var i=1; i<=arrayLen(records); i++) {
			returnList = listAppend(returnList, records[i]['paymentTermID']);
		}
		return returnList;
	}

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	public string function getOriginalAuthorizationCode( string orderPaymentID, string referencedOrderPaymentID, string accountPaymentID ) {
		return getPaymentDAO().getOriginalAuthorizationCode(argumentcollection=arguments);
	}

	public string function getOriginalAuthorizationProviderTransactionID( string orderPaymentID, string referencedOrderPaymentID, string accountPaymentID ) {
		return getPaymentDAO().getOriginalAuthorizationProviderTransactionID(argumentcollection=arguments);
	}

	public string function getOriginalChargeProviderTransactionID( string orderPaymentID, string referencedOrderPaymentID, string accountPaymentID ) {
		return getPaymentDAO().getOriginalChargeProviderTransactionID(argumentcollection=arguments);
	}

	public string function getOriginalProviderTransactionID( string orderPaymentID, string referencedOrderPaymentID, string accountPaymentID ) {
		return getPaymentDAO().getOriginalProviderTransactionID(argumentcollection=arguments);
	}

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================


	public any function processPaymentTransaction_runTransaction(required any paymentTransaction, required struct data) {
		param name="arguments.data.amount" default="0";
		param name="arguments.data.transactionType" default="";

		// Make sure there is an orderPayment or accountPayment
		if(!isNull(arguments.paymentTransaction.getPayment())) {

			// Lock the session scope to make sure that
			lock scope="Session" timeout="45" {

				// Check to make sure this isn't a duplicate transaction
				var isDuplicateTransaction = getPaymentDAO().isDuplicatePaymentTransaction(paymentID=arguments.paymentTransaction.getPayment().getPrimaryIDValue(), idColumnName=arguments.paymentTransaction.getPayment().getPrimaryIDPropertyName(), paymentType=arguments.paymentTransaction.getPayment().getPaymentMethodType(), transactionType=arguments.data.transactionType, transactionAmount=arguments.data.amount);

				// Add the duplicate error to the payment, if this was
				if(isDuplicateTransaction) {

					arguments.paymentTransaction.addError('runTransaction', "This transaction is duplicate of an already processed transaction.", true);

				// Otherwise continue with processing
				} else {

					// Setup the startTickCount & the transactionType
					arguments.paymentTransaction.setTransactionStartTickCount( getTickCount() );
					arguments.paymentTransaction.setTransactionType( arguments.data.transactionType );

					// Add the transaction to the hibernate scope
					getHibachiDAO().save(arguments.paymentTransaction);

					// Flush the ORMSession so this transaction gets added
					getHibachiDAO().flushORMSession();

					// ======== CORE PROCESSING ==========



					// If this isn't a creditOffline or receiveOffline, and an INTEGRATION EXISTS
					if(!listFindNoCase("creditOffline,receiveOffline", arguments.data.transactionType) && listFindNoCase("creditCard,external", arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentMethodType()) && !isNull(arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentIntegration())) {

						// Get the PaymentCFC
						var integration = arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentIntegration();
						var integrationPaymentCFC = getIntegrationService().getPaymentIntegrationCFC( integration );

						// Create a request Bean
						var requestBean = getTransient("#arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentMethodType()#TransactionRequestBean");

						// Setup generic info into
						requestBean.setTransactionID( arguments.paymentTransaction.getPaymentTransactionID() );
						requestBean.setTransactionType( arguments.data.transactionType );
						requestBean.setTransactionAmount( arguments.data.amount );
						if(structKeyExists(arguments.data, "preAuthorizationCode")) {
							requestBean.setPreAuthorizationCode( arguments.data.preAuthorizationCode );
						}
						if(structKeyExists(arguments.data, "preAuthorizationProviderTransactionID")) {
							requestBean.setPreAuthorizationProviderTransactionID( arguments.data.preAuthorizationProviderTransactionID );
						}
						if(listFindNoCase("OrderPayment,AccountPayment", arguments.paymentTransaction.getPayment().getClassName())) {
							requestBean.setTransactionCurrencyCode( arguments.paymentTransaction.getPayment().getCurrencyCode() );
							var currency = getCurrencyService().getCurrency( arguments.paymentTransaction.getPayment().getCurrencyCode() );
							if(!isNull(currency) && !isNull(currency.getCurrencyISONumber())) {
								requestBean.setTransactionCurrencyISONumber( currency.getCurrencyISONumber() );
							}
						}

						// Move all of the info into the new request bean
						if(arguments.paymentTransaction.getPayment().getClassName() eq "OrderPayment") {
							requestBean.populatePaymentInfoWithOrderPayment( arguments.paymentTransaction.getPayment() );
							arguments.paymentTransaction.setCurrencyCode( arguments.paymentTransaction.getPayment().getCurrencyCode() );
						} else if (arguments.paymentTransaction.getPayment().getClassName() eq "AccountPayment") {
							requestBean.populatePaymentInfoWithAccountPayment( arguments.paymentTransaction.getPayment() );
							arguments.paymentTransaction.setCurrencyCode( arguments.paymentTransaction.getPayment().getCurrencyCode() );
						} else if (arguments.paymentTransaction.getPayment().getClassName() eq "AccountPaymentMethod") {
							requestBean.populatePaymentInfoWithAccountPaymentMethod( arguments.paymentTransaction.getPayment() );
						}

						// Wrap in a try / catch so that the transaction will still get saved to the DB even in error
						try {

							// Get Response Bean from provider service
							logHibachi("#integration.getIntegrationName()# Payment Integration Transaction Request - Started (#arguments.data.transactionType#)", true);

							var response = integrationPaymentCFC.invokeMethod("process#arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentMethodType()#", {requestBean=requestBean});

							logHibachi("#integration.getIntegrationName()# Payment Integration Transaction Request - Finished (#arguments.data.transactionType#)", true);

							// Populate the Credit Card Transaction with the details of this process

							// messages
							arguments.paymentTransaction.setMessage(serializeJSON(response.getMessages()));

							// providerTransactionID
							if(!isNull(response.getProviderTransactionID())) {
								arguments.paymentTransaction.setProviderTransactionID( response.getProviderTransactionID() );
							}
							// amountAuthorized
							if(!isNull(response.getAmountAuthorized())) {
								arguments.paymentTransaction.setAmountAuthorized(response.getAmountAuthorized());
							}
							// amountReceived
							if(!isNull(response.getAmountReceived())) {
								arguments.paymentTransaction.setAmountReceived(response.getAmountReceived());
							}
							// amountCredited
							if(!isNull(response.getAmountCredited())) {
								arguments.paymentTransaction.setAmountCredited(response.getAmountCredited());
							}
							// authorizationCode
							if(!isNull(response.getAuthorizationCode())) {
								arguments.paymentTransaction.setAuthorizationCode(response.getAuthorizationCode());
							}
							// statusCode
							if(!isNull(response.getStatusCode())) {
								arguments.paymentTransaction.setStatusCode(response.getStatusCode());
							}
							// avsCode
							if(!isNull(response.getAVSCode())) {
								arguments.paymentTransaction.setAVSCode(response.getAVSCode());
							}

							// If the reposnse passes back an authorizationCode that was used, then add it to the transaction
							if(!isNull(response.getAuthorizationCodeUsed()) && len(response.getAuthorizationCodeUsed())) {
								arguments.paymentTransaction.setAuthorizationCodeUsed( arguments.data.preAuthorizationCode );

							// If the response didn't pass back an authorizationCode used, then we can check the transactionType, and if we passed in a preAuthorizationCode and then a value was set
							} else if(listFindNoCase("chargePreAuthorization", arguments.data.transactionType) && structKeyExists(arguments.data, "preAuthorizationCode") && !isNull(response.getAmountReceived()) && isNumeric(response.getAmountReceived()) && response.getAmountReceived() gt 0) {
								arguments.paymentTransaction.setAuthorizationCodeUsed( arguments.data.preAuthorizationCode );

							}

							// If this transaction used an authorizationCode, and the response has told us that the authorizationCode is now invalid then we should update any paymentTransactions with that authorizeCode and set them to now be invalid
							if(!isNull(response.getAuthorizationCodeInvalidFlag()) && response.getAuthorizationCodeInvalidFlag() && !isNull(arguments.paymentTransaction.getAuthorizationCodeUsed()) && len(arguments.paymentTransaction.getAuthorizationCodeUsed())) {
								if(arguments.paymentTransaction.getPayment().getClassName() eq "OrderPayment") {
									getPaymentDAO().updateInvalidAuthorizationCode( autorizationCode=arguments.paymentTransaction.getAuthorizationCodeUsed(), orderPaymentID=arguments.paymentTransaction.getPayment().getOrderPaymentID() );
								} else if (arguments.paymentTransaction.getPayment().getClassName() eq "AccountPayment") {
									getPaymentDAO().updateInvalidAuthorizationCode( autorizationCode=arguments.paymentTransaction.getAuthorizationCodeUsed(), orderPaymentID=arguments.paymentTransaction.getPayment().getOrderPaymentID() );
								}
							}

							// add the providerToken to the orderPayment & accountPayment
							if(!isNull(response.getProviderToken()) && len(response.getProviderToken())) {

								// Set the provider token if one was returned
								arguments.paymentTransaction.getPayment().setProviderToken( response.getProviderToken() );

								// If this was an OrderPayment and it has an accountPaymentMethod then also update that token
								if(arguments.paymentTransaction.getPayment().getClassName() eq "OrderPayment" && !isNull(arguments.paymentTransaction.getPayment().getAccountPaymentMethod())) {
									arguments.paymentTransaction.getPayment().getAccountPaymentMethod().setProviderToken( response.getProviderToken() );
								}

							}

							// Set the successFlag in the transaction acordingly
							arguments.paymentTransaction.setTransactionSuccessFlag( !response.hasErrors() );

							// Make sure that this transaction with all of it's info gets added to the DB
							getHibachiDAO().flushORMSession();

							// If the response had errors
							if(response.hasErrors()) {
								// add errors to the paymentTransaction
								arguments.paymentTransaction.addError('runTransaction', response.getErrors(), true);
							}

						} catch (any e) {

							// Set the successFlag to false
							arguments.paymentTransaction.setTransactionSuccessFlag( false );

							// Populate the orderPayment with the processing error and make it persistable
							arguments.paymentTransaction.addError('runTransaction', rbKey('error.unexpected.checklog'), true);

							// Log the exception
							logHibachiException(e);

							rethrow;
						}

					// NO INTEGRATION
					} else {

						//GiftCard
                        if(listFindNoCase("giftCard", arguments.paymentTransaction.getPayment().getPaymentMethod().getPaymentMethodType())){
                            var giftCard = getService("HibachiService").get("giftCard",  getDAO("giftCardDAO").getIDByCode(arguments.paymentTransaction.getOrderPayment().getGiftCardNumberEncrypted()));

							var amount = arguments.data.amount;

                            if(arguments.data.transactionType == "charge"){

                                var giftCardProcessObject = giftCard.getProcessObject("AddDebit");

                                giftCardProcessObject.setOrderPayment(arguments.paymentTransaction.getOrderPayment());
                                giftCardProcessObject.setOrderItems(arguments.paymentTransaction.getOrderPayment().getOrder().getOrderItems());

								if(giftCard.isExpired()){

									amount = 0;
									arguments.paymentTransaction.addError("runTransaction", getHibachiScope().getRBKey("validate.giftCard.isExpired"), true);
									return arguments.paymentTransaction;

								} else if(giftCard.getBalanceAmount() LTE amount){
                                    amount = giftCard.getBalanceAmount();
                                }

                                if(amount NEQ 0){
                                    giftCardProcessObject.setDebitAmount(amount);

                                    var card = getService("GiftCardService").process(giftCard, giftCardProcessObject, "addDebit");

                                    if(!card.hasErrors()){
                                        arguments.paymentTransaction.setAmountReceived( amount );
                                    } else {
                                        arguments.paymentTransaction.addErrors(card.getErrors());
                                    }
                                }
                            } else if(arguments.data.transactionType == "credit") {

                                var giftCardProcessObject = giftCard.getProcessObject("AddCredit");

                                giftCardProcessObject.setOrderPayments(arguments.paymentTransaction.getOrderPayment().getOrder().getOrderPayments());
                                giftCardProcessObject.setOrderItems(arguments.paymentTransaction.getOrderPayment().getOrder().getOrderItems());

                                giftCardProcessObject.setCreditAmount(amount);

                                var card = getService("GiftCardService").process(giftCard, giftCardProcessObject, "addCredit");

                                if(!card.hasErrors()){
                                    arguments.paymentTransaction.setAmountCredited(amount);
                                } else {
                                    arguments.paymentTransaction.addErrors(card.getErrors());
                                }
                            }

                        } else {

                            // Setup amountReceived
                            if( listFindNoCase("receive,receiveOffline", arguments.data.transactionType) ) {
                                arguments.paymentTransaction.setAmountReceived( arguments.data.amount );
                            }

                            // Setup amountCredited
                            if( listFindNoCase("credit,creditOffline", arguments.data.transactionType) ) {
                                arguments.paymentTransaction.setAmountCredited( arguments.data.amount );
                            }
                        }

					}

					// ======== END CORE PROCESSING ==========

					// Set the transactionEndTickCount
					arguments.paymentTransaction.setTransactionEndTickCount( getTickCount() );

					// Flush the ORMSession again this transaction gets updated
					getHibachiDAO().flushORMSession();
				}

			}//end lock

		}

		return arguments.paymentTransaction;
	}

	// =====================  END: Process Methods ============================

	// ====================== START: Status Methods ===========================

	// ======================  END: Status Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================

	// ===================== START: Delete Overrides ==========================

	// =====================  END: Delete Overrides ===========================
}
