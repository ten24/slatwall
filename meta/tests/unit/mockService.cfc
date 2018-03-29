
component extends="testbox.system.BaseSpec"{


	
	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('ServiceMock')) == 'ServiceMock'){
			//add basic hibachiService dependencies
			var hibachiDao = createMock('Slatwall.model.dao.HibachiDAO');
			var hibachiEventService = createMock('Slatwall.org.Hibachi.HibachiEventService');
			
			var serviceName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('ServiceMock')+4);
			var ServiceMock = createMock('Slatwall.model.service.#serviceName#');
			
			ServiceMock.setHibachiDao(hibachiDao);
			ServiceMock.setHibachiEventService(hibachiEventService);
			
			return ServiceMock;
		}else if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('DAOMock')) == 'DAOMock'){
			
			var DAOName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('DAOMock'));
			var DAOMock = createMock('Slatwall.model.dao.#daoName#');
			
			return DAOMock;
		}
	}
	
	public any function getHibachiValidationServiceMock(){
		var hibachiValidationServiceMock = createMock('Slatwall.org.Hibachi.HibachiValidationService');
		
		return hibachiValidationServiceMock;
	}
	
	public any function getTOTPAuthenticatorMock(){
		return createMock('Slatwall.org.Hibachi.marcins.TOTPAuthenticator');
	}
	
	public any function getPaymentServiceMock(){
		
		var paymentDAO = createMock('Slatwall.model.dao.paymentDAO');
		var currencyService = createMock('Slatwall.model.service.CurrencyService');
		var integrationService = createMock('Slatwall.model.service.IntegrationService');
		var settingService = createMock('Slatwall.model.service.SettingService');
	
		var paymentServiceMock = onMissingMethod('getPaymentServiceMock',{});
	
		paymentServiceMock.setpaymentDAO(paymentDAO);
		paymentServiceMock.setcurrencyService(currencyService);
		paymentServiceMock.setintegrationService(integrationService);
		paymentServiceMock.setsettingService(settingService);
	
		return paymentServiceMock;
	}
	
	public any function getAccountServiceMock(){
		
		var orderService = createMock('Slatwall.model.service.OrderService');
		var typeService = createMock('Slatwall.model.service.TypeService');
		
		var accountDAO = this.getaccountDAOMock();
		var permissionGroupDAO = this.getpermissionGroupDAOMock();
		var addressService = this.getaddressServiceMock();
		var emailService = this.getemailServiceMock();
		var eventRegistrationService = this.geteventRegistrationServiceMock();
		var giftCardService = this.getgiftCardServiceMock();
		var hibachiAuditService = this.gethibachiAuditServiceMock();
		var loyaltyService = this.getloyaltyServiceMock();
		var paymentService = this.getpaymentServiceMock();
		
		var priceGroupService = this.getpriceGroupServiceMock();
		var settingService = this.getsettingServiceMock();
		var siteService = this.getsiteServiceMock();
		var totpAuthenticator = this.gettotpAuthenticatorMock();
		
		
		var accountServiceMock = onMissingMethod('getAccountServiceMock',{});
		
		accountServiceMock.setOrderService(orderService);
		accountServiceMock.setTypeService(typeService);
		 
		accountServiceMock.setaccountDAO(accountDAO);
		accountServiceMock.setpermissionGroupDAO(permissionGroupDAO);
		accountServiceMock.setaddressService(addressService);
		accountServiceMock.setemailService(emailService);
		accountServiceMock.seteventRegistrationService(eventRegistrationService);
		accountServiceMock.setgiftCardService(giftCardService);
		accountServiceMock.sethibachiAuditService(hibachiAuditService);
		accountServiceMock.setloyaltyService(loyaltyService);
		accountServiceMock.setpaymentService(paymentService);
		accountServiceMock.setpriceGroupService(priceGroupService);
		accountServiceMock.setsettingService(settingService);
		accountServiceMock.setsiteService(siteService);
		accountServiceMock.settotpAuthenticator(totpAuthenticator);
		
		return accountServiceMock;
	
	}
	

	public any function getSettingServiceMock(){
		var settingDAO = createMock('Slatwall.model.dao.SettingDAO');
		
		var hibachiEventService = createMock('Slatwall.org.Hibachi.HibachiEventService');
		var contentService = createMock('Slatwall.model.service.ContentService');
		var currencyService = this.getCurrencyServiceMock();
		var emailService = createMock('Slatwall.model.service.EmailService');
		var fulfillmentService = this.getFulfillmentServiceMock();
		var integrationService = createMock('Slatwall.model.service.IntegrationService');
		var ledgerAccountService = this.getLedgerAccountServiceMock();
		var locationService = createMock('Slatwall.model.service.LocationService');
		var measurementService = createMock('Slatwall.model.service.MeasurementService');
		var paymentService = this.getPaymentServiceMock();
		var siteService = createMock('Slatwall.model.service.SiteService');
		var taskService = createMock('Slatwall.model.service.TaskService');
		var taxService = createMock('Slatwall.model.service.TaxService');
		var typeService = createMock('Slatwall.model.service.TypeService');
		var skuService = createMock('Slatwall.model.service.SkuService');
		
		
		var settingService = onMissingMethod('getSettingServiceMock',{});
		
		
		settingService.setsettingDAO(settingDAO);
		settingService.sethibachiEventService(hibachiEventService);
		settingService.setcontentService(contentService);
		settingService.setcurrencyService(currencyService);
		settingService.setemailService(emailService);
		settingService.setfulfillmentService(fulfillmentService);
		settingService.setintegrationService(integrationService);
		settingService.setledgerAccountService(ledgerAccountService);
		settingService.setlocationService(locationService);
		settingService.setmeasurementService(measurementService);
		settingService.setpaymentService(paymentService);
		settingService.setsiteService(siteService);
		settingService.settaskService(taskService);
		settingService.settaxService(taxService);
		settingService.settypeService(typeService);
		settingService.setskuService(skuService);
		
		return settingService;
	}
	
	

}
