component extends="testbox.system.BaseSpec"{



	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('ServiceMock')) == 'ServiceMock'){
			//add basic hibachiService dependencies
			var hibachiDao = this.getHibachiDAOMock();
			var hibachiEventService = createMock('Slatwall.org.Hibachi.HibachiEventService');
			var hibachiCacheService = createMock('Slatwall.org.Hibachi.HibachiCacheService');
			hibachiCacheService.init();
			var hibachiUtilityService=createMock('Slatwall.org.Hibachi.HibachiUtilityService');

			var serviceName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('ServiceMock')+4);
			var ServiceMock = createMock('Slatwall.model.service.#serviceName#');

			ServiceMock.setHibachiDao(hibachiDao);
			ServiceMock.setHibachiEventService(hibachiEventService);
			ServiceMock.setHibachiCacheService(hibachiCacheService);
			ServiceMock.setHibachiUtilityService(hibachiUtilityService);

			return ServiceMock;
		}else if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('DAOMock')) == 'DAOMock'){

			var DAOName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('DAOMock'));
			var DAOMock = createMock('Slatwall.model.dao.#daoName#');

			return DAOMock;
		}else if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('TransientMock')) == 'TransientMock') {

			var transientName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('TransientMock')-3);
			var transientMock = createMock('Slatwall.model.transient.#transientName#');

			return transientMock;
		}
	}

	public any function getHibachiValidationServiceMock(){
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();
		var hibachiDAO = this.getHibachiDAOMock();

		var hibachiValidationServiceMock = createMock('Slatwall.org.Hibachi.HibachiValidationService');

		hibachiValidationServiceMock.sethibachiUtilityService(hibachiUtilityService);
		hibachiValidationServiceMock.sethibachiDAO(hibachiDAO);

		return hibachiValidationServiceMock;
	}

	public any function getTOTPAuthenticatorMock(){
		return createMock('Slatwall.org.Hibachi.marcins.TOTPAuthenticator');
	}

	public any function getPaymentServiceMock(){

		var paymentDAO = createMock('Slatwall.model.dao.PaymentDAO');
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
		var typeService = this.getTypeServiceMock();

		var accountDAO = this.getaccountDAOMock();
		//var permissionGroupDAO = this.getpermissionGroupDAOMock();
		var addressService = this.getaddressServiceMock();
		var emailService = this.getemailServiceMock();
		var eventRegistrationService = this.geteventRegistrationServiceMock();
		//var giftCardService = this.getgiftCardServiceMock();
		var hibachiAuditService = this.gethibachiAuditServiceMock();
		var loyaltyService = createMock('Slatwall.model.service.LoyaltyService');//this.getloyaltyServiceMock();
		
		var paymentService = this.getpaymentServiceMock();

		var priceGroupService = this.getpriceGroupServiceMock();
		var settingService = this.getsettingServiceMock();
		var siteService = this.getsiteServiceMock();
		//var totpAuthenticator = this.gettotpAuthenticatorMock();


		var accountServiceMock = onMissingMethod('getAccountServiceMock',{});

		accountServiceMock.setOrderService(orderService);
		accountServiceMock.setTypeService(typeService);

		accountServiceMock.setaccountDAO(accountDAO);
		//accountServiceMock.setpermissionGroupDAO(permissionGroupDAO);
		accountServiceMock.setaddressService(addressService);
		accountServiceMock.setemailService(emailService);
		accountServiceMock.seteventRegistrationService(eventRegistrationService);
		//accountServiceMock.setgiftCardService(giftCardService);
		accountServiceMock.sethibachiAuditService(hibachiAuditService);
		accountServiceMock.setloyaltyService(loyaltyService);
		accountServiceMock.setpaymentService(paymentService);
		accountServiceMock.setpriceGroupService(priceGroupService);
		accountServiceMock.setsettingService(settingService);
		accountServiceMock.setsiteService(siteService);
		//accountServiceMock.settotpAuthenticator(totpAuthenticator);

		return accountServiceMock;

	}

	public any function getLedgerAccountServiceMock() {
		return this.onMissingMethod('getLedgerAccountServiceMock',{});
	}

	public any function getSettingServiceMock(){
		var settingDAO = createMock('Slatwall.model.dao.SettingDAO');

		//var hibachiEventService = createMock('Slatwall.org.Hibachi.HibachiEventService');
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
		//var skuService = createMock('Slatwall.model.service.SkuService');


		var settingService = this.onMissingMethod('getSettingServiceMock',{});


		settingService.setsettingDAO(settingDAO);
		//settingService.sethibachiEventService(hibachiEventService);
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
		//settingService.setskuService(skuService);

		return settingService;
	}

	public any function getHibachiCollectionServiceMock(){
		return this.onMissingMethod('getHibachiCollectionServiceMock',{});
	}

	public any function getAttributeServiceMock(){
		var attributeDAO = createMock('Slatwall.model.dao.AttributeDAO');

		var attributeServiceMock = onMissingMethod('getAttributeServiceMock',{});

		attributeServiceMock.setattributeDAO(attributeDAO);

		return attributeServiceMock;
	}

	public any function getContentServiceMock(){
		var contentDAO = createMock('Slatwall.model.dao.ContentDAO');

		var hibachiDataService = this.getHibachiDataServiceMock(); //createMock('Slatwall.org.Hibachi.HibachiDataService');
		var settingService = this.getSettingServiceMock();//createMock('Slatwall.model.service.SettingService');
		var productService = createMock('Slatwall.model.service.ProductService');
		var skuService = createMock('Slatwall.model.service.SkuService');

		var hibachiDao = this.gethibachiDAOMock();//createMock('Slatwall.model.dao.HibachiDao');


		var contentService = onMissingMethod('getContentServiceMock',{});


		contentService.setcontentDAO(contentDAO);
		contentService.sethibachiDataService(hibachiDataService);
		contentService.setsettingService(settingService);
		contentService.setproductService(productService);
		contentService.setskuService(skuService);

		contentService.getHibachiDao().getHibachiAuditService().sethibachiDAO(hibachiDao);

		return contentService;
	}

	public any function getCurrencyServiceMock(){
		var currencyDAO = this.getCurrencyDAOMock();

		var currencyService = onMissingMethod('getCurrencyServiceMock',{});

		currencyService.setcurrencyDAO(currencyDAO);

		return currencyService;
	}

	public any function getHibachiServiceMock(){
		return this.onMissingMethod('getHibachiServiceMock',{});
	}

	public any function getHibachiUtilityServiceMock(){
		//var settingService = createMock('Slatwall.model.service.settingService');
		var settingService = this.getSettingServiceMock();
		var hibachiTagService = createMock('Slatwall.org.Hibachi.HibachiTagService');

		var hibachiUtilityService = onMissingMethod('getHibachiUtilityServiceMock',{});

		hibachiUtilityService.setsettingService(settingService);
		hibachiUtilityService.sethibachiTagService(hibachiTagService);

		return hibachiUtilityService;
	}

	public any function getHibachiYamlServiceMock(){
		var hibachiDAO = this.getHibachiDAOMock();

		var hibachiYamlServiceMock = createMock('Slatwall.org.Hibachi.HibachiYamlService');

		hibachiYamlServiceMock.sethibachiDAO(hibachiDAO);

		return hibachiYamlServiceMock;
	}

	public any function getImageServiceMock(){

		var hibachiTagService = createMock('Slatwall.org.Hibachi.HibachiTagService');
		var settingService = this.getSettingServiceMock();
		var skuService = createMock('Slatwall.model.service.SkuService');

		var imageService = onMissingMethod('getImageServiceMock',{});

		imageService.sethibachiTagService(hibachiTagService);
		imageService.setsettingService(settingService);
		imageService.setskuService(skuService);

		return imageService;
	}

	public any function getOrderDAOMock() {
		return this.onMissingMethod('getOrderDAOMock',{});
	}

	public any function getAccountDAOMock() {
		return this.onMissingMethod('getAccountDAOMock',{});
	}

	public any function getSettingDAOMock() {
		return this.onMissingMethod('getSettingDAOMock',{});
	}

	public any function getCurrencyDAOMock() {
		return this.onMissingMethod('getCurrencyDAOMock',{});
	}

	public any function getStockDAOMock() {
		return this.onMissingMethod('getStockDAOMock',{});
	}

	public any function getInventoryDAOMock() {
		return this.onMissingMethod('getInventoryDAOMock',{});
	}

	public any function getLocationDAOMock() {
		return this.onMissingMethod('getLocationDAOMock',{});
	}

	public any function getCommentDAOMock() {
		return this.onMissingMethod('getCommentDAOMock',{});
	}

	public any function getOptionDAOMock() {
		return this.onMissingMethod('getOptionDAOMock',{});
	}

	public any function getHibachiDAOMock() {
		var hibachiAuditService = createMock('Slatwall.org.Hibachi.HibachiAuditService');
		var hibachiDAO = createMock('Slatwall.org.Hibachi.HibachiDAO');
		hibachiDAO.setApplicationKey('Slatwall');
		hibachiAuditService.setHibachiDAO(hibachiDAO);

		var applicationKey = "Slatwall";
		var hibachiDAOMock = onMissingMethod('getHibachiDAOMock',{});

		hibachiDAOMock.setapplicationKey(applicationKey);
		hibachiDAOMock.sethibachiAuditService(hibachiAuditService);

		return hibachiDAOMock;
	}

	public any function getHibachiDataDAOMock() {
		return this.onMissingMethod('getHibachiDataDAOMock',{});
	}

	public any function getProductDAOMock() {
		return this.onMissingMethod('getProductDAOMock',{});
	}

	public any function getPriceGroupDAOMock() {
		return this.onMissingMethod('getPriceGroupDAOMock',{});
	}

	public any function getProductTypeDAOMock() {
		return this.onMissingMethod('getProductTypeDAOMock',{});
	}

	public any function getPromotionDAOMock() {
		return this.onMissingMethod('getPromotionDAOMock',{});
	}

	public any function getRoundingRuleDAOMock() {
		return this.onMissingMethod('getRoundingRuleDAOMock',{});
	}

	public any function getSkuDAOMock() {
		var hibachiCacheService = createMock('Slatwall.org.Hibachi.HibachiCacheService');
		hibachiCacheService.init();

		var skuDAOMock = this.onMissingMethod('getSkuDAOMock',{});

		skuDAOMock.sethibachiCacheService(hibachiCacheService);

		return skuDAOMock;
	}

	public any function getSubscriptionDAOMock() {
		return this.onMissingMethod('getSubscriptionDAOMock',{});
	}

	public any function getTypeDAOMock() {
		return this.onMissingMethod('getTypeDAOMock',{});
	}

	public any function getWorkflowDAOMock() {
		return this.onMissingMethod('getWorkflowDAOMock',{});
	}

	public any function getAddressServiceMock() {
		return this.onMissingMethod('getAddressServiceMock',{});
	}

	public any function getTemplateServiceMock() {
		return this.onMissingMethod('getTemplateServiceMock',{});
	}

	public any function getFulFillmentServiceMock() {
		return this.onMissingMethod('getFulfillmentServiceMock',{});
	}

	public any function getIntegrationServiceMock() {
		return this.onMissingMethod('getIntegrationServiceMock',{});
	}

	public any function getLocationServiceMock() {
		var locationDAO = this.getLocationDAOMock();
		var stockDAO = this.getStockDAOMock();

		var locationServiceMock = this.onMissingMethod('getLocationServiceMock',{});

		locationServiceMock.setLocationDAO(locationDAO);
		locationServiceMock.setStockDAO(stockDAO);

		return locationServiceMock;
	}

	public any function getEmailServiceMock() {
		var templateService = this.getTemplateServiceMock();
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();

		var emailServiceMock = this.onMissingMethod('getEmailServiceMock',{});

		emailServiceMock.gettemplateService(templateService);
		emailServiceMock.gethibachiUtilityService(hibachiUtilityService);

		return emailServiceMock;
	}

	public any function getHibachiAuditServiceMock() {
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();

		var hibachiAuditServiceMock = this.onMissingMethod('getHibachiAuditServiceMock',{});

		hibachiAuditServiceMock.sethibachiUtilityService(hibachiUtilityService);

		return hibachiAuditServiceMock;
	}

	public any function getHibachiDataServiceMock() {
		var hibachiDataDAO = this.getHibachiDAOMock();

		var hibachiDataServiceMock = this.onMissingMethod('getHibachiDataServiceMock',{});

		hibachiDataServiceMock.sethibachiDataDAO(hibachiDataDAO);

		return hibachiDataServiceMock;
	}

	public any function getTypeServiceMock() {
		var typeDAO = this.getTypeDAOMock();

		var typeServiceMock = this.onMissingMethod('getTypeServiceMock',{});

		typeServiceMock.settypeDAO(typeDAO);

		return typeServiceMock;
	}

	public any function getEventRegistrationServiceMock() {
		var commentService = createMock('Slatwall.model.service.CommentService');
		var orderService   = createMock('Slatwall.model.service.OrderService');
		var settingService = this.getSettingServiceMock();
		var typeService = this.getTypeServiceMock();

		var eventRegistrationServiceMock = this.onMissingMethod('getEventRegistrationServiceMock',{});

		eventRegistrationServiceMock.setcommentService(commentService);
		eventRegistrationServiceMock.setorderService(orderService);
		eventRegistrationServiceMock.setsettingService(settingService);
		eventRegistrationServiceMock.settypeService(typeService);

		return eventRegistrationServiceMock;
	}

	public any function getSubscriptionServiceMock() {
		var orderDAO = this.getOrderDAOMock();
		var subscriptionDAO = this.getSubscriptionDAOMock();
		var emailService = this.getEmailServiceMock();
		var orderService = createMock('Slatwall.model.service.OrderService');
		var paymentService = this.getPaymentServiceMock();
		var skuService = createMock('Slatwall.model.service.SkuService');

		var subscriptionServiceMock = this.onMissingMethod('getSubscriptionServiceMock',{});

		subscriptionServiceMock.setorderDAO(orderDAO);
		subscriptionServiceMock.setsubscriptionDAO(subscriptionDAO);
		subscriptionServiceMock.setemailService(emailService);
		subscriptionServiceMock.setorderService(orderService);
		subscriptionServiceMock.setpaymentService(paymentService);
		subscriptionServiceMock.setskuService(skuService);

		return subscriptionServiceMock;
	}

	public any function getCommentServiceMock() {
		var commentDAO = this.getCommentDAOMock();
		var orderService = createMock('Slatwall.model.service.OrderService');

		var commentServiceMock = this.onMissingMethod('getCommentServiceMock',{});

		commentServiceMock.setcommentDAO(commentDAO);
		commentServiceMock.setorderService(orderService);

		return commentServiceMock;
	}

	public any function getStockServiceMock() {
		var commentService = this.getCommentServiceMock();
		var locationService= this.getLocationServiceMock();
		var skuService = createMock('Slatwall.model.service.SkuService');
		var settingService = this.getSettingServiceMock();
		var typeService = this.getTypeServiceMock();

		var stockDAO = this.getStockDAOMock();

		var stockServiceMock = this.onMissingMethod('getStockServiceMock',{});

		stockServiceMock.setcommentService(commentService);
		stockServiceMock.setlocationService(locationService);
		stockServiceMock.setskuService(skuService);
		stockServiceMock.setsettingService(settingService);
		stockServiceMock.settypeService(typeService);
		stockServiceMock.setstockDAO(stockDAO);

		return stockServiceMock;
	}

	public any function getProductServiceMock() {
		var productDAO = this.getProductDAOMock();
		var skuDAO = this.getSkuDAOMock();
		var productTypeDAO = this.getproductTypeDAOMock();
		var hibachiDataService = this.getHibachiDataServiceMock();
		var contentService = this.getcontentServiceMock();
		var eventRegistrationService = this.getEventRegistrationServiceMock();
		var imageService = createMock('Slatwall.model.service.ImageService');
		var locationService = this.getLocationServiceMock();
		var optionService = createMock('Slatwall.model.service.OptionService');
		var productScheduleService = createMock('Slatwall.model.service.ProductScheduleService');
		var settingService = this.getSettingServiceMock();
		var skuService = createMock('Slatwall.model.service.SkuService');
		var subscriptionService = this.getSubscriptionServiceMock();
		var typeService = this.getTypeServiceMock();
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();

		var productServiceMock = this.onMissingMethod('getProductServiceMock',{});

		productServiceMock.setproductDAO(productDAO);
		productServiceMock.setskuDAO(skuDAO);
		productServiceMock.setproductTypeDAO(productTypeDAO);
		productServiceMock.sethibachiDataService(hibachiDataService);
		productServiceMock.setcontentService(contentService);
		productServiceMock.seteventRegistrationService(eventRegistrationService);
		productServiceMock.setimageService(imageService);
		productServiceMock.setlocationService(locationService);
		productServiceMock.setoptionService(optionService);
		productServiceMock.setproductScheduleService(productScheduleService);
		productServiceMock.setsettingService(settingService);
		productServiceMock.setskuService(skuService);
		productServiceMock.setsubscriptionService(subscriptionService);
		productServiceMock.settypeService(typeService);
		productServiceMock.sethibachiUtilityService(hibachiUtilityService);

		return productServiceMock;
	}

	public any function getSkuServiceMock() {
		var skuDAO = this.getSkuDAOMock();
		var locationService = this.getLocationServiceMock();
		var optionService = createMock('Slatwall.model.service.OptionService');
		var productService = this.getProductServiceMock();
		var subscriptionService = this.getSubscriptionServiceMock();
		var contentService = this.getContentServiceMock();
		var stockService = this.getStockServiceMock();
		var settingService = this.getSettingServiceMock();
		var typeService = this.getTypeServiceMock();

		var hibachiDAO = this.getHibachiDAOMock();

		var skuServiceMock = this.onMissingMethod('getSkuServiceMock',{});

		skuServiceMock.setskuDAO(skuDAO);
		skuServiceMock.setlocationService(locationService);
		skuServiceMock.setoptionService(optionService);
		skuServiceMock.setproductService(productService);
		skuServiceMock.setsubscriptionService(subscriptionService);
		skuServiceMock.setcontentService(contentService);
		skuServiceMock.setstockService(stockService);
		skuServiceMock.setsettingService(settingService);
		skuServiceMock.settypeService(typeService);

		productService.getHibachiDao().getHibachiAuditService().sethibachiDAO(hibachiDao);

		return skuServiceMock;
	}

	public any function getOptionServiceMock() {
		var optionDAO = this.getOptionDAOMock();
		var productService = this.getProductServiceMock();

		var optionServiceMock = this.onMissingMethod('getOptionServiceMock',{});

		optionServiceMock.setoptionDAO(optionDAO);
		optionServiceMock.setproductService(productService);

		return optionServiceMock;
	}

	public any function getPriceGroupServiceMock() {
		var priceGroupDAO = this.getpriceGroupDAOMock();
		var skuService = this.getskuServiceMock();
		var productService = this.getproductServiceMock();

		var priceGroupServiceMock = this.onMissingMethod('getPriceGroupServiceMock',{});

		priceGroupServiceMock.setpriceGroupDAO(priceGroupDAO);
		priceGroupServiceMock.setskuService(skuService);
		priceGroupServiceMock.setproductService(productService);

		return priceGroupServiceMock;
	}

	public any function getSiteServiceMock() {
		return this.onMissingMethod('getSiteServiceMock',{});
	}

	public any function getHibachiAuthenticationServiceMock() {
		var integrationService = this.getIntegrationServiceMock();

		var hibachiAuthenticationServiceMock = this.onMissingMethod('getHibachiAuthenticationServiceMock',{});

		hibachiAuthenticationServiceMock.setIntegrationService(integrationService);

		return hibachiAuthenticationServiceMock;
	}

	public any function getRoundingRuleServiceMock() {
		var roundingRuleDAO = this.getRoundingRuleDAOMock();

		var roundingRuleServiceMock = this.onMissingMethod('getRoundingRuleServiceMock',{});

		roundingRuleServiceMock.setroundingRuleDAO(roundingRuleDAO);

		return roundingRuleServiceMock;
	}

	public any function getPromotionServiceMock() {
		var promotionDAO = this.getPromotionDAOMock();
		var addressService = this.getAddressServiceMock();
		var roundingRuleService = this.getRoundingRuleServiceMock();
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();

		var promotionServiceMock = this.onMissingMethod('getPromotionServiceMock',{});

		promotionServiceMock.setpromotionDAO(promotionDAO);
		promotionServiceMock.setaddressService(addressService);
		promotionServiceMock.setroundingRuleService(roundingRuleService);
		promotionServiceMock.sethibachiUtilityService(hibachiUtilityService);

		return promotionServiceMock;
	}

	public any function getShippingServiceMock() {
		var addressService = this.getAddressServiceMock();
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();
		var integrationService = this.getIntegrationServiceMock();
		var orderService = createMock('Slatwall.model.service.OrderService');
		var settingService = this.getSettingServiceMock();

		var shippingServiceMock = this.onMissingMethod('getShippingServiceMock',{});

		shippingServiceMock.setaddressService(addressService);
		shippingServiceMock.sethibachiUtilityService(hibachiUtilityService);
		shippingServiceMock.setintegrationService(integrationService);
		shippingServiceMock.setorderService(orderService);
		shippingServiceMock.setsettingService(settingService);

		return shippingServiceMock;
	}

	public any function getTaxServiceMock() {
		var addressService = this.getAddressServiceMock();
		var hibachiValidationService = this.getHibachiValidationServiceMock();
		var integrationService = this.getIntegrationServiceMock();
		var settingService = this.getSettingServiceMock();

		var taxServiceMock = this.onMissingMethod('getTaxServiceMock',{});

		taxServiceMock.setaddressService(addressService);
		taxServiceMock.sethibachiValidationService(hibachiValidationService);
		taxServiceMock.setintegrationService(integrationService);
		taxServiceMock.setsettingService(settingService);

		return taxServiceMock;

	}

	public any function getOrderServiceMock() {
		var orderDAO = this.getOrderDAOMock();
		var accountService = this.getAccountServiceMock();//createMock('Slatwall.model.service.AccountService');
		var addressService = this.getAddressServiceMock();
		var commentService = this.getCommentServiceMock();
		var emailService = this.getEmailServiceMock();
		var eventRegistrationService = this.getEventRegistrationServiceMock();
		var fulfillmentService = this.getFulfillmentServiceMock();
		var giftCardService = this.getGiftCardServiceMock();
		var hibachiUtilityService = this.getHibachiUtilityServiceMock();
		var hibachiAuthenticationService = this.getHibachiAuthenticationServiceMock();
		var integrationService = this.getIntegrationServiceMock();
		var locationService = this.getLocationServiceMock();
		var paymentService = this.getPaymentServiceMock();
		var priceGroupService = this.getPriceGroupServiceMock();
		var promotionService = this.getPromotionServiceMock();
		var settingService = this.getSettingServiceMock();
		var shippingService = this.getShippingServiceMock();
		var skuService = this.getSkuServiceMock();
		var stockService= this.getStockServiceMock();
		var subscriptionService = this.getSubscriptionServiceMock();
		var taxService = this.getTaxServiceMock();
		var typeService = this.getTypeServiceMock();
		//var hibachiUtilityService = this.getHibachiUtilityServiceMock();

		var orderServiceMock = this.onMissingMethod('getOrderServiceMock',{});

		orderServiceMock.setorderDAO(orderDAO);
		orderServiceMock.setaccountService(accountService);
		orderServiceMock.setaddressService(addressService);
		orderServiceMock.setcommentService(commentService);
		orderServiceMock.setemailService(emailService);
		orderServiceMock.seteventRegistrationService(eventRegistrationService);
		orderServiceMock.setfulfillmentService(fulfillmentService);
		orderServiceMock.setgiftCardService(giftCardService);
		orderServiceMock.sethibachiUtilityService(hibachiUtilityService);
		orderServiceMock.sethibachiAuthenticationService(hibachiAuthenticationService);
		orderServiceMock.setintegrationService(integrationService);
		orderServiceMock.setlocationService(locationService);
		orderServiceMock.setpaymentService(paymentService);
		orderServiceMock.setpriceGroupService(priceGroupService);
		orderServiceMock.setpromotionService(promotionService);
		orderServiceMock.setsettingService(settingService);
		orderServiceMock.setshippingService(shippingService);
		orderServiceMock.setskuService(skuService);
		orderServiceMock.setstockService(stockService);
		orderServiceMock.setsubscriptionService(subscriptionService);
		orderServiceMock.settaxService(taxService);
		orderServiceMock.settypeService(typeService);
		//orderServiceMock.sethibachiUtilityService(hibachiUtilityService);

		return orderServiceMock;
	}

	public any function getEmailBounceServiceMock() {
		var orderService = this.getOrderServiceMock();

		var emailBounceServiceMock = this.onMissingMethod('getEmailBounceServiceMock',{});

		emailBounceServiceMock.setorderService(orderService);

		return emailBounceServiceMock;
	}

	public any function getGiftCardServiceMock() {
		return this.onMissingMethod('getGiftCardServiceMock',{});
	}

	public any function getHibachiCacheServiceMock() {
		var hibachiCacheServiceMock = createMock('Slatwall.org.Hibachi.HibachiCacheService');
		hibachiCacheServiceMock.init();

		return hibachiCacheServiceMock;
	}

	public any function getInventoryServiceMock() {
		var inventoryDAO = this.getInventoryDAOMock();
		var skuService = this.getSkuServiceMock();

		var inventoryServiceMock = this.onMissingMethod('getInventoryServiceMock',{});

		inventoryServiceMock.setinventoryDAO(inventoryDAO);
		inventoryServiceMock.setskuService(skuService);

		return inventoryServiceMock;
	}

	public any function getHibachiJWTServiceMock() {
		return this.onMissingMethod('getHibachiJWTServiceMock',{});
	}

	public any function getUpdateServiceMock() {

		updateServiceMock = this.onMissingMethod('getUpdateServiceMock',{});
		updateServiceMock.init();

		return updateServiceMock;
	}

	public any function getHibachiRBServiceMock() {
		var integrationService = this.getIntegrationServiceMock();

		var hibachiRBServiceMock = this.onMissingMethod('getHibachiRBServiceMock',{});

		hibachiRBServiceMock.setintegrationService(integrationService);

		return hibachiRBServiceMock;
	}

	public any function getWorkflowServiceMock() {
		var workflowDAO = this.getWorkflowDAOMock();
		var hibachiValidationService = this.getHibachiValidationServiceMock();

		var workflowServiceMock = this.onMissingMethod('getWorkflowServiceMock',{});

		workflowServiceMock.setworkflowDAO(workflowDAO);
		workflowServiceMock.sethibachiValidationService(hibachiValidationService);

		return workflowServiceMock;
	}

	public any function getHibachiEntityParserTransientMock() {

		var hibachiEntityParserMock = this.onMissingMethod('getHibachiEntityParserTransientMock',{});
		hibachiEntityParserMock.init();

		return  hibachiEntityParserMock;
	}

}
