component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

    public void function setUp() {
        super.setup();
        
        variables.service = variables.mockservice.getIntegrationServiceMock();
        variables.accountPaymentMethodID = '2c9180876fa59460016fa9624bbc09f6';
        
        variables.integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('nexio');
		variables.paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));
	}

	/**
	 * @test
	 */
	public void function processCreditCard() {

		var integrationCFC = request.slatwallScope.getBean("IntegrationService").getIntegrationByIntegrationPackage('nexio');
		var paymentIntegrationCFC = createMock(object=request.slatwallScope.getBean("IntegrationService").getPaymentIntegrationCFC(integrationCFC));

		var cards = [
			'4111111111111111', // 1. Visa
			'5200000000000007', // 2. MasterCard
			'6011111111111117', // 3. Discover
			'378282246310005',  // 4. AMEX
			'3566111111111113', // 5. JCB
			'2222420000001113', // 6. MasterCard
			'2222630000001125', // 7. MasterCard
			'5555555555554444', // 8. MasterCard
		];

		var transactionTypes = [
			'generateToken',			// 1
			'authorizeAndCharge',		// 2
			'authorize', 				// 3
			'chargePreAuthorization', 	// 4
			'credit',					// 5
			'void'						// 6
		];

		var values = {
			selectedMerchant = '100161',
            currencyCode = 'PLN',
			testMode = true,
			amount = 20.00,
			expMonth = '03',
			expYear = '20',
			cvn = '222', // 222 to invoke "Failure", 111 to invoke "Success"
			cardNumber = cards[1],
			transactionType = transactionTypes[1],
			providerToken = '', // token_ex
			// providerToken = '16647a85-766c-4cd4-8566-91d2e9c8c363', // token_ex
			originalAuthorizationProviderTransactionID = 'eyJuYW1lIjoidXNhZXBheSIsIm1lcmNoYW50SWQiOiIxMDAxNjEiLCJyZWZOdW1iZXIiOiIzMTAzNDIzOTQwIiwicmFuZG9tIjowLCJjdXJyZW5jeSI6InVzZCJ9', // authorizationID
			originalChargeProviderTransactionID = 'eyJuYW1lIjoidXNhZXBheSIsIm1lcmNoYW50SWQiOiIxMDAxNjEiLCJyZWZOdW1iZXIiOiIzMTAzNDIzOTQwIiwicmFuZG9tIjowLCJjdXJyZW5jeSI6InVzZCJ9' // chargeID
		};

		// Setup objects
		var paymentTransaction = request.slatwallScope.getBean("paymentService").newPaymentTransaction();
		var payment = request.slatwallScope.getBean("paymentService").newOrderPayment();
		var order = createMock(object=request.slatwallScope.getBean('orderService').newOrder());
		var account = createMock(object=request.slatwallScope.getBean('accountService').newAccount());
		var address = createMock(object=request.slatwallScope.getBean('addressService').newAddress());
		var emailAddress = createMock(object=request.slatwallScope.getBean('accountService').newAccountEmailAddress());
		paymentTransaction.setOrderPayment(payment);
		payment.setOrder(order);
		order.setAccount(account);
		order.setOrderID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		order.setBillingAddress(address);
		emailAddress.setAccount(account);
		emailAddress.setEmailAddress('todd.hatcher@ten24web.com');		
		account.setPrimaryEmailAddress(emailAddress);
		account.setAccountID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		account.setFirstName("Todd");
		account.setLastName("Hatcher");
		address.setStreetAddress("16112 Cherrywood St.");
		address.setStreet2Address("");
		address.setCity("WARSZAWA");
		address.setStateCode("");
		address.setPostalCode("49802"); //"49802" for AVS failure OR "56649" for AVS valid
		address.setCountryCode("PL");
		payment.setNameOnCreditCard(account.getFullName());
		payment.setCreditCardNumber(values.cardNumber);
		payment.setSecurityCode(values.cvn);
		payment.setCurrencyCode(values.currencyCode);
		payment.setAmount(values.amount);
		payment.setExpirationMonth(values.expMonth);
		payment.setExpirationYear(values.expYear);

		// Setup requestBean
		var requestBean = request.slatwallScope.getTransient('creditCardTransactionRequestBean');
		requestBean.setTransactionID(request.slatwallScope.getService("hibachiService").createHibachiUUID());
		requestBean.setTransactionAmount(payment.getAmount());
		requestBean.setTransactionCurrencyCode(payment.getCurrencyCode());
		requestBean.setTransactionType(values.transactionType);

		// Token from generateToken
		if (len(values.providerToken)) {
			requestBean.setProviderToken(values.providerToken);
		}

		// AuthorizationID to use for 'chargePreAuthorization'
		if (len(values.originalAuthorizationProviderTransactionID)) {
			requestBean.setOriginalAuthorizationProviderTransactionID(values.originalAuthorizationProviderTransactionID);
		}

		// ChargeID to use for 'credit' or 'void'
		if (len(values.originalChargeProviderTransactionID)) {
			requestBean.setOriginalChargeProviderTransactionID(values.originalChargeProviderTransactionID);
		}

		requestBean.populatePaymentInfoWithOrderPayment( paymentTransaction.getPayment() );

		/*
		// Set Integration Settings based on selectedMerchant
		// MerchantID
		getBean('settingService').saveSetting(getBean('settingService').getSetting('8a72828360d9e8390160e4746d46012e'), {
			settingName = 'integrationcybersourceMERCHANTID',
			settingValue = merchants[values.selectedMerchant].mid,
			integration = {
				integrationID = '8a72828360d9e8390160da75680c0034'
			}
		});

		// Test Transaction Key
		getBean('settingService').saveSetting(getBean('settingService').getSetting('8a72828360d9e8390160da95a08c003f'), {
			settingName = 'integrationcybersourceTRANSACTIONKEYTEST',
			settingValue = merchants[values.selectedMerchant].transactionKey,
			integration = {
				integrationID = '8a72828360d9e8390160da75680c0034'
			}
		});
		*/
		/*
		// Set Disable Pre-Auth
		getBean('settingService').saveSetting(getBean('settingService').getSetting('8a80cb8160e8b88f0160fe04a4f5024b'), {
			settingName = 'integrationcybersourceDISABLEAUTOAUTH',
			settingValue = values.disablePreAuth,
			integration = {
				integrationID = '8a72828360d9e8390160da75680c0034'
			}
		});

		// Set Verify CVV
		getBean('settingService').saveSetting(getBean('settingService').getSetting('8a80cb8160e8b88f0160fe0535c6024d'), {
			settingName = 'integrationcybersourceVERIFYCVNUMBER',
			settingValue = values.verifyCVNumber,
			integration = {
				integrationID = '8a72828360d9e8390160da75680c0034'
			}
		});
		

		// Set Testing Flag to false
		getBean('settingService').saveSetting(getBean('settingService').getSetting('8a80cb8160e8b88f0160fdf248dd0249'), {
			settingName = 'integrationcybersourceTESTMODE',
			settingValue = values.testMode,
			integration = {
				integrationID = '8a72828360d9e8390160da75680c0034'
			}
		});
		*/

		// Verfify that we don't execute a transaction larger than 1.10 cents in live mode
		if (!values.testMode && requestBean.getTransactionAmount() > 1.10) {
			requestBean.setTransactionAmount(.05);
		}

		// Manual test override without needed to set integration testMode=false
		// requestBean.getOrder().setTestOrderFlag(values.testMode);
		// writeDump("***Test mode: ");
		// writeDump({testMode = paymentIntegrationCFC.getTestModeFlag(requestBean, 'testMode'), transactionAmount = requestBean.getTransactionAmount()});

		// writeDump(var=paymentIntegrationCFC.processCreditCard(requestBean), top=1, abort=true);
		
		// Run transaction
		var responseBean = paymentIntegrationCFC.processCreditCard(requestBean);
		// Debugging
		debug({errors=responseBean.getErrors(), messages=responseBean.getMessages(), properties=[
			{'avsCode' = responseBean.getAVSCode()},
			{'authorizationCode' = responseBean.getAuthorizationCode()},
			{'amountAuthorized' = responseBean.getAmountAuthorized()},
			{'amountReceived' = responseBean.getAmountReceived()},
			{'amountCredited' = responseBean.getAmountCredited()},
			{'statusCode' = responseBean.getStatusCode()},
			{'providerToken' = responseBean.getProviderToken()},
			{'providerTransactionID' = responseBean.getProviderTransactionID()},
			{'securityCodeMatchFlag' = responseBean.getSecurityCodeMatchFlag()},
		]});
	}
	
	/**
	 * @test
	 * */
	public void function processCardView() {
		var requestBean = request.slatwallScope.getTransient('externalTransactionRequestBean');
		
		var accountPaymentMethod = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod('#variables.accountPaymentMethodID#');
		requestBean.setProviderToken(accountPaymentMethod.getProviderToken()); //Set Provider Token
		var responseBean = variables.paymentIntegrationCFC.getCardStatus(requestBean);
		writeDump(var = responseBean, top = 2);
	}
	
	/**
	 * @test
	 * */
	 public void function processCardUpdate() {
	 	
		var accountService = request.slatwallScope.getService("accountService");
		var accountPaymentMethod = request.slatwallScope.getBean('paymentService').getAccountPaymentMethod('#variables.accountPaymentMethodID#');
		
		var accountData = {
			firstName = "Account",
			lastName = "Delete",
			phoneNumber = "1234567890",
			createAuthenticationFlag = 0
		};

		// var account = entityNew("SlatwallAccount");

		// account = accountService.processAccount(account, accountData, 'create');
		// var accountHasErrors = account.hasErrors();
		
		var processContext = "cardStatus";
		
		//process will determine whether we need to inflate a process object or pass data directly
		var paymentMethod = accountService.process(accountPaymentMethod, accountData, processContext);
		writeDump(var = paymentMethod, top = 2); abort;
	 }
}