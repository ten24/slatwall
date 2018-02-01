
component extends="testbox.system.BaseSpec"{


	
	public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments) {
		if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('ServiceMock')) == 'ServiceMock'){
			var hibachiDao = createMock('Slatwall.model.dao.HibachiDao');
			
			var serviceName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('ServiceMock')+4);
			var ServiceMock = createMock('Slatwall.model.service.#serviceName#');
			
			ServiceMock.setHibachiDao(hibachiDao);
			
			return ServiceMock;
		}else if(left(arguments.missingMethodName,3)=='get' && right(arguments.missingMethodName,len('DAOMock')) == 'DAOMock'){
			
			var DAOName = mid(arguments.missingMethodName,4,len(arguments.missingMethodName)-len('DAOMock'));
			var DAOMock = createMock('Slatwall.model.dao.#daoName#');
			
			return DAOMock;
		}
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
