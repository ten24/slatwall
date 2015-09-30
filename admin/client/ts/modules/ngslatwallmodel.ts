
			/// <reference path="../../../../client/typings/tsd.d.ts" />
			/// <reference path="../../../../client/typings/slatwallTypeScript.d.ts" />
			angular.module('ngSlatwallModel',['ngSlatwall']).config(['$provide',function ($provide
			 ) {
	    	
	    	$provide.decorator( '$slatwall', [ 
		    	"$delegate", 
		    	'$http',
	            '$timeout',
	            '$log',
	            '$rootScope',
	            '$location',
	            '$anchorScroll',
	            '$q',
	            'utilityService', 
	            'formService', 
	            function( $delegate,
		            $http,
		            $timeout,
		            $log,
		            $rootScope,
		            $location,
		            $anchorScroll,
		            $q,
		            utilityService, 
		            formService 
		        )
	            {
	            
	            var _deferred = {};
			    var _config = {
			        dateFormat : 'MM/DD/YYYY',
			        timeFormat : 'HH:MM',
			        rbLocale : '',
			        baseURL : '/',
			        applicationKey : 'Slatwall',
			        debugFlag : true,
			        instantiationKey : '84552B2D-A049-4460-55F23F30FE7B26AD'
			    };
			    
			    if(slatwallAngular.slatwallConfig){
			        angular.extend(_config, slatwallAngular.slatwallConfig);
			    }	
			    
			    
	            	
                var _jsEntities = {};
                var entities = {};
                var validations = {};
                var defaultValues = {};
                
                	entities['Print'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"printContent":{"ormtype":"string","name":"printContent"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"printID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"printID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"logPrintFlag":{"persistent":false,"name":"logPrintFlag"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Print'].className = 'Print';
                	validations['Print'] = {"properties":{}};
                	defaultValues['Print'] = {
                	printID:'',
										printContent:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['Audit'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"auditDateTime":{"ormtype":"timestamp","name":"auditDateTime"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditArchiveStartDateTime":{"ormtype":"timestamp","name":"auditArchiveStartDateTime"},"relatedEntity":{"persistent":false,"type":"any","name":"relatedEntity"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"auditType":{"ormtype":"string","hb_formattype":"rbKey","name":"auditType"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"sessionAccountFullName":{"ormtype":"string","name":"sessionAccountFullName"},"baseObject":{"ormtype":"string","name":"baseObject"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"auditArchiveEndDateTime":{"ormtype":"timestamp","name":"auditArchiveEndDateTime"},"sessionIPAddress":{"ormtype":"string","name":"sessionIPAddress"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"auditArchiveCreatedDateTime":{"ormtype":"timestamp","name":"auditArchiveCreatedDateTime"},"sessionAccountID":{"length":32,"ormtype":"string","name":"sessionAccountID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"changeDetails":{"persistent":false,"type":"any","name":"changeDetails"},"sessionAccountEmailAddress":{"ormtype":"string","name":"sessionAccountEmailAddress"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"data":{"length":8000,"ormtype":"string","name":"data"},"baseID":{"ormtype":"string","name":"baseID"},"auditID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"auditID"},"archiveProcessedFlag":{"persistent":false,"type":"boolean","name":"archiveProcessedFlag"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"title":{"length":1000,"ormtype":"string","name":"title"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Audit'].className = 'Audit';
                	validations['Audit'] = {"properties":{"auditType":[{"contexts":"save","inList":"create,update,delete,rollback,archive,login,loginInvalid,logout"},{"contexts":"rollback","inList":"update,rollback,archive"}],"archiveProcessedFlag":[{"contexts":"delete","eq":true}]}};
                	defaultValues['Audit'] = {
                	auditID:'',
										auditType:null,
									auditDateTime:'1443623988583',
										auditArchiveStartDateTime:null,
									auditArchiveEndDateTime:null,
									auditArchiveCreatedDateTime:null,
									baseObject:null,
									baseID:null,
									data:null,
									title:null,
									sessionIPAddress:'127.0.0.1',
										sessionAccountID:null,
									sessionAccountEmailAddress:null,
									sessionAccountFullName:null,
									
						z:''
	                };
                
                	entities['App'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"appName":{"ormtype":"string","name":"appName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"appCode":{"unique":true,"ormtype":"string","index":"PI_APPCODE","name":"appCode"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"sites":{"cfc":"Site","fieldtype":"one-to-many","singularname":"site","cascade":"all-delete-orphan","fkcolumn":"appID","type":"array","inverse":true,"name":"sites"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"appRootPath":{"ormtype":"string","name":"appRootPath"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"appPath":{"persistent":false,"name":"appPath"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"appID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"appID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"hint":"Only used when integrated with a remote system","ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"integration":{"cfc":"Integration","fieldtype":"many-to-one","fkcolumn":"integrationID","hb_populateenabled":"public","name":"integration"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['App'].className = 'App';
                	validations['App'] = {"properties":{"appCode":[{"contexts":"save","required":true}],"integration":[{"contexts":"save","required":true}],"appName":[{"contexts":"save","required":true}]}};
                	defaultValues['App'] = {
                	appID:'',
										appName:null,
									appCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['EventTrigger'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"printTemplate":{"cfc":"PrintTemplate","fieldtype":"many-to-one","fkcolumn":"printTemplateID","hb_optionsnullrbkey":"define.select","name":"printTemplate"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"emailTemplate":{"cfc":"EmailTemplate","fieldtype":"many-to-one","fkcolumn":"emailTemplateID","hb_optionsnullrbkey":"define.select","name":"emailTemplate"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"eventName":{"hb_formfieldtype":"select","ormtype":"string","name":"eventName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"eventTriggerTypeOptions":{"persistent":false,"name":"eventTriggerTypeOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"eventTriggerObject":{"hb_formfieldtype":"select","ormtype":"string","name":"eventTriggerObject"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"eventTriggerType":{"hb_formfieldtype":"select","ormtype":"string","name":"eventTriggerType"},"eventTriggerID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"eventTriggerID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"eventTriggerObjectOptions":{"persistent":false,"name":"eventTriggerObjectOptions"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"eventTriggerName":{"ormtype":"string","name":"eventTriggerName"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"eventNameOptions":{"persistent":false,"name":"eventNameOptions"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['EventTrigger'].className = 'EventTrigger';
                	validations['EventTrigger'] = {"properties":{"eventTriggerObjectType":[{"contexts":"save","required":true}],"eventTriggerName":[{"contexts":"save","required":true}],"eventName":[{"contexts":"save","conditions":"notNew","required":true}],"eventTriggerType":[{"contexts":"save","required":true}]},"conditions":{"notNew":{"newFlag":{"eq":false}}}};
                	defaultValues['EventTrigger'] = {
                	eventTriggerID:'',
										eventTriggerName:null,
									eventTriggerType:null,
									eventTriggerObject:null,
									eventName:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountEmailAddress'] = {"primaryEmailAddressNotInUseFlag":{"persistent":false,"name":"primaryEmailAddressNotInUseFlag"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"verifiedFlag":{"ormtype":"boolean","hb_populateenabled":false,"name":"verifiedFlag"},"emailAddress":{"ormtype":"string","hb_formattype":"email","hb_populateenabled":"public","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"primaryFlag":{"persistent":false,"name":"primaryFlag"},"accountEmailAddressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountEmailAddressID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"accountEmailType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accountEmailType","fkcolumn":"accountEmailTypeID","hb_optionsnullrbkey":"define.select","hb_populateenabled":"public","name":"accountEmailType"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"verificationCode":{"ormtype":"string","hb_populateenabled":false,"name":"verificationCode"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountEmailAddress'].className = 'AccountEmailAddress';
                	validations['AccountEmailAddress'] = {"properties":{"emailAddress":[{"contexts":"save","dataType":"email","required":true},{"contexts":"save","conditions":"requiresNotInUse","method":"getPrimaryEmailAddressNotInUseFlag"}],"primaryFlag":[{"contexts":"delete","eq":false}]},"conditions":{"requiresNotInUse":{"primaryFlag":{"eq":true},"account.slatwallAuthenticationExistsFlag":{"eq":true}}}};
                	defaultValues['AccountEmailAddress'] = {
                	accountEmailAddressID:'',
										emailAddress:null,
									verifiedFlag:0,
									verificationCode:'2c04d9070dda028caa489a084dd7652d',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockHold'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"stockHoldID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockHoldID"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","name":"stock"},"stockHoldExpirationDateTime":{"ormtype":"timestamp","name":"stockHoldExpirationDateTime"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockHold'].className = 'StockHold';
                	validations['StockHold'] = {"properties":{}};
                	defaultValues['StockHold'] = {
                	stockHoldID:'',
										stockHoldExpirationDateTime:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['TaxCategoryRate'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"taxCategoryRateCode":{"ormtype":"string","index":"PI_TAXCATEGORYRATECODE","name":"taxCategoryRateCode"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"taxCategoryRateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taxCategoryRateID"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"addressZone":{"cfc":"AddressZone","fieldtype":"many-to-one","hb_nullrbkey":"define.all","fkcolumn":"addressZoneID","hb_optionsnullrbkey":"define.all","name":"addressZone"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"taxIntegration":{"cfc":"Integration","fieldtype":"many-to-one","fkcolumn":"taxIntegrationID","name":"taxIntegration"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"taxCategory":{"cfc":"TaxCategory","fieldtype":"many-to-one","fkcolumn":"taxCategoryID","name":"taxCategory"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taxRate":{"ormtype":"float","hb_formattype":"percentage","name":"taxRate"},"appliedTaxes":{"cfc":"TaxApplied","fieldtype":"one-to-many","lazy":"extra","singularname":"appliedTax","cascade":"all","fkcolumn":"taxCategoryRateID","inverse":true,"name":"appliedTaxes"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"taxLiabilityAppliedToItemFlag":{"ormtype":"boolean","default":true,"name":"taxLiabilityAppliedToItemFlag"},"taxAddressLookup":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"taxAddressLookup"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['TaxCategoryRate'].className = 'TaxCategoryRate';
                	validations['TaxCategoryRate'] = {"properties":{"taxCategoryRateCode":[{"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$","required":true}],"taxRate":[{"contexts":"save","dataType":"numeric"},{"contexts":"save","conditions":"noIntegration","required":true}],"appliedTaxes":[{"contexts":"delete","maxCollection":0}]},"conditions":{"noIntegration":{"taxIntegration":{"null":true}}}};
                	defaultValues['TaxCategoryRate'] = {
                	taxCategoryRateID:'',
										taxRate:null,
									taxAddressLookup:'shipping_billing',
										taxCategoryRateCode:null,
									taxLiabilityAppliedToItemFlag:true,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['EmailTemplate'] = {"emailTemplateName":{"ormtype":"string","name":"emailTemplateName"},"eventTriggers":{"cfc":"EventTrigger","fieldtype":"one-to-many","lazy":"extra","singularname":"eventTrigger","cascade":"all","fkcolumn":"emailTemplateID","inverse":true,"name":"eventTriggers"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"emailBodyText":{"length":4000,"ormtype":"string","name":"emailBodyText"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"emailTemplateFile":{"hb_formfieldtype":"select","ormtype":"string","name":"emailTemplateFile"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"emailTemplateObjectOptions":{"persistent":false,"name":"emailTemplateObjectOptions"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"emailTemplateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"emailTemplateID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"emailTemplateObject":{"hb_formfieldtype":"select","ormtype":"string","name":"emailTemplateObject"},"validations":{"persistent":false,"type":"struct","name":"validations"},"emailTemplateFileOptions":{"persistent":false,"name":"emailTemplateFileOptions"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"logEmailFlag":{"ormtype":"boolean","default":false,"name":"logEmailFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"emailBodyHTML":{"length":4000,"ormtype":"string","name":"emailBodyHTML"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['EmailTemplate'].className = 'EmailTemplate';
                	validations['EmailTemplate'] = {"properties":{"emailTemplateName":[{"contexts":"save","required":true}],"eventTriggers":[{"contexts":"delete","maxCollection":0}],"emails":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['EmailTemplate'] = {
                	emailTemplateID:'',
										emailTemplateName:null,
									emailTemplateObject:null,
									emailTemplateFile:null,
									emailBodyHTML:'',
										emailBodyText:'',
										logEmailFlag:false,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountLoyaltyTransaction'] = {"accountLoyalty":{"cfc":"AccountLoyalty","fieldtype":"many-to-one","fkcolumn":"accountLoyaltyID","name":"accountLoyalty"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"pointsOut":{"ormtype":"integer","name":"pointsOut"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"redemptionType":{"ormtype":"string","name":"redemptionType"},"loyaltyAccruement":{"cfc":"LoyaltyAccruement","fieldtype":"many-to-one","fkcolumn":"loyaltyAccruementID","name":"loyaltyAccruement"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"accountLoyaltyTransactionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountLoyaltyTransactionID"},"loyaltyRedemption":{"cfc":"LoyaltyRedemption","fieldtype":"many-to-one","fkcolumn":"loyaltyRedemptionID","name":"loyaltyRedemption"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"accruementType":{"ormtype":"string","name":"accruementType"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"pointsIn":{"ormtype":"integer","name":"pointsIn"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"expirationDateTime":{"ormtype":"timestamp","name":"expirationDateTime"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountLoyaltyTransaction'].className = 'AccountLoyaltyTransaction';
                	validations['AccountLoyaltyTransaction'] = {"properties":{}};
                	defaultValues['AccountLoyaltyTransaction'] = {
                	accountLoyaltyTransactionID:'',
										accruementType:null,
									redemptionType:null,
									pointsIn:null,
									pointsOut:null,
									expirationDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountAddress'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accountAddressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountAddressID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"accountAddressName":{"hint":"Nickname for this account Address","ormtype":"string","hb_populateenabled":"public","name":"accountAddressName"},"address":{"hb_populatevalidationcontext":"full","cfc":"Address","fieldtype":"many-to-one","cascade":"all","fkcolumn":"addressID","hb_populateenabled":"public","name":"address"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"accountAddressID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountAddress'].className = 'AccountAddress';
                	validations['AccountAddress'] = {"properties":{"account":[{"contexts":"save","required":true}]},"populatedPropertyValidation":{"address":[{"validate":"full"}]}};
                	defaultValues['AccountAddress'] = {
                	accountAddressID:'',
										accountAddressName:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Loyalty'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","fieldtype":"one-to-many","singularname":"loyaltyRedemption","cascade":"all-delete-orphan","fkcolumn":"loyaltyID","type":"array","inverse":true,"name":"loyaltyRedemptions"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"loyaltyID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"loyaltyID"},"accountLoyalties":{"cfc":"AccountLoyalty","fieldtype":"one-to-many","singularname":"accountLoyalty","cascade":"all-delete-orphan","fkcolumn":"loyaltyID","type":"array","inverse":true,"name":"accountLoyalties"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"loyaltyAccruements":{"cfc":"LoyaltyAccruement","fieldtype":"one-to-many","singularname":"loyaltyAccruement","cascade":"all-delete-orphan","fkcolumn":"loyaltyID","type":"array","inverse":true,"name":"loyaltyAccruements"},"validations":{"persistent":false,"type":"struct","name":"validations"},"loyaltyName":{"ormtype":"string","name":"loyaltyName"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"loyaltyTerms":{"cfc":"LoyaltyTerm","fieldtype":"one-to-many","singularname":"loyaltyTerm","cascade":"all-delete-orphan","fkcolumn":"loyaltyID","type":"array","inverse":true,"name":"loyaltyTerms"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Loyalty'].className = 'Loyalty';
                	validations['Loyalty'] = {"properties":{"loyaltyName":[{"contexts":"save","required":true}]}};
                	defaultValues['Loyalty'] = {
                	loyaltyID:'',
										loyaltyName:null,
									activeFlag:1,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['GiftCard'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"ownerEmailAddress":{"ormtype":"string","name":"ownerEmailAddress"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"balanceAmount":{"ormtype":"big_decimal","name":"balanceAmount"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"ownerAccount":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"ownerAccountID","name":"ownerAccount"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"originalOrderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","cascade":"all","fkcolumn":"originalOrderItemID","name":"originalOrderItem"},"orderItemGiftRecipient":{"cfc":"OrderItemGiftRecipient","fieldtype":"many-to-one","cascade":"all","fkcolumn":"orderItemGiftRecipientID","inverse":true,"name":"orderItemGiftRecipient"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"giftCardID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"giftCardID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"giftCardCode":{"ormtype":"string","name":"giftCardCode"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"ownerLastName":{"ormtype":"string","name":"ownerLastName"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"issuedDate":{"ormtype":"timestamp","name":"issuedDate"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"expirationDate":{"ormtype":"timestamp","name":"expirationDate"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"giftCardExpirationTerm":{"cfc":"Term","fieldtype":"many-to-one","cascade":"all","fkcolumn":"giftCardExpirationTermID","name":"giftCardExpirationTerm"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"giftCardTransactions":{"cfc":"GiftCardTransaction","fieldtype":"one-to-many","singularname":"giftCardTransaction","cascade":"all-delete-orphan","fkcolumn":"giftCardID","inverse":true,"name":"giftCardTransactions"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"ownerFirstName":{"ormtype":"string","name":"ownerFirstName"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"giftCardPin":{"ormtype":"string","name":"giftCardPin"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['GiftCard'].className = 'GiftCard';
                	validations['GiftCard'] = {"properties":{"ownerEmailAddress":[{"contexts":"save","required":true}],"giftCardID":[{"contexts":"updateEmailAddress","method":"hasEmailBounce"}],"giftCardCode":[{"contexts":"save","required":true},{"contexts":"edit,delete","method":"canEditOrDelete"}]}};
                	defaultValues['GiftCard'] = {
                	giftCardID:'',
										giftCardCode:null,
									giftCardPin:null,
									expirationDate:null,
									ownerFirstName:null,
									ownerLastName:null,
									ownerEmailAddress:null,
									activeFlag:1,
									issuedDate:null,
									currencyCode:null,
									balanceAmount:0,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AttributeValue'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"attributeValueFileURL":{"persistent":false,"name":"attributeValueFileURL"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"accountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"accountAddressID","name":"accountAddress"},"accountPayment":{"cfc":"AccountPayment","fieldtype":"many-to-one","fkcolumn":"accountPaymentID","name":"accountPayment"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"attributeValue":{"length":4000,"ormtype":"string","hb_formattype":"custom","name":"attributeValue"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"image":{"cfc":"Image","fieldtype":"many-to-one","fkcolumn":"imageID","name":"image"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","fkcolumn":"productID","name":"product"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"attributeValueEncryptedGenerator":{"column":"attributeValueEncryptGen","hb_auditable":false,"ormtype":"string","name":"attributeValueEncryptedGenerator"},"type":{"cfc":"Type","fieldtype":"many-to-one","fkcolumn":"typeID","name":"type"},"attribute":{"cfc":"Attribute","notnull":true,"fieldtype":"many-to-one","fkcolumn":"attributeID","name":"attribute"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"vendorOrder":{"cfc":"VendorOrder","fieldtype":"many-to-one","fkcolumn":"vendorOrderID","name":"vendorOrder"},"orderDelivery":{"cfc":"OrderDelivery","fieldtype":"many-to-one","fkcolumn":"orderDeliveryID","name":"orderDelivery"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"brand":{"cfc":"Brand","fieldtype":"many-to-one","fkcolumn":"brandID","name":"brand"},"validations":{"persistent":false,"type":"struct","name":"validations"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValueID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"attributeValueID"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"productBundleGroup":{"cfc":"ProductBundleGroup","fieldtype":"many-to-one","fkcolumn":"productBundleGroupID","name":"productBundleGroup"},"attributeValueType":{"notnull":true,"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"custom","name":"attributeValueType"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"locationConfiguration":{"cfc":"LocationConfiguration","fieldtype":"many-to-one","fkcolumn":"locationConfigurationID","name":"locationConfiguration"},"attributeID":{"length":32,"insert":false,"update":false,"name":"attributeID"},"attributeValueEncrypted":{"hb_auditable":false,"ormtype":"string","name":"attributeValueEncrypted"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"attributeValueOptions":{"persistent":false,"name":"attributeValueOptions"},"content":{"cfc":"Content","fieldtype":"many-to-one","fkcolumn":"contentID","name":"content"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"file":{"cfc":"File","fieldtype":"many-to-one","fkcolumn":"fileID","name":"file"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValueOption":{"cfc":"AttributeOption","fieldtype":"many-to-one","fkcolumn":"attributeValueOptionID","name":"attributeValueOption"},"productReview":{"cfc":"ProductReview","fieldtype":"many-to-one","fkcolumn":"productReviewID","name":"productReview"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"optionGroup":{"cfc":"OptionGroup","fieldtype":"many-to-one","fkcolumn":"optionGroupID","name":"optionGroup"},"subscriptionBenefit":{"cfc":"SubscriptionBenefit","fieldtype":"many-to-one","fkcolumn":"subscriptionBenefitID","name":"subscriptionBenefit"},"attributeValueEncryptedDateTime":{"column":"attributeValueEncryptDT","hb_auditable":false,"ormtype":"timestamp","name":"attributeValueEncryptedDateTime"},"productType":{"cfc":"ProductType","fieldtype":"many-to-one","fkcolumn":"productTypeID","name":"productType"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderPayment":{"cfc":"OrderPayment","fieldtype":"many-to-one","fkcolumn":"orderPaymentID","name":"orderPayment"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"attributeOption":{"cfc":"AttributeOption","fieldtype":"many-to-one","fkcolumn":"attributeOptionID","name":"attributeOption"}};
                	entities['AttributeValue'].className = 'AttributeValue';
                	validations['AttributeValue'] = {"properties":{"attribute":[{"contexts":"save","required":true}],"attributeValueType":[{"contexts":"save","required":true}],"attributeValue":[{"contexts":"save","method":"regexMatches"}]},"conditions":{"attributeRequired":{"attribute.requiredFlag":{"eq":true}}}};
                	defaultValues['AttributeValue'] = {
                	attributeValueID:'',
										attributeValue:'',
										attributeValueEncrypted:null,
									attributeValueEncryptedDateTime:null,
									attributeValueEncryptedGenerator:null,
									attributeValueType:null,
									attributeID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ProductBundleBuildItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"productBundleGroup":{"cfc":"ProductBundleGroup","fieldtype":"many-to-one","fkcolumn":"productBundleGroupID","name":"productBundleGroup"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"productBundleBuildItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productBundleBuildItemID"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"productBundleBuild":{"cfc":"ProductBundleBuild","fieldtype":"many-to-one","fkcolumn":"productBundleBuildID","name":"productBundleBuild"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ProductBundleBuildItem'].className = 'ProductBundleBuildItem';
                	validations['ProductBundleBuildItem'] = {"properties":{}};
                	defaultValues['ProductBundleBuildItem'] = {
                	productBundleBuildItemID:'',
										quantity:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['LoyaltyAccruement'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"excludedBrands":{"cfc":"Brand","linktable":"SwLoyaltyAccruExclBrand","fieldtype":"many-to-many","singularname":"excludedBrand","inversejoincolumn":"brandID","fkcolumn":"loyaltyAccruementID","type":"array","name":"excludedBrands"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"loyalty":{"cfc":"Loyalty","fieldtype":"many-to-one","fkcolumn":"loyaltyID","name":"loyalty"},"pointType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"pointType"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwLoyaltyAccruBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"loyaltyAccruementID","name":"brands"},"skus":{"cfc":"Sku","linktable":"SwLoyaltyAccruSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"loyaltyAccruementID","name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"excludedSkus":{"cfc":"Sku","linktable":"SwLoyaltyAccruExclSku","fieldtype":"many-to-many","singularname":"excludedSku","inversejoincolumn":"skuID","fkcolumn":"loyaltyAccruementID","name":"excludedSkus"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"excludedProducts":{"cfc":"Product","linktable":"SwLoyaltyAccruExclProduct","fieldtype":"many-to-many","singularname":"excludedProduct","inversejoincolumn":"productID","fkcolumn":"loyaltyAccruementID","name":"excludedProducts"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"startDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","name":"startDateTime"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"accruementType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"accruementType"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"pointQuantity":{"ormtype":"integer","name":"pointQuantity"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"expirationTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"expirationTermID","hb_optionsnullrbkey":"define.never","name":"expirationTerm"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"productTypes":{"cfc":"ProductType","linktable":"SwLoyaltyAccruProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"loyaltyAccruementID","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"loyaltyAccruementID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"loyaltyAccruementID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all-delete-orphan","fkcolumn":"loyaltyAccruementID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"excludedProductTypes":{"cfc":"ProductType","linktable":"SwLoyaltyAccruExclProductType","fieldtype":"many-to-many","singularname":"excludedProductType","inversejoincolumn":"productTypeID","fkcolumn":"loyaltyAccruementID","name":"excludedProductTypes"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"products":{"cfc":"Product","linktable":"SwLoyaltyAccruProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"loyaltyAccruementID","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"endDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['LoyaltyAccruement'].className = 'LoyaltyAccruement';
                	validations['LoyaltyAccruement'] = {"properties":{"pointQuantity":[{"contexts":"save","dataType":"numeric","required":true}],"endDateTime":[{"contexts":"save","dataType":"date"},{"contexts":"save","gtDateTimeProperty":"startDateTime","conditions":"needsEndAfterStart"}],"startDateTime":[{"contexts":"save","dataType":"date"}],"pointType":[{"contexts":"save","inList":"fixed","conditions":"accruementTypeEnroll"}]},"conditions":{"needsEndAfterStart":{"endDateTime":{"required":true},"startDateTime":{"required":true}},"accruementTypeEnroll":{"accruementType":{"eq":"enrollment"}}}};
                	defaultValues['LoyaltyAccruement'] = {
                	loyaltyAccruementID:'',
										startDateTime:null,
									endDateTime:null,
									accruementType:null,
									pointType:null,
									pointQuantity:null,
									activeFlag:1,
									currencyCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['EventRegistration'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"phoneNumber":{"ormtype":"string","name":"phoneNumber"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"waitlistQueuePositionStruct":{"persistent":false,"name":"waitlistQueuePositionStruct"},"emailAddress":{"ormtype":"string","hb_populateenabled":"public","name":"emailAddress"},"waitlistQueueDateTime":{"hint":"Datetime registrant was added to waitlist.","ormtype":"timestamp","hb_formattype":"dateTime","name":"waitlistQueueDateTime"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"firstName":{"ormtype":"string","hb_populateenabled":"public","name":"firstName"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"lastName":{"ormtype":"string","hb_populateenabled":"public","name":"lastName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"eventRegistrationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"eventRegistrationID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"eventRegistrationStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=eventRegistrationStatusType","fkcolumn":"eventRegistrationStatusTypeID","name":"eventRegistrationStatusType"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"registrantAttendanceCode":{"hint":"Unique code to track registrant attendance","length":8,"unique":true,"ormtype":"string","name":"registrantAttendanceCode"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"registrationStatusTitle":{"persistent":false,"name":"registrationStatusTitle"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"productName":{"persistent":false,"name":"productName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"attendedFlag":{"persistent":false,"name":"attendedFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"pendingClaimDateTime":{"hint":"Datetime registrant was changed to pending claim.","ormtype":"timestamp","hb_formattype":"dateTime","name":"pendingClaimDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['EventRegistration'].className = 'EventRegistration';
                	validations['EventRegistration'] = {"properties":{}};
                	defaultValues['EventRegistration'] = {
                	eventRegistrationID:'',
										firstName:null,
									lastName:null,
									emailAddress:null,
									phoneNumber:null,
									waitlistQueueDateTime:null,
									pendingClaimDateTime:null,
									registrantAttendanceCode:null,
									remoteID:null,
									createdDateTime:'',
										modifiedDateTime:'',
										
						z:''
	                };
                
                	entities['EventRegistration_Approve'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Approve'].className = 'EventRegistration_Approve';
                	validations['EventRegistration_Approve'] = {"properties":{}};
                	defaultValues['EventRegistration_Approve'] = {
                	eventRegistration:'',
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['EventRegistration_Attend'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Attend'].className = 'EventRegistration_Attend';
                	validations['EventRegistration_Attend'] = {"properties":{}};
                	defaultValues['EventRegistration_Attend'] = {
                	eventRegistration:'',
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['EventRegistration_Cancel'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"createReturnOrderFlag":{"hint":"Instructs order return process whether it should perform return.","type":"boolean","name":"createReturnOrderFlag"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Cancel'].className = 'EventRegistration_Cancel';
                	validations['EventRegistration_Cancel'] = {"properties":{}};
                	defaultValues['EventRegistration_Cancel'] = {
                	eventRegistration:'',
										createReturnOrderFlag:false,
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['EventRegistration_Pending'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Pending'].className = 'EventRegistration_Pending';
                	validations['EventRegistration_Pending'] = {"properties":{}};
                	defaultValues['EventRegistration_Pending'] = {
                	eventRegistration:'',
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['EventRegistration_Register'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Register'].className = 'EventRegistration_Register';
                	validations['EventRegistration_Register'] = {"properties":{}};
                	defaultValues['EventRegistration_Register'] = {
                	eventRegistration:'',
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['EventRegistration_Waitlist'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"eventRegistration":{"name":"eventRegistration"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"comment":{"name":"comment"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['EventRegistration_Waitlist'].className = 'EventRegistration_Waitlist';
                	validations['EventRegistration_Waitlist'] = {"properties":{}};
                	defaultValues['EventRegistration_Waitlist'] = {
                	eventRegistration:'',
										comment:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Image'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"imageName":{"ormtype":"string","name":"imageName"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","fkcolumn":"productID","name":"product"},"imageID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"imageID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"option":{"cfc":"Option","fieldtype":"many-to-one","fkcolumn":"optionID","name":"option"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"imageDescription":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"imageDescription"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"options":{"cfc":"Option","linktable":"SwImageOption","fieldtype":"many-to-many","singularname":"option","inversejoincolumn":"optionID","fkcolumn":"imageID","name":"options"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"directory":{"ormtype":"string","name":"directory"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"promotion":{"cfc":"Promotion","fieldtype":"many-to-one","fkcolumn":"promotionID","name":"promotion"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"imageID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"imageType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=imageType","fkcolumn":"imageTypeID","name":"imageType"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"imageFile":{"hb_formfieldtype":"file","hb_fileupload":true,"ormtype":"string","hb_fileacceptmimetype":"image/gif,image/jpeg,image/pjpeg,image/png,image/x-png","hb_fileacceptextension":".jpeg,.jpg,.png,.gif","name":"imageFile"}};
                	entities['Image'].className = 'Image';
                	validations['Image'] = {"properties":{"imageFile":[{"contexts":"save","required":true}]}};
                	defaultValues['Image'] = {
                	imageID:'',
										imageName:null,
									imageDescription:null,
									imageFile:null,
									directory:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['MeasurementUnit'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"conversionRatio":{"ormtype":"float","name":"conversionRatio"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"unitCode":{"fieldtype":"id","unique":true,"ormtype":"string","generated":"never","name":"unitCode"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"measurementType":{"hb_formfieldtype":"select","ormtype":"string","name":"measurementType"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"unitName":{"ormtype":"string","name":"unitName"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['MeasurementUnit'].className = 'MeasurementUnit';
                	validations['MeasurementUnit'] = {"properties":{}};
                	defaultValues['MeasurementUnit'] = {
                	unitCode:null,
									measurementType:null,
									unitName:null,
									conversionRatio:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['TaxApplied'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"taxLiabilityAmount":{"ormtype":"big_decimal","name":"taxLiabilityAmount"},"taxJurisdictionID":{"ormtype":"string","name":"taxJurisdictionID"},"taxCategoryRate":{"cfc":"TaxCategoryRate","fieldtype":"many-to-one","fkcolumn":"taxCategoryRateID","name":"taxCategoryRate"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"taxLocality":{"ormtype":"string","hb_populateenabled":"public","name":"taxLocality"},"taxJurisdictionType":{"ormtype":"string","name":"taxJurisdictionType"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"taxCountryCode":{"ormtype":"string","hb_populateenabled":"public","name":"taxCountryCode"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"orderItemID","name":"orderItem"},"taxPostalCode":{"ormtype":"string","hb_populateenabled":"public","name":"taxPostalCode"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"taxStateCode":{"ormtype":"string","hb_populateenabled":"public","name":"taxStateCode"},"taxCity":{"ormtype":"string","hb_populateenabled":"public","name":"taxCity"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"appliedType":{"ormtype":"string","name":"appliedType"},"taxStreetAddress":{"ormtype":"string","hb_populateenabled":"public","name":"taxStreetAddress"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taxImpositionType":{"ormtype":"string","name":"taxImpositionType"},"taxRate":{"ormtype":"big_decimal","hb_formattype":"percentage","name":"taxRate"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"taxJurisdictionName":{"ormtype":"string","name":"taxJurisdictionName"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"taxAppliedID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taxAppliedID"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"taxImpositionName":{"ormtype":"string","name":"taxImpositionName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"taxAmount":{"ormtype":"big_decimal","name":"taxAmount"},"taxStreet2Address":{"ormtype":"string","hb_populateenabled":"public","name":"taxStreet2Address"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"taxImpositionID":{"ormtype":"string","name":"taxImpositionID"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['TaxApplied'].className = 'TaxApplied';
                	validations['TaxApplied'] = {"properties":{}};
                	defaultValues['TaxApplied'] = {
                	taxAppliedID:'',
										taxAmount:null,
									taxLiabilityAmount:null,
									taxRate:null,
									appliedType:null,
									currencyCode:null,
									taxStreetAddress:null,
									taxStreet2Address:null,
									taxLocality:null,
									taxCity:null,
									taxStateCode:null,
									taxPostalCode:null,
									taxCountryCode:null,
									taxImpositionID:null,
									taxImpositionName:null,
									taxImpositionType:null,
									taxJurisdictionID:null,
									taxJurisdictionName:null,
									taxJurisdictionType:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Setting'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"emailTemplate":{"cfc":"EmailTemplate","fieldtype":"many-to-one","fkcolumn":"emailTemplateID","name":"emailTemplate"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"settingValue":{"length":4000,"ormtype":"string","name":"settingValue"},"email":{"cfc":"Email","fieldtype":"many-to-one","fkcolumn":"emailID","name":"email"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"productID","name":"product"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"settingValueEncryptionProcessedFlag":{"persistent":false,"type":"boolean","name":"settingValueEncryptionProcessedFlag"},"task":{"cfc":"Task","fieldtype":"many-to-one","fkcolumn":"taskID","name":"task"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"subscriptionTerm":{"cfc":"SubscriptionTerm","fieldtype":"many-to-one","fkcolumn":"subscriptionTermID","name":"subscriptionTerm"},"settingID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"settingID"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","name":"shippingMethod"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"settingName":{"ormtype":"string","name":"settingName"},"settingValueEncryptedDateTime":{"column":"settingValueEncryptDT","hb_auditable":false,"ormtype":"timestamp","name":"settingValueEncryptedDateTime"},"fulfillmentMethod":{"cfc":"FulfillmentMethod","fieldtype":"many-to-one","fkcolumn":"fulfillmentMethodID","name":"fulfillmentMethod"},"brand":{"cfc":"Brand","fieldtype":"many-to-one","fkcolumn":"brandID","name":"brand"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"shippingMethodRate":{"cfc":"ShippingMethodRate","fieldtype":"many-to-one","fkcolumn":"shippingMethodRateID","name":"shippingMethodRate"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"cmsContentID":{"ormtype":"string","name":"cmsContentID"},"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"locationConfiguration":{"cfc":"LocationConfiguration","fieldtype":"many-to-one","fkcolumn":"locationConfigurationID","name":"locationConfiguration"},"settingValueEncryptedGenerator":{"column":"settingValueEncryptGen","hb_auditable":false,"ormtype":"string","name":"settingValueEncryptedGenerator"},"paymentMethod":{"cfc":"PaymentMethod","fieldtype":"many-to-one","fkcolumn":"paymentMethodID","name":"paymentMethod"},"content":{"cfc":"Content","fieldtype":"many-to-one","fkcolumn":"contentID","name":"content"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"site":{"cfc":"Site","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"siteID","name":"site"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"productType":{"cfc":"ProductType","fieldtype":"many-to-one","fkcolumn":"productTypeID","name":"productType"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"subscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageID","name":"subscriptionUsage"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Setting'].className = 'Setting';
                	validations['Setting'] = {"properties":{}};
                	defaultValues['Setting'] = {
                	settingID:'',
										settingName:null,
									settingValue:null,
									settingValueEncryptedDateTime:null,
									settingValueEncryptedGenerator:null,
									cmsContentID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Type'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"parentType":{"cfc":"Type","fieldtype":"many-to-one","fkcolumn":"parentTypeID","name":"parentType"},"childTypes":{"cfc":"Type","fieldtype":"one-to-many","singularname":"childType","cascade":"all","fkcolumn":"parentTypeID","type":"array","inverse":true,"name":"childTypes"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"childRequiresSystemCodeFlag":{"ormtype":"boolean","name":"childRequiresSystemCodeFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"parentType","ormtype":"integer","name":"sortOrder"},"typeDescription":{"length":4000,"ormtype":"string","name":"typeDescription"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"type":{"persistent":false,"type":"string","name":"type"},"systemCode":{"ormtype":"string","index":"PI_SYSTEMCODE","name":"systemCode"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"typeName":{"ormtype":"string","name":"typeName"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"typeID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"typeID"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"typeID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"typeCode":{"ormtype":"string","name":"typeCode"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"typeIDPath":{"length":4000,"ormtype":"string","name":"typeIDPath"}};
                	entities['Type'].className = 'Type';
                	validations['Type'] = {"properties":{"typeName":[{"contexts":"save","required":true}],"typeID":[{"contexts":"delete","null":true,"conditions":"topLevelSystemType"}],"childTypes":[{"contexts":"delete","maxCollection":0}],"typeCode":[{"uniqueOrNull":true,"contexts":"save"}],"systemCode":[{"contexts":"save","conditions":"requiresSystemCode","required":true},{"contexts":"delete","method":"hasPeerTypeWithMatchingSystemCode"}]},"conditions":{"topLevelSystemType":{"parentType":{"null":true},"systemCode":{"required":true}},"requiresSystemCode":{"parentType.childRequiresSystemCodeFlag":{"eq":true},"parentType":{"required":true}}}};
                	defaultValues['Type'] = {
                	typeID:'',
										typeIDPath:'',
										typeName:null,
									typeCode:null,
									typeDescription:null,
									sortOrder:null,
									systemCode:null,
									childRequiresSystemCodeFlag:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountRelationship'] = {"relatedAccount":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"relatedAccountID","hb_optionsnullrbkey":"define.select","name":"relatedAccount"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","hb_optionsnullrbkey":"define.select","name":"account"},"relationshipType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=relationshipType","fkcolumn":"relationshipTypeID","hb_optionsnullrbkey":"define.select","name":"relationshipType"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"accountRelationshipID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountRelationshipID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountRelationship'].className = 'AccountRelationship';
                	validations['AccountRelationship'] = {"properties":{}};
                	defaultValues['AccountRelationship'] = {
                	accountRelationshipID:'',
										createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionUsageBenefitAccount'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"subscriptionUsageBenefit":{"cfc":"SubscriptionUsageBenefit","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageBenefitID","name":"subscriptionUsageBenefit"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"subsUsageBenefitAccountID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subsUsageBenefitAccountID"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"endDateTime":{"ormtype":"timestamp","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionUsageBenefitAccount'].className = 'SubscriptionUsageBenefitAccount';
                	validations['SubscriptionUsageBenefitAccount'] = {"properties":{}};
                	defaultValues['SubscriptionUsageBenefitAccount'] = {
                	subsUsageBenefitAccountID:'',
										endDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionUsageBenefit'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"renewalSubscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","fkcolumn":"renewalSubscriptionUsageID","inverse":true,"name":"renewalSubscriptionUsage"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"contents":{"cfc":"Content","linktable":"SwSubsUsageBenefitContent","fieldtype":"many-to-many","singularname":"content","inversejoincolumn":"contentID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"contents"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"promotions":{"cfc":"Promotion","linktable":"SwSubsUsageBenefitPromotion","fieldtype":"many-to-many","singularname":"promotion","inversejoincolumn":"promotionID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"promotions"},"excludedContents":{"cfc":"Content","linktable":"SwSubsUsageBenefitExclContent","fieldtype":"many-to-many","singularname":"excludedContent","inversejoincolumn":"contentID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"excludedContents"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"maxUseCount":{"ormtype":"integer","name":"maxUseCount"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"subscriptionBenefit":{"cfc":"SubscriptionBenefit","fieldtype":"many-to-one","fkcolumn":"subscriptionBenefitID","name":"subscriptionBenefit"},"excludedCategories":{"cfc":"Category","linktable":"SwSubsUsageBenefitExclCategory","fieldtype":"many-to-many","singularname":"excludedCategory","inversejoincolumn":"categoryID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"excludedCategories"},"categories":{"cfc":"Category","linktable":"SwSubsUsageBenefitCategory","fieldtype":"many-to-many","singularname":"category","inversejoincolumn":"categoryID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"categories"},"validations":{"persistent":false,"type":"struct","name":"validations"},"subscriptionUsageBenefitAccounts":{"cfc":"SubscriptionUsageBenefitAccount","fieldtype":"one-to-many","singularname":"subscriptionUsageBenefitAccount","cascade":"all-delete-orphan","fkcolumn":"subscriptionUsageBenefitID","type":"array","inverse":true,"name":"subscriptionUsageBenefitAccounts"},"priceGroups":{"cfc":"PriceGroup","linktable":"SwSubsUsageBenefitPriceGroup","fieldtype":"many-to-many","singularname":"priceGroup","inversejoincolumn":"priceGroupID","fkcolumn":"subscriptionUsageBenefitID","type":"array","name":"priceGroups"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageID","inverse":true,"name":"subscriptionUsage"},"accessType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accessType","fkcolumn":"accessTypeID","name":"accessType"},"subscriptionUsageBenefitID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionUsageBenefitID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionUsageBenefit'].className = 'SubscriptionUsageBenefit';
                	validations['SubscriptionUsageBenefit'] = {"properties":{}};
                	defaultValues['SubscriptionUsageBenefit'] = {
                	subscriptionUsageBenefitID:'',
										maxUseCount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorOrder'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"vendorOrderStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=vendorOrderStatusType","fkcolumn":"vendorOrderStatusTypeID","name":"vendorOrderStatusType"},"subTotal":{"persistent":false,"hb_formattype":"currency","name":"subTotal"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"estimatedReceivalDateTime":{"ormtype":"timestamp","name":"estimatedReceivalDateTime"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"vendorOrderItems":{"cfc":"VendorOrderItem","fieldtype":"one-to-many","singularname":"vendorOrderItem","cascade":"all","fkcolumn":"vendorOrderID","inverse":true,"name":"vendorOrderItems"},"total":{"persistent":false,"hb_formattype":"currency","name":"total"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"vendorOrderType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=vendorOrderType","fkcolumn":"vendorOrderTypeID","name":"vendorOrderType"},"currencyCodeOptions":{"persistent":false,"name":"currencyCodeOptions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"vendorOrderID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorOrderID"},"billToLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"billToLocation"},"stockReceivers":{"cfc":"StockReceiver","fieldtype":"one-to-many","singularname":"stockReceiver","cascade":"all-delete-orphan","fkcolumn":"vendorOrderID","type":"array","inverse":true,"name":"stockReceivers"},"currencyCode":{"length":3,"hb_formfieldtype":"select","ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"vendorOrderNumber":{"ormtype":"string","name":"vendorOrderNumber"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"vendorOrderID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"addVendorOrderItemSkuOptionsSmartList":{"persistent":false,"name":"addVendorOrderItemSkuOptionsSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorOrder'].className = 'VendorOrder';
                	validations['VendorOrder'] = {"properties":{"vendorOrderType":[{"contexts":"save","required":true}],"vendorOrderStatusType":[{"contexts":"save","required":true}],"vendor":[{"contexts":"save","required":true}],"stockReceivers":[{"contexts":"delete","maxCollection":0}],"vendorOrderItems":[{"contexts":"receiveStock","minCollection":1}]}};
                	defaultValues['VendorOrder'] = {
                	vendorOrderID:'',
										vendorOrderNumber:null,
									estimatedReceivalDateTime:null,
									currencyCode:'USD',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorOrder_AddVendorOrderItem'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"vendorOrder":{"name":"vendorOrder"},"price":{"name":"price"},"quantity":{"name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"skuID":{"name":"skuID"},"deliverToLocationID":{"hb_formfieldtype":"select","name":"deliverToLocationID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"cost":{"name":"cost"},"vendorOrderItemTypeSystemCode":{"name":"vendorOrderItemTypeSystemCode"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorOrder_AddVendorOrderItem'].className = 'VendorOrder_AddVendorOrderItem';
                	validations['VendorOrder_AddVendorOrderItem'] = {"properties":{}};
                	defaultValues['VendorOrder_AddVendorOrderItem'] = {
                	vendorOrder:'',
										skuID:'',
									cost:0,
										quantity:1,
										vendorOrderItemTypeSystemCode:"voitPurchase",
										deliverToLocationID:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['VendorOrder_Receive'] = {"locationID":{"hb_rbkey":"entity.location","hb_formfieldtype":"select","name":"locationID"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"vendorOrder":{"name":"vendorOrder"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"vendorOrderID":{"name":"vendorOrderID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"packingSlipNumber":{"hb_rbkey":"entity.stockReceiver.packingSlipNumber","name":"packingSlipNumber"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"boxCount":{"hb_rbkey":"entity.stockReceiver.boxCount","name":"boxCount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"vendorOrderItems":{"type":"array","name":"vendorOrderItems","hb_populatearray":true}};
                	entities['VendorOrder_Receive'].className = 'VendorOrder_Receive';
                	validations['VendorOrder_Receive'] = {"properties":{}};
                	defaultValues['VendorOrder_Receive'] = {
                	vendorOrder:'',
										locationID:'',
									vendorOrderID:'',
									packingSlipNumber:'',
									boxCount:'',
									vendorOrderItems:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['ShippingMethod'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardShippingMethod","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"shippingMethodID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"shippingMethodName":{"ormtype":"string","name":"shippingMethodName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"fulfillmentMethod","ormtype":"integer","name":"sortOrder"},"orderFulfillments":{"cfc":"OrderFulfillment","fieldtype":"one-to-many","lazy":"extra","singularname":"orderFulfillment","fkcolumn":"shippingMethodID","inverse":true,"name":"orderFulfillments"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"shippingMethodRates":{"cfc":"ShippingMethodRate","fieldtype":"one-to-many","singularname":"shippingMethodRate","cascade":"all-delete-orphan","fkcolumn":"shippingMethodID","inverse":true,"name":"shippingMethodRates"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"shippingMethodID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"shippingMethodID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualShippingMethod","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"shippingMethodID","inverse":true,"name":"promotionQualifiers"},"fulfillmentMethod":{"cfc":"FulfillmentMethod","fieldtype":"many-to-one","fkcolumn":"fulfillmentMethodID","name":"fulfillmentMethod"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"shippingMethodCode":{"ormtype":"string","name":"shippingMethodCode"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ShippingMethod'].className = 'ShippingMethod';
                	validations['ShippingMethod'] = {"properties":{"shippingMethodCode":[{"uniqueOrNull":true,"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$"}],"orderFulfillments":[{"contexts":"delete","maxCollection":0}],"shippingMethodName":[{"contexts":"save","required":true}]}};
                	defaultValues['ShippingMethod'] = {
                	shippingMethodID:'',
										activeFlag:1,
									shippingMethodName:null,
									shippingMethodCode:null,
									sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Option'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardOption","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"optionID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"productImages":{"cfc":"Image","linktable":"SwImageOption","fieldtype":"many-to-many","lazy":"extra","singularname":"productImage","inversejoincolumn":"imageID","fkcolumn":"optionID","inverse":true,"name":"productImages"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"skus":{"cfc":"Sku","linktable":"SwSkuOption","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"optionID","inverse":true,"name":"skus"},"optionDescription":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"optionDescription"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"optionGroup","ormtype":"integer","name":"sortOrder"},"optionName":{"ormtype":"string","name":"optionName"},"images":{"cfc":"Image","fieldtype":"one-to-many","singularname":"image","cascade":"all-delete-orphan","fkcolumn":"optionID","type":"array","inverse":true,"name":"images"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"defaultImage":{"cfc":"Image","fieldtype":"many-to-one","fkcolumn":"defaultImageID","name":"defaultImage"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"promotionRewardExclusions":{"cfc":"PromotionReward","linktable":"SwPromoRewardExclOption","fieldtype":"many-to-many","singularname":"promotionRewardExclusion","inversejoincolumn":"promotionRewardID","fkcolumn":"optionID","inverse":true,"type":"array","name":"promotionRewardExclusions"},"optionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"optionID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualOption","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"optionID","inverse":true,"name":"promotionQualifiers"},"optionGroup":{"cfc":"OptionGroup","fieldtype":"many-to-one","fkcolumn":"optionGroupID","name":"optionGroup"},"promotionQualifierExclusions":{"cfc":"PromotionQualifier","linktable":"SwPromoQualExclOption","fieldtype":"many-to-many","singularname":"promotionQualifierExclusion","inversejoincolumn":"promotionQualifierID","fkcolumn":"optionID","inverse":true,"type":"array","name":"promotionQualifierExclusions"},"optionCode":{"ormtype":"string","index":"PI_OPTIONCODE","name":"optionCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Option'].className = 'Option';
                	validations['Option'] = {"properties":{"skus":[{"contexts":"delete","maxCollection":0}],"optionName":[{"contexts":"save","required":true}],"optionGroup":[{"contexts":"save","required":true}],"optionCode":[{"uniqueOrNull":true,"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$"}]}};
                	defaultValues['Option'] = {
                	optionID:'',
										optionCode:null,
									optionName:null,
									optionDescription:null,
									sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PhysicalCountItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"skuCode":{"ormtype":"string","index":"PI_SKUCODE","name":"skuCode"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"countPostDateTime":{"ormtype":"timestamp","name":"countPostDateTime"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"physicalStatusTypeSystemCode":{"persistent":false,"name":"physicalStatusTypeSystemCode"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","name":"stock"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"physicalCountItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"physicalCountItemID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"physicalCount":{"cfc":"PhysicalCount","fieldtype":"many-to-one","fkcolumn":"physicalCountID","name":"physicalCount"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"sku":{"cfc":"Sku","persistent":false,"fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PhysicalCountItem'].className = 'PhysicalCountItem';
                	validations['PhysicalCountItem'] = {"properties":{"quantity":[{"contexts":"save","required":true}],"physicalStatusTypeSystemCode":[{"contexts":"delete,edit","inList":"pstOpen"}],"physicalCount":[{"contexts":"save","required":true}]}};
                	defaultValues['PhysicalCountItem'] = {
                	physicalCountItemID:'',
										quantity:null,
									skuCode:null,
									countPostDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorAddress'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"vendorAddressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorAddressID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"address":{"cfc":"Address","fieldtype":"many-to-one","cascade":"all","fkcolumn":"addressID","name":"address"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorAddress'].className = 'VendorAddress';
                	validations['VendorAddress'] = {"properties":{"vendor":[{"contexts":"save","required":true}]},"populatedPropertyValidation":{"address":[{"validate":"full"}]}};
                	defaultValues['VendorAddress'] = {
                	vendorAddressID:'',
										createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderFulfillment'] = {"accountEmailAddress":{"cfc":"AccountEmailAddress","fieldtype":"many-to-one","fkcolumn":"accountEmailAddressID","hb_populateenabled":"public","name":"accountEmailAddress"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"appliedPromotions":{"cfc":"PromotionApplied","fieldtype":"one-to-many","singularname":"appliedPromotion","cascade":"all-delete-orphan","fkcolumn":"orderFulfillmentID","inverse":true,"name":"appliedPromotions"},"accountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"accountAddressID","hb_populateenabled":"public","name":"accountAddress"},"requiredShippingInfoExistsFlag":{"persistent":false,"name":"requiredShippingInfoExistsFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"shippingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"shippingAddressID","hb_populateenabled":"public","name":"shippingAddress"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"shippingMethodOptions":{"persistent":false,"type":"array","name":"shippingMethodOptions"},"estimatedDeliveryDateTime":{"ormtype":"timestamp","name":"estimatedDeliveryDateTime"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"saveAccountAddress":{"persistent":false,"name":"saveAccountAddress"},"fulfillmentMethodType":{"persistent":false,"type":"numeric","name":"fulfillmentMethodType"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","hb_populateenabled":"public","name":"shippingMethod"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all","fkcolumn":"orderFulfillmentID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"saveAccountAddressFlag":{"persistent":false,"hb_populateenabled":"public","name":"saveAccountAddressFlag"},"fulfillmentMethod":{"cfc":"FulfillmentMethod","fieldtype":"many-to-one","fkcolumn":"fulfillmentMethodID","hb_populateenabled":"public","name":"fulfillmentMethod"},"validations":{"persistent":false,"type":"struct","name":"validations"},"fulfillmentCharge":{"ormtype":"big_decimal","name":"fulfillmentCharge"},"taxAmount":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"taxAmount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"orderFulfillmentID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"shippingMethodRate":{"persistent":false,"type":"array","name":"shippingMethodRate"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"totalShippingWeight":{"persistent":false,"hb_formattype":"weight","type":"numeric","name":"totalShippingWeight"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"emailAddress":{"ormtype":"string","hb_populateenabled":"public","name":"emailAddress"},"discountAmount":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"discountAmount"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"subtotalAfterDiscounts":{"persistent":false,"hb_formattype":"currency","type":"array","name":"subtotalAfterDiscounts"},"subtotal":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"subtotal"},"pickupLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","hb_populateenabled":"public","name":"pickupLocation"},"fulfillmentShippingMethodOptions":{"cfc":"ShippingMethodOption","fieldtype":"one-to-many","singularname":"fulfillmentShippingMethodOption","cascade":"all-delete-orphan","fkcolumn":"orderFulfillmentID","inverse":true,"name":"fulfillmentShippingMethodOptions"},"orderFulfillmentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderFulfillmentID"},"shippingCharge":{"persistent":false,"name":"shippingCharge"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"quantityUndelivered":{"persistent":false,"type":"numeric","name":"quantityUndelivered"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"estimatedFulfillmentDateTime":{"ormtype":"timestamp","name":"estimatedFulfillmentDateTime"},"orderStatusCode":{"persistent":false,"type":"numeric","name":"orderStatusCode"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"orderFulfillmentItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"orderFulfillmentItem","cascade":"all","fkcolumn":"orderFulfillmentID","hb_populateenabled":"public","inverse":true,"name":"orderFulfillmentItems"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"chargeAfterDiscount":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"chargeAfterDiscount"},"subtotalAfterDiscountsWithTax":{"persistent":false,"hb_formattype":"currency","type":"array","name":"subtotalAfterDiscountsWithTax"},"nextEstimatedFulfillmentDateTime":{"persistent":false,"type":"timestamp","name":"nextEstimatedFulfillmentDateTime"},"quantityDelivered":{"persistent":false,"type":"numeric","name":"quantityDelivered"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"saveAccountAddressName":{"persistent":false,"hb_populateenabled":"public","name":"saveAccountAddressName"},"remoteID":{"ormtype":"string","name":"remoteID"},"manualFulfillmentChargeFlag":{"ormtype":"boolean","hb_populateenabled":false,"name":"manualFulfillmentChargeFlag"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"accountAddressOptions":{"persistent":false,"type":"array","name":"accountAddressOptions"},"discountTotal":{"persistent":false,"name":"discountTotal"},"nextEstimatedDeliveryDateTime":{"persistent":false,"type":"timestamp","name":"nextEstimatedDeliveryDateTime"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"orderFulfillmentStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderFulfillmentStatusType","fkcolumn":"orderFulfillmentStatusTypeID","name":"orderFulfillmentStatusType"}};
                	entities['OrderFulfillment'].className = 'OrderFulfillment';
                	validations['OrderFulfillment'] = {"properties":{"quantityUndelivered":[{"contexts":"fulfillItems","minValue":0}],"order":[{"contexts":"save","required":true}],"fulfillmentCharge":[{"contexts":"save","dataType":"numeric","minValue":0}],"pickupLocation":[{"contexts":"placeOrder","conditions":"fulfillmentTypePickup","required":true}],"shippingMethod":[{"contexts":"placeOrder","conditions":"fulfillmentTypeShipping","required":true},{"contexts":"placeOrder","conditions":"fulfillmentTypeShippingWithoutRateOverride","method":"hasValidShippingMethodRate"}],"orderStatusCode":[{"contexts":"edit,manualFulfillmentCharge","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"},{"contexts":"fulfillItems","inList":"ostNew,ostProcessing"}],"emailAddress":[{"contexts":"placeOrder","conditions":"fulfillmentTypeEmail","required":true}],"orderFulfillmentID":[{"contexts":"delete","maxValue":0}],"orderFulfillmentItems":[{"contexts":"placeOrder,fulfillItems","minCollection":1}],"requiredShippingInfoExistsFlag":[{"contexts":"placeOrder","conditions":"fulfillmentTypeShipping","eq":true}],"fulfillmentMethod":[{"contexts":"save","required":true,"method":"allOrderFulfillmentItemsAreEligibleForFulfillmentMethod"}]},"conditions":{"fulfillmentTypePickup":{"fulfillmentMethodType":{"eq":"pickup"}},"fulfillmentTypeShippingWithoutRateOverride":{"fulfillmentMethodType":{"eq":"shipping"},"accountAddress":{"null":true}},"fulfillmentTypeShipping":{"fulfillmentMethodType":{"eq":"shipping"}},"fulfillmentTypeEmail":{"fulfillmentMethodType":{"eq":"email"}},"fulfillmentTypeShippingNoAccountAddress":{"fulfillmentMethodType":{"eq":"shipping"},"accountAddress":{"null":true}}},"populatedPropertyValidation":{"shippingAddress":[{"conditions":"fulfillmentTypeShippingNoAccountAddress","validate":"full"}]}};
                	defaultValues['OrderFulfillment'] = {
                	orderFulfillmentID:'',
										fulfillmentCharge:0,
									currencyCode:null,
									emailAddress:null,
									manualFulfillmentChargeFlag:0,
									estimatedDeliveryDateTime:null,
									estimatedFulfillmentDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorAccount'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"vendorAccountID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorAccountID"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"roleType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=roleType","fkcolumn":"roleTypeID","name":"roleType"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorAccount'].className = 'VendorAccount';
                	validations['VendorAccount'] = {"properties":{}};
                	defaultValues['VendorAccount'] = {
                	vendorAccountID:'',
										createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ShippingMethodRate'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"addressZoneOptions":{"persistent":false,"type":"array","name":"addressZoneOptions"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"shippingIntegrationMethod":{"ormtype":"string","name":"shippingIntegrationMethod"},"shippingIntegration":{"cfc":"Integration","fieldtype":"many-to-one","fkcolumn":"shippingIntegrationID","name":"shippingIntegration"},"addressZone":{"cfc":"AddressZone","fieldtype":"many-to-one","hb_nullrbkey":"define.all","fkcolumn":"addressZoneID","name":"addressZone"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"shippingMethod","ormtype":"integer","name":"sortOrder"},"maximumShipmentWeight":{"hb_nullrbkey":"define.unlimited","ormtype":"float","name":"maximumShipmentWeight"},"shippingIntegrationMethodOptions":{"persistent":false,"type":"array","name":"shippingIntegrationMethodOptions"},"shippingMethodRateName":{"persistent":false,"type":"string","name":"shippingMethodRateName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"shippingMethodRateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"shippingMethodRateID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"shippingMethodOptions":{"cfc":"ShippingMethodOption","fieldtype":"one-to-many","lazy":"extra","cascade":"delete-orphan","singularname":"shippingMethodOption","fkcolumn":"shippingMethodRateID","inverse":true,"type":"array","name":"shippingMethodOptions"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"minimumShipmentItemPrice":{"hb_nullrbkey":"define.0","ormtype":"big_decimal","name":"minimumShipmentItemPrice"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"maximumShipmentItemPrice":{"hb_nullrbkey":"define.unlimited","ormtype":"big_decimal","name":"maximumShipmentItemPrice"},"minimumShipmentWeight":{"hb_nullrbkey":"define.0","ormtype":"float","name":"minimumShipmentWeight"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","name":"shippingMethod"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"defaultAmount":{"hb_nullrbkey":"define.0","ormtype":"big_decimal","hb_formattype":"currency","name":"defaultAmount"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"shipmentWeightRange":{"persistent":false,"type":"string","name":"shipmentWeightRange"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"shipmentItemPriceRange":{"persistent":false,"type":"string","name":"shipmentItemPriceRange"}};
                	entities['ShippingMethodRate'].className = 'ShippingMethodRate';
                	validations['ShippingMethodRate'] = {"properties":{"defaultAmount":[{"contexts":"save","dataType":"numeric"}],"maximumShipmentWeight":[{"contexts":"save","dataType":"numeric"}],"minimumShipmentItemPrice":[{"contexts":"save","dataType":"numeric"}],"maximumShipmentItemPrice":[{"contexts":"save","dataType":"numeric"}],"minimumShipmentWeight":[{"contexts":"save","dataType":"numeric"}]}};
                	defaultValues['ShippingMethodRate'] = {
                	shippingMethodRateID:'',
										sortOrder:null,
									minimumShipmentWeight:null,
									maximumShipmentWeight:null,
									minimumShipmentItemPrice:null,
									maximumShipmentItemPrice:null,
									defaultAmount:null,
									shippingIntegrationMethod:null,
									activeFlag:1,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockAdjustmentItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","default":0,"name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"toStock":{"cfc":"Stock","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"toStockID","name":"toStock"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"fromStock":{"cfc":"Stock","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"fromStockID","name":"fromStock"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"stockAdjustmentDeliveryItems":{"cfc":"StockAdjustmentDeliveryItem","fieldtype":"one-to-many","singularname":"stockAdjustmentDeliveryItem","cascade":"all-delete-orphan","fkcolumn":"stockAdjustmentItemID","type":"array","inverse":true,"name":"stockAdjustmentDeliveryItems"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"stockReceiverItems":{"cfc":"StockReceiverItem","fieldtype":"one-to-many","singularname":"stockReceiverItem","cascade":"all-delete-orphan","fkcolumn":"stockAdjustmentItemID","type":"array","inverse":true,"name":"stockReceiverItems"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"stockAdjustmentItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockAdjustmentItemID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustment":{"cfc":"StockAdjustment","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentID","name":"stockAdjustment"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockAdjustmentItem'].className = 'StockAdjustmentItem';
                	validations['StockAdjustmentItem'] = {"properties":{"quantity":[{"contexts":"save","dataType":"numeric","required":true,"minValue":0}]}};
                	defaultValues['StockAdjustmentItem'] = {
                	stockAdjustmentItemID:'',
										quantity:0,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['CommentRelationship'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"referencedExpressionEnd":{"ormtype":"integer","hb_populateenabled":false,"name":"referencedExpressionEnd"},"referencedExpressionProperty":{"ormtype":"string","hb_populateenabled":false,"name":"referencedExpressionProperty"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"comment":{"cfc":"Comment","fieldtype":"many-to-one","fkcolumn":"commentID","name":"comment"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","fkcolumn":"productID","name":"product"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"vendorOrder":{"cfc":"VendorOrder","fieldtype":"many-to-one","fkcolumn":"vendorOrderID","name":"vendorOrder"},"commentRelationshipID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"commentRelationshipID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"physical":{"cfc":"Physical","fieldtype":"many-to-one","fkcolumn":"physicalID","name":"physical"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"referencedExpressionValue":{"ormtype":"string","hb_populateenabled":false,"name":"referencedExpressionValue"},"referencedRelationshipFlag":{"ormtype":"boolean","hb_populateenabled":false,"default":false,"name":"referencedRelationshipFlag"},"referencedExpressionEntity":{"ormtype":"string","hb_populateenabled":false,"name":"referencedExpressionEntity"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustment":{"cfc":"StockAdjustment","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentID","name":"stockAdjustment"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"referencedExpressionStart":{"ormtype":"integer","hb_populateenabled":false,"name":"referencedExpressionStart"}};
                	entities['CommentRelationship'].className = 'CommentRelationship';
                	validations['CommentRelationship'] = {"properties":{}};
                	defaultValues['CommentRelationship'] = {
                	commentRelationshipID:'',
										referencedRelationshipFlag:false,
									referencedExpressionStart:null,
									referencedExpressionEnd:null,
									referencedExpressionEntity:null,
									referencedExpressionProperty:null,
									referencedExpressionValue:null,
									
						z:''
	                };
                
                	entities['WorkflowTaskAction'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"printTemplate":{"cfc":"PrintTemplate","fieldtype":"many-to-one","fkcolumn":"printTemplateID","name":"printTemplate"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"emailTemplate":{"cfc":"EmailTemplate","fieldtype":"many-to-one","fkcolumn":"emailTemplateID","name":"emailTemplate"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"actionTypeOptions":{"persistent":false,"name":"actionTypeOptions"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"workflowTaskActionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"workflowTaskActionID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"actionType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"actionType"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"workflowTask":{"cfc":"WorkflowTask","fieldtype":"many-to-one","fkcolumn":"workflowTaskID","name":"workflowTask"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"updateDataStruct":{"persistent":false,"type":"struct","name":"updateDataStruct"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"updateData":{"length":8000,"hb_formfieldtype":"json","hb_auditable":false,"ormtype":"string","name":"updateData"}};
                	entities['WorkflowTaskAction'].className = 'WorkflowTaskAction';
                	validations['WorkflowTaskAction'] = {"properties":{}};
                	defaultValues['WorkflowTaskAction'] = {
                	workflowTaskActionID:'',
										actionType:null,
									updateData:angular.fromJson('{"staticData":{},"dynamicData":{}}'),
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Location'] = {"locationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"locationID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"locationConfigurations":{"cfc":"LocationConfiguration","fieldtype":"one-to-many","singularname":"locationConfiguration","cascade":"all-delete-orphan","fkcolumn":"locationID","type":"array","inverse":true,"name":"locationConfigurations"},"primaryAddress":{"cfc":"LocationAddress","fieldtype":"many-to-one","fkcolumn":"locationAddressID","name":"primaryAddress"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"baseLocation":{"persistent":false,"type":"string","name":"baseLocation"},"physicals":{"cfc":"Physical","linktable":"SwPhysicalLocation","fieldtype":"many-to-many","singularname":"physical","inversejoincolumn":"physicalID","fkcolumn":"locationID","inverse":true,"type":"array","name":"physicals"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"locationAddresses":{"cfc":"LocationAddress","fieldtype":"one-to-many","singularname":"locationAddress","cascade":"all-delete-orphan","fkcolumn":"locationID","type":"array","inverse":true,"name":"locationAddresses"},"validations":{"persistent":false,"type":"struct","name":"validations"},"locationName":{"ormtype":"string","name":"locationName"},"remoteID":{"ormtype":"string","name":"remoteID"},"childLocations":{"cfc":"Location","fieldtype":"one-to-many","singularname":"childLocation","cascade":"all","fkcolumn":"parentLocationID","inverse":true,"type":"array","name":"childLocations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"parentLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"parentLocationID","name":"parentLocation"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"locationID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stocks":{"cfc":"Stock","fieldtype":"one-to-many","lazy":"extra","cascade":"all-delete-orphan","singularname":"stock","fkcolumn":"locationID","inverse":true,"type":"array","name":"stocks"},"locationPathName":{"persistent":false,"name":"locationPathName"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"locationIDPath":{"ormtype":"string","name":"locationIDPath"}};
                	entities['Location'].className = 'Location';
                	validations['Location'] = {"properties":{"locationName":[{"contexts":"save","required":true}],"primaryAddress":[{"contexts":"save","required":true}],"physicals":[{"contexts":"delete","maxCollection":0}],"stocks":[{"contexts":"delete","maxCollection":0}],"physicalCounts":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['Location'] = {
                	locationID:'',
										locationIDPath:'',
										locationName:null,
									activeFlag:1,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockReceiverItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"vendorOrderItem":{"cfc":"VendorOrderItem","fieldtype":"many-to-one","fkcolumn":"vendorOrderItemID","name":"vendorOrderItem"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"stockID","name":"stock"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"cost":{"ormtype":"big_decimal","name":"cost"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"stockReceiver":{"cfc":"StockReceiver","fieldtype":"many-to-one","fkcolumn":"stockReceiverID","name":"stockReceiver"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockReceiverItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockReceiverItemID"},"stockAdjustmentItem":{"cfc":"StockAdjustmentItem","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentItemID","name":"stockAdjustmentItem"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockReceiverItem'].className = 'StockReceiverItem';
                	validations['StockReceiverItem'] = {"properties":{}};
                	defaultValues['StockReceiverItem'] = {
                	stockReceiverItemID:'',
										quantity:null,
									cost:null,
									currencyCode:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['ProductBundleGroup'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"skuCollectionConfig":{"length":8000,"hb_formfieldtype":"json","hb_auditable":false,"ormtype":"string","name":"skuCollectionConfig"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"hb_formfieldtype":"number","ormtype":"big_decimal","default":0,"name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"minimumQuantity":{"hb_formfieldtype":"number","ormtype":"integer","default":1,"name":"minimumQuantity"},"amountType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"amountType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"maximumQuantity":{"hb_formfieldtype":"number","ormtype":"integer","default":1,"name":"maximumQuantity"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"productBundleGroupID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productBundleGroupID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"amountTypeOptions":{"persistent":false,"name":"amountTypeOptions"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"productBundleGroupType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=productBundleGroupType","fkcolumn":"productBundleGroupTypeID","name":"productBundleGroupType"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"productBundleGroupID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"productBundleSku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"productBundleSkuID","name":"productBundleSku"}};
                	entities['ProductBundleGroup'].className = 'ProductBundleGroup';
                	validations['ProductBundleGroup'] = {"properties":{}};
                	defaultValues['ProductBundleGroup'] = {
                	productBundleGroupID:'',
										activeFlag:1,
									minimumQuantity:1,
									maximumQuantity:1,
									amountType:null,
									amount:0,
									skuCollectionConfig:angular.fromJson('{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"_sku","columns":[{"title":"skuID","isVisible":true,"propertyIdentifier":"_sku.skuID"},{"title":"Active","isVisible":true,"propertyIdentifier":"_sku.activeFlag"},{"title":"Published","isVisible":true,"propertyIdentifier":"_sku.publishedFlag"},{"title":"Sku Name","isVisible":true,"propertyIdentifier":"_sku.skuName"},{"title":"Sku Description","isVisible":true,"propertyIdentifier":"_sku.skuDescription"},{"title":"SKU Code","isVisible":true,"propertyIdentifier":"_sku.skuCode"},{"title":"List Price","isVisible":true,"propertyIdentifier":"_sku.listPrice"},{"title":"Price","isVisible":true,"propertyIdentifier":"_sku.price"},{"title":"Renewal Price","isVisible":true,"propertyIdentifier":"_sku.renewalPrice"}],"baseEntityName":"Sku"}'),
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderReturn'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"returnLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"returnLocationID","hb_populateenabled":"public","name":"returnLocation"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"orderReturnID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderReturnID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderReturnItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"orderReturnItem","cascade":"all","fkcolumn":"orderReturnID","hb_populateenabled":"public","inverse":true,"name":"orderReturnItems"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"fulfillmentRefundAmount":{"ormtype":"big_decimal","name":"fulfillmentRefundAmount"}};
                	entities['OrderReturn'].className = 'OrderReturn';
                	validations['OrderReturn'] = {"properties":{"orderStatusCode":[{"contexts":"edit,delete","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"}]}};
                	defaultValues['OrderReturn'] = {
                	orderReturnID:'',
										fulfillmentRefundAmount:0,
									currencyCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderReturn_Receive'] = {"locationID":{"hb_rbkey":"entity.location","hb_formfieldtype":"select","name":"locationID"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderReturn":{"name":"orderReturn"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"orderReturnItems":{"type":"array","name":"orderReturnItems","hb_populatearray":true},"packingSlipNumber":{"hb_rbkey":"entity.stockReceiver.packingSlipNumber","name":"packingSlipNumber"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"boxCount":{"hb_rbkey":"entity.stockReceiver.boxCount","name":"boxCount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderReturn_Receive'].className = 'OrderReturn_Receive';
                	validations['OrderReturn_Receive'] = {"properties":{}};
                	defaultValues['OrderReturn_Receive'] = {
                	orderReturn:'',
										locationID:'',
									packingSlipNumber:'',
									boxCount:'',
									orderReturnItems:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['PaymentTransaction'] = {"providerTransactionID":{"ormtype":"string","name":"providerTransactionID"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"authorizationCodeInvalidFlag":{"ormtype":"boolean","name":"authorizationCodeInvalidFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"amountCharged":{"notnull":true,"dbdefault":0,"ormtype":"big_decimal","name":"amountCharged"},"accountPayment":{"cfc":"AccountPayment","fieldtype":"many-to-one","fkcolumn":"accountPaymentID","name":"accountPayment"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"transactionStartTickCount":{"ormtype":"string","name":"transactionStartTickCount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"transactionType":{"ormtype":"string","name":"transactionType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"avsDescription":{"persistent":false,"name":"avsDescription"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"amountCredited":{"notnull":true,"dbdefault":0,"ormtype":"big_decimal","name":"amountCredited"},"validations":{"persistent":false,"type":"struct","name":"validations"},"transactionDateTime":{"ormtype":"timestamp","name":"transactionDateTime"},"accountPaymentMethod":{"cfc":"AccountPaymentMethod","fieldtype":"many-to-one","fkcolumn":"accountPaymentMethodID","name":"accountPaymentMethod"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"authorizationCode":{"ormtype":"string","name":"authorizationCode"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"securityCodeMatchFlag":{"ormtype":"boolean","name":"securityCodeMatchFlag"},"paymentTransactionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"paymentTransactionID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"avsCode":{"ormtype":"string","name":"avsCode"},"transactionEndTickCount":{"ormtype":"string","name":"transactionEndTickCount"},"message":{"length":4000,"ormtype":"string","name":"message"},"transactionSuccessFlag":{"ormtype":"boolean","name":"transactionSuccessFlag"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"statusCode":{"ormtype":"string","name":"statusCode"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"amountAuthorized":{"notnull":true,"dbdefault":0,"ormtype":"big_decimal","name":"amountAuthorized"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"authorizationCodeUsed":{"ormtype":"string","name":"authorizationCodeUsed"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderPayment":{"cfc":"OrderPayment","fieldtype":"many-to-one","fkcolumn":"orderPaymentID","name":"orderPayment"},"amountReceived":{"notnull":true,"dbdefault":0,"ormtype":"big_decimal","name":"amountReceived"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PaymentTransaction'].className = 'PaymentTransaction';
                	validations['PaymentTransaction'] = {"properties":{"orderPayment":[{"contexts":"save","method":"hasOrderPaymentOrAccountPayment"}],"accountPayment":[{"contexts":"save","method":"hasOrderPaymentOrAccountPayment"}],"paymentTransactionID":[{"contexts":"delete,edit","maxLength":0}]}};
                	defaultValues['PaymentTransaction'] = {
                	paymentTransactionID:'',
										transactionType:null,
									transactionStartTickCount:null,
									transactionEndTickCount:null,
									transactionSuccessFlag:null,
									providerTransactionID:null,
									transactionDateTime:null,
									authorizationCode:null,
									authorizationCodeUsed:null,
									authorizationCodeInvalidFlag:null,
									amountAuthorized:0,
									amountReceived:0,
									amountCredited:0,
									currencyCode:null,
									securityCodeMatchFlag:null,
									avsCode:null,
									statusCode:null,
									message:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									amountCharged:0,
									
						z:''
	                };
                
                	entities['Term'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"renewalSubscriptionTerms":{"cfc":"SubscriptionTerm","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"renewalSubscriptionTerm","fkcolumn":"renewalTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"renewalSubscriptionTerms"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"initialSubscriptionTerms":{"cfc":"SubscriptionTerm","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"initialSubscriptionTerm","fkcolumn":"initialTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"initialSubscriptionTerms"},"termName":{"ormtype":"string","name":"termName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"termID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"termID"},"gracePeriodSubscriptionUsageTerms":{"cfc":"SubscriptionUsage","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"gracePeriodSubscriptionUsageTerm","fkcolumn":"gracePeriodTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"gracePeriodSubscriptionUsageTerms"},"termMonths":{"ormtype":"integer","name":"termMonths"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"giftCardExpirationTerms":{"cfc":"Sku","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"giftCardExpirationTerm","fkcolumn":"giftCardExpirationTermID","inverse":true,"type":"array","name":"giftCardExpirationTerms"},"giftCards":{"cfc":"GiftCard","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"giftCard","fkcolumn":"giftCardExpirationTermID","inverse":true,"type":"array","name":"giftCards"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"termYears":{"ormtype":"integer","name":"termYears"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"paymentTerms":{"cfc":"PaymentTerm","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"paymentTerm","fkcolumn":"termID","inverse":true,"hb_populateenabled":false,"type":"array","name":"paymentTerms"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"initialSubscriptionUsageTerms":{"cfc":"SubscriptionUsage","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"initialSubscriptionUsageTerm","fkcolumn":"initialTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"initialSubscriptionUsageTerms"},"loyaltyAccruementExpirationTerms":{"cfc":"LoyaltyAccruement","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"loyaltyAccruementExpirationTerm","fkcolumn":"expirationTermID","inverse":true,"type":"array","name":"loyaltyAccruementExpirationTerms"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"termHours":{"ormtype":"integer","name":"termHours"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"gracePeriodSubscriptionTerms":{"cfc":"SubscriptionTerm","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"gracePeriodSubscriptionTerm","fkcolumn":"gracePeriodTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"gracePeriodSubscriptionTerms"},"renewalSubscriptionUsageTerms":{"cfc":"SubscriptionUsage","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"renewalSubscriptionUsageTerm","fkcolumn":"renewalTermID","inverse":true,"hb_populateenabled":false,"type":"array","name":"renewalSubscriptionUsageTerms"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"termDays":{"ormtype":"integer","name":"termDays"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"loyaltyTerms":{"cfc":"LoyaltyTerm","fieldtype":"one-to-many","lazy":"extra","cascade":"all-delete-orphan","singularname":"loyaltyTerm","fkcolumn":"termID","inverse":true,"type":"array","name":"loyaltyTerms"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Term'].className = 'Term';
                	validations['Term'] = {"properties":{"paymentTerms":[{"contexts":"delete","maxCollection":0}],"gracePeriodSubscriptionUsageTerms":[{"contexts":"delete","maxCollection":0}],"termMonths":[{"contexts":"save","dataType":"numeric"}],"renewalSubscriptionTerms":[{"contexts":"delete","maxCollection":0}],"initialSubscriptionUsageTerms":[{"contexts":"delete","maxCollection":0}],"termHours":[{"contexts":"save","dataType":"numeric"}],"initialSubscriptionTerms":[{"contexts":"delete","maxCollection":0}],"termName":[{"contexts":"save","required":true}],"termDays":[{"contexts":"save","dataType":"numeric"}],"termYears":[{"contexts":"save","dataType":"numeric"}],"gracePeriodSubscriptionTerms":[{"contexts":"delete","maxCollection":0}],"renewalSubscriptionUsageTerms":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['Term'] = {
                	termID:'',
										termName:null,
									termHours:null,
									termDays:null,
									termMonths:null,
									termYears:null,
									sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Stock'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"calculatedQNC":{"ormtype":"integer","name":"calculatedQNC"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"inventory":{"cfc":"Inventory","fieldtype":"one-to-many","lazy":"extra","singularname":"inventory","fkcolumn":"stockID","inverse":true,"name":"inventory"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"vendorOrderItems":{"cfc":"VendorOrderItem","fieldtype":"one-to-many","singularname":"vendorOrderItem","fkcolumn":"stockID","inverse":true,"name":"vendorOrderItems"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"calculatedQOH":{"ormtype":"integer","name":"calculatedQOH"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"stockID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"calculatedQATS":{"ormtype":"integer","name":"calculatedQATS"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Stock'].className = 'Stock';
                	validations['Stock'] = {"properties":{}};
                	defaultValues['Stock'] = {
                	stockID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									calculatedQATS:null,
									calculatedQOH:null,
									calculatedQNC:null,
									
						z:''
	                };
                
                	entities['Comment'] = {"primaryRelationship":{"persistent":false,"name":"primaryRelationship"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"comment":{"length":4000,"hb_formfieldtype":"textarea","ormtype":"string","name":"comment"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"commentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"commentID"},"publicFlag":{"ormtype":"boolean","name":"publicFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"commentWithLinks":{"persistent":false,"name":"commentWithLinks"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"commentRelationships":{"cfc":"CommentRelationship","fieldtype":"one-to-many","singularname":"commentRelationship","cascade":"all-delete-orphan","fkcolumn":"commentID","type":"array","inverse":true,"name":"commentRelationships"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Comment'].className = 'Comment';
                	validations['Comment'] = {"properties":{}};
                	defaultValues['Comment'] = {
                	commentID:'',
										comment:null,
									publicFlag:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['Order'] = {"totalReturnQuantity":{"persistent":false,"name":"totalReturnQuantity"},"appliedPromotions":{"cfc":"PromotionApplied","fieldtype":"one-to-many","singularname":"appliedPromotion","cascade":"all-delete-orphan","fkcolumn":"orderID","inverse":true,"name":"appliedPromotions"},"fulfillmentDiscountAmountTotal":{"persistent":false,"hb_formattype":"currency","name":"fulfillmentDiscountAmountTotal"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"assignedAccount":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"assignedAccountID","name":"assignedAccount"},"orderID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderID"},"orderDiscountAmountTotal":{"persistent":false,"hb_formattype":"currency","name":"orderDiscountAmountTotal"},"shippingAccountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"shippingAccountAddressID","hb_populateenabled":"public","name":"shippingAccountAddress"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"referencedOrderType":{"ormtype":"string","hb_formattype":"rbKey","name":"referencedOrderType"},"shippingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"shippingAddressID","hb_populateenabled":"public","name":"shippingAddress"},"dynamicCreditOrderPaymentAmount":{"persistent":false,"hb_formattype":"currency","name":"dynamicCreditOrderPaymentAmount"},"saveBillingAccountAddressFlag":{"persistent":false,"hb_populateenabled":"public","name":"saveBillingAccountAddressFlag"},"totalSaleQuantity":{"persistent":false,"name":"totalSaleQuantity"},"itemDiscountAmountTotal":{"persistent":false,"hb_formattype":"currency","name":"itemDiscountAmountTotal"},"estimatedDeliveryDateTime":{"ormtype":"timestamp","name":"estimatedDeliveryDateTime"},"orderCloseDateTime":{"ormtype":"timestamp","name":"orderCloseDateTime"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"billingAccountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"billingAccountAddressID","hb_populateenabled":"public","name":"billingAccountAddress"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all","fkcolumn":"orderID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"promotionCodeList":{"persistent":false,"name":"promotionCodeList"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"orderID","type":"array","inverse":true,"name":"attributeValues"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"saveBillingAccountAddressName":{"persistent":false,"hb_populateenabled":"public","name":"saveBillingAccountAddressName"},"taxTotal":{"persistent":false,"hb_formattype":"currency","name":"taxTotal"},"paymentMethodOptionsSmartList":{"persistent":false,"name":"paymentMethodOptionsSmartList"},"eligiblePaymentMethodDetails":{"persistent":false,"name":"eligiblePaymentMethodDetails"},"paymentAmountDue":{"persistent":false,"hb_formattype":"currency","name":"paymentAmountDue"},"saveShippingAccountAddressName":{"persistent":false,"hb_populateenabled":"public","name":"saveShippingAccountAddressName"},"promotionCodes":{"cfc":"PromotionCode","linktable":"SwOrderPromotionCode","fieldtype":"many-to-many","singularname":"promotionCode","inversejoincolumn":"promotionCodeID","fkcolumn":"orderID","name":"promotionCodes"},"subTotalAfterItemDiscounts":{"persistent":false,"hb_formattype":"currency","name":"subTotalAfterItemDiscounts"},"paymentAmountCreditedTotal":{"persistent":false,"hb_formattype":"currency","name":"paymentAmountCreditedTotal"},"orderFulfillments":{"cfc":"OrderFulfillment","fieldtype":"one-to-many","singularname":"orderFulfillment","cascade":"all-delete-orphan","fkcolumn":"orderID","hb_populateenabled":"public","inverse":true,"name":"orderFulfillments"},"dynamicChargeOrderPayment":{"persistent":false,"name":"dynamicChargeOrderPayment"},"orderPaymentAmountNeeded":{"persistent":false,"hb_formattype":"currency","name":"orderPaymentAmountNeeded"},"saleItemSmartList":{"persistent":false,"name":"saleItemSmartList"},"orderNumber":{"ormtype":"string","name":"orderNumber"},"quantityUnreceived":{"persistent":false,"name":"quantityUnreceived"},"depositItemSmartList":{"persistent":false,"name":"depositItemSmartList"},"orderOpenDateTime":{"ormtype":"timestamp","name":"orderOpenDateTime"},"orderReturns":{"cfc":"OrderReturn","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"orderReturn","fkcolumn":"orderID","inverse":true,"hb_populateenabled":"public","type":"array","name":"orderReturns"},"orderPaymentCreditAmountNeeded":{"persistent":false,"hb_formattype":"currency","name":"orderPaymentCreditAmountNeeded"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"deliveredItemsAmountTotal":{"persistent":false,"name":"deliveredItemsAmountTotal"},"quantityUndelivered":{"persistent":false,"name":"quantityUndelivered"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"paymentAmountReceivedTotal":{"persistent":false,"hb_formattype":"currency","name":"paymentAmountReceivedTotal"},"referencedOrder":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"referencedOrderID","name":"referencedOrder"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"addOrderItemStockOptionsSmartList":{"persistent":false,"name":"addOrderItemStockOptionsSmartList"},"statusCode":{"persistent":false,"name":"statusCode"},"estimatedFulfillmentDateTime":{"ormtype":"timestamp","name":"estimatedFulfillmentDateTime"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"dynamicChargeOrderPaymentAmount":{"persistent":false,"hb_formattype":"currency","name":"dynamicChargeOrderPaymentAmount"},"fulfillmentChargeAfterDiscountTotal":{"persistent":false,"hb_formattype":"currency","name":"fulfillmentChargeAfterDiscountTotal"},"orderPaymentChargeAmountNeeded":{"persistent":false,"hb_formattype":"currency","name":"orderPaymentChargeAmountNeeded"},"addOrderItemSkuOptionsSmartList":{"persistent":false,"name":"addOrderItemSkuOptionsSmartList"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"fulfillmentTotal":{"persistent":false,"hb_formattype":"currency","name":"fulfillmentTotal"},"quantityDelivered":{"persistent":false,"name":"quantityDelivered"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"totalQuantity":{"persistent":false,"name":"totalQuantity"},"orderTypeOptions":{"persistent":false,"name":"orderTypeOptions"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"quantityReceived":{"persistent":false,"name":"quantityReceived"},"discountTotal":{"persistent":false,"hb_formattype":"currency","name":"discountTotal"},"dynamicCreditOrderPayment":{"persistent":false,"name":"dynamicCreditOrderPayment"},"nextEstimatedDeliveryDateTime":{"persistent":false,"type":"timestamp","name":"nextEstimatedDeliveryDateTime"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","singularname":"orderPayment","cascade":"all-delete-orphan","fkcolumn":"orderID","hb_populateenabled":"public","inverse":true,"name":"orderPayments"},"paymentAmountTotal":{"persistent":false,"hb_formattype":"currency","name":"paymentAmountTotal"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"totalItems":{"persistent":false,"name":"totalItems"},"orderDeliveries":{"cfc":"OrderDelivery","fieldtype":"one-to-many","singularname":"orderDelivery","cascade":"delete-orphan","fkcolumn":"orderID","inverse":true,"name":"orderDeliveries"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"referencingPaymentAmountCreditedTotal":{"persistent":false,"hb_formattype":"currency","name":"referencingPaymentAmountCreditedTotal"},"referencingOrders":{"cfc":"Order","fieldtype":"one-to-many","singularname":"referencingOrder","cascade":"all-delete-orphan","fkcolumn":"referencedOrderID","inverse":true,"name":"referencingOrders"},"orderType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderType","fkcolumn":"orderTypeID","name":"orderType"},"orderStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderStatusType","fkcolumn":"orderStatusTypeID","name":"orderStatusType"},"saveShippingAccountAddressFlag":{"persistent":false,"hb_populateenabled":"public","name":"saveShippingAccountAddressFlag"},"orderPlacedSite":{"cfc":"Site","fieldtype":"many-to-one","fkcolumn":"orderPlcaedSiteID","hb_populateenabled":"public","name":"orderPlacedSite"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"orderCreatedSite":{"cfc":"Site","fieldtype":"many-to-one","fkcolumn":"orderCreatedSiteID","hb_populateenabled":"public","name":"orderCreatedSite"},"returnItemSmartList":{"persistent":false,"name":"returnItemSmartList"},"orderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"orderItem","cascade":"all-delete-orphan","fkcolumn":"orderID","hb_populateenabled":"public","inverse":true,"name":"orderItems"},"defaultStockLocationOptions":{"persistent":false,"name":"defaultStockLocationOptions"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"orderOpenIPAddress":{"ormtype":"string","name":"orderOpenIPAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"subTotal":{"persistent":false,"hb_formattype":"currency","name":"subTotal"},"billingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"billingAddressID","hb_populateenabled":"public","name":"billingAddress"},"calculatedTotal":{"ormtype":"big_decimal","name":"calculatedTotal"},"fulfillmentChargeTotal":{"persistent":false,"hb_formattype":"currency","name":"fulfillmentChargeTotal"},"total":{"persistent":false,"hb_formattype":"currency","name":"total"},"orderRequirementsList":{"persistent":false,"name":"orderRequirementsList"},"fulfillmentRefundTotal":{"persistent":false,"hb_formattype":"currency","name":"fulfillmentRefundTotal"},"addPaymentRequirementDetails":{"persistent":false,"name":"addPaymentRequirementDetails"},"stockReceivers":{"cfc":"StockReceiver","fieldtype":"one-to-many","singularname":"stockReceiver","cascade":"all-delete-orphan","fkcolumn":"orderID","type":"array","inverse":true,"name":"stockReceivers"},"nextEstimatedFulfillmentDateTime":{"persistent":false,"type":"timestamp","name":"nextEstimatedFulfillmentDateTime"},"defaultStockLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"defaultStockLocation"},"remoteID":{"ormtype":"string","name":"remoteID"},"orderPaymentRefundOptions":{"persistent":false,"name":"orderPaymentRefundOptions"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"orderOrigin":{"cfc":"OrderOrigin","fieldtype":"many-to-one","fkcolumn":"orderOriginID","hb_optionsnullrbkey":"define.none","name":"orderOrigin"}};
                	entities['Order'].className = 'Order';
                	validations['Order'] = {"properties":{"account":[{"contexts":"addOrderPayment,placeOrder","required":true}],"statusCode":[{"contexts":"placeOrder,delete","inList":"ostNotPlaced"},{"contexts":"addSaleOrderItem,addOrderPayment,addPromotionCode,updateStatus","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"},{"contexts":"cancelOrder,closeOrder","inList":"ostNew,ostProcessing,ostOnHold"},{"contexts":"createReturn","inList":"ostNew,ostProcessing,ostOnHold,ostClosed"},{"contexts":"takeOffHold","inList":"ostOnHold"},{"contexts":"placeOnHold","inList":"ostNew,ostProcessing"},{"contexts":"auditRollback","inList":"ostNotPlaced"}],"orderType":[{"contexts":"save","required":true}],"quantityReceived":[{"contexts":"cancelOrder","maxValue":0}],"orderStatusType":[{"contexts":"save","required":true}],"quantityDelivered":[{"contexts":"cancelOrder","maxValue":0},{"contexts":"createReturn","minValue":1}],"orderItems":[{"contexts":"placeOrder,addOrderPayment","minCollection":1},{"contexts":"cancelOrder","method":"canCancel"}]},"populatedPropertyValidation":{"billingAddress":[{"validate":"full"}],"shippingAddress":[{"validate":"full"}]}};
                	defaultValues['Order'] = {
                	orderID:'',
										orderNumber:'',
										currencyCode:null,
									orderOpenDateTime:null,
									orderOpenIPAddress:null,
									orderCloseDateTime:null,
									referencedOrderType:null,
									estimatedDeliveryDateTime:null,
									estimatedFulfillmentDateTime:null,
									calculatedTotal:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Order_AddOrderItem'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"locationIDOptions":{"name":"locationIDOptions"},"quantity":{"name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderItemTypeSystemCode":{"name":"orderItemTypeSystemCode"},"returnLocation":{"hb_rbkey":"entity.location","name":"returnLocation"},"attributeValuesByCodeStruct":{"name":"attributeValuesByCodeStruct"},"product":{"hb_rbkey":"entity.product","name":"product"},"shippingAddress":{"cfc":"Address","persistent":false,"fieldtype":"many-to-one","fkcolumn":"addressID","name":"shippingAddress"},"childOrderItems":{"type":"array","name":"childOrderItems","hb_populatearray":true},"price":{"name":"price"},"fulfillmentMethodType":{"name":"fulfillmentMethodType"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"fulfillmentMethod":{"hb_rbkey":"entity.fulfillmentMethod","name":"fulfillmentMethod"},"validations":{"persistent":false,"type":"struct","name":"validations"},"selectedOptionIDList":{"name":"selectedOptionIDList"},"fulfillmentMethodID":{"hb_formfieldtype":"select","name":"fulfillmentMethodID"},"saveShippingAccountAddressFlag":{"hb_formfieldtype":"yesno","name":"saveShippingAccountAddressFlag"},"orderFulfillment":{"hb_rbkey":"entity.orderFulfillment","name":"orderFulfillment"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"shippingAccountAddressID":{"hb_formfieldtype":"select","name":"shippingAccountAddressID"},"publicRemoteID":{"name":"publicRemoteID"},"location":{"hb_rbkey":"entity.location","name":"location"},"locationID":{"hb_rbkey":"entity.location","hb_formfieldtype":"select","name":"locationID"},"populatedFlag":{"name":"populatedFlag"},"orderReturn":{"hb_rbkey":"entity.orderReturn","name":"orderReturn"},"returnLocationID":{"hb_rbkey":"entity.orderReturn.returnLocation","hb_formfieldtype":"select","name":"returnLocationID"},"emailAddress":{"hb_rbkey":"entity.orderFulfillment.emailAddress","name":"emailAddress"},"assignedOrderItemAttributeSets":{"name":"assignedOrderItemAttributeSets"},"productID":{"name":"productID"},"saveShippingAccountAddressName":{"name":"saveShippingAccountAddressName"},"orderFulfillmentIDOptions":{"name":"orderFulfillmentIDOptions"},"stock":{"hb_rbkey":"entity.stock","name":"stock"},"order":{"name":"order"},"registrants":{"type":"array","name":"registrants","hb_populatearray":true},"pickupLocationID":{"hb_rbkey":"entity.orderFulfillment.pickupLocation","hb_formfieldtype":"select","name":"pickupLocationID"},"shippingAccountAddressIDOptions":{"name":"shippingAccountAddressIDOptions"},"pickupLocationIDOptions":{"name":"pickupLocationIDOptions"},"orderFulfillmentID":{"hb_formfieldtype":"select","name":"orderFulfillmentID"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"orderReturnID":{"hb_rbkey":"entity.orderReturn","hb_formfieldtype":"select","name":"orderReturnID"},"stockID":{"name":"stockID"},"skuID":{"name":"skuID"},"currencyCode":{"name":"currencyCode"},"returnLocationIDOptions":{"name":"returnLocationIDOptions"},"orderReturnIDOptions":{"name":"orderReturnIDOptions"},"sku":{"hb_rbkey":"entity.sku","name":"sku"},"fulfillmentMethodIDOptions":{"name":"fulfillmentMethodIDOptions"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"fulfillmentRefundAmount":{"hb_rbkey":"entity.orderReturn.fulfillmentRefundAmount","name":"fulfillmentRefundAmount"}};
                	entities['Order_AddOrderItem'].className = 'Order_AddOrderItem';
                	validations['Order_AddOrderItem'] = {"properties":{"preProcessDisplayedFlag":[{"conditions":"newOrderFulfillment,newOrderReturn,customizationsExist","eq":1}],"price":[{"dataType":"numeric","required":true,"minValue":0}],"quantity":[{"dataType":"numeric","required":true,"minValue":1},{"lteProperty":"sku.qats","conditions":"itemIsSku"},{"lteProperty":"stock.qats","conditions":"itemIsStock"}],"emailAddress":[{"dataType":"email"}],"orderFulfillmentID":[],"sku":[{"required":true}],"orderReturnID":[]},"conditions":{"existingOrderReturn":{"orderReturn":{"null":false}},"orderItemTypeSale":{"orderItemTypeSystemCode":{"eq":"oitSale"}},"orderItemTypeReturn":{"orderItemTypeSystemCode":{"eq":"oitReturn"}},"newOrderReturn":{"orderReturn":{"null":true},"orderItemTypeSystemCode":{"eq":"oitReturn"}},"itemIsSku":{"stock":{"null":true}},"itemIsStock":{"stock":{"null":false}},"newOrderFulfillment":{"orderFulfillment":{"null":true},"orderItemTypeSystemCode":{"eq":"oitSale"}},"customizationsExist":{"assignedOrderItemAttributeSets":{"minCollection":1}},"existingOrderFulfillment":{"orderFulfillment":{"null":false}},"newShippingOrderFulfillmentWithNewAddress":{"fulfillmentMethodType":{"eq":"shipping"},"shippingAccountAddressID":{"eq":"new"},"orderFulfillmentID":{"eq":""}}},"populatedPropertyValidation":{"shippingAddress":[{"conditions":"existingOrderFulfillment","validate":false},{"conditions":"newShippingOrderFulfillmentWithNewAddress","validate":"full"}]}};
                	defaultValues['Order_AddOrderItem'] = {
                	order:'',
										stock:'',
									sku:'',
									product:'',
									location:'',
									orderFulfillment:'',
									orderReturn:'',
									returnLocation:'',
									fulfillmentMethod:'',
									stockID:'',
									skuID:'',
									productID:'',
									locationID:'',
									returnLocationID:'',
									selectedOptionIDList:'',
									orderFulfillmentID:"new",
										orderReturnID:"new",
										fulfillmentMethodID:'',
									shippingAccountAddressID:'',
									pickupLocationID:'',
									price:0,
										currencyCode:"USD",
										quantity:1,
										orderItemTypeSystemCode:"oitSale",
										saveShippingAccountAddressFlag:1,
										saveShippingAccountAddressName:'',
									fulfillmentRefundAmount:0,
										emailAddress:'',
									registrants:'',
									childOrderItems:[],
										publicRemoteID:'',
									attributeValuesByCodeStruct:'',
									fulfillmentMethodIDOptions:[{"fulfillmentMethodType":"email","name":"Email","value":"4028288b4f8438a1014f8477188f0095"},{"fulfillmentMethodType":"shipping","name":"Shipping","value":"444df2fb93d5fa960ba2966ba2017953"},{"fulfillmentMethodType":"auto","name":"Auto","value":"444df2ffeca081dc22f69c807d2bd8fe"},{"fulfillmentMethodType":"attend","name":"Attend Event","value":"444df300bf377327cd0e44f4b16be38e"},{"fulfillmentMethodType":"shipping","name":"TestRunner","value":"db6b606861a744629ea3a6808a39a161"}],
										locationIDOptions:[{"value":"88e6d435d3ac2e5947c81ab3da60eba2","name":"Default"}],
										orderFulfillmentIDOptions:[{"value":"new","name":"New"}],
										orderReturnIDOptions:[{"value":"new","name":"New"}],
										pickupLocationIDOptions:[{"value":"88e6d435d3ac2e5947c81ab3da60eba2","name":"Default"}],
										returnLocationIDOptions:[{"value":"88e6d435d3ac2e5947c81ab3da60eba2","name":"Default"}],
										assignedOrderItemAttributeSets:[],
										fulfillmentMethodType:"",
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_AddOrderPayment'] = {"newOrderPayment":{"cfc":"OrderPayment","persistent":false,"fieldtype":"many-to-one","fkcolumn":"orderPaymentID","name":"newOrderPayment"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"previousOrderPaymentID":{"hb_rbkey":"entity.previousOrderPayment","hb_formfieldtype":"select","name":"previousOrderPaymentID"},"paymentTermIDOptions":{"name":"paymentTermIDOptions"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"saveGiftCardToAccountFlag":{"hb_formfieldtype":"yesno","name":"saveGiftCardToAccountFlag"},"saveAccountPaymentMethodFlag":{"hb_formfieldtype":"yesno","name":"saveAccountPaymentMethodFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"copyFromType":{"hb_rbkey":"entity.copyFromType","hb_formfieldtype":"select","ormtype":"string","name":"copyFromType"},"saveAccountPaymentMethodName":{"hb_rbkey":"entity.accountPaymentMethod.accountPaymentMethodName","name":"saveAccountPaymentMethodName"},"copyFromTypeOptions":{"name":"copyFromTypeOptions"},"accountAddressID":{"hb_rbkey":"entity.accountAddress","hb_formfieldtype":"select","name":"accountAddressID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"accountPaymentMethodIDOptions":{"name":"accountPaymentMethodIDOptions"},"order":{"name":"order"},"attributeValuesByCodeStruct":{"name":"attributeValuesByCodeStruct"},"previousOrderPaymentIDOptions":{"name":"previousOrderPaymentIDOptions"},"paymentMethodIDOptions":{"name":"paymentMethodIDOptions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"accountPaymentMethodID":{"hb_rbkey":"entity.accountPaymentMethod","hb_formfieldtype":"select","name":"accountPaymentMethodID"},"accountAddressIDOptions":{"name":"accountAddressIDOptions"}};
                	entities['Order_AddOrderPayment'].className = 'Order_AddOrderPayment';
                	validations['Order_AddOrderPayment'] = {"properties":{"newOrderPayment.currencyCode":[{"conditions":"giftCardPayment,redeemGiftCardToAccount,giftCardOrderTypeReturn","method":"giftCardCurrencyMatches"}],"newOrderPayment.giftCardNumberEncrypted":[{"conditions":"redeemGiftCardToAccount","method":"canRedeemGiftCardToAccount"}],"newOrderPayment.paymentMethodID":[{"conditions":"giftCardOrderTypeReturn","eq":"50d8cd61009931554764385482347f3a"}],"newOrderPayment.dynamicAmountFlag":[{"conditions":"noPaymentAmountNeeded","eq":false}]},"conditions":{"giftCardOrderTypeReturn":{"newOrderPayment":{"method":"isGiftCardReturnOrderPayment"},"order.typeCode":{"eq":"otReturnOrder"}},"orderTypeReturn":{"order.typeCode":{"eq":"otReturnOrder"}},"redeemGiftCardToAccount":{"saveGiftCardToAccountFlag":{"eq":true},"newOrderPayment.paymentMethodID":{"eq":"50d8cd61009931554764385482347f3a"}},"giftCardPayment":{"saveGiftCardToAccountFlag":{"eq":false},"newOrderPayment.paymentMethodID":{"eq":"50d8cd61009931554764385482347f3a"}},"noPaymentAmountNeeded":{"order.orderPaymentAmountNeeded":{"eq":0}}},"populatedPropertyValidation":{"newOrderPayment":[{"validate":false}]}};
                	defaultValues['Order_AddOrderPayment'] = {
                	order:'',
										copyFromType:"",
										accountPaymentMethodID:"",
										accountAddressID:"",
										previousOrderPaymentID:"",
										saveAccountPaymentMethodFlag:0,
										saveAccountPaymentMethodName:'',
									saveGiftCardToAccountFlag:'',
									attributeValuesByCodeStruct:'',
									accountPaymentMethodIDOptions:[],
										previousOrderPaymentIDOptions:[],
										paymentMethodIDOptions:[],
										accountAddressIDOptions:[{"VALUE":"","NAME":"New"}],
										paymentTermIDOptions:[{"VALUE":"","NAME":"Select"},{"VALUE":"27f223d1a5b7cba92e783c926e29efc6","NAME":"Net 30"},{"VALUE":"27f223d2f018f5737a2b82838c4027e9","NAME":"Net 60"},{"VALUE":"27f223d3b4b878a2771226a03417a764","NAME":"Net 90"}],
										copyFromTypeOptions:[{"VALUE":"","NAME":"New"}],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_AddPromotionCode'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"order":{"name":"order"},"populatedFlag":{"name":"populatedFlag"},"promotionCode":{"hb_rbkey":"entity.promotionCode.promotionCode","name":"promotionCode"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Order_AddPromotionCode'].className = 'Order_AddPromotionCode';
                	validations['Order_AddPromotionCode'] = {"properties":{"promotionCode":[{"required":true,"method":"promotionCodeNotAlreadyApplied"}]}};
                	defaultValues['Order_AddPromotionCode'] = {
                	order:'',
										promotionCode:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_ChangeCurrencyCode'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"order":{"name":"order"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"currencyCode":{"name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Order_ChangeCurrencyCode'].className = 'Order_ChangeCurrencyCode';
                	validations['Order_ChangeCurrencyCode'] = {"properties":{}};
                	defaultValues['Order_ChangeCurrencyCode'] = {
                	order:'',
										currencyCode:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_Create'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"phoneNumber":{"name":"phoneNumber"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"newAccountFlag":{"name":"newAccountFlag"},"emailAddress":{"name":"emailAddress"},"firstName":{"hb_rbkey":"entity.account.firstName","name":"firstName"},"orderOriginID":{"hb_rbkey":"entity.orderOrigin","hb_formfieldtype":"select","name":"orderOriginID"},"order":{"name":"order"},"lastName":{"hb_rbkey":"entity.account.lastName","name":"lastName"},"accountID":{"cfc":"Account","hb_rbkey":"entity.account","hb_formfieldtype":"textautocomplete","name":"accountID"},"orderTypeID":{"hb_rbkey":"entity.order.orderType","hb_formfieldtype":"select","name":"orderTypeID"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"defaultStockLocationID":{"hb_rbkey":"entity.order.defaultStockLocation","hb_formfieldtype":"select","name":"defaultStockLocationID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"createAuthenticationFlag":{"hb_rbkey":"processObject.account_create.createAuthenticationFlag","name":"createAuthenticationFlag"},"passwordConfirm":{"name":"passwordConfirm"},"currencyCode":{"hb_rbkey":"entity.currency","hb_formfieldtype":"select","name":"currencyCode"},"company":{"hb_rbkey":"entity.account.company","name":"company"},"validations":{"persistent":false,"type":"struct","name":"validations"},"password":{"name":"password"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"emailAddressConfirm":{"name":"emailAddressConfirm"},"fulfillmentMethodIDOptions":{"name":"fulfillmentMethodIDOptions"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Order_Create'].className = 'Order_Create';
                	validations['Order_Create'] = {"properties":{"password":[{"conditions":"savePasswordSelected","eqProperty":"passwordConfirm","required":true,"minLength":6}],"lastName":[{"conditions":"newAccountSelected","required":true}],"accountID":[{"conditions":"existingAccountSelected","required":true}],"emailAddress":[{"conditions":"savePasswordSelected","required":true},{"dataType":"email"},{"conditions":"newAccountSelected","eqProperty":"emailAddressConfirm"}],"firstName":[{"conditions":"newAccountSelected","required":true}],"passwordConfirm":[{"conditions":"savePasswordSelected","required":true}],"emailAddressConfirm":[{"conditions":"savePasswordSelected","required":true}]},"conditions":{"newAccountSelected":{"newAccountFlag":{"eq":1}},"savePasswordSelected":{"newAccountFlag":{"eq":1},"createAuthenticationFlag":{"eq":1}},"existingAccountSelected":{"newAccountFlag":{"eq":0}}}};
                	defaultValues['Order_Create'] = {
                	order:'',
										orderTypeID:"444df2df9f923d6c6fd0942a466e84cc",
										currencyCode:'',
									newAccountFlag:1,
										accountID:'',
									firstName:'',
									lastName:'',
									company:'',
									phoneNumber:'',
									emailAddress:'',
									emailAddressConfirm:'',
									createAuthenticationFlag:0,
										password:'',
									passwordConfirm:'',
									orderOriginID:'',
									defaultStockLocationID:'',
									fulfillmentMethodIDOptions:[{"name":"Email","value":"4028288b4f8438a1014f8477188f0095"},{"name":"Shipping","value":"444df2fb93d5fa960ba2966ba2017953"},{"name":"Auto","value":"444df2ffeca081dc22f69c807d2bd8fe"},{"name":"Attend Event","value":"444df300bf377327cd0e44f4b16be38e"},{"name":"TestRunner","value":"db6b606861a744629ea3a6808a39a161"}],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_CreateReturn'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"receiveItemsFlag":{"hb_sessiondefault":0,"hb_formfieldtype":"yesno","name":"receiveItemsFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"order":{"name":"order"},"refundOrderPaymentID":{"hb_formfieldtype":"select","name":"refundOrderPaymentID"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"orderTypeCode":{"hb_rbkey":"entity.order.orderType","hb_formfieldtype":"select","name":"orderTypeCode"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"orderItems":{"type":"array","name":"orderItems","hb_populatearray":true},"fulfillmentRefundAmount":{"name":"fulfillmentRefundAmount"}};
                	entities['Order_CreateReturn'].className = 'Order_CreateReturn';
                	validations['Order_CreateReturn'] = {"properties":{"fulfillmentRefundAmount":[{"dataType":"numeric","minValue":0}]}};
                	defaultValues['Order_CreateReturn'] = {
                	order:'',
										orderItems:[],
										fulfillmentRefundAmount:0,
										refundOrderPaymentID:"",
										receiveItemsFlag:0,
										orderTypeCode:"otReturnOrder",
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Order_UpdateOrderFulfillment'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"order":{"name":"order"},"orderItemIDList":{"name":"orderItemIDList"},"populatedFlag":{"name":"populatedFlag"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"orderItems":{"hb_populateenabled":false,"name":"orderItems"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Order_UpdateOrderFulfillment'].className = 'Order_UpdateOrderFulfillment';
                	validations['Order_UpdateOrderFulfillment'] = {"properties":{"orderItemIDList":[{"required":true}],"orderFulfillment":[{"required":true,"method":"getOrderFulfillmentMatchesOrderFlag"}]},"conditions":{"newAccountSelected":{"newAccountFlag":{"eq":1}},"savePasswordSelected":{"newAccountFlag":{"eq":1},"createAuthenticationFlag":{"eq":1}},"existingAccountSelected":{"newAccountFlag":{"eq":0}}}};
                	defaultValues['Order_UpdateOrderFulfillment'] = {
                	order:'',
										orderItemIDList:'',
									orderItems:[],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['LoyaltyRedemption'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"excludedBrands":{"cfc":"Brand","linktable":"SwLoyaltyRedemptionExclBrand","fieldtype":"many-to-many","singularname":"excludedBrand","inversejoincolumn":"brandID","fkcolumn":"loyaltyRedemptionID","type":"array","name":"excludedBrands"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"loyalty":{"cfc":"Loyalty","fieldtype":"many-to-one","fkcolumn":"loyaltyID","name":"loyalty"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwLoyaltyRedemptionBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"loyaltyRedemptionID","name":"brands"},"skus":{"cfc":"Sku","linktable":"SwLoyaltyRedemptionSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"loyaltyRedemptionID","name":"skus"},"redemptionType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"redemptionType"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"ormtype":"big_decimal","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"loyaltyTerm":{"cfc":"LoyaltyTerm","fieldtype":"many-to-one","fkcolumn":"loyaltyTermID","name":"loyaltyTerm"},"excludedSkus":{"cfc":"Sku","linktable":"SwLoyaltyRedemptionExclSku","fieldtype":"many-to-many","singularname":"excludedSku","inversejoincolumn":"skuID","fkcolumn":"loyaltyRedemptionID","name":"excludedSkus"},"amountType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"amountType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"excludedProducts":{"cfc":"Product","linktable":"SwLoyaltyRedemptionExclProduct","fieldtype":"many-to-many","singularname":"excludedProduct","inversejoincolumn":"productID","fkcolumn":"loyaltyRedemptionID","name":"excludedProducts"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"productTypes":{"cfc":"ProductType","linktable":"SwLoyaltyRedemptionProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"loyaltyRedemptionID","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all-delete-orphan","fkcolumn":"loyaltyRedemptionID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"autoRedemptionType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"autoRedemptionType"},"excludedProductTypes":{"cfc":"ProductType","linktable":"SwLoyaltyRedempExclProductType","fieldtype":"many-to-many","singularname":"excludedProductType","inversejoincolumn":"productTypeID","fkcolumn":"loyaltyRedemptionID","name":"excludedProductTypes"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"priceGroup":{"cfc":"PriceGroup","fieldtype":"many-to-one","fkcolumn":"priceGroupID","name":"priceGroup"},"products":{"cfc":"Product","linktable":"SwLoyaltyRedemptionProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"loyaltyRedemptionID","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"loyaltyRedemptionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"loyaltyRedemptionID"},"minimumPointQuantity":{"ormtype":"integer","name":"minimumPointQuantity"},"redemptionPointType":{"hb_formfieldtype":"select","ormtype":"string","name":"redemptionPointType"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"nextRedemptionDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","name":"nextRedemptionDateTime"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['LoyaltyRedemption'].className = 'LoyaltyRedemption';
                	validations['LoyaltyRedemption'] = {"properties":{"amount":[{"contexts":"save","dataType":"numeric"}],"priceGroup":[{"contexts":"save","conditions":"redemptionTypePriceGroupAssignment","required":true}],"minimumPointQuantity":[{"contexts":"save","dataType":"numeric"}]},"conditions":{"redemptionTypePriceGroupAssignment":{"redemptionType":{"eq":"priceGroupAssignment"}}}};
                	defaultValues['LoyaltyRedemption'] = {
                	loyaltyRedemptionID:'',
										redemptionPointType:null,
									redemptionType:null,
									autoRedemptionType:null,
									amountType:null,
									amount:null,
									activeFlag:1,
									nextRedemptionDateTime:null,
									currencyCode:null,
									minimumPointQuantity:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Category'] = {"childCategories":{"cfc":"Category","fieldtype":"one-to-many","singularname":"childCategory","cascade":"all-delete-orphan","fkcolumn":"parentCategoryID","type":"array","inverse":true,"name":"childCategories"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"allowProductAssignmentFlag":{"ormtype":"boolean","name":"allowProductAssignmentFlag"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"contents":{"cfc":"Content","linktable":"SwContentCategory","fieldtype":"many-to-many","singularname":"content","inversejoincolumn":"contentID","fkcolumn":"categoryID","inverse":true,"type":"array","name":"contents"},"restrictAccessFlag":{"ormtype":"boolean","name":"restrictAccessFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"cmsCategoryID":{"ormtype":"string","index":"RI_CMSCATEGORYID","name":"cmsCategoryID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"categoryName":{"ormtype":"string","name":"categoryName"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"site":{"cfc":"Site","fieldtype":"many-to-one","fkcolumn":"siteID","name":"site"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"categoryIDPath":{"length":4000,"ormtype":"string","name":"categoryIDPath"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"categoryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"categoryID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"hint":"Only used when integrated with a remote system","ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"parentCategory":{"cfc":"Category","fieldtype":"many-to-one","fkcolumn":"parentCategoryID","name":"parentCategory"},"products":{"cfc":"Product","linktable":"SwProductCategory","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"categoryID","inverse":true,"name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Category'].className = 'Category';
                	validations['Category'] = {"properties":{}};
                	defaultValues['Category'] = {
                	categoryID:'',
										categoryIDPath:null,
									categoryName:null,
									restrictAccessFlag:null,
									allowProductAssignmentFlag:null,
									cmsCategoryID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['TaxCategory'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"taxCategoryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taxCategoryID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"taxCategoryRates":{"cfc":"TaxCategoryRate","fieldtype":"one-to-many","singularname":"taxCategoryRate","cascade":"all-delete-orphan","fkcolumn":"taxCategoryID","type":"array","inverse":true,"name":"taxCategoryRates"},"taxCategoryCode":{"ormtype":"string","index":"PI_TAXCATEGORYCODE","name":"taxCategoryCode"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taxCategoryRatesDeletableFlag":{"persistent":false,"type":"boolean","name":"taxCategoryRatesDeletableFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"taxCategoryName":{"ormtype":"string","name":"taxCategoryName"}};
                	entities['TaxCategory'].className = 'TaxCategory';
                	validations['TaxCategory'] = {"properties":{"taxCategoryCode":[{"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$","required":true}],"taxCategoryName":[{"contexts":"save","required":true}]}};
                	defaultValues['TaxCategory'] = {
                	taxCategoryID:'',
										activeFlag:1,
									taxCategoryName:null,
									taxCategoryCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['TaskSchedule'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"successEmailList":{"ormtype":"string","name":"successEmailList"},"nextRunDateTime":{"ormtype":"timestamp","name":"nextRunDateTime"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"schedule":{"cfc":"Schedule","fieldtype":"many-to-one","fkcolumn":"scheduleID","name":"schedule"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"startDateTime":{"ormtype":"timestamp","name":"startDateTime"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"task":{"cfc":"Task","fieldtype":"many-to-one","fkcolumn":"taskID","name":"task"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"taskScheduleID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taskScheduleID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"endDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"failureEmailList":{"ormtype":"string","name":"failureEmailList"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['TaskSchedule'].className = 'TaskSchedule';
                	validations['TaskSchedule'] = {"properties":{"task":[{"contexts":"save","required":true}],"schedule":[{"contexts":"save","required":true}],"startDateTime":[{"contexts":"save","required":true}]}};
                	defaultValues['TaskSchedule'] = {
                	taskScheduleID:'',
										startDateTime:null,
									endDateTime:null,
									nextRunDateTime:null,
									failureEmailList:null,
									successEmailList:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SkuCurrency'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"renewalPrice":{"hb_rbkey":"entity.sku.renewalPrice","ormtype":"big_decimal","hb_formattype":"currency","default":0,"name":"renewalPrice"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"skuCurrencyID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"skuCurrencyID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"listPrice":{"hb_rbkey":"entity.sku.listPrice","ormtype":"big_decimal","hb_formattype":"currency","default":0,"name":"listPrice"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"currency":{"cfc":"Currency","fieldtype":"many-to-one","fkcolumn":"currencyCode","name":"currency"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"price":{"hb_rbkey":"entity.sku.price","ormtype":"big_decimal","hb_formattype":"currency","name":"price"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"insert":false,"update":false,"name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SkuCurrency'].className = 'SkuCurrency';
                	validations['SkuCurrency'] = {"properties":{"price":[{"contexts":"save","dataType":"numeric","required":true,"minValue":0}],"renewalPrice":[{"contexts":"save","dataType":"numeric","minValue":0}],"listPrice":[{"contexts":"save","dataType":"numeric","minValue":0}]}};
                	defaultValues['SkuCurrency'] = {
                	skuCurrencyID:'',
										price:null,
									renewalPrice:0,
									listPrice:0,
									currencyCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionReward'] = {"promotionRewardID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionRewardID"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"promotionRewardCurrencies":{"cfc":"PromotionRewardCurrency","fieldtype":"one-to-many","singularname":"promotionRewardCurrency","cascade":"all-delete-orphan","fkcolumn":"promotionRewardID","type":"array","inverse":true,"name":"promotionRewardCurrencies"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwPromoRewardBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"promotionRewardID","name":"brands"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"ormtype":"big_decimal","hb_formattype":"custom","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"amountType":{"ormtype":"string","hb_formattype":"rbKey","name":"amountType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"excludedOptions":{"cfc":"Option","linktable":"SwPromoRewardExclOption","fieldtype":"many-to-many","singularname":"excludedOption","inversejoincolumn":"optionID","fkcolumn":"promotionRewardID","type":"array","name":"excludedOptions"},"excludedProducts":{"cfc":"Product","linktable":"SwPromoRewardExclProduct","fieldtype":"many-to-many","singularname":"excludedProduct","inversejoincolumn":"productID","fkcolumn":"promotionRewardID","name":"excludedProducts"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"applicableTermOptions":{"persistent":false,"name":"applicableTermOptions"},"fulfillmentMethods":{"cfc":"FulfillmentMethod","linktable":"SwPromoRewardFulfillmentMethod","fieldtype":"many-to-many","singularname":"fulfillmentMethod","inversejoincolumn":"fulfillmentMethodID","fkcolumn":"promotionRewardID","name":"fulfillmentMethods"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"amountTypeOptions":{"persistent":false,"name":"amountTypeOptions"},"productTypes":{"cfc":"ProductType","linktable":"SwPromoRewardProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"promotionRewardID","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"options":{"cfc":"Option","linktable":"SwPromoRewardOption","fieldtype":"many-to-many","singularname":"option","inversejoincolumn":"optionID","fkcolumn":"promotionRewardID","name":"options"},"rewardType":{"ormtype":"string","hb_formattype":"rbKey","name":"rewardType"},"validations":{"persistent":false,"type":"struct","name":"validations"},"products":{"cfc":"Product","linktable":"SwPromoRewardProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"promotionRewardID","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"applicableTerm":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"applicableTerm"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionPeriod":{"cfc":"PromotionPeriod","fieldtype":"many-to-one","fkcolumn":"promotionPeriodID","name":"promotionPeriod"},"roundingRule":{"cfc":"RoundingRule","fieldtype":"many-to-one","fkcolumn":"roundingRuleID","hb_optionsnullrbkey":"define.none","name":"roundingRule"},"excludedBrands":{"cfc":"Brand","linktable":"SwPromoRewardExclBrand","fieldtype":"many-to-many","singularname":"excludedBrand","inversejoincolumn":"brandID","fkcolumn":"promotionRewardID","type":"array","name":"excludedBrands"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"skus":{"cfc":"Sku","linktable":"SwPromoRewardSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"promotionRewardID","name":"skus"},"excludedSkus":{"cfc":"Sku","linktable":"SwPromoRewardExclSku","fieldtype":"many-to-many","singularname":"excludedSku","inversejoincolumn":"skuID","fkcolumn":"promotionRewardID","name":"excludedSkus"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"maximumUsePerItem":{"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumUsePerItem"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"maximumUsePerQualification":{"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumUsePerQualification"},"maximumUsePerOrder":{"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumUsePerOrder"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"rewards":{"persistent":false,"type":"string","name":"rewards"},"currencyCodeOptions":{"persistent":false,"name":"currencyCodeOptions"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"excludedProductTypes":{"cfc":"ProductType","linktable":"SwPromoRewardExclProductType","fieldtype":"many-to-many","singularname":"excludedProductType","inversejoincolumn":"productTypeID","fkcolumn":"promotionRewardID","name":"excludedProductTypes"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"eligiblePriceGroups":{"cfc":"PriceGroup","linktable":"SwPromoRewardEligiblePriceGrp","fieldtype":"many-to-many","singularname":"eligiblePriceGroup","inversejoincolumn":"priceGroupID","fkcolumn":"promotionRewardID","type":"array","name":"eligiblePriceGroups"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"shippingAddressZones":{"cfc":"AddressZone","linktable":"SwPromoRewardShipAddressZone","fieldtype":"many-to-many","singularname":"shippingAddressZone","inversejoincolumn":"addressZoneID","fkcolumn":"promotionRewardID","name":"shippingAddressZones"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"shippingMethods":{"cfc":"ShippingMethod","linktable":"SwPromoRewardShippingMethod","fieldtype":"many-to-many","singularname":"shippingMethod","inversejoincolumn":"shippingMethodID","fkcolumn":"promotionRewardID","name":"shippingMethods"}};
                	entities['PromotionReward'].className = 'PromotionReward';
                	validations['PromotionReward'] = {"properties":{"amount":[{"contexts":"save","dataType":"numeric","required":true}],"amountType":[{"contexts":"save","required":true}],"maximumUsePerItem":[{"contexts":"save","dataType":"numeric"}],"maximumUsePerQualification":[{"contexts":"save","dataType":"numeric"}],"maximumUsePerOrder":[{"contexts":"save","dataType":"numeric"}]}};
                	defaultValues['PromotionReward'] = {
                	promotionRewardID:'',
										amount:null,
									currencyCode:'USD',
										amountType:null,
									rewardType:null,
									applicableTerm:null,
									maximumUsePerOrder:null,
									maximumUsePerItem:null,
									maximumUsePerQualification:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['File'] = {"fileRelationships":{"cfc":"FileRelationship","fetch":"join","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"FileRelationship","fkcolumn":"fileID","inverse":true,"type":"array","name":"fileRelationships"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"fileID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"fileID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"mimeType":{"ormtype":"string","name":"mimeType"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"fileName":{"ormtype":"string","name":"fileName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"fileType":{"ormtype":"string","name":"fileType"},"fileUpload":{"persistent":false,"hb_formfieldtype":"file","type":"string","name":"fileUpload"},"fileDescription":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"fileDescription"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"fileID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"filePath":{"persistent":false,"setter":false,"type":"string","name":"filePath"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"urlTitle":{"ormtype":"string","name":"urlTitle"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['File'].className = 'File';
                	validations['File'] = {"properties":{"fileRelationships":[{"contexts":"delete","maxCollection":0}],"fileUpload":[{"contexts":"save","conditions":"isNewFile","required":true}],"urlTitle":[{"contexts":"save","required":true}],"fileName":[{"contexts":"save","required":true}]},"conditions":{"isNewFile":{"newFlag":{"eq":true}}}};
                	defaultValues['File'] = {
                	fileID:'',
										activeFlag:1,
									fileType:null,
									mimeType:null,
									fileName:null,
									fileDescription:null,
									urlTitle:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Site'] = {"app":{"cfc":"App","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"appID","hb_populateenabled":"public","name":"app"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"allowAdminAccessFlag":{"ormtype":"boolean","name":"allowAdminAccessFlag"},"contents":{"cfc":"Content","fieldtype":"one-to-many","lazy":"extra","cascade":"all-delete-orphan","singularname":"content","fkcolumn":"siteID","inverse":true,"type":"array","name":"contents"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"assetsPath":{"persistent":false,"name":"assetsPath"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"cmsSiteID":{"ormtype":"string","index":"RI_CMSSITEID","name":"cmsSiteID"},"sitePath":{"persistent":false,"name":"sitePath"},"siteCode":{"ormtype":"string","index":"PI_SITECODE","name":"siteCode"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"siteName":{"ormtype":"string","name":"siteName"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"templatesPath":{"persistent":false,"name":"templatesPath"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"siteID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"siteID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"domainNames":{"ormtype":"string","name":"domainNames"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Site'].className = 'Site';
                	validations['Site'] = {"properties":{"app":[{"contexts":"save","conditions":"isSlatwallCMS","required":true}],"domainNames":[{"contexts":"save","conditions":"isSlatwallCMS","required":true}],"siteID":[{"contexts":"save","conditions":"notSlatwallCMS","required":true}],"contents":[{"contexts":"delete","maxCollection":0}],"siteCode":[{"contexts":"save","conditions":"isSlatwallCMS","required":true}]},"conditions":{"notSlatwallCMS":{"app.integration.integrationPackage":{"neq":"slatwallcms"}},"isSlatwallCMS":{"app.integration.integrationPackage":{"eq":"slatwallcms"}}}};
                	defaultValues['Site'] = {
                	siteID:'',
										siteName:null,
									siteCode:null,
									domainNames:null,
									allowAdminAccessFlag:0,
									cmsSiteID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Physical'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"locations":{"cfc":"Location","linktable":"SwPhysicalLocation","fieldtype":"many-to-many","singularname":"location","inversejoincolumn":"locationID","fkcolumn":"physicalID","type":"array","name":"locations"},"physicalStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=physicalStatusType","fkcolumn":"physicalStatusTypeID","name":"physicalStatusType"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"physicalStatusTypeSystemCode":{"persistent":false,"name":"physicalStatusTypeSystemCode"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwPhysicalBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"BrandID","fkcolumn":"physicalID","type":"array","name":"brands"},"skus":{"cfc":"Sku","linktable":"SwPhysicalSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"physicalID","type":"array","name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"stockAdjustments":{"cfc":"StockAdjustment","fieldtype":"one-to-many","singularname":"stockAdjustment","cascade":"all-delete-orphan","fkcolumn":"physicalID","type":"array","inverse":true,"name":"stockAdjustments"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"physicalCounts":{"cfc":"PhysicalCount","fieldtype":"one-to-many","singularname":"physicalCount","cascade":"all-delete-orphan","fkcolumn":"physicalID","type":"array","inverse":true,"name":"physicalCounts"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"physicalName":{"ormtype":"string","name":"physicalName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"discrepancyQuery":{"persistent":false,"name":"discrepancyQuery"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"productTypes":{"cfc":"ProductType","linktable":"SwPhysicalProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"physicalID","type":"array","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"physicalID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"physicalID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"products":{"cfc":"Product","linktable":"SwPhysicalProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"physicalID","type":"array","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Physical'].className = 'Physical';
                	validations['Physical'] = {"properties":{"physicalName":[{"contexts":"save","required":true}],"locations":[{"contexts":"save","minCollection":1}],"physicalStatusTypeSystemCode":[{"contexts":"delete,addPhysicalCount,commit,edit","inList":"pstOpen"}]}};
                	defaultValues['Physical'] = {
                	physicalID:'',
										physicalName:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Physical_AddPhysicalCount'] = {"locationID":{"hb_formfieldtype":"select","name":"locationID"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"locationIDOptions":{"name":"locationIDOptions"},"countPostDateTime":{"hb_rbkey":"entity.define.countPostDateTime","hb_formfieldtype":"datetime","name":"countPostDateTime"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"physical":{"name":"physical"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"countFile":{"hb_formfieldtype":"file","name":"countFile"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Physical_AddPhysicalCount'].className = 'Physical_AddPhysicalCount';
                	validations['Physical_AddPhysicalCount'] = {"properties":{"location":[{"required":true}],"countPostDateTime":[{"dataType":"date","required":true}]}};
                	defaultValues['Physical_AddPhysicalCount'] = {
                	physical:'',
										locationID:'',
									countPostDateTime:'',
									countFile:'',
									locationIDOptions:[],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['WorkflowTrigger'] = {"objectPropertyIdentifier":{"ormtype":"string","name":"objectPropertyIdentifier"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"workflowTriggerID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"workflowTriggerID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"triggerType":{"ormtype":"string","name":"triggerType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"schedule":{"cfc":"Schedule","fieldtype":"many-to-one","fkcolumn":"scheduleID","name":"schedule"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"scheduleCollection":{"cfc":"Collection","fieldtype":"many-to-one","fkcolumn":"scheduleCollectionID","name":"scheduleCollection"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"triggerEvent":{"ormtype":"string","name":"triggerEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"workflow":{"cfc":"Workflow","fieldtype":"many-to-one","fkcolumn":"workflowID","name":"workflow"}};
                	entities['WorkflowTrigger'].className = 'WorkflowTrigger';
                	validations['WorkflowTrigger'] = {"properties":{}};
                	defaultValues['WorkflowTrigger'] = {
                	workflowTriggerID:'',
										triggerType:null,
									objectPropertyIdentifier:null,
									triggerEvent:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['CurrencyRate'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"conversionCurrencyCode":{"length":255,"insert":false,"update":false,"name":"conversionCurrencyCode"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"currency":{"cfc":"Currency","fieldtype":"many-to-one","length":255,"fkcolumn":"currencyCode","name":"currency"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"conversionCurrency":{"cfc":"Currency","fieldtype":"many-to-one","length":255,"fkcolumn":"conversionCurrencyCode","name":"conversionCurrency"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":255,"insert":false,"update":false,"name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"currencyRateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"currencyRateID"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"conversionRate":{"ormtype":"float","name":"conversionRate"},"effectiveStartDateTime":{"hb_nullrbkey":"define.now","ormtype":"timestamp","name":"effectiveStartDateTime"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['CurrencyRate'].className = 'CurrencyRate';
                	validations['CurrencyRate'] = {"properties":{"currency":[{"contexts":"save","required":true}],"conversionCurrency":[{"contexts":"save","required":true}],"conversionRate":[{"contexts":"save","dataType":"numeric","required":true}],"effectiveStartDateTime":[{"contexts":"save","gtNow":true}]}};
                	defaultValues['CurrencyRate'] = {
                	currencyRateID:'',
										conversionRate:null,
									effectiveStartDateTime:null,
									currencyCode:null,
									conversionCurrencyCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Session'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"sessionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"sessionID"},"requestAccount":{"persistent":false,"type":"any","name":"requestAccount"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"sessionCookieNPSID":{"length":64,"ormtype":"string","name":"sessionCookieNPSID"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","type":"any","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fetch":"join","fieldtype":"many-to-one","fkcolumn":"accountID","type":"any","name":"account"},"lastRequestDateTime":{"ormtype":"timestamp","name":"lastRequestDateTime"},"lastRequestIPAddress":{"ormtype":"string","name":"lastRequestIPAddress"},"accountAuthentication":{"cfc":"AccountAuthentication","fetch":"join","fieldtype":"many-to-one","fkcolumn":"accountAuthenticationID","name":"accountAuthentication"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"sessionExpirationDateTime":{"ormtype":"timestamp","name":"sessionExpirationDateTime"},"lastPlacedOrderID":{"ormtype":"string","name":"lastPlacedOrderID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"shippingAddressPostalCode":{"ormtype":"string","name":"shippingAddressPostalCode"},"rbLocale":{"ormtype":"string","name":"rbLocale"},"sessionCookiePSID":{"length":64,"ormtype":"string","name":"sessionCookiePSID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"deviceID":{"ormtype":"string","default":"","name":"deviceID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Session'].className = 'Session';
                	validations['Session'] = {"properties":{}};
                	defaultValues['Session'] = {
                	sessionID:'',
										shippingAddressPostalCode:null,
									lastRequestDateTime:null,
									lastRequestIPAddress:null,
									lastPlacedOrderID:null,
									rbLocale:null,
									sessionCookiePSID:null,
									sessionCookieNPSID:null,
									sessionExpirationDateTime:null,
									deviceID:'',
										createdDateTime:'',
										modifiedDateTime:'',
										
						z:''
	                };
                
                	entities['UpdateScript'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"loadOrder":{"ormtype":"integer","name":"loadOrder"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"updateScriptID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"updateScriptID"},"successfulExecutionCount":{"ormtype":"integer","default":0,"name":"successfulExecutionCount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"lastExecutedDateTime":{"ormtype":"timestamp","name":"lastExecutedDateTime"},"maxExecutionCount":{"ormtype":"integer","name":"maxExecutionCount"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"executionCount":{"ormtype":"integer","default":0,"name":"executionCount"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"scriptPath":{"ormtype":"string","name":"scriptPath"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['UpdateScript'].className = 'UpdateScript';
                	validations['UpdateScript'] = {"properties":{}};
                	defaultValues['UpdateScript'] = {
                	updateScriptID:'',
										scriptPath:null,
									loadOrder:null,
									maxExecutionCount:null,
									successfulExecutionCount:0,
									executionCount:0,
									lastExecutedDateTime:null,
									
						z:''
	                };
                
                	entities['OptionGroup'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"imageGroupFlag":{"ormtype":"boolean","default":0,"name":"imageGroupFlag"},"optionGroupName":{"ormtype":"string","name":"optionGroupName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"optionGroupDescription":{"length":4000,"ormtype":"string","name":"optionGroupDescription"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"required":true,"ormtype":"integer","name":"sortOrder"},"optionGroupID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"optionGroupID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"optionGroupImage":{"ormtype":"string","name":"optionGroupImage"},"options":{"cfc":"Option","fieldtype":"one-to-many","singularname":"option","cascade":"all-delete-orphan","fkcolumn":"optionGroupID","inverse":true,"orderby":"sortOrder","name":"options"},"optionGroupCode":{"ormtype":"string","index":"PI_OPTIONGROUPCODE","name":"optionGroupCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"optionGroupID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OptionGroup'].className = 'OptionGroup';
                	validations['OptionGroup'] = {"properties":{"optionGroupName":[{"contexts":"save","required":true}],"options":[{"contexts":"delete","maxCollection":0}],"optionGroupCode":[{"uniqueOrNull":true,"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$"}]}};
                	defaultValues['OptionGroup'] = {
                	optionGroupID:'',
										optionGroupName:null,
									optionGroupCode:null,
									optionGroupImage:null,
									optionGroupDescription:null,
									imageGroupFlag:0,
									sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['LocationAddress'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"locationAddressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"locationAddressID"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"locationAddressName":{"ormtype":"string","name":"locationAddressName"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"address":{"hb_populatevalidationcontext":"location","cfc":"Address","fieldtype":"many-to-one","fkcolumn":"addressID","name":"address"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['LocationAddress'].className = 'LocationAddress';
                	validations['LocationAddress'] = {"properties":{"location":[{"contexts":"save","required":true}]},"populatedPropertyValidation":{"address":[{"validate":"location"}]}};
                	defaultValues['LocationAddress'] = {
                	locationAddressID:'',
										locationAddressName:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionUsage'] = {"nextBillDate":{"hb_formfieldtype":"date","ormtype":"timestamp","hb_formattype":"date","name":"nextBillDate"},"subscriptionOrderItems":{"cfc":"SubscriptionOrderItem","fieldtype":"one-to-many","singularname":"subscriptionOrderItem","cascade":"all-delete-orphan","fkcolumn":"subscriptionUsageID","type":"array","inverse":true,"name":"subscriptionOrderItems"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"subscriptionUsageID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionUsageID"},"mostRecentSubscriptionOrderItem":{"persistant":false,"name":"mostRecentSubscriptionOrderItem"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"mostRecentOrder":{"persistant":false,"name":"mostRecentOrder"},"nextReminderEmailDate":{"hb_formfieldtype":"date","ormtype":"timestamp","hb_formattype":"date","name":"nextReminderEmailDate"},"currentStatus":{"persistent":false,"name":"currentStatus"},"initialSku":{"persistant":false,"name":"initialSku"},"totalNumberOfSubscriptionOrderItems":{"persistant":false,"name":"totalNumberOfSubscriptionOrderItems"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"shippingAccountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"shippingAccountAddressID","hb_populateenabled":"public","name":"shippingAccountAddress"},"currentStatusCode":{"persistent":false,"name":"currentStatusCode"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"shippingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"shippingAddressID","hb_populateenabled":"public","name":"shippingAddress"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"initialOrderItem":{"persistant":false,"name":"initialOrderItem"},"initialOrder":{"persistant":false,"name":"initialOrder"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"subscriptionTerm":{"cfc":"SubscriptionTerm","fieldtype":"many-to-one","fkcolumn":"subscriptionTermID","name":"subscriptionTerm"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","hb_populateenabled":"public","name":"shippingMethod"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"autoPayFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"autoPayFlag"},"validations":{"persistent":false,"type":"struct","name":"validations"},"accountPaymentMethod":{"cfc":"AccountPaymentMethod","fieldtype":"many-to-one","fkcolumn":"accountPaymentMethodID","name":"accountPaymentMethod"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"currentStatusType":{"persistent":false,"name":"currentStatusType"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"renewalPrice":{"ormtype":"big_decimal","hb_formattype":"currency","name":"renewalPrice"},"emailAddress":{"ormtype":"string","hb_populateenabled":"public","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"initialProduct":{"persistant":false,"name":"initialProduct"},"renewalTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"renewalTermID","name":"renewalTerm"},"allowProrateFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"allowProrateFlag"},"subscriptionUsageBenefits":{"cfc":"SubscriptionUsageBenefit","fieldtype":"one-to-many","singularname":"subscriptionUsageBenefit","cascade":"all-delete-orphan","fkcolumn":"subscriptionUsageID","type":"array","name":"subscriptionUsageBenefits"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"mostRecentOrderItem":{"persistant":false,"name":"mostRecentOrderItem"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"subscriptionOrderItemName":{"persistent":false,"name":"subscriptionOrderItemName"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"gracePeriodTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"gracePeriodTermID","name":"gracePeriodTerm"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"autoRenewFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"autoRenewFlag"},"expirationDate":{"hb_formfieldtype":"date","ormtype":"timestamp","hb_formattype":"date","name":"expirationDate"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"initialTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"initialTermID","name":"initialTerm"},"subscriptionStatus":{"cfc":"SubscriptionStatus","fieldtype":"one-to-many","singularname":"subscriptionStatus","cascade":"all-delete-orphan","fkcolumn":"subscriptionUsageID","type":"array","inverse":true,"name":"subscriptionStatus"},"renewalSubscriptionUsageBenefits":{"cfc":"SubscriptionUsageBenefit","fieldtype":"one-to-many","singularname":"renewalSubscriptionUsageBenefit","cascade":"all-delete-orphan","fkcolumn":"renewalSubscriptionUsageID","type":"array","name":"renewalSubscriptionUsageBenefits"},"initialSubscriptionOrderItem":{"persistant":false,"name":"initialSubscriptionOrderItem"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionUsage'].className = 'SubscriptionUsage';
                	validations['SubscriptionUsage'] = {"properties":{"currentStatusCode":[{"contexts":"cancel","inList":"sstActive,sstSuspended"}],"subscriptionUsageID":[{"contexts":"delete","maxLength":0}]}};
                	defaultValues['SubscriptionUsage'] = {
                	subscriptionUsageID:'',
										allowProrateFlag:null,
									renewalPrice:null,
									currencyCode:null,
									autoRenewFlag:null,
									autoPayFlag:null,
									nextBillDate:null,
									nextReminderEmailDate:null,
									expirationDate:null,
									emailAddress:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									initialSubscriptionOrderItem:null,
									initialOrderItem:null,
									initialOrder:null,
									initialSku:null,
									initialProduct:null,
									mostRecentSubscriptionOrderItem:null,
									mostRecentOrderItem:null,
									mostRecentOrder:null,
									totalNumberOfSubscriptionOrderItems:'0',
									
						z:''
	                };
                
                	entities['SubscriptionUsage_AddUsageBenefit'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"name":"subscriptionUsage"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"subscriptionBenefitID":{"hb_rbkey":"entity.subscriptionBenefit","hb_formfieldtype":"select","name":"subscriptionBenefitID"},"benefitTermType":{"hb_formfieldtype":"select","name":"benefitTermType"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['SubscriptionUsage_AddUsageBenefit'].className = 'SubscriptionUsage_AddUsageBenefit';
                	validations['SubscriptionUsage_AddUsageBenefit'] = {"properties":{"subscriptionBenefitID":[{"contexts":"save","required":true}]}};
                	defaultValues['SubscriptionUsage_AddUsageBenefit'] = {
                	subscriptionUsage:'',
										benefitTermType:'',
									subscriptionBenefitID:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['SubscriptionUsage_Cancel'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"name":"subscriptionUsage"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"effectiveDateTime":{"hb_nullrbkey":"define.now","hb_formfieldtype":"datetime","name":"effectiveDateTime"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['SubscriptionUsage_Cancel'].className = 'SubscriptionUsage_Cancel';
                	validations['SubscriptionUsage_Cancel'] = {"properties":{}};
                	defaultValues['SubscriptionUsage_Cancel'] = {
                	subscriptionUsage:'',
										effectiveDateTime:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['SubscriptionUsage_Renew'] = {"newOrderPayment":{"cfc":"OrderPayment","persistent":false,"fieldtype":"many-to-one","fkcolumn":"orderPaymentID","name":"newOrderPayment"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"prorateExpirationDate":{"hb_formattype":"date","name":"prorateExpirationDate"},"renewalPaymentType":{"hb_formfieldtype":"select","name":"renewalPaymentType"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"proratedPrice":{"hb_rbkey":"entity.sku.renewalPrice","hb_formattype":"currency","name":"proratedPrice"},"saveAccountPaymentMethodFlag":{"hb_formfieldtype":"yesno","name":"saveAccountPaymentMethodFlag"},"updateSubscriptionUsageAccountPaymentMethodFlag":{"hb_formfieldtype":"yesno","name":"updateSubscriptionUsageAccountPaymentMethodFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"saveAccountPaymentMethodName":{"hb_formfieldtype":"yesno","name":"saveAccountPaymentMethodName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"extendExpirationDate":{"hb_formattype":"date","name":"extendExpirationDate"},"order":{"name":"order"},"accountPaymentMethod":{"cfc":"AccountPaymentMethod","persistent":false,"fieldtype":"many-to-one","hb_rbkey":"entity.accountPaymentMethod","fkcolumn":"accountPaymentMethodID","name":"accountPaymentMethod"},"orderPayment":{"cfc":"OrderPayment","persistent":false,"fieldtype":"many-to-one","hb_rbkey":"entity.orderPayment","fkcolumn":"orderPaymentID","name":"orderPayment"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"name":"subscriptionUsage"},"autoUpdateFlag":{"default":0,"name":"autoUpdateFlag"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"renewalStartType":{"hb_formfieldtype":"select","name":"renewalStartType"}};
                	entities['SubscriptionUsage_Renew'].className = 'SubscriptionUsage_Renew';
                	validations['SubscriptionUsage_Renew'] = {"properties":{}};
                	defaultValues['SubscriptionUsage_Renew'] = {
                	subscriptionUsage:'',
										order:'',
										renewalStartType:"extend",
										saveAccountPaymentMethodFlag:0,
										saveAccountPaymentMethodName:'',
									updateSubscriptionUsageAccountPaymentMethodFlag:0,
										autoUpdateFlag:0,
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['StockAdjustment'] = {"addStockAdjustmentItemSkuOptionsSmartList":{"persistent":false,"name":"addStockAdjustmentItemSkuOptionsSmartList"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"addStockAdjustmentItemStockOptionsSmartList":{"persistent":false,"name":"addStockAdjustmentItemStockOptionsSmartList"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"stockAdjustmentType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=stockAdjustmentType","fkcolumn":"stockAdjustmentTypeID","name":"stockAdjustmentType"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"fromLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"fromLocationID","name":"fromLocation"},"adjustmentSkuOptions":{"persistent":false,"name":"adjustmentSkuOptions"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"toLocation":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"toLocationID","name":"toLocation"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"stockAdjustmentItems":{"cfc":"StockAdjustmentItem","fieldtype":"one-to-many","singularname":"stockAdjustmentItem","cascade":"all-delete-orphan","fkcolumn":"stockAdjustmentID","inverse":true,"name":"stockAdjustmentItems"},"displayName":{"persistent":false,"name":"displayName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"physical":{"cfc":"Physical","fieldtype":"many-to-one","fkcolumn":"physicalID","name":"physical"},"statusCode":{"persistent":false,"name":"statusCode"},"stockAdjustmentStatusTypeSystemCode":{"persistent":false,"name":"stockAdjustmentStatusTypeSystemCode"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"stockReceivers":{"cfc":"StockReceiver","fieldtype":"one-to-many","singularname":"stockReceiver","cascade":"all","fkcolumn":"stockAdjustmentID","type":"array","inverse":true,"name":"stockReceivers"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustmentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockAdjustmentID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"stockAdjustmentTypeSystemCode":{"persistent":false,"name":"stockAdjustmentTypeSystemCode"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"stockAdjustmentStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=stockAdjustmentStatusType","fkcolumn":"stockAdjustmentStatusTypeID","name":"stockAdjustmentStatusType"}};
                	entities['StockAdjustment'].className = 'StockAdjustment';
                	validations['StockAdjustment'] = {"properties":{"fromLocation":[{"contexts":"save","conditions":"shouldHaveFromLocation","required":true}],"statusCode":[{"contexts":"addItems,processAdjustment,delete","inList":"sastNew"}],"stockAdjustmentType":[{"contexts":"save","required":true}],"toLocation":[{"contexts":"save","conditions":"shouldHaveToLocation","required":true}],"stockAdjustmentStatusType":[{"contexts":"save","required":true}],"stockReceivers":[{"contexts":"delete","maxCollection":0}]},"conditions":{"shouldHaveFromLocation":{"stockAdjustmentTypeSystemCode":{"inList":"satLocationTransfer,satManualOut"}},"shouldHaveToLocation":{"stockAdjustmentTypeSystemCode":{"inList":"satLocationTransfer,satManualIn"}}}};
                	defaultValues['StockAdjustment'] = {
                	stockAdjustmentID:'',
										createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockAdjustment_AddStockAdjustmentItem'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"stockID":{"name":"stockID"},"quantity":{"name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"skuID":{"name":"skuID"},"stock":{"name":"stock"},"validations":{"persistent":false,"type":"struct","name":"validations"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustment":{"name":"stockAdjustment"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockAdjustment_AddStockAdjustmentItem'].className = 'StockAdjustment_AddStockAdjustmentItem';
                	validations['StockAdjustment_AddStockAdjustmentItem'] = {"properties":{"quantity":[{"contexts":"save","dataType":"numeric","required":true,"minValue":0}]}};
                	defaultValues['StockAdjustment_AddStockAdjustmentItem'] = {
                	stockAdjustment:'',
										sku:'',
									stock:'',
									skuID:'',
									stockID:'',
									quantity:1,
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['SubscriptionStatus'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"subscriptionStatusType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=subscriptionStatusType","fkcolumn":"subscriptionStatusTypeID","name":"subscriptionStatusType"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"subscriptionStatusID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionStatusID"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"subscriptionStatusChangeReasonType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=subscriptionStatusChangeReasonType","fkcolumn":"subsStatusChangeReasonTypeID","name":"subscriptionStatusChangeReasonType"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"changeDateTime":{"ormtype":"timestamp","name":"changeDateTime"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"effectiveDateTime":{"ormtype":"timestamp","name":"effectiveDateTime"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageID","name":"subscriptionUsage"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionStatus'].className = 'SubscriptionStatus';
                	validations['SubscriptionStatus'] = {"properties":{}};
                	defaultValues['SubscriptionStatus'] = {
                	subscriptionStatusID:'',
										changeDateTime:null,
									effectiveDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['GiftCardTransaction'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"giftCard":{"cfc":"GiftCard","fieldtype":"many-to-one","fkcolumn":"giftCardID","name":"giftCard"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"creditAmount":{"ormtype":"big_decimal","name":"creditAmount"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"debitAmount":{"ormtype":"big_decimal","name":"debitAmount"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"giftCardTransactionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"giftCardTransactionID"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"orderPayment":{"cfc":"OrderPayment","fieldtype":"many-to-one","fkcolumn":"orderPaymentID","name":"orderPayment"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"orderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"orderItem","cascade":"all-delete-orphan","fkcolumn":"giftCardTransactionID","inverse":true,"name":"orderItems"}};
                	entities['GiftCardTransaction'].className = 'GiftCardTransaction';
                	validations['GiftCardTransaction'] = {"properties":{}};
                	defaultValues['GiftCardTransaction'] = {
                	giftCardTransactionID:'',
										currencyCode:null,
									creditAmount:null,
									debitAmount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Workflow'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"workflowObjectOptions":{"persistent":false,"name":"workflowObjectOptions"},"workflowObject":{"hb_formfieldtype":"select","ormtype":"string","name":"workflowObject"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"workflowTasks":{"cfc":"WorkflowTask","fieldtype":"one-to-many","singularname":"workflowTask","cascade":"all-delete-orphan","fkcolumn":"workflowID","type":"array","inverse":true,"name":"workflowTasks"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"workflowName":{"ormtype":"string","name":"workflowName"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"workflowTriggers":{"cfc":"WorkflowTrigger","fieldtype":"one-to-many","singularname":"workflowTrigger","cascade":"all-delete-orphan","fkcolumn":"workflowID","type":"array","inverse":true,"name":"workflowTriggers"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"workflowID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"workflowID"},"activeFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Workflow'].className = 'Workflow';
                	validations['Workflow'] = {"properties":{"workflowName":[{"contexts":"save","required":true}],"workflowObject":[{"contexts":"save","required":true}]}};
                	defaultValues['Workflow'] = {
                	workflowID:'',
										activeFlag:1,
									workflowName:null,
									workflowObject:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AttributeOption'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"attribute","ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeOptionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"attributeOptionID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"attributeOptionLabel":{"ormtype":"string","name":"attributeOptionLabel"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attribute":{"cfc":"Attribute","fieldtype":"many-to-one","fkcolumn":"attributeID","name":"attribute"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeOptionValue":{"ormtype":"string","name":"attributeOptionValue"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"attributeOptionID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AttributeOption'].className = 'AttributeOption';
                	validations['AttributeOption'] = {"properties":{"attributeOptionValue":[{"contexts":"save","required":true}],"attributeOptionLabel":[{"contexts":"save","required":true}]}};
                	defaultValues['AttributeOption'] = {
                	attributeOptionID:'',
										attributeOptionValue:null,
									attributeOptionLabel:'',
										sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountLoyalty'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"loyalty":{"cfc":"Loyalty","fieldtype":"many-to-one","fkcolumn":"loyaltyID","name":"loyalty"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"accountLoyaltyID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountLoyaltyID"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"accountLoyaltyNumber":{"ormtype":"string","name":"accountLoyaltyNumber"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all-delete-orphan","fkcolumn":"accountLoyaltyID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"lifetimeBalance":{"persistent":false,"name":"lifetimeBalance"}};
                	entities['AccountLoyalty'].className = 'AccountLoyalty';
                	validations['AccountLoyalty'] = {"properties":{"accountLoyaltyID":[{"contexts":"delete","maxLength":0}],"loyalty":[{"contexts":"save","required":true}]}};
                	defaultValues['AccountLoyalty'] = {
                	accountLoyaltyID:'',
										accountLoyaltyNumber:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorPhoneNumber'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"phoneNumber":{"ormtype":"string","name":"phoneNumber"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"vendorPhoneNumberID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorPhoneNumberID"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorPhoneNumber'].className = 'VendorPhoneNumber';
                	validations['VendorPhoneNumber'] = {"properties":{}};
                	defaultValues['VendorPhoneNumber'] = {
                	vendorPhoneNumberID:'',
										phoneNumber:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Collection'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"collectionConfig":{"hint":"json object used to construct the base collection HQL query","length":8000,"hb_formfieldtype":"json","hb_auditable":false,"ormtype":"string","name":"collectionConfig"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"postFilterGroups":{"persistent":false,"hint":"where conditions that are added by the user through the UI, applied in addition to the collectionConfig.","singularname":"postFilterGroup","type":"array","name":"postFilterGroups"},"processContext":{"persistent":false,"type":"string","name":"processContext"},"collectionEntityObject":{"persistent":false,"type":"any","name":"collectionEntityObject"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"collectionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"collectionID"},"nonPersistentColumn":{"persistent":false,"type":"boolean","name":"nonPersistentColumn"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"postOrderBys":{"persistent":false,"hint":"order bys added by the use in the UI, applied/overried the default collectionConfig order bys","type":"array","name":"postOrderBys"},"collectionCode":{"unique":true,"ormtype":"string","index":"PI_COLLECTIONCODE","name":"collectionCode"},"cacheable":{"persistent":false,"type":"boolean","name":"cacheable"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"collectionObjectOptions":{"persistent":false,"name":"collectionObjectOptions"},"pageRecords":{"persistent":false,"type":"array","name":"pageRecords"},"validations":{"persistent":false,"type":"struct","name":"validations"},"collectionName":{"ormtype":"string","name":"collectionName"},"collectionConfigStruct":{"persistent":false,"type":"struct","name":"collectionConfigStruct"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"parentCollection":{"cfc":"Collection","fieldtype":"many-to-one","fkcolumn":"parentCollectionID","name":"parentCollection"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"hqlParams":{"persistent":false,"type":"struct","name":"hqlParams"},"pageRecordsShow":{"persistent":false,"hint":"This is the total number of entities to display","type":"numeric","name":"pageRecordsShow"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"cacheName":{"persistent":false,"type":"string","name":"cacheName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"savedStateID":{"persistent":false,"type":"string","name":"savedStateID"},"pageRecordsStart":{"persistent":false,"hint":"This represents the first record to display and it is used in paging.","type":"numeric","name":"pageRecordsStart"},"collectionDescription":{"ormtype":"string","name":"collectionDescription"},"currentURL":{"persistent":false,"type":"string","name":"currentURL"},"currentPageDeclaration":{"persistent":false,"type":"string","name":"currentPageDeclaration"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"keywordArray":{"persistent":false,"type":"array","name":"keywordArray"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"hqlAliases":{"persistent":false,"type":"struct","name":"hqlAliases"},"collectionObject":{"hb_formfieldtype":"select","ormtype":"string","name":"collectionObject"},"records":{"persistent":false,"type":"array","name":"records"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"keywords":{"persistent":false,"type":"string","name":"keywords"}};
                	entities['Collection'].className = 'Collection';
                	validations['Collection'] = {"properties":{"collectionName":[{"contexts":"save","required":true}],"collectionID":[{"contexts":"save","method":"canSaveCollectionByCollectionObject"}],"collectionCode":[{"uniqueOrNull":true,"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$"}]}};
                	defaultValues['Collection'] = {
                	collectionID:'',
										collectionName:null,
									collectionCode:null,
									collectionDescription:null,
									collectionObject:null,
									collectionConfig:angular.fromJson('{}'),
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorOrderItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","default":0,"name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","name":"stock"},"vendorOrderItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorOrderItemID"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"cost":{"ormtype":"big_decimal","hb_formattype":"currency","name":"cost"},"quantityUnreceived":{"persistent":false,"name":"quantityUnreceived"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"estimatedReceivalDateTime":{"ormtype":"timestamp","name":"estimatedReceivalDateTime"},"stockReceiverItems":{"cfc":"StockReceiverItem","fieldtype":"one-to-many","singularname":"stockReceiverItem","cascade":"all-delete-orphan","fkcolumn":"vendorOrderItemID","type":"array","inverse":true,"name":"stockReceiverItems"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"vendorOrder":{"cfc":"VendorOrder","fieldtype":"many-to-one","fkcolumn":"vendorOrderID","name":"vendorOrder"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"extendedCost":{"persistent":false,"hb_formattype":"currency","name":"extendedCost"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"vendorOrderItemType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=vendorOrderItemType","fkcolumn":"vendorOrderItemTypeID","name":"vendorOrderItemType"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"quantityReceived":{"persistent":false,"name":"quantityReceived"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorOrderItem'].className = 'VendorOrderItem';
                	validations['VendorOrderItem'] = {"properties":{"stockReceiverItems":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['VendorOrderItem'] = {
                	vendorOrderItemID:'',
										quantity:0,
									cost:null,
									currencyCode:null,
									estimatedReceivalDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ProductSchedule'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"firstScheduledSku":{"persistent":false,"name":"firstScheduledSku"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"monthlyRepeatByType":{"hint":"Whether recurrence is repeated based on day of month or day of week.","ormtype":"string","name":"monthlyRepeatByType"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"recurringTimeUnit":{"hint":"Daily, Weekly, Monthly, Yearly","ormtype":"string","name":"recurringTimeUnit"},"skus":{"cfc":"Sku","fieldtype":"one-to-many","singularname":"sku","cascade":"all","fkcolumn":"productScheduleID","type":"array","inverse":true,"name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","fkcolumn":"productID","hb_populateenabled":"public","name":"product"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"weeklyRepeatDays":{"hint":"List containing days of the week on which the schedule occurs.","ormtype":"string","name":"weeklyRepeatDays"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"scheduleEndDate":{"hint":"If endsOn=date this will be the date the schedule ends","hb_formfieldtype":"date","ormtype":"timestamp","name":"scheduleEndDate"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","name":"modifiedDateTime"},"productScheduleID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productScheduleID"},"scheduleSummary":{"persistent":false,"name":"scheduleSummary"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ProductSchedule'].className = 'ProductSchedule';
                	validations['ProductSchedule'] = {"properties":{}};
                	defaultValues['ProductSchedule'] = {
                	productScheduleID:'',
										recurringTimeUnit:null,
									weeklyRepeatDays:null,
									monthlyRepeatByType:null,
									scheduleEndDate:null,
									remoteID:null,
									createdDateTime:'',
										modifiedDateTime:'',
										
						z:''
	                };
                
                	entities['AccountPayment'] = {"appliedAccountPayments":{"cfc":"AccountPaymentApplied","fieldtype":"one-to-many","singularname":"appliedAccountPayment","cascade":"all","fkcolumn":"accountPaymentID","type":"array","inverse":true,"name":"appliedAccountPayments"},"amountUnreceived":{"persistent":false,"hb_formattype":"currency","name":"amountUnreceived"},"expirationYearOptions":{"persistent":false,"name":"expirationYearOptions"},"originalAuthorizationCode":{"persistent":false,"name":"originalAuthorizationCode"},"creditCardType":{"ormtype":"string","name":"creditCardType"},"paymentMethodOptions":{"persistent":false,"name":"paymentMethodOptions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"expirationMonth":{"hb_formfieldtype":"select","ormtype":"string","name":"expirationMonth"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"experationMonthOptions":{"persistent":false,"name":"experationMonthOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"companyPaymentMethodFlag":{"ormtype":"boolean","name":"companyPaymentMethodFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","hb_optionsnullrbkey":"define.select","name":"account"},"amount":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"creditCardNumber":{"persistent":false,"name":"creditCardNumber"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"originalAuthorizationProviderTransactionID":{"persistent":false,"name":"originalAuthorizationProviderTransactionID"},"bankRoutingNumberEncrypted":{"ormtype":"string","name":"bankRoutingNumberEncrypted"},"providerToken":{"ormtype":"string","name":"providerToken"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"creditCardLastFour":{"ormtype":"string","name":"creditCardLastFour"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"amountCredited":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountCredited"},"validations":{"persistent":false,"type":"struct","name":"validations"},"accountPaymentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountPaymentID"},"accountPaymentMethod":{"cfc":"AccountPaymentMethod","fieldtype":"many-to-one","fkcolumn":"accountPaymentMethodID","hb_optionsnullrbkey":"define.select","name":"accountPaymentMethod"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"accountPaymentID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"accountPaymentType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accountPaymentType","fkcolumn":"accountPaymentTypeID","name":"accountPaymentType"},"paymentTransactions":{"cfc":"PaymentTransaction","fieldtype":"one-to-many","singularname":"paymentTransaction","cascade":"all","fkcolumn":"accountPaymentID","type":"array","inverse":true,"name":"paymentTransactions"},"originalProviderTransactionID":{"persistent":false,"name":"originalProviderTransactionID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"amountUnassigned":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountUnassigned"},"giftCardNumber":{"persistent":false,"name":"giftCardNumber"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"nameOnCreditCard":{"ormtype":"string","name":"nameOnCreditCard"},"paymentMethod":{"cfc":"PaymentMethod","fieldtype":"many-to-one","fkcolumn":"paymentMethodID","hb_optionsnullrbkey":"define.select","name":"paymentMethod"},"bankRoutingNumber":{"persistent":false,"name":"bankRoutingNumber"},"expirationYear":{"hb_formfieldtype":"select","ormtype":"string","name":"expirationYear"},"billingAddress":{"cfc":"Address","fieldtype":"many-to-one","cascade":"all","fkcolumn":"billingAddressID","hb_optionsnullrbkey":"define.select","name":"billingAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"originalChargeProviderTransactionID":{"persistent":false,"name":"originalChargeProviderTransactionID"},"amountUncaptured":{"persistent":false,"hb_formattype":"currency","name":"amountUncaptured"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"creditCardNumberEncrypted":{"ormtype":"string","name":"creditCardNumberEncrypted"},"checkNumberEncrypted":{"ormtype":"string","name":"checkNumberEncrypted"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"bankAccountNumber":{"persistent":false,"name":"bankAccountNumber"},"bankAccountNumberEncrypted":{"ormtype":"string","name":"bankAccountNumberEncrypted"},"amountUncredited":{"persistent":false,"hb_formattype":"currency","name":"amountUncredited"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"expirationDate":{"persistent":false,"name":"expirationDate"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"amountAuthorized":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountAuthorized"},"creditCardOrProviderTokenExistsFlag":{"persistent":false,"name":"creditCardOrProviderTokenExistsFlag"},"remoteID":{"ormtype":"string","name":"remoteID"},"checkNumber":{"persistent":false,"name":"checkNumber"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"appliedAccountPaymentOptions":{"persistent":false,"name":"appliedAccountPaymentOptions"},"amountReceived":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountReceived"},"paymentMethodType":{"persistent":false,"name":"paymentMethodType"},"giftCardNumberEncrypted":{"ormtype":"string","name":"giftCardNumberEncrypted"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"amountUnauthorized":{"persistent":false,"hb_formattype":"currency","name":"amountUnauthorized"},"securityCode":{"persistent":false,"name":"securityCode"}};
                	entities['AccountPayment'].className = 'AccountPayment';
                	validations['AccountPayment'] = {"properties":{"paymentMethod":[{"contexts":"save","required":true}],"amount":[{"contexts":"save","dataType":"numeric","required":true,"minValue":0}],"paymentMethodType":[{"contexts":"save","inList":"cash,check,creditCard,external,giftCard","required":true}],"accountPaymentType":[{"contexts":"save","required":true}],"paymentTransactions":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['AccountPayment'] = {
                	accountPaymentID:'',
										currencyCode:'USD',
										bankRoutingNumberEncrypted:null,
									bankAccountNumberEncrypted:null,
									checkNumberEncrypted:null,
									companyPaymentMethodFlag:null,
									creditCardNumberEncrypted:null,
									creditCardLastFour:null,
									creditCardType:null,
									expirationMonth:null,
									expirationYear:null,
									giftCardNumberEncrypted:null,
									nameOnCreditCard:null,
									providerToken:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountPayment_CreateTransaction'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"amount":{"name":"amount"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"transactionType":{"hb_formfieldtype":"select","name":"transactionType"},"transactionTypeOptions":{"name":"transactionTypeOptions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"accountPayment":{"name":"accountPayment"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['AccountPayment_CreateTransaction'].className = 'AccountPayment_CreateTransaction';
                	validations['AccountPayment_CreateTransaction'] = {"properties":{}};
                	defaultValues['AccountPayment_CreateTransaction'] = {
                	accountPayment:'',
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['OrderItem'] = {"orderItemStatusType":{"cfc":"Type","fetch":"join","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderItemStatusType","fkcolumn":"orderItemStatusTypeID","name":"orderItemStatusType"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","hb_populateenabled":"public","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"appliedPromotions":{"cfc":"PromotionApplied","fieldtype":"one-to-many","singularname":"appliedPromotion","cascade":"all-delete-orphan","fkcolumn":"orderItemID","inverse":true,"name":"appliedPromotions"},"eventRegistrations":{"cfc":"EventRegistration","fieldtype":"one-to-many","lazy":"extra","cascade":"all-delete-orphan","singularname":"eventRegistration","fkcolumn":"orderItemID","inverse":true,"hb_populateenabled":"public","name":"eventRegistrations"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"orderItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderItemID"},"productBundlePrice":{"persistent":false,"hb_formattype":"currency","name":"productBundlePrice"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"extendedPrice":{"persistent":false,"hb_formattype":"currency","name":"extendedPrice"},"stockReceiverItems":{"cfc":"StockReceiverItem","fieldtype":"one-to-many","singularname":"stockReceiverItem","fkcolumn":"orderItemID","type":"array","inverse":true,"name":"stockReceiverItems"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"parentOrderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"parentOrderItemID","name":"parentOrderItem"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"childOrderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"childOrderItem","cascade":"all-delete-orphan","fkcolumn":"parentOrderItemID","hb_populateenabled":"public","inverse":true,"name":"childOrderItems"},"estimatedDeliveryDateTime":{"ormtype":"timestamp","name":"estimatedDeliveryDateTime"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"price":{"ormtype":"big_decimal","name":"price"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"accountLoyaltyTransactions":{"cfc":"AccountLoyaltyTransaction","fieldtype":"one-to-many","singularname":"accountLoyaltyTransaction","cascade":"all","fkcolumn":"orderItemID","type":"array","inverse":true,"name":"accountLoyaltyTransactions"},"validations":{"persistent":false,"type":"struct","name":"validations"},"taxAmount":{"persistent":false,"hb_formattype":"currency","name":"taxAmount"},"appliedPriceGroup":{"cfc":"PriceGroup","fieldtype":"many-to-one","fkcolumn":"appliedPriceGroupID","name":"appliedPriceGroup"},"activeEventRegistrations":{"persistent":false,"name":"activeEventRegistrations"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"orderItemID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"publicRemoteID":{"ormtype":"string","hb_populateenabled":"public","name":"publicRemoteID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"salePrice":{"persistent":false,"type":"struct","name":"salePrice"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"skuPrice":{"ormtype":"big_decimal","name":"skuPrice"},"productBundleGroup":{"cfc":"ProductBundleGroup","fieldtype":"many-to-one","fkcolumn":"productBundleGroupID","hb_populateenabled":"public","name":"productBundleGroup"},"taxLiabilityAmount":{"persistent":false,"hb_formattype":"currency","name":"taxLiabilityAmount"},"orderReturn":{"cfc":"OrderReturn","fieldtype":"many-to-one","fkcolumn":"orderReturnID","name":"orderReturn"},"referencingOrderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"referencingOrderItem","cascade":"all","fkcolumn":"referencedOrderItemID","inverse":true,"name":"referencingOrderItems"},"discountAmount":{"persistent":false,"hint":"This is the discount amount after quantity (talk to Greg if you don't understand)","hb_formattype":"currency","name":"discountAmount"},"extendedPriceAfterDiscount":{"persistent":false,"hb_formattype":"currency","name":"extendedPriceAfterDiscount"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItemType":{"cfc":"Type","fetch":"join","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderItemType","fkcolumn":"orderItemTypeID","name":"orderItemType"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","hb_populateenabled":"public","name":"stock"},"order":{"cfc":"Order","fetch":"join","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"orderID","hb_populateenabled":false,"name":"order"},"registrants":{"persistent":false,"name":"registrants"},"quantityUnreceived":{"persistent":false,"name":"quantityUnreceived"},"giftCards":{"cfc":"GiftCard","fieldtype":"one-to-many","singularname":"giftCard","cascade":"all","fkcolumn":"originalOrderItemID","type":"array","inverse":true,"name":"giftCards"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"appliedTaxes":{"cfc":"TaxApplied","fieldtype":"one-to-many","singularname":"appliedTax","cascade":"all-delete-orphan","fkcolumn":"orderItemID","inverse":true,"name":"appliedTaxes"},"quantityUndelivered":{"persistent":false,"name":"quantityUndelivered"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"estimatedFulfillmentDateTime":{"ormtype":"timestamp","name":"estimatedFulfillmentDateTime"},"orderDeliveryItems":{"cfc":"OrderDeliveryItem","fieldtype":"one-to-many","singularname":"orderDeliveryItem","cascade":"delete-orphan","fkcolumn":"orderItemID","inverse":true,"name":"orderDeliveryItems"},"orderStatusCode":{"persistent":false,"name":"orderStatusCode"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"quantityDelivered":{"persistent":false,"name":"quantityDelivered"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"itemTotal":{"persistent":false,"hb_formattype":"currency","name":"itemTotal"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"quantityReceived":{"persistent":false,"name":"quantityReceived"},"orderItemGiftRecipients":{"cfc":"OrderItemGiftRecipient","fieldtype":"one-to-many","singularname":"orderItemGiftRecipient","cascade":"all","fkcolumn":"orderItemID","type":"array","inverse":true,"name":"orderItemGiftRecipients"},"referencedOrderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"referencedOrderItemID","name":"referencedOrderItem"},"sku":{"cfc":"Sku","fetch":"join","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"skuID","hb_populateenabled":"public","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"productBundleGroupPrice":{"persistent":false,"hb_formattype":"currency","name":"productBundleGroupPrice"}};
                	entities['OrderItem'].className = 'OrderItem';
                	validations['OrderItem'] = {"properties":{"orderItemStatusType":[{"contexts":"save","required":true}],"quantity":[{"contexts":"save","dataType":"numeric","method":"hasQuantityWithinMaxOrderQuantity"},{"contexts":"save","method":"hasQuantityWithinMinOrderQuantity"}],"orderStatusCode":[{"contexts":"edit,delete","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"}],"orderItemType":[{"contexts":"save","required":true}],"sku":[{"contexts":"save","required":true}]}};
                	defaultValues['OrderItem'] = {
                	orderItemID:'',
										price:null,
									skuPrice:null,
									currencyCode:null,
									quantity:null,
									estimatedDeliveryDateTime:null,
									estimatedFulfillmentDateTime:null,
									publicRemoteID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Email'] = {"emailFailTo":{"ormtype":"string","hb_populateenabled":"public","name":"emailFailTo"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"emailBodyText":{"length":4000,"ormtype":"string","hb_populateenabled":"public","name":"emailBodyText"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"relatedObject":{"ormtype":"string","name":"relatedObject"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"emailTo":{"ormtype":"string","hb_populateenabled":"public","name":"emailTo"},"voidSendFlag":{"persistent":false,"name":"voidSendFlag"},"emailBCC":{"ormtype":"string","hb_populateenabled":"public","name":"emailBCC"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"emailFrom":{"ormtype":"string","hb_populateenabled":"public","name":"emailFrom"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"emailSubject":{"ormtype":"string","hb_populateenabled":"public","name":"emailSubject"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"emailCC":{"ormtype":"string","hb_populateenabled":"public","name":"emailCC"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"logEmailFlag":{"persistent":false,"name":"logEmailFlag"},"emailBodyHTML":{"length":4000,"ormtype":"string","hb_populateenabled":"public","name":"emailBodyHTML"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"relatedObjectID":{"ormtype":"string","name":"relatedObjectID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"emailID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"emailID"}};
                	entities['Email'].className = 'Email';
                	validations['Email'] = {"properties":{"emailName":[{"contexts":"save","required":true}]}};
                	defaultValues['Email'] = {
                	emailID:'',
										emailTo:null,
									emailFrom:null,
									emailFailTo:null,
									emailCC:null,
									emailBCC:null,
									emailSubject:null,
									emailBodyHTML:null,
									emailBodyText:null,
									relatedObject:null,
									relatedObjectID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderItemGiftRecipient'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"emailAddress":{"ormtype":"string","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"firstName":{"ormtype":"string","name":"firstName"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"lastName":{"ormtype":"string","name":"lastName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"giftMessage":{"length":4000,"ormtype":"string","name":"giftMessage"},"giftCards":{"cfc":"GiftCard","fieldtype":"one-to-many","singularname":"giftCard","cascade":"all-delete-orphan","fkcolumn":"orderItemGiftRecipientID","name":"giftCards"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"orderItemGiftRecipientID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderItemGiftRecipientID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderItemGiftRecipient'].className = 'OrderItemGiftRecipient';
                	validations['OrderItemGiftRecipient'] = {"properties":{"lastName":[{"contexts":"save","required":true}],"quantity":[{"contexts":"save","required":true,"minValue":1}],"emailAddress":[{"contexts":"save","required":true}],"giftMessage":[{"contexts":"save","method":"hasCorrectGiftMessageLength"}],"firstName":[{"contexts":"save","required":true}],"giftCard":[{"contexts":"edit,delete","method":"canEditOrDelete"}]}};
                	defaultValues['OrderItemGiftRecipient'] = {
                	orderItemGiftRecipientID:'',
										firstName:null,
									lastName:null,
									emailAddress:null,
									quantity:null,
									giftMessage:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PermissionGroup'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"permissions":{"cfc":"Permission","fieldtype":"one-to-many","singularname":"permission","cascade":"all-delete-orphan","fkcolumn":"permissionGroupID","type":"array","inverse":true,"name":"permissions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"permissionGroupName":{"ormtype":"string","name":"permissionGroupName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"accounts":{"cfc":"Account","linktable":"SwAccountPermissionGroup","fieldtype":"many-to-many","singularname":"account","inversejoincolumn":"accountID","fkcolumn":"permissionGroupID","inverse":true,"name":"accounts"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"permissionsByDetails":{"persistent":false,"name":"permissionsByDetails"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"permissionGroupID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"permissionGroupID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PermissionGroup'].className = 'PermissionGroup';
                	validations['PermissionGroup'] = {"properties":{}};
                	defaultValues['PermissionGroup'] = {
                	permissionGroupID:'',
										permissionGroupName:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Account'] = {"primaryPhoneNumber":{"cfc":"AccountPhoneNumber","fieldtype":"many-to-one","fkcolumn":"primaryPhoneNumberID","hb_populateenabled":"public","name":"primaryPhoneNumber"},"primaryEmailAddressNotInUseFlag":{"persistent":false,"name":"primaryEmailAddressNotInUseFlag"},"accountContentAccesses":{"cfc":"AccountContentAccess","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"accountContentAccess","fkcolumn":"accountID","inverse":true,"hb_populateenabled":false,"type":"array","name":"accountContentAccesses"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"accountCreatedSite":{"cfc":"Site","fieldtype":"many-to-one","fkcolumn":"accountCreatedSiteID","hb_populateenabled":"public","name":"accountCreatedSite"},"accountPayments":{"cfc":"AccountPayment","fieldtype":"one-to-many","singularname":"accountPayment","cascade":"all","fkcolumn":"accountID","type":"array","inverse":true,"name":"accountPayments"},"activeSubscriptionUsageBenefitsSmartList":{"persistent":false,"name":"activeSubscriptionUsageBenefitsSmartList"},"firstName":{"ormtype":"string","hb_populateenabled":"public","name":"firstName"},"eventRegistrations":{"cfc":"EventRegistration","fieldtype":"one-to-many","singularname":"eventRegistration","cascade":"all-delete-orphan","fkcolumn":"accountID","inverse":true,"name":"eventRegistrations"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"ordersPlacedSmartList":{"persistent":false,"name":"ordersPlacedSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"primaryEmailAddress":{"cfc":"AccountEmailAddress","fieldtype":"many-to-one","fkcolumn":"primaryEmailAddressID","hb_populateenabled":"public","name":"primaryEmailAddress"},"primaryShippingAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"primaryShippingAddressID","hb_populateenabled":"public","name":"primaryShippingAddress"},"eligibleAccountPaymentMethodsSmartList":{"persistent":false,"name":"eligibleAccountPaymentMethodsSmartList"},"lastName":{"ormtype":"string","hb_populateenabled":"public","name":"lastName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"cmsAccountID":{"ormtype":"string","index":"RI_CMSACCOUNTID","hb_populateenabled":false,"name":"cmsAccountID"},"guestAccountFlag":{"persistent":false,"hb_formattype":"yesno","name":"guestAccountFlag"},"orders":{"cfc":"Order","fieldtype":"one-to-many","singularname":"order","fkcolumn":"accountID","inverse":true,"hb_populateenabled":false,"type":"array","orderby":"orderOpenDateTime desc","name":"orders"},"accountLoyalties":{"cfc":"AccountLoyalty","fieldtype":"one-to-many","singularname":"accountLoyalty","cascade":"all-delete-orphan","fkcolumn":"accountID","type":"array","inverse":true,"name":"accountLoyalties"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"fullName":{"persistent":false,"name":"fullName"},"permissionGroups":{"cfc":"PermissionGroup","linktable":"SwAccountPermissionGroup","fieldtype":"many-to-many","singularname":"permissionGroup","inversejoincolumn":"permissionGroupID","fkcolumn":"accountID","name":"permissionGroups"},"remoteContactID":{"hint":"Only used when integrated with a remote system","ormtype":"string","hb_populateenabled":false,"name":"remoteContactID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"remoteCustomerID":{"hint":"Only used when integrated with a remote system","ormtype":"string","hb_populateenabled":false,"name":"remoteCustomerID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"productReviews":{"cfc":"ProductReview","fieldtype":"one-to-many","singularname":"productReview","fkcolumn":"accountID","hb_populateenabled":false,"type":"array","inverse":true,"name":"productReviews"},"company":{"ormtype":"string","hb_populateenabled":"public","name":"company"},"validations":{"persistent":false,"type":"struct","name":"validations"},"subscriptionUsageBenefitAccounts":{"cfc":"SubscriptionUsageBenefitAccount","fieldtype":"one-to-many","singularname":"subscriptionUsageBenefitAccount","cascade":"all-delete-orphan","fkcolumn":"accountID","type":"array","inverse":true,"name":"subscriptionUsageBenefitAccounts"},"unenrolledAccountLoyaltyOptions":{"persistent":false,"name":"unenrolledAccountLoyaltyOptions"},"gravatarURL":{"persistent":false,"name":"gravatarURL"},"accountPaymentMethods":{"cfc":"AccountPaymentMethod","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"accountPaymentMethod","fkcolumn":"accountID","inverse":true,"hb_populateenabled":"public","type":"array","name":"accountPaymentMethods"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"accountID","type":"array","inverse":true,"name":"attributeValues"},"termAccountOrderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","singularname":"termAccountOrderPayment","cascade":"all","fkcolumn":"termPaymentAccountID","type":"array","inverse":true,"name":"termAccountOrderPayments"},"address":{"persistent":false,"name":"address"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"loginLockExpiresDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"loginLockExpiresDateTime"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"primaryAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"primaryAddressID","hb_populateenabled":"public","name":"primaryAddress"},"phoneNumber":{"persistent":false,"name":"phoneNumber"},"termAccountBalance":{"persistent":false,"hb_formattype":"currency","name":"termAccountBalance"},"accountPhoneNumbers":{"cfc":"AccountPhoneNumber","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"accountPhoneNumber","fkcolumn":"accountID","inverse":true,"hb_populateenabled":"public","type":"array","name":"accountPhoneNumbers"},"adminIcon":{"persistent":false,"name":"adminIcon"},"accountAuthentications":{"cfc":"AccountAuthentication","fieldtype":"one-to-many","singularname":"accountAuthentication","cascade":"all-delete-orphan","fkcolumn":"accountID","type":"array","inverse":true,"name":"accountAuthentications"},"emailAddress":{"persistent":false,"hb_formattype":"email","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"termAccountAvailableCredit":{"persistent":false,"hb_formattype":"currency","name":"termAccountAvailableCredit"},"passwordResetID":{"persistent":false,"name":"passwordResetID"},"promotionCodes":{"cfc":"PromotionCode","linktable":"SwPromotionCodeAccount","fieldtype":"many-to-many","singularname":"promotionCode","inversejoincolumn":"promotionCodeID","fkcolumn":"accountID","inverse":true,"hb_populateenabled":false,"type":"array","name":"promotionCodes"},"remoteEmployeeID":{"hint":"Only used when integrated with a remote system","ormtype":"string","hb_populateenabled":false,"name":"remoteEmployeeID"},"failedLoginAttemptCount":{"hb_auditable":false,"ormtype":"integer","hb_populateenabled":false,"name":"failedLoginAttemptCount"},"accountID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountID"},"giftCards":{"cfc":"GiftCard","fieldtype":"one-to-many","singularname":"giftCard","cascade":"all","fkcolumn":"ownerAccountID","type":"array","inverse":true,"name":"giftCards"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"subscriptionUsages":{"cfc":"SubscriptionUsage","fieldtype":"one-to-many","singularname":"subscriptionUsage","cascade":"all-delete-orphan","fkcolumn":"accountID","type":"array","inverse":true,"name":"subscriptionUsages"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"jwtToken":{"persistent":false,"name":"jwtToken"},"superUserFlag":{"ormtype":"boolean","name":"superUserFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"adminAccountFlag":{"persistent":false,"hb_formattype":"yesno","name":"adminAccountFlag"},"primaryBillingAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"primaryBillingAddressID","hb_populateenabled":"public","name":"primaryBillingAddress"},"priceGroups":{"cfc":"PriceGroup","linktable":"SwAccountPriceGroup","fieldtype":"many-to-many","singularname":"priceGroup","inversejoincolumn":"priceGroupID","fkcolumn":"accountID","name":"priceGroups"},"remoteID":{"hint":"Only used when integrated with a remote system","ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"ordersNotPlacedSmartList":{"persistent":false,"name":"ordersNotPlacedSmartList"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"slatwallAuthenticationExistsFlag":{"persistent":false,"name":"slatwallAuthenticationExistsFlag"},"termOrderPaymentsByDueDateSmartList":{"persistent":false,"name":"termOrderPaymentsByDueDateSmartList"},"primaryPaymentMethod":{"cfc":"AccountPaymentMethod","fieldtype":"many-to-one","fkcolumn":"primaryPaymentMethodID","hb_populateenabled":"public","name":"primaryPaymentMethod"},"accountAddresses":{"cfc":"AccountAddress","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"accountAddress","fkcolumn":"accountID","inverse":true,"hb_populateenabled":"public","type":"array","name":"accountAddresses"},"saveablePaymentMethodsSmartList":{"persistent":false,"name":"saveablePaymentMethodsSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"accountEmailAddresses":{"cfc":"AccountEmailAddress","fieldtype":"one-to-many","cascade":"all-delete-orphan","singularname":"accountEmailAddress","fkcolumn":"accountID","inverse":true,"hb_populateenabled":"public","type":"array","name":"accountEmailAddresses"}};
                	entities['Account'].className = 'Account';
                	validations['Account'] = {"properties":{"primaryEmailAddress":[{"contexts":"save","conditions":"slatwallAuthenticatedAccount","method":"getPrimaryEmailAddressesNotInUseFlag"}],"unenrolledAccountLoyaltyOptions":[{"contexts":"addAccountLoyalty","minCollection":1}],"lastName":[{"contexts":"save","required":true}],"accountEmailAddressesNotInUseFlag":[{"contexts":"createPassword","eq":true}],"cmsAccountID":[{"uniqueOrNull":true,"contexts":"save"}],"slatwallAuthenticationExistsFlag":[{"contexts":"createPassword","eq":false},{"contexts":"changePassword","eq":true}],"orders":[{"contexts":"delete","maxCollection":0}],"emailAddress":[{"contexts":"createPassword","required":true}],"firstName":[{"contexts":"save","required":true}],"productReviews":[{"contexts":"delete","maxCollection":0}]},"conditions":{"slatwallAuthenticatedAccount":{"slatwallAuthenticationExistsFlag":{"eq":true}}}};
                	defaultValues['Account'] = {
                	accountID:'',
										superUserFlag:false,
									firstName:null,
									lastName:null,
									company:null,
									loginLockExpiresDateTime:null,
									failedLoginAttemptCount:null,
									cmsAccountID:null,
									remoteID:null,
									remoteEmployeeID:null,
									remoteCustomerID:null,
									remoteContactID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Account_AddAccountLoyalty'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"accountLoyaltyNumber":{"name":"accountLoyaltyNumber"},"loyaltyIDOptions":{"name":"loyaltyIDOptions"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"loyalty":{"name":"loyalty"},"validations":{"persistent":false,"type":"struct","name":"validations"},"account":{"name":"account"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"loyaltyID":{"hb_rbkey":"entity.loyalty","hb_formfieldtype":"select","name":"loyaltyID"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Account_AddAccountLoyalty'].className = 'Account_AddAccountLoyalty';
                	validations['Account_AddAccountLoyalty'] = {"properties":{}};
                	defaultValues['Account_AddAccountLoyalty'] = {
                	account:'',
										loyaltyID:'',
									accountLoyaltyNumber:'',
									loyaltyIDOptions:[],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_AddAccountPayment'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"appliedOrderPayments":{"type":"array","name":"appliedOrderPayments","hb_populatearray":true},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"saveAccountPaymentMethodFlag":{"hb_formfieldtype":"yesno","name":"saveAccountPaymentMethodFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"saveAccountPaymentMethodName":{"hb_rbkey":"entity.accountPaymentMethod.accountPaymentMethodName","name":"saveAccountPaymentMethodName"},"accountAddressID":{"hb_rbkey":"entity.accountAddress","hb_formfieldtype":"select","name":"accountAddressID"},"newAccountPayment":{"cfc":"AccountPayment","persistent":false,"fieldtype":"many-to-one","fkcolumn":"accountPaymentID","name":"newAccountPayment"},"currencyCode":{"hb_rbkey":"entity.currency","hb_formfieldtype":"select","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"accountPaymentMethodIDOptions":{"name":"accountPaymentMethodIDOptions"},"account":{"name":"account"},"paymentMethodIDOptions":{"name":"paymentMethodIDOptions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"accountPaymentMethodID":{"hb_rbkey":"entity.accountPaymentMethod","hb_formfieldtype":"select","name":"accountPaymentMethodID"},"accountAddressIDOptions":{"name":"accountAddressIDOptions"}};
                	entities['Account_AddAccountPayment'].className = 'Account_AddAccountPayment';
                	validations['Account_AddAccountPayment'] = {"properties":{}};
                	defaultValues['Account_AddAccountPayment'] = {
                	account:'',
										accountPaymentMethodID:"",
										accountAddressID:"",
										saveAccountPaymentMethodFlag:0,
										saveAccountPaymentMethodName:'',
									currencyCode:'',
									appliedOrderPayments:'',
									accountPaymentMethodIDOptions:[{"VALUE":"","NAME":"New"}],
										paymentMethodIDOptions:[{"name":"Credit Card","paymentmethodtype":"creditCard","allowsave":false,"value":"444df303dedc6dab69dd7ebcc9b8036a"},{"name":"Gift Card","paymentmethodtype":"giftCard","allowsave":false,"value":"50d8cd61009931554764385482347f3a"}],
										accountAddressIDOptions:[{"VALUE":"","NAME":"New"}],
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_CreatePassword'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"account":{"name":"account"},"populatedFlag":{"name":"populatedFlag"},"password":{"name":"password"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"passwordConfirm":{"name":"passwordConfirm"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Account_CreatePassword'].className = 'Account_CreatePassword';
                	validations['Account_CreatePassword'] = {"properties":{"password":[{"required":true},{"conditions":"isPublicAccount","minLength":6},{"regex":"^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$","conditions":"isAdminAccount"}],"passwordConfirm":[{"eqProperty":"password","required":true}]},"conditions":{"isAdminAccount":{"account.AdminAccountFlag":{"eq":true}},"isPublicAccount":{"account.AdminAccountFlag":{"eq":false}}}};
                	defaultValues['Account_CreatePassword'] = {
                	account:'',
										password:'',
									passwordConfirm:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_ChangePassword'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"account":{"name":"account"},"populatedFlag":{"name":"populatedFlag"},"password":{"name":"password"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"passwordConfirm":{"name":"passwordConfirm"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Account_ChangePassword'].className = 'Account_ChangePassword';
                	validations['Account_ChangePassword'] = {"properties":{"password":[{"required":true},{"conditions":"isPublicAccount","minLength":6},{"regex":"^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$","conditions":"isAdminAccount"}],"passwordConfirm":[{"eqProperty":"password","required":true}]},"conditions":{"isAdminAccount":{"account.AdminAccountFlag":{"eq":true}},"isPublicAccount":{"account.AdminAccountFlag":{"eq":false}}}};
                	defaultValues['Account_ChangePassword'] = {
                	account:'',
										password:'',
									passwordConfirm:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_Create'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"phoneNumber":{"name":"phoneNumber"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailAddress":{"name":"emailAddress"},"createAuthenticationFlag":{"hb_sessiondefault":1,"name":"createAuthenticationFlag"},"firstName":{"hb_rbkey":"entity.account.firstName","name":"firstName"},"passwordConfirm":{"name":"passwordConfirm"},"company":{"hb_rbkey":"entity.account.company","name":"company"},"validations":{"persistent":false,"type":"struct","name":"validations"},"account":{"name":"account"},"password":{"name":"password"},"lastName":{"hb_rbkey":"entity.account.lastName","name":"lastName"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"emailAddressConfirm":{"name":"emailAddressConfirm"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Account_Create'].className = 'Account_Create';
                	validations['Account_Create'] = {"properties":{"password":[{"conditions":"savePasswordSelected","eqProperty":"passwordConfirm","required":true,"minLength":6}],"lastName":[{"required":true}],"emailAddress":[{"conditions":"savePasswordSelected","required":true,"method":"getPrimaryEmailAddressNotInUseFlag"},{"dataType":"email","eqProperty":"emailAddressConfirm"}],"firstName":[{"required":true}],"passwordConfirm":[{"conditions":"savePasswordSelected","required":true}],"emailAddressConfirm":[{"conditions":"savePasswordSelected","required":true}]},"conditions":{"savePasswordSelected":{"createAuthenticationFlag":{"eq":1}}}};
                	defaultValues['Account_Create'] = {
                	account:'',
										firstName:'',
									lastName:'',
									company:'',
									phoneNumber:'',
									emailAddress:'',
									emailAddressConfirm:'',
									createAuthenticationFlag:1,
										password:'',
									passwordConfirm:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_ForgotPassword'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"account":{"name":"account"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailAddress":{"name":"emailAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"siteID":{"name":"siteID"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Account_ForgotPassword'].className = 'Account_ForgotPassword';
                	validations['Account_ForgotPassword'] = {"properties":{"emailAddress":[{"dataType":"email","required":true}]}};
                	defaultValues['Account_ForgotPassword'] = {
                	account:'',
										emailAddress:'',
									siteID:"",
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_Login'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"account":{"name":"account"},"populatedFlag":{"name":"populatedFlag"},"password":{"name":"password"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailAddress":{"name":"emailAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Account_Login'].className = 'Account_Login';
                	validations['Account_Login'] = {"properties":{"password":[{"required":true}],"emailAddress":[{"dataType":"email","required":true}]}};
                	defaultValues['Account_Login'] = {
                	account:'',
										emailAddress:'',
									password:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_ResetPassword'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"passwordConfirm":{"name":"passwordConfirm"},"validations":{"persistent":false,"type":"struct","name":"validations"},"swprid":{"name":"swprid"},"account":{"name":"account"},"password":{"name":"password"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"accountPasswordResetID":{"name":"accountPasswordResetID"}};
                	entities['Account_ResetPassword'].className = 'Account_ResetPassword';
                	validations['Account_ResetPassword'] = {"properties":{"swprid":[{"eqProperty":"accountPasswordResetID","required":true}],"password":[{"required":true},{"conditions":"isPublicAccount","minLength":6},{"regex":"^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$","conditions":"isAdminAccount"}],"passwordConfirm":[{"eqProperty":"password","required":true}]},"conditions":{"isAdminAccount":{"account.AdminAccountFlag":{"eq":true}},"isPublicAccount":{"account.AdminAccountFlag":{"eq":false}}}};
                	defaultValues['Account_ResetPassword'] = {
                	account:'',
										swprid:'',
									password:'',
									passwordConfirm:'',
									accountPasswordResetID:"aa7f8620986972053e6d94195d2230b2",
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_SetupInitialAdmin'] = {"siteTitle":{"name":"siteTitle"},"adminAccessFlag":{"hb_formfieldtype":"yesno","default":0,"name":"adminAccessFlag"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"site":{"name":"site"},"slatwallAsCMSFlag":{"hb_formfieldtype":"yesno","default":0,"name":"slatwallAsCMSFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"siteDomains":{"name":"siteDomains"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailAddress":{"name":"emailAddress"},"firstName":{"hb_rbkey":"entity.account.firstName","name":"firstName"},"passwordConfirm":{"name":"passwordConfirm"},"company":{"hb_rbkey":"entity.account.company","name":"company"},"validations":{"persistent":false,"type":"struct","name":"validations"},"account":{"name":"account"},"password":{"name":"password"},"lastName":{"hb_rbkey":"entity.account.lastName","name":"lastName"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"emailAddressConfirm":{"name":"emailAddressConfirm"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Account_SetupInitialAdmin'].className = 'Account_SetupInitialAdmin';
                	validations['Account_SetupInitialAdmin'] = {"properties":{"password":[{"regex":"^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$","eqProperty":"passwordConfirm","required":true}],"lastName":[{"required":true}],"emailAddress":[{"dataType":"email","eqProperty":"emailAddressConfirm","required":true}],"firstName":[{"required":true}],"passwordConfirm":[{"required":true}],"emailAddressConfirm":[{"dataType":"email","required":true}]}};
                	defaultValues['Account_SetupInitialAdmin'] = {
                	account:'',
										site:'',
									firstName:'',
									lastName:'',
									company:'',
									emailAddress:'',
									emailAddressConfirm:'',
									password:'',
									passwordConfirm:'',
									slatwallAsCMSFlag:0,
										siteTitle:'',
									siteDomains:'',
									adminAccessFlag:0,
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_UpdatePassword'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"existingPassword":{"name":"existingPassword"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailAddress":{"name":"emailAddress"},"passwordConfirm":{"name":"passwordConfirm"},"validations":{"persistent":false,"type":"struct","name":"validations"},"account":{"name":"account"},"password":{"name":"password"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Account_UpdatePassword'].className = 'Account_UpdatePassword';
                	validations['Account_UpdatePassword'] = {"properties":{"password":[{"regex":"^.*(?=.{7,})(?=.*[0-9])(?=.*[a-zA-Z]).*$","required":true}],"existingPassword":[{"required":true}],"emailAddress":[{"dataType":"email","required":true}],"passwordConfirm":[{"eqProperty":"password","required":true}]}};
                	defaultValues['Account_UpdatePassword'] = {
                	account:'',
										emailAddress:'',
									existingPassword:'',
									password:'',
									passwordConfirm:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Account_GenerateAuthToken'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"account":{"name":"account"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"authenticationDescription":{"name":"authenticationDescription"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Account_GenerateAuthToken'].className = 'Account_GenerateAuthToken';
                	validations['Account_GenerateAuthToken'] = {"properties":{"authenticationDescription":[{"required":true}]}};
                	defaultValues['Account_GenerateAuthToken'] = {
                	account:'',
										authenticationDescription:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Inventory'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"stockReceiverItem":{"cfc":"StockReceiverItem","fieldtype":"many-to-one","fkcolumn":"stockReceiverItemID","name":"stockReceiverItem"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","name":"stock"},"orderDeliveryItem":{"cfc":"OrderDeliveryItem","fieldtype":"many-to-one","fkcolumn":"orderDeliveryItemID","name":"orderDeliveryItem"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"inventoryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"inventoryID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"quantityOut":{"ormtype":"integer","name":"quantityOut"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"stockAdjustmentDeliveryItem":{"cfc":"StockAdjustmentDeliveryItem","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentDeliveryItemID","name":"stockAdjustmentDeliveryItem"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"quantityIn":{"ormtype":"integer","name":"quantityIn"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Inventory'].className = 'Inventory';
                	validations['Inventory'] = {"properties":{}};
                	defaultValues['Inventory'] = {
                	inventoryID:'',
										quantityIn:null,
									quantityOut:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionCode'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"promotionCodeID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionCodeID"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"promotionCode":{"ormtype":"string","index":"PI_PROMOTIONCODE","name":"promotionCode"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"orders":{"cfc":"Order","linktable":"SwOrderPromotionCode","fieldtype":"many-to-many","lazy":"extra","singularname":"order","inversejoincolumn":"orderID","fkcolumn":"promotionCodeID","inverse":true,"type":"array","name":"orders"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"startDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","hb_formattype":"dateTime","name":"startDateTime"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"accounts":{"cfc":"Account","linktable":"SwPromotionCodeAccount","fieldtype":"many-to-many","singularname":"account","inversejoincolumn":"accountID","fkcolumn":"promotionCodeID","type":"array","name":"accounts"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"maximumUseCount":{"notnull":false,"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumUseCount"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"currentFlag":{"persistent":false,"type":"boolean","name":"currentFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"promotion":{"cfc":"Promotion","fieldtype":"many-to-one","fkcolumn":"promotionID","name":"promotion"},"endDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","hb_formattype":"dateTime","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"maximumAccountUseCount":{"notnull":false,"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumAccountUseCount"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PromotionCode'].className = 'PromotionCode';
                	validations['PromotionCode'] = {"properties":{"promotionCode":[{"contexts":"save","required":true,"unique":true}],"endDateTime":[{"contexts":"save","dataType":"date"},{"contexts":"save","gtDateTimeProperty":"startDateTime","conditions":"needsEndAfterStart"}],"orders":[{"contexts":"delete","maxCollection":0}],"startDateTime":[{"contexts":"save","dataType":"date"}]},"conditions":{"needsEndAfterStart":{"endDateTime":{"required":true},"startDateTime":{"required":true}}}};
                	defaultValues['PromotionCode'] = {
                	promotionCodeID:'',
										promotionCode:null,
									startDateTime:null,
									endDateTime:null,
									maximumUseCount:null,
									maximumAccountUseCount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountAuthentication'] = {"integrationAccessTokenExpiration":{"column":"integrationAccessTokenExp","ormtype":"string","name":"integrationAccessTokenExpiration"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"forceLogoutFlag":{"persistent":false,"name":"forceLogoutFlag"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"accountAuthenticationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountAuthenticationID"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","hb_optionsnullrbkey":"define.select","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"updatePasswordOnNextLoginFlag":{"ormtype":"boolean","name":"updatePasswordOnNextLoginFlag"},"authToken":{"ormtype":"string","name":"authToken"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"integrationAccessToken":{"ormtype":"string","name":"integrationAccessToken"},"expirationDateTime":{"ormtype":"timestamp","name":"expirationDateTime"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"integrationRefreshToken":{"ormtype":"string","name":"integrationRefreshToken"},"authenticationDescription":{"ormtype":"string","name":"authenticationDescription"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"password":{"ormtype":"string","name":"password"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"integration":{"cfc":"Integration","fieldtype":"many-to-one","fkcolumn":"integrationID","hb_optionsnullrbkey":"define.select","name":"integration"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"integrationAccountID":{"ormtype":"string","name":"integrationAccountID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountAuthentication'].className = 'AccountAuthentication';
                	validations['AccountAuthentication'] = {"properties":{}};
                	defaultValues['AccountAuthentication'] = {
                	accountAuthenticationID:'',
										password:null,
									authToken:null,
									expirationDateTime:null,
									integrationAccountID:null,
									integrationAccessToken:null,
									integrationAccessTokenExpiration:null,
									integrationRefreshToken:null,
									activeFlag:1,
									updatePasswordOnNextLoginFlag:null,
									authenticationDescription:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Country'] = {"street2AddressShowFlag":{"ormtype":"boolean","name":"street2AddressShowFlag"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"street2AddressRequiredFlag":{"ormtype":"boolean","name":"street2AddressRequiredFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"defaultCurrency":{"cfc":"Currency","fieldtype":"many-to-one","fkcolumn":"defaultCurrencyCode","name":"defaultCurrency"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"cityLabel":{"ormtype":"string","name":"cityLabel"},"streetAddressRequiredFlag":{"ormtype":"boolean","name":"streetAddressRequiredFlag"},"postalCodeShowFlag":{"ormtype":"boolean","name":"postalCodeShowFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"stateCodeRequiredFlag":{"ormtype":"boolean","name":"stateCodeRequiredFlag"},"localityLabel":{"ormtype":"string","name":"localityLabel"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"countryCode":{"fieldtype":"id","length":2,"ormtype":"string","name":"countryCode"},"countryCode3Digit":{"length":3,"ormtype":"string","name":"countryCode3Digit"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"streetAddressLabel":{"ormtype":"string","name":"streetAddressLabel"},"countryISONumber":{"ormtype":"integer","name":"countryISONumber"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"cityShowFlag":{"ormtype":"boolean","name":"cityShowFlag"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"postalCodeRequiredFlag":{"ormtype":"boolean","name":"postalCodeRequiredFlag"},"stateCodeLabel":{"ormtype":"string","name":"stateCodeLabel"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"stateCodeOptions":{"persistent":false,"type":"array","name":"stateCodeOptions"},"cityRequiredFlag":{"ormtype":"boolean","name":"cityRequiredFlag"},"localityRequiredFlag":{"ormtype":"boolean","name":"localityRequiredFlag"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"postalCodeLabel":{"ormtype":"string","name":"postalCodeLabel"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"countryName":{"ormtype":"string","name":"countryName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"states":{"persistent":false,"hb_rbkey":"entity.state_plural","type":"array","name":"states"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"streetAddressShowFlag":{"ormtype":"boolean","name":"streetAddressShowFlag"},"street2AddressLabel":{"ormtype":"string","name":"street2AddressLabel"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"localityShowFlag":{"ormtype":"boolean","name":"localityShowFlag"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"stateCodeShowFlag":{"ormtype":"boolean","name":"stateCodeShowFlag"},"defaultCurrencyOptions":{"persistent":false,"type":"array","name":"defaultCurrencyOptions"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Country'].className = 'Country';
                	validations['Country'] = {"properties":{"countryCode":[{"contexts":"save","required":true,"minLength":2,"maxLength":3}],"countryCode3Digit":[{"contexts":"save","minLength":3,"maxLength":3}],"countryISONumber":[{"contexts":"save","dataType":"numeric"}],"countryName":[{"contexts":"save","required":true}]}};
                	defaultValues['Country'] = {
                	countryCode:null,
									countryCode3Digit:null,
									countryISONumber:null,
									countryName:null,
									activeFlag:1,
									streetAddressLabel:null,
									streetAddressShowFlag:null,
									streetAddressRequiredFlag:null,
									street2AddressLabel:null,
									street2AddressShowFlag:null,
									street2AddressRequiredFlag:null,
									localityLabel:null,
									localityShowFlag:null,
									localityRequiredFlag:null,
									cityLabel:null,
									cityShowFlag:null,
									cityRequiredFlag:null,
									stateCodeLabel:null,
									stateCodeShowFlag:null,
									stateCodeRequiredFlag:null,
									postalCodeLabel:null,
									postalCodeShowFlag:null,
									postalCodeRequiredFlag:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Product'] = {"listingPages":{"cfc":"Content","linktable":"SwProductListingPage","fieldtype":"many-to-many","singularname":"listingPage","inversejoincolumn":"contentID","fkcolumn":"productID","name":"listingPages"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardProduct","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"productID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"redemptionAmountTypeOptions":{"persistent":false,"type":"array","name":"redemptionAmountTypeOptions"},"productImages":{"cfc":"Image","fieldtype":"one-to-many","singularname":"productImage","cascade":"all-delete-orphan","fkcolumn":"productID","type":"array","inverse":true,"name":"productImages"},"relatedProducts":{"cfc":"Product","linktable":"SwRelatedProduct","fieldtype":"many-to-many","singularname":"relatedProduct","inversejoincolumn":"relatedProductID","fkcolumn":"productID","type":"array","name":"relatedProducts"},"vendors":{"cfc":"Vendor","linktable":"SwVendorProduct","fieldtype":"many-to-many","singularname":"vendor","inversejoincolumn":"vendorID","fkcolumn":"productID","inverse":true,"type":"array","name":"vendors"},"eventRegistrations":{"persistent":false,"type":"array","name":"eventRegistrations"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionProduct","fieldtype":"many-to-many","singularname":"loyaltyRedemption","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"productID","inverse":true,"type":"array","name":"loyaltyRedemptions"},"defaultProductImageFiles":{"persistent":false,"name":"defaultProductImageFiles"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"schedulingOptions":{"persistent":false,"hb_formattype":"array","name":"schedulingOptions"},"livePrice":{"persistent":false,"hb_formattype":"currency","name":"livePrice"},"brandOptions":{"persistent":false,"type":"array","name":"brandOptions"},"transactionExistsFlag":{"persistent":false,"type":"boolean","name":"transactionExistsFlag"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"promotionRewardExclusions":{"cfc":"PromotionReward","linktable":"SwPromoRewardExclProduct","fieldtype":"many-to-many","singularname":"promotionRewardExclusion","inversejoincolumn":"promotionRewardID","fkcolumn":"productID","inverse":true,"type":"array","name":"promotionRewardExclusions"},"productDescription":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"productDescription"},"baseProductType":{"persistent":false,"type":"string","name":"baseProductType"},"productSchedules":{"cfc":"ProductSchedule","fieldtype":"one-to-many","singularname":"productSchedule","cascade":"all-delete-orphan","fkcolumn":"productID","inverse":true,"name":"productSchedules"},"loyaltyRedemptionExclusions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedempExclProduct","fieldtype":"many-to-many","singularname":"loyaltyRedemptionExclusion","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"productID","inverse":true,"type":"array","name":"loyaltyRedemptionExclusions"},"availableForPurchaseFlag":{"persistent":false,"type":"boolean","name":"availableForPurchaseFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRates":{"cfc":"PriceGroupRate","linktable":"SwPriceGroupRateProduct","fieldtype":"many-to-many","singularname":"priceGroupRate","inversejoincolumn":"priceGroupRateID","fkcolumn":"productID","inverse":true,"name":"priceGroupRates"},"price":{"persistent":false,"hb_formattype":"currency","name":"price"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"qats":{"persistent":false,"type":"numeric","name":"qats"},"estimatedReceivalDetails":{"persistent":false,"type":"struct","name":"estimatedReceivalDetails"},"productName":{"notnull":true,"ormtype":"string","name":"productName"},"promotionQualifierExclusions":{"cfc":"PromotionQualifier","linktable":"SwPromoQualExclProduct","fieldtype":"many-to-many","singularname":"promotionQualifierExclusion","inversejoincolumn":"promotionQualifierID","fkcolumn":"productID","inverse":true,"type":"array","name":"promotionQualifierExclusions"},"categories":{"cfc":"Category","linktable":"SwProductCategory","fieldtype":"many-to-many","singularname":"category","inversejoincolumn":"categoryID","fkcolumn":"productID","name":"categories"},"unusedProductOptionGroups":{"persistent":false,"type":"array","name":"unusedProductOptionGroups"},"productReviews":{"cfc":"ProductReview","fieldtype":"one-to-many","singularname":"productReview","cascade":"all-delete-orphan","fkcolumn":"productID","inverse":true,"name":"productReviews"},"loyaltyAccruements":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruProduct","fieldtype":"many-to-many","singularname":"loyaltyAccruement","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"productID","inverse":true,"name":"loyaltyAccruements"},"eventConflictExistsFlag":{"persistent":false,"type":"boolean","name":"eventConflictExistsFlag"},"publishedFlag":{"ormtype":"boolean","default":false,"name":"publishedFlag"},"brand":{"cfc":"Brand","fetch":"join","fieldtype":"many-to-one","fkcolumn":"brandID","hb_optionsnullrbkey":"define.none","name":"brand"},"validations":{"persistent":false,"type":"struct","name":"validations"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"productID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"purchaseStartDateTime":{"ormtype":"timestamp","name":"purchaseStartDateTime"},"calculatedQATS":{"ormtype":"integer","name":"calculatedQATS"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"urlTitle":{"unique":true,"ormtype":"string","name":"urlTitle"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"unusedProductOptions":{"persistent":false,"type":"array","name":"unusedProductOptions"},"calculatedTitle":{"ormtype":"string","name":"calculatedTitle"},"salePrice":{"persistent":false,"hb_formattype":"currency","name":"salePrice"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"brandName":{"persistent":false,"type":"string","name":"brandName"},"renewalPrice":{"persistent":false,"hb_formattype":"currency","name":"renewalPrice"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"productID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productID"},"productCode":{"unique":true,"ormtype":"string","index":"PI_PRODUCTCODE","name":"productCode"},"skus":{"cfc":"Sku","fieldtype":"one-to-many","singularname":"sku","cascade":"all-delete-orphan","fkcolumn":"productID","type":"array","inverse":true,"name":"skus"},"bundleSkusSmartList":{"persistent":false,"name":"bundleSkusSmartList"},"placedOrderItemsSmartList":{"persistent":false,"type":"any","name":"placedOrderItemsSmartList"},"calculatedAllowBackorderFlag":{"ormtype":"boolean","name":"calculatedAllowBackorderFlag"},"physicals":{"cfc":"Physical","linktable":"SwPhysicalProduct","fieldtype":"many-to-many","singularname":"physical","inversejoincolumn":"physicalID","fkcolumn":"productID","inverse":true,"type":"array","name":"physicals"},"nextSkuCodeCount":{"persistent":false,"name":"nextSkuCodeCount"},"listPrice":{"persistent":false,"hb_formattype":"currency","name":"listPrice"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"defaultSku":{"cfc":"Sku","fetch":"join","fieldtype":"many-to-one","cascade":"delete","fkcolumn":"defaultSkuID","name":"defaultSku"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"calculatedSalePrice":{"ormtype":"big_decimal","name":"calculatedSalePrice"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualProduct","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"productID","inverse":true,"name":"promotionQualifiers"},"allowBackorderFlag":{"persistent":false,"type":"boolean","name":"allowBackorderFlag"},"optionGroupCount":{"persistent":false,"type":"numeric","name":"optionGroupCount"},"salePriceDetailsForSkus":{"persistent":false,"type":"struct","name":"salePriceDetailsForSkus"},"currentAccountPrice":{"persistent":false,"hb_formattype":"currency","name":"currentAccountPrice"},"currencyCode":{"persistent":false,"name":"currencyCode"},"productType":{"cfc":"ProductType","fetch":"join","fieldtype":"many-to-one","fkcolumn":"productTypeID","name":"productType"},"allowAddOptionGroupFlag":{"persistent":false,"type":"boolean","name":"allowAddOptionGroupFlag"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"unusedProductSubscriptionTerms":{"persistent":false,"type":"array","name":"unusedProductSubscriptionTerms"},"loyaltyAccruementExclusions":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruExclProduct","fieldtype":"many-to-many","singularname":"loyaltyAccruementExclusion","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"productID","inverse":true,"type":"array","name":"loyaltyAccruementExclusions"},"title":{"persistent":false,"type":"string","name":"title"},"purchaseEndDateTime":{"ormtype":"timestamp","name":"purchaseEndDateTime"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Product'].className = 'Product';
                	validations['Product'] = {"properties":{"baseProductType":[{"contexts":"addSku","inList":"gift-card,event,merchandise"},{"contexts":"addOptionGroup,addOption","inList":"merchandise"},{"contexts":"addSubscriptionSku","inList":"subscription"},{"contexts":"addEventSchedule,addSkuBundle","inList":"event"}],"price":[{"contexts":"save","dataType":"numeric","required":true}],"optionGroupCount":[{"contexts":"addSku","eq":0}],"productName":[{"contexts":"save","required":true}],"productCode":[{"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$","required":true,"unique":true}],"unusedProductOptionGroups":[{"contexts":"addOptionGroup","minCollection":1}],"productType":[{"contexts":"save","required":true}],"allowAddOptionGroupFlag":[{"contexts":"addOptionGroup,addOption","eq":true}],"unusedProductSubscriptionTerms":[{"contexts":"addSubscriptionTerm","minCollection":1}],"transactionExistsFlag":[{"contexts":"delete","eq":false}],"physicalCounts":[{"contexts":"delete","maxCollection":0}],"urlTitle":[{"contexts":"save","required":true,"unique":true}],"unusedProductOptions":[{"contexts":"addOption","minCollection":1}]}};
                	defaultValues['Product'] = {
                	productID:'',
										activeFlag:1,
									urlTitle:null,
									productName:null,
									productCode:null,
									productDescription:null,
									publishedFlag:false,
									sortOrder:null,
									purchaseStartDateTime:null,
									purchaseEndDateTime:null,
									calculatedSalePrice:null,
									calculatedQATS:null,
									calculatedAllowBackorderFlag:null,
									calculatedTitle:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Product_AddOptionGroup'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"optionGroup":{"name":"optionGroup"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Product_AddOptionGroup'].className = 'Product_AddOptionGroup';
                	validations['Product_AddOptionGroup'] = {"properties":{}};
                	defaultValues['Product_AddOptionGroup'] = {
                	product:'',
										optionGroup:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Product_AddOption'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"option":{"name":"option"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Product_AddOption'].className = 'Product_AddOption';
                	validations['Product_AddOption'] = {"properties":{}};
                	defaultValues['Product_AddOption'] = {
                	product:'',
										option:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Product_AddSubscriptionSku'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"price":{"hb_rbkey":"entity.sku.price","name":"price"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"renewalPrice":{"hb_rbkey":"entity.sku.renewalPrice","name":"renewalPrice"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionTermID":{"name":"subscriptionTermID"},"listPrice":{"hb_rbkey":"entity.sku.listPrice","name":"listPrice"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"renewalSubscriptionBenefits":{"name":"renewalSubscriptionBenefits"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"subscriptionBenefits":{"name":"subscriptionBenefits"}};
                	entities['Product_AddSubscriptionSku'].className = 'Product_AddSubscriptionSku';
                	validations['Product_AddSubscriptionSku'] = {"properties":{"price":[{"dataType":"numeric","required":true}],"renewalPrice":[{"dataType":"numeric","required":true}],"listPrice":[{"dataType":"numeric"}],"renewalSubscriptionBenefits":[{"required":true}],"subscriptionBenefits":[{"required":true}]}};
                	defaultValues['Product_AddSubscriptionSku'] = {
                	product:'',
										subscriptionTermID:'',
									price:0,
										renewalPrice:0,
										subscriptionBenefits:'',
									renewalSubscriptionBenefits:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Product_UpdateSkus'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"skuCurrencies":{"type":"array","name":"skuCurrencies","hb_populatearray":true},"price":{"hb_rbkey":"entity.sku.price","name":"price"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"updatePriceFlag":{"name":"updatePriceFlag"},"listPrice":{"hb_rbkey":"entity.sku.listPrice","name":"listPrice"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"updateListPriceFlag":{"name":"updateListPriceFlag"}};
                	entities['Product_UpdateSkus'].className = 'Product_UpdateSkus';
                	validations['Product_UpdateSkus'] = {"properties":{"price":[{"dataType":"numeric","conditions":"showPrice","required":true}],"listPrice":[{"dataType":"numeric","conditions":"showListPrice","required":true}]},"conditions":{"showListPrice":{"updateListPriceFlag":{"eq":1}},"showPrice":{"updatePriceFlag":{"eq":1}}}};
                	defaultValues['Product_UpdateSkus'] = {
                	product:'',
										updatePriceFlag:'',
									price:'',
									updateListPriceFlag:'',
									listPrice:'',
									skuCurrencies:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Product_AddProductReview'] = {"newProductReview":{"cfc":"ProductReview","persistent":false,"fieldtype":"many-to-one","fkcolumn":"productReviewID","name":"newProductReview"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Product_AddProductReview'].className = 'Product_AddProductReview';
                	validations['Product_AddProductReview'] = {"properties":{}};
                	defaultValues['Product_AddProductReview'] = {
                	product:'',
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Schedule'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"scheduleID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"scheduleID"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"daysOfWeekToRun":{"hb_formfieldtype":"checkboxgroup","ormtype":"string","name":"daysOfWeekToRun"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"scheduleName":{"ormtype":"string","name":"scheduleName"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"recuringType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"recuringType"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"frequencyEndTime":{"hb_nullrbkey":"entity.schedule.frequencyEndTime.runOnce","hb_formfieldtype":"time","ormtype":"timestamp","hb_formattype":"time","name":"frequencyEndTime"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"frequencyStartTime":{"hb_formfieldtype":"time","ormtype":"timestamp","hb_formattype":"time","name":"frequencyStartTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"frequencyInterval":{"ormtype":"integer","name":"frequencyInterval"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"daysOfMonthToRun":{"hb_formfieldtype":"checkboxgroup","ormtype":"string","name":"daysOfMonthToRun"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Schedule'].className = 'Schedule';
                	validations['Schedule'] = {"properties":{"recuringType":[{"contexts":"save","required":true}],"frequencyInterval":[{"contexts":"save","conditions":"frequencyEndTimeExists","required":true}],"frequencyEndTime":[{"contexts":"save","gtDateTimeProperty":"frequencyStartTime","conditions":"frequencyEndTimeExists"}],"scheduleName":[{"contexts":"save","required":true}],"frequencyStartTime":[{"contexts":"save","required":true}]},"conditions":{"frequencyEndTimeExists":{"frequencyEndTime":{"required":true}}}};
                	defaultValues['Schedule'] = {
                	scheduleID:'',
										scheduleName:null,
									recuringType:null,
									daysOfWeekToRun:null,
									daysOfMonthToRun:null,
									frequencyInterval:null,
									frequencyStartTime:null,
									frequencyEndTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountContentAccess'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fetch":"join","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"contents":{"cfc":"Content","linktable":"SwAccountContentAccessContent","fieldtype":"many-to-many","singularname":"content","inversejoincolumn":"contentID","fkcolumn":"accountContentAccessID","type":"array","name":"contents"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"accountContentAccessID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountContentAccessID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accessContents":{"cfc":"Content","linktable":"SwAccountContentAccessContent","fieldtype":"many-to-many","singularname":"accessContent","inversejoincolumn":"contentID","fkcolumn":"accountContentAccessID","type":"array","name":"accessContents"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountContentAccess'].className = 'AccountContentAccess';
                	validations['AccountContentAccess'] = {"properties":{}};
                	defaultValues['AccountContentAccess'] = {
                	accountContentAccessID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Task'] = {"taskUrl":{"ormtype":"string","name":"taskUrl"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"taskConfig":{"length":4000,"ormtype":"string","name":"taskConfig"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"taskHistories":{"cfc":"TaskHistory","fieldtype":"one-to-many","singularname":"taskHistory","cascade":"all-delete-orphan","fkcolumn":"taskID","type":"array","inverse":true,"name":"taskHistories"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taskMethod":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"taskMethod"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"runningFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"runningFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"taskName":{"ormtype":"string","name":"taskName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"taskSchedules":{"cfc":"TaskSchedule","fieldtype":"one-to-many","singularname":"taskSchedule","cascade":"all-delete-orphan","fkcolumn":"taskID","type":"array","inverse":true,"name":"taskSchedules"},"taskID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taskID"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"taskMethodOptions":{"persistent":false,"name":"taskMethodOptions"},"timeout":{"ormtype":"integer","name":"timeout"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Task'].className = 'Task';
                	validations['Task'] = {"properties":{"taskMethod":[{"contexts":"save","required":true}],"taskName":[{"contexts":"save","required":true}]}};
                	defaultValues['Task'] = {
                	taskID:'',
										activeFlag:1,
									taskName:null,
									taskMethod:null,
									taskUrl:null,
									taskConfig:null,
									runningFlag:null,
									timeout:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Attribute'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"attributeCode":{"ormtype":"string","index":"PI_ATTRIBUTECODE","name":"attributeCode"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"decryptValueInAdminFlag":{"ormtype":"boolean","name":"decryptValueInAdminFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"sortcontext":"attributeSet","ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"requiredFlag":{"ormtype":"boolean","default":false,"name":"requiredFlag"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"attributeDescription":{"length":4000,"ormtype":"string","name":"attributeDescription"},"validationMessage":{"ormtype":"string","name":"validationMessage"},"validationRegex":{"ormtype":"string","name":"validationRegex"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"displayOnOrderDetailFlag":{"ormtype":"boolean","default":0,"name":"displayOnOrderDetailFlag"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"delete-orphan","fkcolumn":"attributeID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"typeSet":{"cfc":"Type","fieldtype":"many-to-one","fkcolumn":"typeSetID","name":"typeSet"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"attributeOptions":{"cfc":"AttributeOption","fieldtype":"one-to-many","singularname":"attributeOption","cascade":"all-delete-orphan","fkcolumn":"attributeID","inverse":true,"orderby":"sortOrder","name":"attributeOptions"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"attributeInputType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"attributeInputType"},"attributeSet":{"cfc":"AttributeSet","fieldtype":"many-to-one","fkcolumn":"attributeSetID","hb_optionsnullrbkey":"define.select","name":"attributeSet"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"typeSetOptions":{"persistent":false,"name":"typeSetOptions"},"defaultValue":{"ormtype":"string","name":"defaultValue"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"attributeID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"attributeID"},"relatedObject":{"hb_formfieldtype":"select","ormtype":"string","name":"relatedObject"},"validationType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=validationType","fkcolumn":"validationTypeID","hb_optionsnullrbkey":"define.select","name":"validationType"},"attributeType":{"persistent":false,"name":"attributeType"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"attributeValueUploadDirectory":{"persistent":false,"name":"attributeValueUploadDirectory"},"formFieldType":{"persistent":false,"name":"formFieldType"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeHint":{"ormtype":"string","name":"attributeHint"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"relatedObjectOptions":{"persistent":false,"name":"relatedObjectOptions"},"attributeName":{"ormtype":"string","name":"attributeName"},"attributeInputTypeOptions":{"persistent":false,"name":"attributeInputTypeOptions"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"validationTypeOptions":{"persistent":false,"name":"validationTypeOptions"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Attribute'].className = 'Attribute';
                	validations['Attribute'] = {"properties":{"typeSet":[{"contexts":"save","conditions":"attributeInputTypeRequiresTypeSet","required":true}],"attributeType":[{"contexts":"save","required":true}],"attributeCode":[{"contexts":"save","regex":"^[a-zA-Z][a-zA-Z0-9_]*$","required":true,"unique":true}],"attributeName":[{"contexts":"save","required":true}],"relatedObject":[{"contexts":"save","conditions":"attributeInputTypeRequiresObject","required":true}]},"conditions":{"attributeInputTypeRequiresObject":{"attributeInputType":{"inList":"relatedObjectSelect,relatedObjectMultiselect"}},"attributeInputTypeRequiresTypeSet":{"attributeInputType":{"inList":"typeSelect"}}}};
                	defaultValues['Attribute'] = {
                	attributeID:'',
										activeFlag:1,
									displayOnOrderDetailFlag:0,
									attributeName:null,
									attributeCode:null,
									attributeDescription:null,
									attributeHint:null,
									attributeInputType:null,
									defaultValue:null,
									requiredFlag:false,
									sortOrder:null,
									validationMessage:null,
									validationRegex:null,
									decryptValueInAdminFlag:null,
									relatedObject:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionQualifier'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"promotionQualifierID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionQualifierID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwPromoQualBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"promotionQualifierID","name":"brands"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"excludedOptions":{"cfc":"Option","linktable":"SwPromoQualExclOption","fieldtype":"many-to-many","singularname":"excludedOption","inversejoincolumn":"optionID","fkcolumn":"promotionQualifierID","type":"array","name":"excludedOptions"},"excludedProducts":{"cfc":"Product","linktable":"SwPromoQualExclProduct","fieldtype":"many-to-many","singularname":"excludedProduct","inversejoincolumn":"productID","fkcolumn":"promotionQualifierID","name":"excludedProducts"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"fulfillmentMethods":{"cfc":"FulfillmentMethod","linktable":"SwPromoQualFulfillmentMethod","fieldtype":"many-to-many","singularname":"fulfillmentMethod","inversejoincolumn":"fulfillmentMethodID","fkcolumn":"promotionQualifierID","name":"fulfillmentMethods"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"maximumOrderSubtotal":{"hb_nullrbkey":"define.unlimited","ormtype":"big_decimal","hb_formattype":"currency","name":"maximumOrderSubtotal"},"productTypes":{"cfc":"ProductType","linktable":"SwPromoQualProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"promotionQualifierID","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"options":{"cfc":"Option","linktable":"SwPromoQualOption","fieldtype":"many-to-many","singularname":"option","inversejoincolumn":"optionID","fkcolumn":"promotionQualifierID","name":"options"},"rewardMatchingType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"rewardMatchingType"},"validations":{"persistent":false,"type":"struct","name":"validations"},"qualifierType":{"ormtype":"string","hb_formattype":"rbKey","name":"qualifierType"},"maximumFulfillmentWeight":{"hb_nullrbkey":"define.unlimited","ormtype":"big_decimal","hb_formattype":"weight","name":"maximumFulfillmentWeight"},"products":{"cfc":"Product","linktable":"SwPromoQualProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"promotionQualifierID","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"minimumOrderSubtotal":{"hb_nullrbkey":"define.0","ormtype":"big_decimal","hb_formattype":"currency","name":"minimumOrderSubtotal"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionPeriod":{"cfc":"PromotionPeriod","fieldtype":"many-to-one","fkcolumn":"promotionPeriodID","name":"promotionPeriod"},"excludedBrands":{"cfc":"Brand","linktable":"SwPromoQualExclBrand","fieldtype":"many-to-many","singularname":"excludedBrand","inversejoincolumn":"brandID","fkcolumn":"promotionQualifierID","type":"array","name":"excludedBrands"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"skus":{"cfc":"Sku","linktable":"SwPromoQualSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"promotionQualifierID","name":"skus"},"excludedSkus":{"cfc":"Sku","linktable":"SwPromoQualExclSku","fieldtype":"many-to-many","singularname":"excludedSku","inversejoincolumn":"skuID","fkcolumn":"promotionQualifierID","name":"excludedSkus"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"minimumFulfillmentWeight":{"hb_nullrbkey":"define.0","ormtype":"big_decimal","hb_formattype":"weight","name":"minimumFulfillmentWeight"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"qualifierApplicationTypeOptions":{"persistent":false,"type":"array","name":"qualifierApplicationTypeOptions"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"maximumOrderQuantity":{"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumOrderQuantity"},"maximumItemQuantity":{"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumItemQuantity"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"minimumItemQuantity":{"hb_nullrbkey":"define.0","ormtype":"integer","name":"minimumItemQuantity"},"excludedProductTypes":{"cfc":"ProductType","linktable":"SwPromoQualExclProductType","fieldtype":"many-to-many","singularname":"excludedProductType","inversejoincolumn":"productTypeID","fkcolumn":"promotionQualifierID","name":"excludedProductTypes"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"minimumItemPrice":{"hb_nullrbkey":"define.0","ormtype":"big_decimal","hb_formattype":"currency","name":"minimumItemPrice"},"minimumOrderQuantity":{"hb_nullrbkey":"define.0","ormtype":"integer","name":"minimumOrderQuantity"},"maximumItemPrice":{"hb_nullrbkey":"define.unlimited","ormtype":"big_decimal","hb_formattype":"currency","name":"maximumItemPrice"},"shippingAddressZones":{"cfc":"AddressZone","linktable":"SwPromoQualShipAddressZone","fieldtype":"many-to-many","singularname":"shippingAddressZone","inversejoincolumn":"addressZoneID","fkcolumn":"promotionQualifierID","name":"shippingAddressZones"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"shippingMethods":{"cfc":"ShippingMethod","linktable":"SwPromoQualShippingMethod","fieldtype":"many-to-many","singularname":"shippingMethod","inversejoincolumn":"shippingMethodID","fkcolumn":"promotionQualifierID","name":"shippingMethods"}};
                	entities['PromotionQualifier'].className = 'PromotionQualifier';
                	validations['PromotionQualifier'] = {"properties":{}};
                	defaultValues['PromotionQualifier'] = {
                	promotionQualifierID:'',
										qualifierType:null,
									minimumOrderQuantity:null,
									maximumOrderQuantity:null,
									minimumOrderSubtotal:null,
									maximumOrderSubtotal:null,
									minimumItemQuantity:null,
									maximumItemQuantity:null,
									minimumItemPrice:null,
									maximumItemPrice:null,
									minimumFulfillmentWeight:null,
									maximumFulfillmentWeight:null,
									rewardMatchingType:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionTerm'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"skus":{"cfc":"Sku","fieldtype":"one-to-many","singularname":"sku","cascade":"all","fkcolumn":"subscriptionTermID","type":"array","inverse":true,"name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"renewalTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"renewalTermID","name":"renewalTerm"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"allowProrateFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"allowProrateFlag"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"gracePeriodTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"gracePeriodTermID","name":"gracePeriodTerm"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"autoRenewFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"autoRenewFlag"},"autoPayFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"autoPayFlag"},"validations":{"persistent":false,"type":"struct","name":"validations"},"subscriptionTermName":{"ormtype":"string","name":"subscriptionTermName"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"initialTerm":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"initialTermID","name":"initialTerm"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionTermID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionTermID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionTerm'].className = 'SubscriptionTerm';
                	validations['SubscriptionTerm'] = {"properties":{"subscriptionTermName":[{"contexts":"save","required":true}],"skus":[{"contexts":"delete","maxCollection":0}],"renewalTerm":[{"contexts":"save","required":true}],"initialTerm":[{"contexts":"save","required":true}],"renewalReminderDays":[{"contexts":"save","regex":"^([0-9]+,?)+$"}],"autoRetryPaymentDays":[{"contexts":"save","regex":"^([0-9]+,?)+$"}]}};
                	defaultValues['SubscriptionTerm'] = {
                	subscriptionTermID:'',
										subscriptionTermName:null,
									allowProrateFlag:null,
									autoRenewFlag:null,
									autoPayFlag:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderDelivery'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"paymentTransaction":{"cfc":"PaymentTransaction","fieldtype":"many-to-one","fkcolumn":"paymentTransactionID","name":"paymentTransaction"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"totalQuantityDelivered":{"persistent":false,"hb_formattype":"numeric","type":"numeric","name":"totalQuantityDelivered"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"shippingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"shippingAddressID","name":"shippingAddress"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"trackingNumber":{"ormtype":"string","name":"trackingNumber"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"orderDeliveryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderDeliveryID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","name":"shippingMethod"},"orderDeliveryItems":{"cfc":"OrderDeliveryItem","fieldtype":"one-to-many","singularname":"orderDeliveryItem","cascade":"all-delete-orphan","fkcolumn":"orderDeliveryID","inverse":true,"name":"orderDeliveryItems"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"fulfillmentMethod":{"cfc":"FulfillmentMethod","fieldtype":"many-to-one","fkcolumn":"fulfillmentMethodID","name":"fulfillmentMethod"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"orderDeliveryID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderDelivery'].className = 'OrderDelivery';
                	validations['OrderDelivery'] = {"properties":{"location":[{"contexts":"save","required":true}],"order":[{"contexts":"save","required":true}],"orderDeliveryID":[{"contexts":"delete","maxLength":0}],"orderDeliveryItems":[{"contexts":"save","required":true,"minCollection":1}]}};
                	defaultValues['OrderDelivery'] = {
                	orderDeliveryID:'',
										trackingNumber:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderDelivery_Create'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"orderDelivery":{"name":"orderDelivery"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"shippingMethod":{"cfc":"ShippingMethod","fieldtype":"many-to-one","fkcolumn":"shippingMethodID","name":"shippingMethod"},"orderDeliveryItems":{"type":"array","name":"orderDeliveryItems","hb_populatearray":true},"captureAuthorizedPaymentsFlag":{"hb_formfieldtype":"yesno","name":"captureAuthorizedPaymentsFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"shippingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"shippingAddressID","name":"shippingAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"trackingNumber":{"name":"trackingNumber"},"capturableAmount":{"hb_formattype":"currency","name":"capturableAmount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderDelivery_Create'].className = 'OrderDelivery_Create';
                	validations['OrderDelivery_Create'] = {"properties":{"orderDeliveryItems":[{"method":"hasRecipientsForAllGiftCardDeliveryItems"}]},"conditions":{},"populatedPropertyValidation":{}};
                	defaultValues['OrderDelivery_Create'] = {
                	orderDelivery:'',
										orderDeliveryItems:[],
										trackingNumber:'',
									capturableAmount:0,
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['StockAdjustmentDeliveryItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","fkcolumn":"stockID","name":"stock"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"stockAdjustmentDeliveryItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockAdjustmentDeliveryItemID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"stockAdjustmentDelivery":{"cfc":"StockAdjustmentDelivery","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentDeliveryID","name":"stockAdjustmentDelivery"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustmentItem":{"cfc":"StockAdjustmentItem","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentItemID","name":"stockAdjustmentItem"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockAdjustmentDeliveryItem'].className = 'StockAdjustmentDeliveryItem';
                	validations['StockAdjustmentDeliveryItem'] = {"properties":{"stockAdjustmentDelivery":[{"contexts":"save","required":true}],"stockAdjustmentItem":[{"contexts":"save","required":true}],"stock":[{"contexts":"save","required":true}]}};
                	defaultValues['StockAdjustmentDeliveryItem'] = {
                	stockAdjustmentDeliveryItemID:'',
										quantity:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PriceGroupRateCurrency'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"hb_rbkey":"entity.priceGroupRate.amount","ormtype":"big_decimal","hb_formattype":"currency","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"currency":{"cfc":"Currency","fieldtype":"many-to-one","fkcolumn":"currencyCode","name":"currency"},"priceGroupRate":{"cfc":"PriceGroupRate","fieldtype":"many-to-one","fkcolumn":"priceGroupRateID","name":"priceGroupRate"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRateCurrencyID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"priceGroupRateCurrencyID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"insert":false,"update":false,"name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PriceGroupRateCurrency'].className = 'PriceGroupRateCurrency';
                	validations['PriceGroupRateCurrency'] = {"properties":{}};
                	defaultValues['PriceGroupRateCurrency'] = {
                	priceGroupRateCurrencyID:'',
										amount:null,
									currencyCode:'USD',
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['FileRelationship'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"file":{"cfc":"File","fieldtype":"many-to-one","fkcolumn":"fileID","name":"file"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"baseObject":{"ormtype":"string","name":"baseObject"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"fileRelationshipID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"fileRelationshipID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"baseID":{"ormtype":"string","name":"baseID"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['FileRelationship'].className = 'FileRelationship';
                	validations['FileRelationship'] = {"properties":{}};
                	defaultValues['FileRelationship'] = {
                	fileRelationshipID:'',
										baseObject:null,
									baseID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['TaskHistory'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"endTime":{"ormtype":"timestamp","name":"endTime"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"successFlag":{"ormtype":"boolean","name":"successFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"taskSchedule":{"cfc":"TaskSchedule","fieldtype":"many-to-one","fkcolumn":"taskScheduleID","name":"taskSchedule"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"response":{"ormtype":"string","name":"response"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taskHistoryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"taskHistoryID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"task":{"cfc":"Task","fieldtype":"many-to-one","fkcolumn":"taskID","name":"task"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"startTime":{"ormtype":"timestamp","name":"startTime"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"duration":{"persistent":false,"hb_formattype":"second","name":"duration"}};
                	entities['TaskHistory'].className = 'TaskHistory';
                	validations['TaskHistory'] = {"properties":{}};
                	defaultValues['TaskHistory'] = {
                	taskHistoryID:'',
										successFlag:null,
									response:null,
									startTime:null,
									endTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ShortReference'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"referenceObject":{"ormtype":"string","index":"EI_REFERENCEOBJECT","name":"referenceObject"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"referenceEntity":{"persistent":false,"name":"referenceEntity"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"referenceObjectID":{"unique":true,"ormtype":"string","index":"EI_REFERENCEOBJECTID","name":"referenceObjectID"},"shortReferenceID":{"unsavedvalue":0,"fieldtype":"id","ormtype":"integer","default":0,"name":"shortReferenceID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ShortReference'].className = 'ShortReference';
                	validations['ShortReference'] = {"properties":{}};
                	defaultValues['ShortReference'] = {
                	shortReferenceID:0,
									referenceObjectID:null,
									referenceObject:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['FulfillmentMethod'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"fulfillmentMethodName":{"ormtype":"string","name":"fulfillmentMethodName"},"orderFulfillments":{"cfc":"OrderFulfillment","fieldtype":"one-to-many","lazy":"extra","singularname":"orderFulfillment","fkcolumn":"fulfillmentMethodID","inverse":true,"name":"orderFulfillments"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"autoFulfillFlag":{"ormtype":"boolean","default":false,"name":"autoFulfillFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"fulfillmentMethodType":{"hb_formfieldtype":"select","ormtype":"string","name":"fulfillmentMethodType"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualFulfillmentMethod","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"fulfillmentMethodID","inverse":true,"type":"array","name":"promotionQualifiers"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"fulfillmentMethodID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"fulfillmentMethodID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":false,"name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"shippingMethods":{"cfc":"ShippingMethod","fieldtype":"one-to-many","singularname":"shippingMethod","cascade":"all-delete-orphan","fkcolumn":"fulfillmentMethodID","type":"array","inverse":true,"name":"shippingMethods"}};
                	entities['FulfillmentMethod'].className = 'FulfillmentMethod';
                	validations['FulfillmentMethod'] = {"properties":{"fulfillmentMethodName":[{"contexts":"save","required":true}],"orderFulfillments":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['FulfillmentMethod'] = {
                	fulfillmentMethodID:'',
										fulfillmentMethodName:null,
									fulfillmentMethodType:null,
									activeFlag:false,
									sortOrder:null,
									autoFulfillFlag:false,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Brand'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"brandID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"brandID"},"brandName":{"hint":"This is the common name that the brand goes by.","ormtype":"string","name":"brandName"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardBrand","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"vendors":{"cfc":"Vendor","linktable":"SwVendorBrand","fieldtype":"many-to-many","singularname":"vendor","inversejoincolumn":"vendorID","fkcolumn":"brandID","inverse":true,"name":"vendors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionBrand","fieldtype":"many-to-many","singularname":"loyaltyredemption","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"brandID","inverse":true,"type":"array","name":"loyaltyRedemptions"},"physicals":{"cfc":"Physical","linktable":"SwPhysicalBrand","fieldtype":"many-to-many","singularname":"physical","inversejoincolumn":"physicalID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"type":"array","name":"physicals"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"brandWebsite":{"hint":"This is the Website of the brand","ormtype":"string","hb_formattype":"url","name":"brandWebsite"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"promotionRewardExclusions":{"cfc":"PromotionReward","linktable":"SwPromoRewardExclBrand","fieldtype":"many-to-many","singularname":"promotionRewardExclusion","inversejoincolumn":"promotionRewardID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"type":"array","name":"promotionRewardExclusions"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"loyaltyRedemptionExclusions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionExclBrand","fieldtype":"many-to-many","singularname":"loyaltyRedemptionExclusion","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"brandID","inverse":true,"type":"array","name":"loyaltyRedemptionExclusions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualBrand","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"name":"promotionQualifiers"},"promotionQualifierExclusions":{"cfc":"PromotionQualifier","linktable":"SwPromoQualExclBrand","fieldtype":"many-to-many","singularname":"promotionQualifierExclusion","inversejoincolumn":"promotionQualifierID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"type":"array","name":"promotionQualifierExclusions"},"loyaltyAccruements":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruBrand","fieldtype":"many-to-many","singularname":"loyaltyAccruement","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"name":"loyaltyAccruements"},"publishedFlag":{"ormtype":"boolean","name":"publishedFlag"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"hint":"As Brands Get Old, They would be marked as Not Active","ormtype":"boolean","name":"activeFlag"},"products":{"cfc":"Product","fieldtype":"one-to-many","singularname":"product","fkcolumn":"brandID","type":"array","inverse":true,"name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"brandID","type":"array","inverse":true,"name":"attributeValues"},"loyaltyAccruementExclusions":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruExclBrand","fieldtype":"many-to-many","singularname":"loyaltyAccruementExclusion","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"brandID","inverse":true,"hb_populateenabled":false,"type":"array","name":"loyaltyAccruementExclusions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"urlTitle":{"hint":"This is the name that is used in the URL string","unique":true,"ormtype":"string","name":"urlTitle"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Brand'].className = 'Brand';
                	validations['Brand'] = {"properties":{"brandName":[{"contexts":"save","required":true}],"products":[{"contexts":"delete","maxCollection":0}],"brandWebsite":[{"contexts":"save","dataType":"url"}],"urlTitle":[{"contexts":"save","required":true,"unique":true}],"physicalCounts":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['Brand'] = {
                	brandID:'',
										activeFlag:1,
									publishedFlag:null,
									urlTitle:null,
									brandName:null,
									brandWebsite:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['EmailVerification'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"accountEmailAddress":{"cfc":"AccountEmailAddress","fieldtype":"many-to-one","fkcolumn":"accountEmailAddressID","name":"accountEmailAddress"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"emailVerificationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"emailVerificationID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['EmailVerification'].className = 'EmailVerification';
                	validations['EmailVerification'] = {"properties":{}};
                	defaultValues['EmailVerification'] = {
                	emailVerificationID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SkuBundle'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"skuBundleID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"skuBundleID"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"bundledQuantity":{"ormtype":"integer","name":"bundledQuantity"},"remoteID":{"ormtype":"string","name":"remoteID"},"bundledSku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"bundledSkuID","name":"bundledSku"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SkuBundle'].className = 'SkuBundle';
                	validations['SkuBundle'] = {"properties":{"bundledQuantity":[{"dataType":"numeric","required":true}]}};
                	defaultValues['SkuBundle'] = {
                	skuBundleID:'',
										bundledQuantity:null,
									remoteID:null,
									createdDateTime:'',
										modifiedDateTime:'',
										
						z:''
	                };
                
                	entities['ProductBundleBuild'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"productBundleBuildID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productBundleBuildID"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"session":{"cfc":"Session","fieldtype":"many-to-one","fkcolumn":"sessionID","name":"session"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"productBundleSku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"productBundleSkuID","name":"productBundleSku"}};
                	entities['ProductBundleBuild'].className = 'ProductBundleBuild';
                	validations['ProductBundleBuild'] = {"properties":{}};
                	defaultValues['ProductBundleBuild'] = {
                	productBundleBuildID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountPaymentMethod'] = {"creditCardType":{"ormtype":"string","name":"creditCardType"},"paymentMethodOptions":{"persistent":false,"name":"paymentMethodOptions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"expirationMonth":{"hb_formfieldtype":"select","ormtype":"string","hb_populateenabled":"public","name":"expirationMonth"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","lazy":"extra","singularname":"orderPayment","cascade":"all","fkcolumn":"accountPaymentMethodID","inverse":true,"name":"orderPayments"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"giftCardBalanceAmountFormatted":{"persistent":false,"name":"giftCardBalanceAmountFormatted"},"companyPaymentMethodFlag":{"ormtype":"boolean","hb_populateenabled":"public","name":"companyPaymentMethodFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","hb_optionsnullrbkey":"define.select","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"creditCardNumber":{"persistent":false,"hb_populateenabled":"public","name":"creditCardNumber"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"giftCardBalanceAmount":{"persistent":false,"name":"giftCardBalanceAmount"},"bankRoutingNumberEncrypted":{"ormtype":"string","name":"bankRoutingNumberEncrypted"},"providerToken":{"ormtype":"string","name":"providerToken"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"creditCardLastFour":{"ormtype":"string","name":"creditCardLastFour"},"creditCardNumberEncryptedDateTime":{"column":"creditCardNumberEncryptDT","hb_auditable":false,"ormtype":"timestamp","name":"creditCardNumberEncryptedDateTime"},"billingAccountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"billingAccountAddressID","hb_optionsnullrbkey":"define.select","hb_populateenabled":"public","name":"billingAccountAddress"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"paymentTransactions":{"cfc":"PaymentTransaction","fieldtype":"one-to-many","singularname":"paymentTransaction","cascade":"all","fkcolumn":"accountPaymentMethodID","type":"array","inverse":true,"name":"paymentTransactions"},"paymentMethodOptionsSmartList":{"persistent":false,"name":"paymentMethodOptionsSmartList"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"paymentTerm":{"cfc":"PaymentTerm","fetch":"join","fieldtype":"many-to-one","fkcolumn":"paymentTermID","hb_populateenabled":"public","name":"paymentTerm"},"giftCardNumber":{"persistent":false,"hb_populateenabled":"public","name":"giftCardNumber"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"nameOnCreditCard":{"ormtype":"string","hb_populateenabled":"public","name":"nameOnCreditCard"},"paymentMethod":{"cfc":"PaymentMethod","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:activeFlag=1&f:paymentMethodType=creditCard,termPayment,check,giftCard","hb_optionsadditionalproperties":"paymentMethodType","fkcolumn":"paymentMethodID","hb_optionsnullrbkey":"define.select","hb_populateenabled":"public","name":"paymentMethod"},"bankRoutingNumber":{"persistent":false,"hb_populateenabled":"public","name":"bankRoutingNumber"},"expirationYear":{"hb_formfieldtype":"select","ormtype":"string","hb_populateenabled":"public","name":"expirationYear"},"creditCardNumberEncryptedGenerator":{"column":"creditCardNumberEncryptGen","hb_auditable":false,"ormtype":"string","name":"creditCardNumberEncryptedGenerator"},"billingAddress":{"cfc":"Address","fieldtype":"many-to-one","fkcolumn":"billingAddressID","hb_optionsnullrbkey":"define.select","hb_populateenabled":"public","name":"billingAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"creditCardNumberEncrypted":{"hb_auditable":false,"ormtype":"string","name":"creditCardNumberEncrypted"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"bankAccountNumber":{"persistent":false,"hb_populateenabled":"public","name":"bankAccountNumber"},"bankAccountNumberEncrypted":{"ormtype":"string","name":"bankAccountNumberEncrypted"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"accountPaymentMethodName":{"ormtype":"string","hb_populateenabled":"public","name":"accountPaymentMethodName"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"giftCardNumberEncrypted":{"ormtype":"string","name":"giftCardNumberEncrypted"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"accountPaymentMethodID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountPaymentMethodID"},"securityCode":{"persistent":false,"hb_populateenabled":"public","name":"securityCode"}};
                	entities['AccountPaymentMethod'].className = 'AccountPaymentMethod';
                	validations['AccountPaymentMethod'] = {"properties":{"paymentMethod":[{"contexts":"save","required":true}],"expirationYear":[{"contexts":"save","dataType":"numeric","conditions":"paymentTypeCreditCard","required":true}],"expirationMonth":[{"contexts":"save","dataType":"numeric","conditions":"paymentTypeCreditCard","required":true}],"orderPayments":[{"contexts":"delete","maxCollection":0}],"creditCardNumber":[{"contexts":"save","dataType":"creditCard","conditions":"paymentTypeCreditCardAndNew,editExistingCreditCardNumber","required":true}],"nameOnCreditCard":[{"contexts":"save","conditions":"paymentTypeCreditCard","required":true}],"paymentTransactions":[{"contexts":"delete","maxCollection":0}]},"conditions":{"paymentTypeCreditCard":{"paymentMethod.paymentMethodType":{"eq":"creditCard"}},"editExistingCreditCardNumber":{"newFlag":{"eq":false},"creditCardNumber":{"minLength":1},"paymentMethod.paymentMethodType":{"eq":"creditCard"}},"paymentTypeCreditCardAndNew":{"newFlag":{"eq":true},"paymentMethod.paymentMethodType":{"eq":"creditCard"}}},"populatedPropertyValidation":{"billingAddress":[{"validate":"full"}]}};
                	defaultValues['AccountPaymentMethod'] = {
                	accountPaymentMethodID:'',
										activeFlag:1,
									accountPaymentMethodName:null,
									bankRoutingNumberEncrypted:null,
									bankAccountNumberEncrypted:null,
									companyPaymentMethodFlag:null,
									creditCardNumberEncrypted:null,
									creditCardNumberEncryptedDateTime:null,
									creditCardNumberEncryptedGenerator:null,
									creditCardLastFour:null,
									creditCardType:null,
									expirationMonth:null,
									expirationYear:null,
									giftCardNumberEncrypted:null,
									nameOnCreditCard:null,
									providerToken:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Address'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"phoneNumber":{"ormtype":"string","hb_populateenabled":"public","name":"phoneNumber"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"emailAddress":{"ormtype":"string","hb_populateenabled":"public","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"firstName":{"ormtype":"string","hb_populateenabled":"public","name":"firstName"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stateCodeOptions":{"persistent":false,"type":"array","name":"stateCodeOptions"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"locality":{"ormtype":"string","hb_populateenabled":"public","name":"locality"},"middleName":{"ormtype":"string","hb_populateenabled":"public","name":"middleName"},"stateCode":{"ormtype":"string","hb_populateenabled":"public","name":"stateCode"},"country":{"persistent":false,"name":"country"},"salutation":{"hb_formfieldtype":"select","ormtype":"string","hb_populateenabled":"public","name":"salutation"},"lastName":{"ormtype":"string","hb_populateenabled":"public","name":"lastName"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"addressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"addressID"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"postalCode":{"ormtype":"string","hb_populateenabled":"public","name":"postalCode"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"salutationOptions":{"persistent":false,"type":"array","name":"salutationOptions"},"countryCodeOptions":{"persistent":false,"type":"array","name":"countryCodeOptions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"street2Address":{"ormtype":"string","hb_populateenabled":"public","name":"street2Address"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"middleInitial":{"ormtype":"string","hb_populateenabled":"public","name":"middleInitial"},"name":{"ormtype":"string","hb_populateenabled":"public","name":"name"},"company":{"ormtype":"string","hb_populateenabled":"public","name":"company"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"city":{"ormtype":"string","hb_populateenabled":"public","name":"city"},"countryCode":{"ormtype":"string","hb_populateenabled":"public","name":"countryCode"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"streetAddress":{"ormtype":"string","hb_populateenabled":"public","name":"streetAddress"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Address'].className = 'Address';
                	validations['Address'] = {"properties":{"postalCode":[{"contexts":"full,location","conditions":"postalCodeRequired","required":true}],"locality":[{"contexts":"full,location","conditions":"localityRequired","required":true}],"country":[{"contexts":"save,full","required":true}],"city":[{"contexts":"full,location","conditions":"cityRequired","required":true}],"stateCode":[{"contexts":"full,location","conditions":"stateCodeRequired","required":true}],"streetAddress":[{"contexts":"full,location","conditions":"streetAddressRequired","required":true}],"emailAddress":[{"contexts":"save","dataType":"email"}],"street2Address":[{"contexts":"full,location","conditions":"street2AddressRequired","required":true}],"name":[{"contexts":"full","required":true}]},"conditions":{"localityRequired":{"country.localityRequiredFlag":{"eq":true}},"stateCodeRequired":{"country.stateCodeRequiredFlag":{"eq":true}},"postalCodeRequired":{"country.postalCodeRequiredFlag":{"eq":true}},"cityRequired":{"country.cityRequiredFlag":{"eq":true}},"streetAddressRequired":{"country.streetAddressRequiredFlag":{"eq":true}},"street2AddressRequired":{"country.street2AddressRequiredFlag":{"eq":true}}}};
                	defaultValues['Address'] = {
                	addressID:'',
										name:null,
									company:null,
									streetAddress:null,
									street2Address:null,
									locality:null,
									city:null,
									stateCode:null,
									postalCode:null,
									countryCode:null,
									salutation:null,
									firstName:null,
									lastName:null,
									middleName:null,
									middleInitial:null,
									phoneNumber:null,
									emailAddress:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionApplied'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"promotionAppliedID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionAppliedID"},"discountAmount":{"ormtype":"big_decimal","name":"discountAmount"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"appliedType":{"ormtype":"string","name":"appliedType"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderfulfillmentID","name":"orderFulfillment"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"promotion":{"cfc":"Promotion","fieldtype":"many-to-one","fkcolumn":"promotionID","name":"promotion"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PromotionApplied'].className = 'PromotionApplied';
                	validations['PromotionApplied'] = {"properties":{}};
                	defaultValues['PromotionApplied'] = {
                	promotionAppliedID:'',
										discountAmount:null,
									appliedType:null,
									currencyCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Permission'] = {"permissionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"permissionID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"propertyName":{"ormtype":"string","name":"propertyName"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"permissionGroup":{"cfc":"PermissionGroup","fieldtype":"many-to-one","fkcolumn":"permissionGroupID","name":"permissionGroup"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"allowUpdateFlag":{"ormtype":"boolean","name":"allowUpdateFlag"},"processContext":{"ormtype":"string","name":"processContext"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"allowActionFlag":{"ormtype":"boolean","name":"allowActionFlag"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"allowCreateFlag":{"ormtype":"boolean","name":"allowCreateFlag"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"allowDeleteFlag":{"ormtype":"boolean","name":"allowDeleteFlag"},"allowReadFlag":{"ormtype":"boolean","name":"allowReadFlag"},"entityClassName":{"ormtype":"string","name":"entityClassName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"subsystem":{"ormtype":"string","name":"subsystem"},"item":{"ormtype":"string","name":"item"},"allowProcessFlag":{"ormtype":"boolean","name":"allowProcessFlag"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"accessType":{"ormtype":"string","name":"accessType"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"section":{"ormtype":"string","name":"section"}};
                	entities['Permission'].className = 'Permission';
                	validations['Permission'] = {"properties":{}};
                	defaultValues['Permission'] = {
                	permissionID:'',
										accessType:null,
									subsystem:null,
									section:null,
									item:null,
									allowActionFlag:null,
									allowCreateFlag:null,
									allowReadFlag:null,
									allowUpdateFlag:null,
									allowDeleteFlag:null,
									allowProcessFlag:null,
									entityClassName:null,
									propertyName:null,
									processContext:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AttributeSet'] = {"attributes":{"cfc":"Attribute","fieldtype":"one-to-many","singularname":"attribute","cascade":"all-delete-orphan","fkcolumn":"attributeSetID","inverse":true,"orderby":"sortOrder","name":"attributes"},"attributeSetObject":{"hb_formfieldtype":"select","ormtype":"string","name":"attributeSetObject"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"attributeSetName":{"ormtype":"string","name":"attributeSetName"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"globalFlag":{"ormtype":"boolean","default":1,"name":"globalFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"attributeSetID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"attributeSetID"},"brands":{"cfc":"Brand","linktable":"SwAttributeSetBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"attributeSetID","type":"array","name":"brands"},"contents":{"cfc":"Content","linktable":"SwAttributeSetContent","fieldtype":"many-to-many","singularname":"content","inversejoincolumn":"contentID","fkcolumn":"attributeSetID","type":"array","name":"contents"},"skus":{"cfc":"Sku","linktable":"SwAttributeSetSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"attributeSetID","type":"array","name":"skus"},"types":{"cfc":"Type","linktable":"SwAttributeSetType","fieldtype":"many-to-many","singularname":"type","inversejoincolumn":"typeID","fkcolumn":"attributeSetID","type":"array","name":"types"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"productTypes":{"cfc":"ProductType","linktable":"SwAttributeSetProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"attributeSetID","type":"array","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"attributeSetDescription":{"length":2000,"ormtype":"string","name":"attributeSetDescription"},"accountSaveFlag":{"ormtype":"boolean","name":"accountSaveFlag"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"products":{"cfc":"Product","linktable":"SwAttributeSetProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"attributeSetID","type":"array","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"attributeSetCode":{"ormtype":"string","index":"PI_ATTRIBUTESETCODE","name":"attributeSetCode"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AttributeSet'].className = 'AttributeSet';
                	validations['AttributeSet'] = {"properties":{"attributeSetObject":[{"contexts":"save","required":true}],"attributeSetName":[{"contexts":"save","required":true}],"attributeSetCode":[{"uniqueOrNull":true,"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$"}]}};
                	defaultValues['AttributeSet'] = {
                	attributeSetID:'',
										activeFlag:1,
									attributeSetName:null,
									attributeSetCode:null,
									attributeSetDescription:null,
									attributeSetObject:null,
									globalFlag:1,
									accountSaveFlag:null,
									sortOrder:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AlternateSkuCode'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"alternateSkuCode":{"ormtype":"string","index":"PI_ALTERNATESKUCODE","name":"alternateSkuCode"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"alternateSkuCodeID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"alternateSkuCodeID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"alternateSkuCodeType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=alternateSkuCodeType","fkcolumn":"skuTypeID","name":"alternateSkuCodeType"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AlternateSkuCode'].className = 'AlternateSkuCode';
                	validations['AlternateSkuCode'] = {"properties":{"alternateSkuCode":[{"contexts":"save","required":true,"unique":true}]}};
                	defaultValues['AlternateSkuCode'] = {
                	alternateSkuCodeID:'',
										alternateSkuCode:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PrintTemplate'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"printTemplateObjectOptions":{"persistent":false,"name":"printTemplateObjectOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"printTemplateObject":{"hb_formfieldtype":"select","ormtype":"string","name":"printTemplateObject"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"printContent":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"printContent"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"printTemplateFileOptions":{"persistent":false,"name":"printTemplateFileOptions"},"printTemplateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"printTemplateID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"printTemplateFile":{"hb_formfieldtype":"select","ormtype":"string","name":"printTemplateFile"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"printTemplateName":{"ormtype":"string","name":"printTemplateName"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PrintTemplate'].className = 'PrintTemplate';
                	validations['PrintTemplate'] = {"properties":{}};
                	defaultValues['PrintTemplate'] = {
                	printTemplateID:'',
										printTemplateName:null,
									printTemplateObject:null,
									printTemplateFile:null,
									printContent:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PaymentTerm'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","singularname":"orderPayment","fkcolumn":"paymentTermID","inverse":true,"hb_populateenabled":false,"type":"array","orderby":"createdDateTime desc","name":"orderPayments"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"paymentTermName":{"ormtype":"string","name":"paymentTermName"},"term":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"termID","name":"term"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"paymentTermID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"paymentTermID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"accountPaymentMethods":{"cfc":"AccountPaymentMethod","fieldtype":"one-to-many","singularname":"accountPaymentMethod","fkcolumn":"paymentTermID","inverse":true,"hb_populateenabled":false,"type":"array","orderby":"createdDateTime desc","name":"accountPaymentMethods"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PaymentTerm'].className = 'PaymentTerm';
                	validations['PaymentTerm'] = {"properties":{"accountPaymentMethods":[{"contexts":"delete","maxCollection":0}],"orderPayments":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['PaymentTerm'] = {
                	paymentTermID:'',
										activeFlag:1,
									paymentTermName:null,
									sortOrder:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionOrderItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"subscriptionOrderItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionOrderItemID"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"subscriptionOrderItemType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=subscriptionOrderItemType","fkcolumn":"subscriptionOrderItemTypeID","name":"subscriptionOrderItemType"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","cascade":"all","fkcolumn":"subscriptionUsageID","name":"subscriptionUsage"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionOrderItem'].className = 'SubscriptionOrderItem';
                	validations['SubscriptionOrderItem'] = {"properties":{}};
                	defaultValues['SubscriptionOrderItem'] = {
                	subscriptionOrderItemID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ContentAccess'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"contentAccessID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"contentAccessID"},"content":{"cfc":"Content","fieldtype":"many-to-one","fkcolumn":"contentID","name":"content"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"accountContentAccess":{"cfc":"AccountContentAccess","fieldtype":"many-to-one","fkcolumn":"accountContentAccessID","name":"accountContentAccess"},"subscriptionUsageBenefit":{"cfc":"SubscriptionUsageBenefit","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageBenefitID","name":"subscriptionUsageBenefit"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ContentAccess'].className = 'ContentAccess';
                	validations['ContentAccess'] = {"properties":{}};
                	defaultValues['ContentAccess'] = {
                	contentAccessID:'',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['RoundingRule'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"roundingRuleExpression":{"ormtype":"string","name":"roundingRuleExpression"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRates":{"cfc":"PriceGroupRate","fieldtype":"one-to-many","singularname":"priceGroupRate","fkcolumn":"roundingRuleID","inverse":true,"name":"priceGroupRates"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"roundingRuleDirection":{"ormtype":"string","name":"roundingRuleDirection"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"roundingRuleName":{"ormtype":"string","name":"roundingRuleName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"roundingRuleID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"roundingRuleID"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['RoundingRule'].className = 'RoundingRule';
                	validations['RoundingRule'] = {"properties":{"priceGroupRates":[{"contexts":"delete","maxCollection":0}],"roundingRuleExpression":[{"contexts":"save","required":true,"method":"hasExpressionWithListOfNumericValuesOnly"}],"roundingRuleDirection":[{"contexts":"save","required":true}],"roundingRuleName":[{"contexts":"save","required":true}]}};
                	defaultValues['RoundingRule'] = {
                	roundingRuleID:'',
										roundingRuleName:null,
									roundingRuleExpression:null,
									roundingRuleDirection:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionPeriod'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionRewards":{"cfc":"PromotionReward","fieldtype":"one-to-many","singularname":"promotionReward","cascade":"all-delete-orphan","fkcolumn":"promotionPeriodID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"startDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","hb_formattype":"dateTime","name":"startDateTime"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"maximumUseCount":{"notnull":false,"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumUseCount"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","fieldtype":"one-to-many","singularname":"promotionQualifier","cascade":"all-delete-orphan","fkcolumn":"promotionPeriodID","inverse":true,"name":"promotionQualifiers"},"promotionPeriodID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionPeriodID"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"currentFlag":{"persistent":false,"type":"boolean","name":"currentFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"promotion":{"cfc":"Promotion","fetch":"join","fieldtype":"many-to-one","fkcolumn":"promotionID","name":"promotion"},"endDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","hb_formattype":"dateTime","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"maximumAccountUseCount":{"notnull":false,"hb_nullrbkey":"define.unlimited","ormtype":"integer","name":"maximumAccountUseCount"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PromotionPeriod'].className = 'PromotionPeriod';
                	validations['PromotionPeriod'] = {"properties":{"endDateTime":[{"contexts":"save","dataType":"date"},{"contexts":"save","gtDateTimeProperty":"startDateTime","conditions":"needsEndAfterStart"}],"startDateTime":[{"contexts":"save","dataType":"date"}]},"conditions":{"needsEndAfterStart":{"endDateTime":{"required":true},"startDateTime":{"required":true}}}};
                	defaultValues['PromotionPeriod'] = {
                	promotionPeriodID:'',
										startDateTime:null,
									endDateTime:null,
									maximumUseCount:null,
									maximumAccountUseCount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['State'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"stateCode":{"fieldtype":"id","length":40,"ormtype":"string","name":"stateCode"},"country":{"cfc":"Country","fieldtype":"many-to-one","insert":false,"update":false,"fkcolumn":"countryCode","name":"country"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"stateName":{"ormtype":"string","name":"stateName"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"countryCode":{"fieldtype":"id","length":2,"ormtype":"string","name":"countryCode"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['State'].className = 'State';
                	validations['State'] = {"properties":{"stateName":[{"contexts":"save","required":true}],"stateCode":[{"contexts":"save","required":true}],"countryCode":[{"contexts":"save","required":true}]}};
                	defaultValues['State'] = {
                	stateCode:null,
									countryCode:null,
									stateName:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['LocationConfiguration'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"skus":{"cfc":"Sku","linktable":"SwSkuLocationConfiguration","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"locationConfigurationID","inverse":true,"type":"array","name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"locationConfigurationCapacity":{"ormtype":"integer","name":"locationConfigurationCapacity"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"locationConfigurationName":{"ormtype":"string","name":"locationConfigurationName"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"locationConfigurationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"locationConfigurationID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"locationTree":{"persistent":false,"name":"locationTree"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"locationConfigurationID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"locationPathName":{"persistent":false,"name":"locationPathName"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['LocationConfiguration'].className = 'LocationConfiguration';
                	validations['LocationConfiguration'] = {"properties":{"location":[{"contexts":"save","required":true}],"skus":[{"contexts":"delete","maxCollection":0}],"locationConfigurationName":[{"contexts":"save","required":true}]}};
                	defaultValues['LocationConfiguration'] = {
                	locationConfigurationID:'',
										locationConfigurationName:null,
									locationConfigurationCapacity:null,
									activeFlag:1,
									remoteID:null,
									createdDateTime:'',
										modifiedDateTime:'',
										
						z:''
	                };
                
                	entities['AddressZone'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"addressZoneLocations":{"cfc":"Address","linktable":"SwAddressZoneLocation","fieldtype":"many-to-many","singularname":"addressZoneLocation","cascade":"all-delete-orphan","inversejoincolumn":"addressID","fkcolumn":"addressZoneID","name":"addressZoneLocations"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"taxCategoryRates":{"cfc":"TaxCategoryRate","fieldtype":"one-to-many","singularname":"taxCategoryRate","fkcolumn":"addressZoneID","inverse":true,"name":"taxCategoryRates"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"shippingMethodRates":{"cfc":"ShippingMethodRate","fieldtype":"one-to-many","singularname":"shippingMethodRate","fkcolumn":"addressZoneID","inverse":true,"name":"shippingMethodRates"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualShipAddressZone","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"addressZoneID","inverse":true,"name":"promotionQualifiers"},"validations":{"persistent":false,"type":"struct","name":"validations"},"addressZoneName":{"ormtype":"string","name":"addressZoneName"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"shippingMethods":{"cfc":"ShippingMethod","fieldtype":"one-to-many","singularname":"shippingMethod","fkcolumn":"addressZoneID","inverse":true,"name":"shippingMethods"},"addressZoneID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"addressZoneID"}};
                	entities['AddressZone'].className = 'AddressZone';
                	validations['AddressZone'] = {"properties":{"shippingRates":[{"contexts":"delete","maxCollection":0}],"addressZoneName":[{"contexts":"save","required":true}],"shippingMethods":[{"contexts":"delete","maxCollection":0}],"taxCategoryRates":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['AddressZone'] = {
                	addressZoneID:'',
										addressZoneName:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderDeliveryItem'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"referencingOrderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"referencingOrderItem","cascade":"all","fkcolumn":"referencedOrderDeliveryItemID","inverse":true,"name":"referencingOrderItems"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderItem":{"cfc":"OrderItem","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"orderItemID","name":"orderItem"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"stock":{"cfc":"Stock","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"stockID","name":"stock"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"orderDeliveryItemID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderDeliveryItemID"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"orderDelivery":{"cfc":"OrderDelivery","fieldtype":"many-to-one","fkcolumn":"orderDeliveryID","name":"orderDelivery"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"quantityReturned":{"persistent":false,"name":"quantityReturned"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderDeliveryItem'].className = 'OrderDeliveryItem';
                	validations['OrderDeliveryItem'] = {"properties":{"quantity":[{"contexts":"save","dataType":"numeric","required":true}],"orderDelivery":[{"contexts":"save","required":true}],"orderItem":[{"contexts":"save","required":true}],"stock":[{"contexts":"save","required":true}]}};
                	defaultValues['OrderDeliveryItem'] = {
                	orderDeliveryItemID:'',
										quantity:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['EmailBounce'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"rejectedEmailFrom":{"ormtype":"string","name":"rejectedEmailFrom"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"rejectedEmailTo":{"ormtype":"string","name":"rejectedEmailTo"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"rejectedEmailBody":{"ormtype":"text","name":"rejectedEmailBody"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"relatedObject":{"ormtype":"string","name":"relatedObject"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"rejectedEmailSubject":{"ormtype":"string","name":"rejectedEmailSubject"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"rejectedEmailSendTime":{"ormtype":"timestamp","name":"rejectedEmailSendTime"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"relatedObjectID":{"ormtype":"string","name":"relatedObjectID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"emailBounceID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"emailBounceID"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['EmailBounce'].className = 'EmailBounce';
                	validations['EmailBounce'] = {"properties":{}};
                	defaultValues['EmailBounce'] = {
                	emailBounceID:'',
										rejectedEmailTo:null,
									rejectedEmailFrom:null,
									rejectedEmailSubject:null,
									rejectedEmailBody:null,
									rejectedEmailSendTime:null,
									relatedObject:null,
									relatedObjectID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['PaymentMethod'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"subscriptionRenewalTransactionType":{"column":"subscriptionRenewalTxType","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"subscriptionRenewalTransactionType"},"saveAccountPaymentMethodTransactionTypeOptions":{"persistent":false,"name":"saveAccountPaymentMethodTransactionTypeOptions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"saveOrderPaymentEncryptFlag":{"ormtype":"boolean","name":"saveOrderPaymentEncryptFlag"},"orderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","lazy":"extra","cascade":"all-delete-orphan","singularname":"orderPayment","fkcolumn":"paymentMethodID","inverse":true,"type":"array","name":"orderPayments"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"saveOrderPaymentTransactionTypeOptions":{"persistent":false,"name":"saveOrderPaymentTransactionTypeOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"placeOrderChargeTransactionTypeOptions":{"persistent":false,"name":"placeOrderChargeTransactionTypeOptions"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"saveAccountPaymentMethodTransactionType":{"column":"saveAccountPaymentMethodTxType","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"saveAccountPaymentMethodTransactionType"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"placeOrderChargeTransactionType":{"column":"placeOrderChargeTxType","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"placeOrderChargeTransactionType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"placeOrderCreditTransactionType":{"column":"placeOrderCreditTxType","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"placeOrderCreditTransactionType"},"placeOrderCreditTransactionTypeOptions":{"persistent":false,"name":"placeOrderCreditTransactionTypeOptions"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"paymentIntegration":{"cfc":"Integration","fieldtype":"many-to-one","fkcolumn":"paymentIntegrationID","name":"paymentIntegration"},"allowSaveFlag":{"ormtype":"boolean","default":false,"name":"allowSaveFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"paymentMethodName":{"ormtype":"string","name":"paymentMethodName"},"saveOrderPaymentTransactionType":{"column":"saveOrderPaymentTxType","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"saveOrderPaymentTransactionType"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"paymentIntegrationOptions":{"persistent":false,"name":"paymentIntegrationOptions"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"paymentMethodID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"paymentMethodID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":false,"name":"activeFlag"},"accountPaymentMethods":{"cfc":"AccountPaymentMethod","fieldtype":"one-to-many","lazy":"extra","cascade":"all","singularname":"accountPaymentMethod","fkcolumn":"paymentMethodID","inverse":true,"type":"array","name":"accountPaymentMethods"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"paymentMethodType":{"ormtype":"string","hb_formattype":"rbKey","name":"paymentMethodType"},"saveAccountPaymentMethodEncryptFlag":{"column":"saveAccPaymentMethodEncFlag","ormtype":"boolean","name":"saveAccountPaymentMethodEncryptFlag"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PaymentMethod'].className = 'PaymentMethod';
                	validations['PaymentMethod'] = {"properties":{"saveAccountPaymentMethodTransactionType":[{"contexts":"save","conditions":"allowSaveFlagTrueSaveDataFalse","required":true}],"accountPaymentMethods":[{"contexts":"delete","maxCollection":0}],"paymentMethodName":[{"contexts":"save","required":true}],"orderPayments":[{"contexts":"delete","maxCollection":0}],"paymentMethodType":[{"contexts":"save","inList":"cash,check,creditCard,external,giftCard,termPayment","required":true}]},"conditions":{"allowSaveFlagTrueSaveDataFalse":{"allowSaveFlag":{"eq":true},"saveAccountPaymentMethodEncryptFlag":{"eq":false}}}};
                	defaultValues['PaymentMethod'] = {
                	paymentMethodID:'',
										paymentMethodName:null,
									paymentMethodType:null,
									allowSaveFlag:false,
									activeFlag:false,
									sortOrder:null,
									saveAccountPaymentMethodTransactionType:null,
									saveAccountPaymentMethodEncryptFlag:null,
									saveOrderPaymentTransactionType:null,
									saveOrderPaymentEncryptFlag:null,
									placeOrderChargeTransactionType:null,
									placeOrderCreditTransactionType:null,
									subscriptionRenewalTransactionType:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountPaymentApplied'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"accountPayment":{"cfc":"AccountPayment","fieldtype":"many-to-one","fkcolumn":"accountPaymentID","hb_optionsnullrbkey":"define.select","name":"accountPayment"},"accountPaymentAppliedID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountPaymentAppliedID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"notnull":true,"ormtype":"big_decimal","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"orderPayment":{"cfc":"OrderPayment","fieldtype":"many-to-one","fkcolumn":"orderPaymentID","hb_optionsnullrbkey":"define.select","name":"orderPayment"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"accountPaymentType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accountPaymentType","fkcolumn":"accountPaymentTypeID","name":"accountPaymentType"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountPaymentApplied'].className = 'AccountPaymentApplied';
                	validations['AccountPaymentApplied'] = {"properties":{}};
                	defaultValues['AccountPaymentApplied'] = {
                	accountPaymentAppliedID:'',
										amount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ShippingMethodOption'] = {"totalShippingWeight":{"ormtype":"string","name":"totalShippingWeight"},"totalCharge":{"ormtype":"big_decimal","hb_formattype":"currency","name":"totalCharge"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"shipToPostalCode":{"ormtype":"string","name":"shipToPostalCode"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"discountAmountDetails":{"persistent":false,"name":"discountAmountDetails"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"totalChargeAfterDiscount":{"persistent":false,"hb_formattype":"currency","name":"totalChargeAfterDiscount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"shippingMethodOptionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"shippingMethodOptionID"},"shipToStateCode":{"ormtype":"string","name":"shipToStateCode"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"shipToCity":{"ormtype":"string","name":"shipToCity"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"totalShippingItemPrice":{"ormtype":"string","name":"totalShippingItemPrice"},"shipToCountryCode":{"ormtype":"string","name":"shipToCountryCode"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"orderFulfillment":{"cfc":"OrderFulfillment","fieldtype":"many-to-one","fkcolumn":"orderFulfillmentID","name":"orderFulfillment"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"shippingMethodRate":{"cfc":"ShippingMethodRate","fieldtype":"many-to-one","fkcolumn":"shippingMethodRateID","name":"shippingMethodRate"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ShippingMethodOption'].className = 'ShippingMethodOption';
                	validations['ShippingMethodOption'] = {"properties":{}};
                	defaultValues['ShippingMethodOption'] = {
                	shippingMethodOptionID:'',
										totalCharge:null,
									currencyCode:null,
									totalShippingWeight:null,
									totalShippingItemPrice:null,
									shipToPostalCode:null,
									shipToStateCode:null,
									shipToCountryCode:null,
									shipToCity:null,
									createdDateTime:'',
										createdByAccountID:null,
									
						z:''
	                };
                
                	entities['LoyaltyTerm'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"loyaltyTermID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"loyaltyTermID"},"loyalty":{"cfc":"Loyalty","fieldtype":"many-to-one","fkcolumn":"loyaltyID","name":"loyalty"},"term":{"cfc":"Term","fieldtype":"many-to-one","fkcolumn":"termID","name":"term"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"loyaltyTermName":{"ormtype":"string","name":"loyaltyTermName"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"loyaltyTermStartDateTime":{"hb_nullrbkey":"define.forever","ormtype":"timestamp","name":"loyaltyTermStartDateTime"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"nextLoyaltyTermEndDateTime":{"persistent":false,"name":"nextLoyaltyTermEndDateTime"}};
                	entities['LoyaltyTerm'].className = 'LoyaltyTerm';
                	validations['LoyaltyTerm'] = {"properties":{}};
                	defaultValues['LoyaltyTerm'] = {
                	loyaltyTermID:'',
										loyaltyTermName:null,
									loyaltyTermStartDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Content'] = {"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"disableProductAssignmentFlag":{"ormtype":"boolean","name":"disableProductAssignmentFlag"},"titlePath":{"length":4000,"ormtype":"string","name":"titlePath"},"urlTitlePath":{"length":8000,"ormtype":"string","name":"urlTitlePath"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"sharedAssetsPath":{"persistent":false,"name":"sharedAssetsPath"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"sortOrder":{"ormtype":"integer","name":"sortOrder"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"templateFlag":{"ormtype":"boolean","name":"templateFlag"},"cmsSiteID":{"ormtype":"string","name":"cmsSiteID"},"attributeSets":{"cfc":"AttributeSet","linktable":"SwAttributeSetContent","fieldtype":"many-to-many","singularname":"attributeSet","inversejoincolumn":"attributeSetID","fkcolumn":"contentID","inverse":true,"type":"array","name":"attributeSets"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"contentIDPath":{"length":4000,"ormtype":"string","name":"contentIDPath"},"categories":{"cfc":"Category","linktable":"SwContentCategory","fieldtype":"many-to-many","singularname":"category","inversejoincolumn":"categoryID","fkcolumn":"contentID","type":"array","name":"categories"},"validations":{"persistent":false,"type":"struct","name":"validations"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"parentContent":{"cfc":"Content","fieldtype":"many-to-one","fkcolumn":"parentContentID","name":"parentContent"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"contentID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"urlTitle":{"length":4000,"ormtype":"string","name":"urlTitle"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"cmsContentID":{"ormtype":"string","index":"RI_CMSCONTENTID","name":"cmsContentID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"listingProducts":{"cfc":"Product","linktable":"SwProductListingPage","fieldtype":"many-to-many","singularname":"listingProduct","inversejoincolumn":"productID","fkcolumn":"contentID","inverse":true,"type":"array","name":"listingProducts"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"allowPurchaseFlag":{"ormtype":"boolean","name":"allowPurchaseFlag"},"productListingPageFlag":{"ormtype":"boolean","name":"productListingPageFlag"},"displayInNavigation":{"ormtype":"boolean","name":"displayInNavigation"},"skus":{"cfc":"Sku","linktable":"SwSkuAccessContent","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"contentID","inverse":true,"type":"array","name":"skus"},"contentBody":{"length":8000,"ormtype":"string","name":"contentBody"},"cmsContentIDPath":{"length":500,"ormtype":"string","name":"cmsContentIDPath"},"siteOptions":{"persistent":false,"name":"siteOptions"},"assetsPath":{"persistent":false,"name":"assetsPath"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"excludeFromSearch":{"ormtype":"boolean","name":"excludeFromSearch"},"childContents":{"cfc":"Content","fieldtype":"one-to-many","singularname":"childContent","cascade":"all-delete-orphan","fkcolumn":"parentContentID","type":"array","inverse":true,"name":"childContents"},"contentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"contentID"},"site":{"cfc":"Site","fieldtype":"many-to-one","hb_cascadecalculate":true,"hb_formfieldtype":"select","fkcolumn":"siteID","name":"site"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"categoryIDList":{"persistent":false,"name":"categoryIDList"},"remoteID":{"hint":"Only used when integrated with a remote system","ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"allDescendants":{"persistent":false,"name":"allDescendants"},"title":{"ormtype":"string","name":"title"},"contentTemplateType":{"cfc":"Type","fetch":"join","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=contentTemplateType","fkcolumn":"contentTemplateTypeID","hb_optionsnullrbkey":"define.none","name":"contentTemplateType"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Content'].className = 'Content';
                	validations['Content'] = {"properties":{"contentID":[{"contexts":"save","conditions":"notSlatwallCMS","required":true}],"site":[{"contexts":"save","required":true}],"contentTemplateFile":[{"contexts":"save","conditions":"isSlatwallCMS","required":true}],"urlTitle":[{"contexts":"save,create","conditions":"requireUrlTitle","required":true},{"contexts":"save","regex":"^[A-Za-z0-9-]+$","conditions":"notNewContent"}],"urlTitlePath":[{"contexts":"save","conditions":"isSlatwallCMS","method":"isUniqueUrlTitlePathBySite"}]},"conditions":{"topLevelContent":{"parentContent":{"null":true}},"notNewContent":{"newFlag":{"eq":false},"parentContent":{"null":false},"site.app.integration.integrationPackage":{"eq":"slatwallcms"}},"requireUrlTitle":{"parentContent":{"required":true},"site.app.integration.integrationPackage":{"eq":"slatwallcms"}},"notSlatwallCMS":{"site.app":{"null":true}},"isSlatwallCMS":{"site.app.integration.integrationPackage":{"eq":"slatwallcms"}}}};
                	defaultValues['Content'] = {
                	contentID:'',
										contentIDPath:'',
										activeFlag:1,
									title:null,
									titlePath:'',
										allowPurchaseFlag:0,
									productListingPageFlag:0,
									urlTitle:null,
									urlTitlePath:null,
									contentBody:null,
									displayInNavigation:1,
									excludeFromSearch:0,
									sortOrder:0,
									cmsContentID:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									disableProductAssignmentFlag:null,
									templateFlag:null,
									cmsSiteID:null,
									cmsContentIDPath:null,
									
						z:''
	                };
                
                	entities['Content_CreateSku'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"price":{"name":"price"},"skuCode":{"name":"skuCode"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"productTypeID":{"name":"productTypeID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"productID":{"name":"productID"},"skuID":{"name":"skuID"},"productCode":{"name":"productCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"product":{"name":"product"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"skuName":{"name":"skuName"},"content":{"name":"content"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Content_CreateSku'].className = 'Content_CreateSku';
                	validations['Content_CreateSku'] = {"properties":{"price":[{"dataType":"numeric","conditions":"skuIsNewFlag","required":true,"minValue":0}],"productTypeID":[{"required":true}],"productCode":[{"required":true}]},"conditions":{"skuIsNewFlag":{"sku.newFlag":{"eq":true}}}};
                	defaultValues['Content_CreateSku'] = {
                	content:'',
										product:'',
										sku:'',
										productID:"",
										productTypeID:'',
									skuID:"",
										price:'',
									productCode:'',
									skuCode:-1,
										skuName:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Access'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"accessID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accessID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"accessCode":{"ormtype":"string","name":"accessCode"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"subscriptionUsageBenefitAccount":{"cfc":"SubscriptionUsageBenefitAccount","fieldtype":"many-to-one","fkcolumn":"subsUsageBenefitAccountID","hb_optionsnullrbkey":"define.select","name":"subscriptionUsageBenefitAccount"},"subscriptionUsageBenefit":{"cfc":"SubscriptionUsageBenefit","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageBenefitID","hb_optionsnullrbkey":"define.select","name":"subscriptionUsageBenefit"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"subscriptionUsage":{"cfc":"SubscriptionUsage","fieldtype":"many-to-one","fkcolumn":"subscriptionUsageID","hb_optionsnullrbkey":"define.select","name":"subscriptionUsage"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Access'].className = 'Access';
                	validations['Access'] = {"properties":{"accessID":[{"contexts":"save","method":"hasUsageOrUsageBenefitOrUsageBenefitAccount"}]}};
                	defaultValues['Access'] = {
                	accessID:'',
										accessCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PhysicalCount'] = {"location":{"cfc":"Location","fieldtype":"many-to-one","fkcolumn":"locationID","name":"location"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"countPostDateTime":{"ormtype":"timestamp","name":"countPostDateTime"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"physicalStatusTypeSystemCode":{"persistent":false,"name":"physicalStatusTypeSystemCode"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"physical":{"cfc":"Physical","fieldtype":"many-to-one","fkcolumn":"physicalID","name":"physical"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"physicalCountItems":{"cfc":"PhysicalCountItem","fieldtype":"one-to-many","singularname":"physicalCountItem","cascade":"all-delete-orphan","fkcolumn":"physicalCountID","type":"array","inverse":true,"name":"physicalCountItems"},"validations":{"persistent":false,"type":"struct","name":"validations"},"physicalCountID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"physicalCountID"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PhysicalCount'].className = 'PhysicalCount';
                	validations['PhysicalCount'] = {"properties":{"location":[{"contexts":"save","required":true}],"countPostDateTime":[{"contexts":"save","dataType":"date","required":true}],"physicalStatusTypeSystemCode":[{"contexts":"delete","inList":"pstOpen"}]}};
                	defaultValues['PhysicalCount'] = {
                	physicalCountID:'',
										countPostDateTime:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorEmailAddress'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"emailAddress":{"ormtype":"string","hb_formattype":"email","name":"emailAddress"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"vendorEmailAddressID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorEmailAddressID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorEmailAddress'].className = 'VendorEmailAddress';
                	validations['VendorEmailAddress'] = {"properties":{"emailAddress":[{"contexts":"save","dataType":"email","required":true}]}};
                	defaultValues['VendorEmailAddress'] = {
                	vendorEmailAddressID:'',
										emailAddress:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PriceGroupRate'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"roundingRule":{"cfc":"RoundingRule","fieldtype":"many-to-one","fkcolumn":"roundingRuleID","hb_optionsnullrbkey":"define.none","name":"roundingRule"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"globalFlag":{"ormtype":"boolean","default":false,"name":"globalFlag"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"skus":{"cfc":"Sku","linktable":"SwPriceGroupRateSku","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"priceGroupRateID","name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"ormtype":"big_decimal","hb_formattype":"custom","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"excludedSkus":{"cfc":"Sku","linktable":"SwPriceGroupRateExclSku","fieldtype":"many-to-many","singularname":"excludedSku","inversejoincolumn":"skuID","fkcolumn":"priceGroupRateID","name":"excludedSkus"},"amountType":{"hb_formfieldtype":"select","ormtype":"string","name":"amountType"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"excludedProducts":{"cfc":"Product","linktable":"SwPriceGroupRateExclProduct","fieldtype":"many-to-many","singularname":"excludedProduct","inversejoincolumn":"productID","fkcolumn":"priceGroupRateID","name":"excludedProducts"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"displayName":{"persistent":false,"type":"string","name":"displayName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"appliesTo":{"persistent":false,"type":"string","name":"appliesTo"},"priceGroupRateCurrencies":{"cfc":"PriceGroupRateCurrency","fieldtype":"one-to-many","singularname":"priceGroupRateCurrency","cascade":"all-delete-orphan","fkcolumn":"priceGroupRateID","type":"array","inverse":true,"name":"priceGroupRateCurrencies"},"currencyCodeOptions":{"persistent":false,"name":"currencyCodeOptions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"amountTypeOptions":{"persistent":false,"name":"amountTypeOptions"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"priceGroupRateID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"priceGroupRateID"},"productTypes":{"cfc":"ProductType","linktable":"SwPriceGroupRateProductType","fieldtype":"many-to-many","singularname":"productType","inversejoincolumn":"productTypeID","fkcolumn":"priceGroupRateID","name":"productTypes"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"excludedProductTypes":{"cfc":"ProductType","linktable":"SwPriceGrpRateExclProductType","fieldtype":"many-to-many","singularname":"excludedProductType","inversejoincolumn":"productTypeID","fkcolumn":"priceGroupRateID","name":"excludedProductTypes"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"priceGroup":{"cfc":"PriceGroup","fieldtype":"many-to-one","fkcolumn":"priceGroupID","name":"priceGroup"},"products":{"cfc":"Product","linktable":"SwPriceGroupRateProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"priceGroupRateID","name":"products"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PriceGroupRate'].className = 'PriceGroupRate';
                	validations['PriceGroupRate'] = {"properties":{"priceGroup":[{"contexts":"save","required":true}],"amount":[{"contexts":"save","dataType":"numeric","required":true}],"amountType":[{"contexts":"save","required":true}]},"conditions":{"isNotGlobal":{"getGlobalFlag":{"eq":0}}}};
                	defaultValues['PriceGroupRate'] = {
                	priceGroupRateID:'',
										globalFlag:false,
									amount:null,
									amountType:null,
									currencyCode:'USD',
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PostalCode'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"longitude":{"ormtype":"string","name":"longitude"},"state":{"cfc":"State","fieldtype":"many-to-one","fkcolumn":"stateCode,countryCode","name":"state"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"country":{"cfc":"Country","fieldtype":"many-to-one","insert":false,"update":false,"fkcolumn":"countryCode","name":"country"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"postalCode":{"displayname":"Postal Code","fieldtype":"id","ormtype":"string","name":"postalCode"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"city":{"ormtype":"string","name":"city"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"latitude":{"ormtype":"string","name":"latitude"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PostalCode'].className = 'PostalCode';
                	validations['PostalCode'] = {"properties":{}};
                	defaultValues['PostalCode'] = {
                	postalCode:null,
									city:null,
									latitude:null,
									longitude:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['VendorSkuStock'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"quantity":{"ormtype":"integer","name":"quantity"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"vendorSkuStockID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorSkuStockID"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"cost":{"ormtype":"big_decimal","name":"cost"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"availableDateTime":{"ormtype":"timestamp","name":"availableDateTime"},"vendor":{"cfc":"Vendor","fieldtype":"many-to-one","fkcolumn":"vendorID","name":"vendor"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","name":"sku"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['VendorSkuStock'].className = 'VendorSkuStock';
                	validations['VendorSkuStock'] = {"properties":{}};
                	defaultValues['VendorSkuStock'] = {
                	vendorSkuStockID:'',
										cost:null,
									currencyCode:null,
									quantity:null,
									availableDateTime:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Currency'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"currencyName":{"ormtype":"string","name":"currencyName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"currencyLocalOptions":{"persistent":false,"name":"currencyLocalOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"formattedExample":{"persistent":false,"hb_formattype":"currency","name":"formattedExample"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"currencyRates":{"cfc":"CurrencyRate","fieldtype":"one-to-many","singularname":"currencyRate","cascade":"all-delete-orphan","fkcolumn":"currencyCode","type":"array","inverse":true,"name":"currencyRates"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"currencySymbol":{"ormtype":"string","name":"currencySymbol"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"fieldtype":"id","unique":true,"ormtype":"string","generated":"never","name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"currencyISONumber":{"ormtype":"integer","name":"currencyISONumber"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Currency'].className = 'Currency';
                	validations['Currency'] = {"properties":{}};
                	defaultValues['Currency'] = {
                	currencyCode:null,
									currencyISONumber:null,
									activeFlag:1,
									currencyName:null,
									currencySymbol:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ProductReview'] = {"reviewerName":{"ormtype":"string","hb_populateenabled":"public","name":"reviewerName"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"product":{"cfc":"Product","fieldtype":"many-to-one","fkcolumn":"productID","hb_populateenabled":"public","name":"product"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"reviewTitle":{"ormtype":"string","hb_populateenabled":"public","name":"reviewTitle"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"productReviewID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productReviewID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"ratingOptions":{"persistent":false,"type":"array","name":"ratingOptions"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"rating":{"ormtype":"int","hb_populateenabled":"public","name":"rating"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"productReviewID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"review":{"hint":"HTML Formated review of the Product","length":4000,"ormtype":"string","hb_populateenabled":"public","name":"review"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"sku":{"cfc":"Sku","fieldtype":"many-to-one","fkcolumn":"skuID","hb_populateenabled":"public","name":"sku"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ProductReview'].className = 'ProductReview';
                	validations['ProductReview'] = {"properties":{"reviewerName":[{"contexts":"save","required":true}],"product":[{"contexts":"save","required":true}],"review":[{"contexts":"save","required":true}]}};
                	defaultValues['ProductReview'] = {
                	productReviewID:'',
										activeFlag:0,
									reviewerName:null,
									review:null,
									reviewTitle:'',
										rating:0,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['AccountPhoneNumber'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"phoneNumber":{"hb_populateenabled":"public","type":"string","name":"phoneNumber"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"accountPhoneNumberID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"accountPhoneNumberID"},"accountPhoneType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accountPhoneType","fkcolumn":"accountPhoneTypeID","hb_optionsnullrbkey":"define.select","hb_populateenabled":"public","name":"accountPhoneType"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['AccountPhoneNumber'].className = 'AccountPhoneNumber';
                	validations['AccountPhoneNumber'] = {"properties":{"phoneNumber":[{"contexts":"save","required":true}]}};
                	defaultValues['AccountPhoneNumber'] = {
                	accountPhoneNumberID:'',
										phoneNumber:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockReceiver'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"receiverType":{"notnull":true,"ormtype":"string","hb_formattype":"rbKey","name":"receiverType"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"stockReceiverItems":{"cfc":"StockReceiverItem","fieldtype":"one-to-many","singularname":"stockReceiverItem","cascade":"all-delete-orphan","fkcolumn":"stockReceiverID","inverse":true,"name":"stockReceiverItems"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"vendorOrder":{"cfc":"VendorOrder","fieldtype":"many-to-one","fkcolumn":"vendorOrderID","name":"vendorOrder"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"packingSlipNumber":{"ormtype":"string","name":"packingSlipNumber"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockReceiverID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockReceiverID"},"stockAdjustment":{"cfc":"StockAdjustment","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentID","name":"stockAdjustment"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"boxCount":{"ormtype":"integer","name":"boxCount"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockReceiver'].className = 'StockReceiver';
                	validations['StockReceiver'] = {"properties":{"stockReceiverID":[{"contexts":"delete","maxLength":0}]}};
                	defaultValues['StockReceiver'] = {
                	stockReceiverID:'',
										packingSlipNumber:null,
									boxCount:null,
									receiverType:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Report'] = {"reportTitle":{"ormtype":"string","name":"reportTitle"},"dynamicDateRangeFlag":{"ormtype":"boolean","name":"dynamicDateRangeFlag"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"reportEndDateTime":{"persistent":false,"name":"reportEndDateTime"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"dynamicDateRangeType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"dynamicDateRangeType"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"dynamicDateRangeEndType":{"hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"dynamicDateRangeEndType"},"reportDateTimeGroupBy":{"ormtype":"string","name":"reportDateTimeGroupBy"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"dimensions":{"length":4000,"ormtype":"string","name":"dimensions"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"reportDateTime":{"ormtype":"string","name":"reportDateTime"},"reportCompareEndDateTime":{"persistent":false,"name":"reportCompareEndDateTime"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"showReport":{"ormtype":"boolean","default":false,"name":"showReport"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"orderByType":{"persistent":false,"name":"orderByType"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"reportCompareStartDateTime":{"persistent":false,"name":"reportCompareStartDateTime"},"dynamicDateRangeInterval":{"ormtype":"integer","name":"dynamicDateRangeInterval"},"dynamicDateRangeEndTypeOptions":{"persistent":false,"name":"dynamicDateRangeEndTypeOptions"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"reportStartDateTime":{"persistent":false,"name":"reportStartDateTime"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"metrics":{"length":4000,"ormtype":"string","name":"metrics"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"reportName":{"ormtype":"string","name":"reportName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"limitResults":{"ormtype":"integer","name":"limitResults"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"dynamicDateRangeTypeOptions":{"persistent":false,"name":"dynamicDateRangeTypeOptions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"reportType":{"ormtype":"string","name":"reportType"},"reportCompareFlag":{"ormtype":"boolean","name":"reportCompareFlag"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"reportID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"reportID"}};
                	entities['Report'].className = 'Report';
                	validations['Report'] = {"properties":{}};
                	defaultValues['Report'] = {
                	reportID:'',
										reportName:null,
									reportTitle:null,
									reportDateTime:null,
									reportDateTimeGroupBy:null,
									reportCompareFlag:null,
									metrics:null,
									dimensions:null,
									dynamicDateRangeFlag:1,
									dynamicDateRangeType:'months',
										dynamicDateRangeEndType:'now',
										dynamicDateRangeInterval:1,
									reportType:null,
									limitResults:null,
									showReport:false,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionRewardCurrency'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"hb_rbkey":"entity.promotionReward.amount","ormtype":"big_decimal","hb_formattype":"currency","name":"amount"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"promotionReward":{"cfc":"PromotionReward","fieldtype":"many-to-one","fkcolumn":"promotionRewardID","name":"promotionReward"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"currency":{"cfc":"Currency","fieldtype":"many-to-one","fkcolumn":"currencyCode","name":"currency"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"currencyCode":{"insert":false,"update":false,"name":"currencyCode"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"promotionRewardCurrencyID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionRewardCurrencyID"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PromotionRewardCurrency'].className = 'PromotionRewardCurrency';
                	validations['PromotionRewardCurrency'] = {"properties":{"amount":[{"contexts":"save","dataType":"numeric","required":false}],"currencyCode":[{"contexts":"save","neqProperty":"promotionReward.currencyCode"}]}};
                	defaultValues['PromotionRewardCurrency'] = {
                	promotionRewardCurrencyID:'',
										amount:null,
									currencyCode:'USD',
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['SubscriptionBenefit'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"contents":{"cfc":"Content","linktable":"SwSubsBenefitContent","fieldtype":"many-to-many","cascade":"all","singularname":"content","inversejoincolumn":"contentID","fkcolumn":"subscriptionBenefitID","type":"array","name":"contents"},"skus":{"cfc":"Sku","linktable":"SwSkuSubsBenefit","fieldtype":"many-to-many","singularname":"sku","inversejoincolumn":"skuID","fkcolumn":"subscriptionBenefitID","inverse":true,"type":"array","name":"skus"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"subscriptionBenefitName":{"ormtype":"string","name":"subscriptionBenefitName"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"promotions":{"cfc":"Promotion","linktable":"SwSubsBenefitPromotion","fieldtype":"many-to-many","cascade":"all","singularname":"promotion","inversejoincolumn":"promotionID","fkcolumn":"subscriptionBenefitID","type":"array","name":"promotions"},"excludedContents":{"cfc":"Content","linktable":"SwSubsBenefitExclContent","fieldtype":"many-to-many","cascade":"all","singularname":"excludedContent","inversejoincolumn":"contentID","fkcolumn":"subscriptionBenefitID","type":"array","name":"excludedContents"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"maxUseCount":{"ormtype":"integer","name":"maxUseCount"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"excludedCategories":{"cfc":"Category","linktable":"SwSubsBenefitExclCategory","fieldtype":"many-to-many","cascade":"all","singularname":"excludedCategory","inversejoincolumn":"categoryID","fkcolumn":"subscriptionBenefitID","type":"array","name":"excludedCategories"},"categories":{"cfc":"Category","linktable":"SwSubsBenefitCategory","fieldtype":"many-to-many","cascade":"all","singularname":"category","inversejoincolumn":"categoryID","fkcolumn":"subscriptionBenefitID","type":"array","name":"categories"},"validations":{"persistent":false,"type":"struct","name":"validations"},"priceGroups":{"cfc":"PriceGroup","linktable":"SwSubsBenefitPriceGroup","fieldtype":"many-to-many","cascade":"all","singularname":"priceGroup","inversejoincolumn":"priceGroupID","fkcolumn":"subscriptionBenefitID","type":"array","name":"priceGroups"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"subscriptionBenefitID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"accessType":{"cfc":"Type","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=accessType","fkcolumn":"accessTypeID","name":"accessType"},"subscriptionBenefitID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"subscriptionBenefitID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['SubscriptionBenefit'].className = 'SubscriptionBenefit';
                	validations['SubscriptionBenefit'] = {"properties":{"skus":[{"contexts":"delete","maxCollection":0}],"accessType":[{"contexts":"save","required":true}],"subscriptionBenefitName":[{"contexts":"save","required":true}],"maxUseCount":[{"contexts":"save","dataType":"numeric","required":true}]}};
                	defaultValues['SubscriptionBenefit'] = {
                	subscriptionBenefitID:'',
										subscriptionBenefitName:null,
									maxUseCount:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['ProductType'] = {"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardProductType","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"productTypeID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"productTypeDescription":{"length":4000,"ormtype":"string","name":"productTypeDescription"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"childProductTypes":{"cfc":"ProductType","fieldtype":"one-to-many","singularname":"childProductType","cascade":"all","fkcolumn":"parentProductTypeID","inverse":true,"name":"childProductTypes"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionProductType","fieldtype":"many-to-many","singularname":"loyaltyRedemption","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"loyaltyRedemptions"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"promotionRewardExclusions":{"cfc":"PromotionReward","linktable":"SwPromoRewardExclProductType","fieldtype":"many-to-many","singularname":"promotionRewardExclusion","inversejoincolumn":"promotionRewardID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"promotionRewardExclusions"},"attributeSets":{"cfc":"AttributeSet","linktable":"SwAttributeSetProductType","fieldtype":"many-to-many","singularname":"attributeSet","inversejoincolumn":"attributeSetID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"attributeSets"},"loyaltyRedemptionExclusions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedempExclProductType","fieldtype":"many-to-many","singularname":"loyaltyRedemptionExclusion","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"loyaltyRedemptionExclusions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRates":{"cfc":"PriceGroupRate","linktable":"SwPriceGroupRateProductType","fieldtype":"many-to-many","singularname":"priceGroupRate","inversejoincolumn":"priceGroupRateID","fkcolumn":"productTypeID","inverse":true,"name":"priceGroupRates"},"parentProductTypeOptions":{"persistent":false,"type":"array","name":"parentProductTypeOptions"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"productTypeName":{"ormtype":"string","name":"productTypeName"},"promotionQualifierExclusions":{"cfc":"PromotionQualifier","linktable":"SwPromoQualExclProductType","fieldtype":"many-to-many","singularname":"promotionQualifierExclusion","inversejoincolumn":"promotionQualifierID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"promotionQualifierExclusions"},"loyaltyAccruements":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruProductType","fieldtype":"many-to-many","singularname":"loyaltyAccruement","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"productTypeID","inverse":true,"name":"loyaltyAccruements"},"publishedFlag":{"ormtype":"boolean","name":"publishedFlag"},"validations":{"persistent":false,"type":"struct","name":"validations"},"activeFlag":{"hint":"As A ProductType Get Old, They would be marked as Not Active","ormtype":"boolean","name":"activeFlag"},"productTypeIDPath":{"length":4000,"ormtype":"string","name":"productTypeIDPath"},"products":{"cfc":"Product","fieldtype":"one-to-many","lazy":"extra","singularname":"product","cascade":"all","fkcolumn":"productTypeID","inverse":true,"name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"productTypeID","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"urlTitle":{"hint":"This is the name that is used in the URL string","unique":true,"ormtype":"string","name":"urlTitle"},"priceGroupRateExclusions":{"cfc":"PriceGroupRate","linktable":"SwPriceGrpRateExclProductType","fieldtype":"many-to-many","singularname":"priceGroupRateExclusion","inversejoincolumn":"priceGroupRateID","fkcolumn":"productTypeID","inverse":true,"name":"priceGroupRateExclusions"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"parentProductType":{"cfc":"ProductType","fieldtype":"many-to-one","fkcolumn":"parentProductTypeID","name":"parentProductType"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"physicals":{"cfc":"Physical","linktable":"SwPhysicalProductType","fieldtype":"many-to-many","singularname":"physical","inversejoincolumn":"physicalID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"physicals"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"systemCode":{"ormtype":"string","name":"systemCode"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"productTypeID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"productTypeID"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualProductType","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"productTypeID","inverse":true,"name":"promotionQualifiers"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"loyaltyAccruementExclusions":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruExclProductType","fieldtype":"many-to-many","singularname":"loyaltyAccruementExclusion","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"productTypeID","inverse":true,"type":"array","name":"loyaltyAccruementExclusions"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['ProductType'].className = 'ProductType';
                	validations['ProductType'] = {"properties":{"childProductTypes":[{"contexts":"delete","maxCollection":0}],"products":[{"contexts":"delete","maxCollection":0}],"productTypeName":[{"contexts":"save","required":true}],"urlTitle":[{"contexts":"save","required":true,"unique":true}],"physicalCounts":[{"contexts":"delete","maxCollection":0}],"systemCode":[{"contexts":"delete","maxLength":0}]}};
                	defaultValues['ProductType'] = {
                	productTypeID:'',
										productTypeIDPath:'',
										activeFlag:1,
									publishedFlag:null,
									urlTitle:null,
									productTypeName:null,
									productTypeDescription:null,
									systemCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['StockAdjustmentDelivery'] = {"deliveryCloseDateTime":{"ormtype":"timestamp","name":"deliveryCloseDateTime"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"stockAdjustmentDeliveryItems":{"cfc":"StockAdjustmentDeliveryItem","fieldtype":"one-to-many","singularname":"stockAdjustmentDeliveryItem","cascade":"all-delete-orphan","fkcolumn":"stockAdjustmentDeliveryID","inverse":true,"name":"stockAdjustmentDeliveryItems"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"deliveryOpenDateTime":{"ormtype":"timestamp","name":"deliveryOpenDateTime"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"stockAdjustmentDeliveryID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"stockAdjustmentDeliveryID"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"stockAdjustment":{"cfc":"StockAdjustment","fieldtype":"many-to-one","fkcolumn":"stockAdjustmentID","name":"stockAdjustment"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['StockAdjustmentDelivery'].className = 'StockAdjustmentDelivery';
                	validations['StockAdjustmentDelivery'] = {"properties":{}};
                	defaultValues['StockAdjustmentDelivery'] = {
                	stockAdjustmentDeliveryID:'',
										deliveryOpenDateTime:null,
									deliveryCloseDateTime:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['WorkflowTask'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"workflowTaskActions":{"cfc":"WorkflowTaskAction","fieldtype":"one-to-many","singularname":"workflowTaskAction","cascade":"all-delete-orphan","fkcolumn":"workflowTaskID","type":"array","inverse":true,"name":"workflowTaskActions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"taskConditionsConfigStruct":{"persistent":false,"type":"struct","name":"taskConditionsConfigStruct"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"taskName":{"ormtype":"string","name":"taskName"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","hb_populateenabled":false,"name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"workflowTaskID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"workflowTaskID"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"taskConditionsConfig":{"length":8000,"hb_formfieldtype":"json","hb_auditable":false,"ormtype":"string","name":"taskConditionsConfig"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"workflow":{"cfc":"Workflow","fieldtype":"many-to-one","fkcolumn":"workflowID","name":"workflow"}};
                	entities['WorkflowTask'].className = 'WorkflowTask';
                	validations['WorkflowTask'] = {"properties":{}};
                	defaultValues['WorkflowTask'] = {
                	workflowTaskID:'',
										activeFlag:1,
									taskName:null,
									taskConditionsConfig:angular.fromJson('{"filterGroups":[{"filterGroup":[]}]}'),
										remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Integration'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"integrationName":{"ormtype":"string","name":"integrationName"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"enabledFlag":{"persistent":false,"type":"boolean","name":"enabledFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"integrationPackage":{"unique":true,"ormtype":"string","name":"integrationPackage"},"integrationTypeList":{"ormtype":"string","name":"integrationTypeList"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"integrationID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"integrationID"},"installedFlag":{"ormtype":"boolean","name":"installedFlag"},"apps":{"cfc":"App","fieldtype":"one-to-many","singularname":"app","fkcolumn":"integrationID","type":"array","inverse":true,"name":"apps"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Integration'].className = 'Integration';
                	validations['Integration'] = {"properties":{"integrationPackage":[{"contexts":"save","required":true}]}};
                	defaultValues['Integration'] = {
                	integrationID:'',
										activeFlag:0,
									installedFlag:null,
									integrationPackage:null,
									integrationName:null,
									integrationTypeList:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PromotionAccount'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"account":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"accountID","name":"account"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"startDateTime":{"ormtype":"timestamp","name":"startDateTime"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"promotion":{"cfc":"Promotion","fieldtype":"many-to-one","fkcolumn":"promotionID","name":"promotion"},"endDateTime":{"ormtype":"timestamp","name":"endDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"promotionAccountID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionAccountID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PromotionAccount'].className = 'PromotionAccount';
                	validations['PromotionAccount'] = {"properties":{}};
                	defaultValues['PromotionAccount'] = {
                	promotionAccountID:'',
										startDateTime:null,
									endDateTime:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['PriceGroup'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardEligiblePriceGrp","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"priceGroupID","inverse":true,"type":"array","name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"childPriceGroups":{"cfc":"PriceGroup","fieldtype":"one-to-many","singularname":"ChildPriceGroup","fkcolumn":"parentPriceGroupID","inverse":true,"name":"childPriceGroups"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"priceGroupCode":{"ormtype":"string","index":"PI_PRICEGROUPCODE","name":"priceGroupCode"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"parentPriceGroupOptions":{"persistent":false,"name":"parentPriceGroupOptions"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","fieldtype":"one-to-many","singularname":"loyaltyRedemption","cascade":"all-delete-orphan","fkcolumn":"priceGroupID","type":"array","inverse":true,"name":"loyaltyRedemptions"},"priceGroupIDPath":{"length":4000,"ormtype":"string","name":"priceGroupIDPath"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"subscriptionUsageBenefits":{"cfc":"SubscriptionUsageBenefit","linktable":"SwSubsUsageBenefitPriceGroup","fieldtype":"many-to-many","singularname":"subscriptionUsageBenefit","inversejoincolumn":"subscriptionUsageBenefitID","fkcolumn":"priceGroupID","inverse":true,"type":"array","name":"subscriptionUsageBenefits"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"subscriptionBenefits":{"cfc":"SubscriptionBenefit","linktable":"SwSubsBenefitPriceGroup","fieldtype":"many-to-many","singularname":"subscriptionBenefit","inversejoincolumn":"subscriptionBenefitID","fkcolumn":"priceGroupID","inverse":true,"type":"array","name":"subscriptionBenefits"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRates":{"cfc":"PriceGroupRate","fieldtype":"one-to-many","singularname":"priceGroupRate","cascade":"all-delete-orphan","fkcolumn":"priceGroupID","inverse":true,"name":"priceGroupRates"},"appliedOrderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","singularname":"appliedOrderItem","fkcolumn":"appliedPriceGroupID","type":"array","inverse":true,"name":"appliedOrderItems"},"accounts":{"cfc":"Account","linktable":"SwAccountPriceGroup","fieldtype":"many-to-many","singularname":"account","inversejoincolumn":"accountID","fkcolumn":"priceGroupID","inverse":true,"name":"accounts"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"priceGroupID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"priceGroupID"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","name":"activeFlag"},"priceGroupName":{"ormtype":"string","name":"priceGroupName"},"parentPriceGroup":{"cfc":"PriceGroup","fieldtype":"many-to-one","fkcolumn":"parentPriceGroupID","hb_optionsnullrbkey":"define.none","name":"parentPriceGroup"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['PriceGroup'].className = 'PriceGroup';
                	validations['PriceGroup'] = {"properties":{"promotionRewards":[{"contexts":"delete","maxCollection":0}],"priceGroupName":[{"contexts":"save","required":true}],"appliedOrderItems":[{"contexts":"delete","maxCollection":0}],"accounts":[{"contexts":"delete","maxCollection":0}],"childPriceGroups":[{"contexts":"delete","maxCollection":0}],"subscriptionUsageBenefits":[{"contexts":"delete","maxCollection":0}],"priceGroupCode":[{"contexts":"save","required":true}],"subscriptionBenefits":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['PriceGroup'] = {
                	priceGroupID:'',
										priceGroupIDPath:'',
										activeFlag:1,
									priceGroupName:null,
									priceGroupCode:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Promotion'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"promotionCodesDeletableFlag":{"persistent":false,"type":"boolean","name":"promotionCodesDeletableFlag"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"appliedPromotions":{"cfc":"PromotionApplied","fieldtype":"one-to-many","singularname":"appliedPromotion","cascade":"all","fkcolumn":"promotionID","inverse":true,"name":"appliedPromotions"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"promotionCodes":{"cfc":"PromotionCode","fieldtype":"one-to-many","singularname":"promotionCode","cascade":"all-delete-orphan","fkcolumn":"promotionID","inverse":true,"name":"promotionCodes"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"currentPromotionCodeFlag":{"persistent":false,"type":"boolean","name":"currentPromotionCodeFlag"},"promotionPeriods":{"cfc":"PromotionPeriod","fieldtype":"one-to-many","singularname":"promotionPeriod","cascade":"all-delete-orphan","fkcolumn":"promotionID","inverse":true,"name":"promotionPeriods"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"defaultImage":{"cfc":"Image","fieldtype":"many-to-one","fkcolumn":"defaultImageID","name":"defaultImage"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"promotionDescription":{"length":4000,"ormtype":"string","name":"promotionDescription"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"promotionName":{"ormtype":"string","name":"promotionName"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"promotionSummary":{"length":1000,"ormtype":"string","name":"promotionSummary"},"remoteID":{"ormtype":"string","name":"remoteID"},"currentPromotionPeriodFlag":{"persistent":false,"type":"boolean","name":"currentPromotionPeriodFlag"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"currentFlag":{"persistent":false,"type":"boolean","name":"currentFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"promotionID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"promotionID"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Promotion'].className = 'Promotion';
                	validations['Promotion'] = {"properties":{"promotionCodes":[{"contexts":"delete","method":"getPromotionCodesDeletableFlag"}],"promotionName":[{"contexts":"save","required":true}],"appliedPromotions":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['Promotion'] = {
                	promotionID:'',
										promotionName:null,
									promotionSummary:null,
									promotionDescription:null,
									activeFlag:1,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderPayment'] = {"appliedAccountPayments":{"cfc":"AccountPaymentApplied","fieldtype":"one-to-many","singularname":"appliedAccountPayment","cascade":"all","fkcolumn":"orderPaymentID","type":"array","inverse":true,"name":"appliedAccountPayments"},"amountUnreceived":{"persistent":false,"hb_formattype":"currency","name":"amountUnreceived"},"expirationYearOptions":{"persistent":false,"name":"expirationYearOptions"},"originalAuthorizationCode":{"persistent":false,"name":"originalAuthorizationCode"},"creditCardType":{"ormtype":"string","name":"creditCardType"},"paymentMethodOptions":{"persistent":false,"name":"paymentMethodOptions"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"expirationMonth":{"hb_formfieldtype":"select","ormtype":"string","hb_populateenabled":"public","name":"expirationMonth"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"experationMonthOptions":{"persistent":false,"name":"experationMonthOptions"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"companyPaymentMethodFlag":{"ormtype":"boolean","hb_populateenabled":"public","name":"companyPaymentMethodFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"amount":{"ormtype":"big_decimal","hb_populateenabled":"public","name":"amount"},"referencingOrderPayments":{"cfc":"OrderPayment","fieldtype":"one-to-many","singularname":"referencingOrderPayment","cascade":"all","fkcolumn":"referencedOrderPaymentID","inverse":true,"name":"referencingOrderPayments"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"sucessfulPaymentTransactionExistsFlag":{"persistent":false,"name":"sucessfulPaymentTransactionExistsFlag"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"orderAmountNeeded":{"persistent":false,"name":"orderAmountNeeded"},"paymentDueDate":{"ormtype":"timestamp","hb_populateenabled":"public","name":"paymentDueDate"},"creditCardNumber":{"persistent":false,"hb_populateenabled":"public","name":"creditCardNumber"},"saveBillingAccountAddressFlag":{"persistent":false,"name":"saveBillingAccountAddressFlag"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"purchaseOrderNumber":{"ormtype":"string","hb_populateenabled":"public","name":"purchaseOrderNumber"},"originalAuthorizationProviderTransactionID":{"persistent":false,"name":"originalAuthorizationProviderTransactionID"},"orderPaymentID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderPaymentID"},"bankRoutingNumberEncrypted":{"ormtype":"string","name":"bankRoutingNumberEncrypted"},"providerToken":{"ormtype":"string","name":"providerToken"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"creditCardLastFour":{"ormtype":"string","name":"creditCardLastFour"},"creditCardNumberEncryptedDateTime":{"column":"creditCardNumberEncryptDT","hb_auditable":false,"ormtype":"timestamp","name":"creditCardNumberEncryptedDateTime"},"billingAccountAddress":{"cfc":"AccountAddress","fieldtype":"many-to-one","fkcolumn":"billingAccountAddressID","hb_populateenabled":"public","name":"billingAccountAddress"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"amountCredited":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountCredited"},"validations":{"persistent":false,"type":"struct","name":"validations"},"referencedOrderPayment":{"cfc":"OrderPayment","fieldtype":"many-to-one","fkcolumn":"referencedOrderPaymentID","name":"referencedOrderPayment"},"accountPaymentMethod":{"cfc":"AccountPaymentMethod","fieldtype":"many-to-one","fkcolumn":"accountPaymentMethodID","hb_populateenabled":"public","name":"accountPaymentMethod"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"peerOrderPaymentNullAmountExistsFlag":{"persistent":false,"name":"peerOrderPaymentNullAmountExistsFlag"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"orderPaymentID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"saveBillingAccountAddressName":{"persistent":false,"name":"saveBillingAccountAddressName"},"paymentTransactions":{"cfc":"PaymentTransaction","fieldtype":"one-to-many","cascade":"all","singularname":"paymentTransaction","fkcolumn":"orderPaymentID","inverse":true,"type":"array","orderby":"createdDateTime DESC","name":"paymentTransactions"},"originalProviderTransactionID":{"persistent":false,"name":"originalProviderTransactionID"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"paymentTerm":{"cfc":"PaymentTerm","fetch":"join","fieldtype":"many-to-one","fkcolumn":"paymentTermID","name":"paymentTerm"},"giftCardNumber":{"persistent":false,"hb_populateenabled":"public","name":"giftCardNumber"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderPaymentType":{"cfc":"Type","fetch":"join","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderPaymentType","fkcolumn":"orderPaymentTypeID","name":"orderPaymentType"},"dynamicAmountFlag":{"persistent":false,"hb_formattype":"yesno","name":"dynamicAmountFlag"},"maximumPaymentMethodPaymentAmount":{"persistent":false,"name":"maximumPaymentMethodPaymentAmount"},"nameOnCreditCard":{"ormtype":"string","hb_populateenabled":"public","name":"nameOnCreditCard"},"paymentMethod":{"cfc":"PaymentMethod","fetch":"join","fieldtype":"many-to-one","fkcolumn":"paymentMethodID","hb_populateenabled":"public","name":"paymentMethod"},"order":{"cfc":"Order","fieldtype":"many-to-one","fkcolumn":"orderID","name":"order"},"bankRoutingNumber":{"persistent":false,"hb_populateenabled":"public","name":"bankRoutingNumber"},"expirationYear":{"hb_formfieldtype":"select","ormtype":"string","hb_populateenabled":"public","name":"expirationYear"},"creditCardNumberEncryptedGenerator":{"column":"creditCardNumberEncryptGen","hb_auditable":false,"ormtype":"string","name":"creditCardNumberEncryptedGenerator"},"billingAddress":{"cfc":"Address","fieldtype":"many-to-one","cascade":"all","fkcolumn":"billingAddressID","hb_populateenabled":"public","name":"billingAddress"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"originalChargeProviderTransactionID":{"persistent":false,"name":"originalChargeProviderTransactionID"},"amountUncaptured":{"persistent":false,"hb_formattype":"currency","name":"amountUncaptured"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"creditCardNumberEncrypted":{"hb_auditable":false,"ormtype":"string","name":"creditCardNumberEncrypted"},"checkNumberEncrypted":{"ormtype":"string","name":"checkNumberEncrypted"},"orderPaymentStatusType":{"cfc":"Type","fetch":"join","fieldtype":"many-to-one","hb_optionssmartlistdata":"f:parentType.systemCode=orderPaymentStatusType","fkcolumn":"orderPaymentStatusTypeID","hb_populateenabled":false,"name":"orderPaymentStatusType"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"bankAccountNumber":{"persistent":false,"hb_populateenabled":"public","name":"bankAccountNumber"},"statusCode":{"persistent":false,"name":"statusCode"},"bankAccountNumberEncrypted":{"ormtype":"string","name":"bankAccountNumberEncrypted"},"amountUncredited":{"persistent":false,"hb_formattype":"currency","name":"amountUncredited"},"orderStatusCode":{"persistent":false,"name":"orderStatusCode"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"expirationDate":{"persistent":false,"name":"expirationDate"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"amountAuthorized":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountAuthorized"},"creditCardOrProviderTokenExistsFlag":{"persistent":false,"name":"creditCardOrProviderTokenExistsFlag"},"giftCardPaymentProcessedFlag":{"ormtype":"boolean","hb_populateenabled":"public","default":false,"name":"giftCardPaymentProcessedFlag"},"remoteID":{"ormtype":"string","name":"remoteID"},"checkNumber":{"persistent":false,"hb_populateenabled":"public","name":"checkNumber"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"termPaymentAccount":{"cfc":"Account","fieldtype":"many-to-one","fkcolumn":"termPaymentAccountID","name":"termPaymentAccount"},"amountReceived":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"amountReceived"},"paymentMethodType":{"persistent":false,"name":"paymentMethodType"},"giftCardTransactions":{"cfc":"GiftCardTransaction","fieldtype":"one-to-many","singularname":"giftCardTransaction","cascade":"all-delete-orphan","fkcolumn":"orderPaymentID","type":"array","inverse":true,"name":"giftCardTransactions"},"giftCardNumberEncrypted":{"ormtype":"string","name":"giftCardNumberEncrypted"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"amountUnauthorized":{"persistent":false,"hb_formattype":"currency","name":"amountUnauthorized"},"securityCode":{"persistent":false,"hb_populateenabled":"public","name":"securityCode"}};
                	entities['OrderPayment'].className = 'OrderPayment';
                	validations['OrderPayment'] = {"properties":{"paymentMethod":[{"contexts":"save","required":true}],"expirationYear":[{"contexts":"save","conditions":"paymentTypeCreditCard","required":true}],"amount":[{"contexts":"save","dataType":"numeric","minValue":0},{"contexts":"save","conditions":"peerNullValueAlreadyExists","required":true},{"contexts":"save","lteProperty":"termPaymentAccount.termAccountAvailableCredit","conditions":"paymentTypeTermPayment"},{"contexts":"save","lteProperty":"maximumPaymentMethodPaymentAmount"}],"expirationMonth":[{"contexts":"save","conditions":"paymentTypeCreditCard","required":true}],"termPaymentAccount":[{"contexts":"save","conditions":"paymentTypeTermPayment","required":true}],"orderStatusCode":[{"contexts":"createTransaction","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"},{"contexts":"edit","inList":"ostNotPlaced,ostNew,ostProcessing,ostOnHold"}],"creditCardNumber":[{"contexts":"save","dataType":"creditCard","conditions":"creditCardWithoutToken","required":true}],"paymentTransactions":[{"contexts":"delete","maxCollection":0}],"nameOnCreditCard":[{"contexts":"save","conditions":"paymentTypeCreditCard","required":true}],"securityCode":[{"contexts":"save","conditions":"paymentTypeCreditCardNoTokenAndNewAndNotCopied","required":true}]},"conditions":{"paymentTypeCreditCardNoTokenAndNewAndNotCopied":{"referencedOrderPayment":{"null":true},"newFlag":{"eq":true},"providerToken":{"null":true},"accountPaymentMethod":{"null":true},"paymentMethodType":{"eq":"creditCard"}},"creditCardWithoutToken":{"providerToken":{"null":true},"paymentMethodType":{"eq":"creditCard"}},"peerNullValueAlreadyExists":{"peerOrderPaymentNullAmountExistsFlag":{"eq":true}},"paymentTypeCreditCard":{"paymentMethodType":{"eq":"creditCard"}},"paymentTypeTermPayment":{"paymentMethodType":{"eq":"termPayment"}}},"populatedPropertyValidation":{"billingAddress":[{"conditions":"paymentTypeCreditCard,paymentTypeTermPayment","validate":"full"}]}};
                	defaultValues['OrderPayment'] = {
                	orderPaymentID:'',
										amount:null,
									currencyCode:'USD',
										bankRoutingNumberEncrypted:null,
									bankAccountNumberEncrypted:null,
									checkNumberEncrypted:null,
									companyPaymentMethodFlag:null,
									creditCardNumberEncrypted:null,
									creditCardNumberEncryptedDateTime:null,
									creditCardNumberEncryptedGenerator:null,
									creditCardLastFour:null,
									creditCardType:null,
									expirationMonth:null,
									expirationYear:null,
									giftCardNumberEncrypted:null,
									nameOnCreditCard:null,
									paymentDueDate:null,
									providerToken:null,
									purchaseOrderNumber:null,
									giftCardPaymentProcessedFlag:false,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['OrderPayment_CreateTransaction'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"amount":{"name":"amount"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"transactionType":{"hb_formfieldtype":"select","name":"transactionType"},"orderPayment":{"name":"orderPayment"},"transactionTypeOptions":{"name":"transactionTypeOptions"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['OrderPayment_CreateTransaction'].className = 'OrderPayment_CreateTransaction';
                	validations['OrderPayment_CreateTransaction'] = {"properties":{"amount":[{"dataType":"numeric","required":true,"minValue":0},{"lteProperty":"orderPayment.amountUnAuthorized","conditions":"transactionTypeAuthorize"},{"lteProperty":"orderPayment.amountUnreceived","conditions":"transactionTypeAuthorizeAndCharge"},{"lteProperty":"orderPayment.amountUncredited","conditions":"transactionTypeCredit"},{"lteProperty":"orderPayment.amountUncaptured","conditions":"transactionTypeChargePreAuthorization"}],"transactionType":[{"required":true}]},"conditions":{"transactionTypeCredit":{"transactionType":{"eq":"credit"}},"transactionTypeChargePreAuthorization":{"transactionType":{"eq":"chargePreAuthorization"}},"transactionTypeAuthorize":{"transactionType":{"eq":"authorize"}},"transactionTypeAuthorizeAndCharge":{"transactionType":{"eq":"authorizeAndCharge"}}}};
                	defaultValues['OrderPayment_CreateTransaction'] = {
                	orderPayment:'',
										transactionType:"receive",
										preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Vendor'] = {"primaryPhoneNumber":{"cfc":"VendorPhoneNumber","fieldtype":"many-to-one","fkcolumn":"primaryPhoneNumberID","name":"primaryPhoneNumber"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"primaryAddress":{"cfc":"VendorAddress","fieldtype":"many-to-one","fkcolumn":"primaryAddressID","name":"primaryAddress"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"accountNumber":{"ormtype":"string","name":"accountNumber"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"vendorName":{"ormtype":"string","name":"vendorName"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"brands":{"cfc":"Brand","linktable":"SwVendorBrand","fieldtype":"many-to-many","singularname":"brand","inversejoincolumn":"brandID","fkcolumn":"vendorID","name":"brands"},"vendorAddresses":{"cfc":"VendorAddress","fieldtype":"one-to-many","singularname":"vendorAddress","cascade":"all-delete-orphan","fkcolumn":"vendorID","type":"array","inverse":true,"name":"vendorAddresses"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"primaryEmailAddress":{"cfc":"VendorEmailAddress","fieldtype":"many-to-one","fkcolumn":"primaryEmailAddressID","name":"primaryEmailAddress"},"vendorID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"vendorID"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"vendorOrders":{"cfc":"VendorOrder","fieldtype":"one-to-many","singularname":"vendorOrder","cascade":"save-update","fkcolumn":"vendorID","type":"array","inverse":true,"name":"vendorOrders"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"vendorPhoneNumbers":{"cfc":"VendorPhoneNumber","fieldtype":"one-to-many","singularname":"vendorPhoneNumber","cascade":"all-delete-orphan","fkcolumn":"vendorID","type":"array","inverse":true,"name":"vendorPhoneNumbers"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"vendorWebsite":{"ormtype":"string","name":"vendorWebsite"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"vendorSkusSmartList":{"persistent":false,"name":"vendorSkusSmartList"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"products":{"cfc":"Product","linktable":"SwVendorProduct","fieldtype":"many-to-many","singularname":"product","inversejoincolumn":"productID","fkcolumn":"vendorID","name":"products"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"vendorID","type":"array","inverse":true,"name":"attributeValues"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"vendorEmailAddresses":{"cfc":"VendorEmailAddress","fieldtype":"one-to-many","singularname":"vendorEmailAddress","cascade":"all-delete-orphan","fkcolumn":"vendorID","type":"array","inverse":true,"name":"vendorEmailAddresses"}};
                	entities['Vendor'].className = 'Vendor';
                	validations['Vendor'] = {"properties":{"vendororders":[{"contexts":"delete","maxCollection":0}],"vendorWebsite":[{"contexts":"save","dataType":"url"}],"vendorName":[{"contexts":"save","required":true}]}};
                	defaultValues['Vendor'] = {
                	vendorID:'',
										vendorName:null,
									vendorWebsite:null,
									accountNumber:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Sku'] = {"endReservationDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"endReservationDateTime"},"skuCode":{"length":50,"unique":true,"ormtype":"string","index":"PI_SKUCODE","name":"skuCode"},"bundledSkus":{"cfc":"SkuBundle","fieldtype":"one-to-many","singularname":"bundledSku","cascade":"all-delete-orphan","fkcolumn":"skuID","inverse":true,"name":"bundledSkus"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"transactionExistsFlag":{"persistent":false,"type":"boolean","name":"transactionExistsFlag"},"eligibleFulfillmentMethods":{"persistent":false,"type":"array","name":"eligibleFulfillmentMethods"},"promotionRewardExclusions":{"cfc":"PromotionReward","linktable":"SwPromoRewardExclSku","fieldtype":"many-to-many","singularname":"promotionRewardExclusion","inversejoincolumn":"promotionRewardID","fkcolumn":"skuID","inverse":true,"type":"array","name":"promotionRewardExclusions"},"redemptionAmountPercentage":{"hint":"the percentage to use if type is set to percentage","ormtype":"float","name":"redemptionAmountPercentage"},"loyaltyRedemptionExclusions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionExclSku","fieldtype":"many-to-many","singularname":"loyaltyRedemptionExclusion","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"skuID","inverse":true,"type":"array","name":"loyaltyRedemptionExclusions"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"priceGroupRates":{"cfc":"PriceGroupRate","linktable":"SwPriceGroupRateSku","fieldtype":"many-to-many","singularname":"priceGroupRate","inversejoincolumn":"priceGroupRateID","fkcolumn":"skuID","inverse":true,"name":"priceGroupRates"},"eventCapacity":{"ormtype":"integer","name":"eventCapacity"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"assignedOrderItemAttributeSetSmartList":{"persistent":false,"name":"assignedOrderItemAttributeSetSmartList"},"registrantEmailList":{"persistent":false,"type":"array","name":"registrantEmailList"},"productBundleGroups":{"cfc":"ProductBundleGroup","fieldtype":"one-to-many","singularname":"productBundleGroup","cascade":"all-delete-orphan","fkcolumn":"productBundleSkuID","type":"array","inverse":true,"name":"productBundleGroups"},"options":{"cfc":"Option","linktable":"SwSkuOption","fieldtype":"many-to-many","singularname":"option","inversejoincolumn":"optionID","fkcolumn":"skuID","name":"options"},"promotionQualifierExclusions":{"cfc":"PromotionQualifier","linktable":"SwPromoQualExclSku","fieldtype":"many-to-many","singularname":"promotionQualifierExclusion","inversejoincolumn":"promotionQualifierID","fkcolumn":"skuID","inverse":true,"type":"array","name":"promotionQualifierExclusions"},"productReviews":{"cfc":"ProductReview","fieldtype":"one-to-many","singularname":"productReview","cascade":"all-delete-orphan","fkcolumn":"skuID","inverse":true,"name":"productReviews"},"validations":{"persistent":false,"type":"struct","name":"validations"},"giftCardExpirationTermOptions":{"persistent":false,"name":"giftCardExpirationTermOptions"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"eventStartDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"eventStartDateTime"},"attributeValues":{"cfc":"AttributeValue","fieldtype":"one-to-many","singularname":"attributeValue","cascade":"all-delete-orphan","fkcolumn":"skuID","type":"array","inverse":true,"name":"attributeValues"},"purchaseStartDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"purchaseStartDateTime"},"currencyDetails":{"persistent":false,"type":"struct","name":"currencyDetails"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"salePrice":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"salePrice"},"attendedQuantity":{"hint":"Optional field for manually entered event attendance.","ormtype":"integer","name":"attendedQuantity"},"skuCurrencies":{"cfc":"SkuCurrency","fieldtype":"one-to-many","singularname":"skuCurrency","cascade":"all-delete-orphan","fkcolumn":"skuID","type":"array","inverse":true,"name":"skuCurrencies"},"eventConflictsSmartList":{"persistent":false,"name":"eventConflictsSmartList"},"renewalPrice":{"ormtype":"big_decimal","hb_formattype":"currency","default":0,"name":"renewalPrice"},"adminIcon":{"persistent":false,"name":"adminIcon"},"availableSeatCount":{"persistent":false,"name":"availableSeatCount"},"placedOrderItemsSmartList":{"persistent":false,"type":"any","name":"placedOrderItemsSmartList"},"optionsByOptionGroupCodeStruct":{"persistent":false,"name":"optionsByOptionGroupCodeStruct"},"nextEstimatedAvailableDate":{"persistent":false,"type":"string","name":"nextEstimatedAvailableDate"},"listPrice":{"ormtype":"big_decimal","hb_formattype":"currency","default":0,"name":"listPrice"},"userDefinedPriceFlag":{"ormtype":"boolean","default":0,"name":"userDefinedPriceFlag"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"renewalSubscriptionBenefits":{"cfc":"SubscriptionBenefit","linktable":"SwSkuRenewalSubsBenefit","fieldtype":"many-to-many","singularname":"renewalSubscriptionBenefit","inversejoincolumn":"subscriptionBenefitID","fkcolumn":"skuID","type":"array","name":"renewalSubscriptionBenefits"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"defaultFlag":{"persistent":false,"type":"boolean","name":"defaultFlag"},"subscriptionBenefits":{"cfc":"SubscriptionBenefit","linktable":"SwSkuSubsBenefit","fieldtype":"many-to-many","singularname":"subscriptionBenefit","inversejoincolumn":"subscriptionBenefitID","fkcolumn":"skuID","type":"array","name":"subscriptionBenefits"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"startReservationDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"startReservationDateTime"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"promotionQualifiers":{"cfc":"PromotionQualifier","linktable":"SwPromoQualSku","fieldtype":"many-to-many","singularname":"promotionQualifier","inversejoincolumn":"promotionQualifierID","fkcolumn":"skuID","inverse":true,"name":"promotionQualifiers"},"skuID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"skuID"},"skuDescription":{"length":4000,"hb_formfieldtype":"wysiwyg","ormtype":"string","name":"skuDescription"},"currencyCode":{"length":3,"ormtype":"string","name":"currencyCode"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"loyaltyAccruementExclusions":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruExclSku","fieldtype":"many-to-many","singularname":"loyaltyAccruementExclusion","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"skuID","inverse":true,"type":"array","name":"loyaltyAccruementExclusions"},"skuName":{"ormtype":"string","name":"skuName"},"stocks":{"cfc":"Stock","fieldtype":"one-to-many","hb_cascadecalculate":true,"singularname":"stock","cascade":"all-delete-orphan","fkcolumn":"skuID","inverse":true,"name":"stocks"},"salePriceDiscountType":{"persistent":false,"type":"string","name":"salePriceDiscountType"},"stocksDeletableFlag":{"persistent":false,"type":"boolean","name":"stocksDeletableFlag"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"locations":{"persistent":false,"type":"array","name":"locations"},"promotionRewards":{"cfc":"PromotionReward","linktable":"SwPromoRewardSku","fieldtype":"many-to-many","singularname":"promotionReward","inversejoincolumn":"promotionRewardID","fkcolumn":"skuID","inverse":true,"name":"promotionRewards"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"productSchedule":{"cfc":"ProductSchedule","fieldtype":"many-to-one","fkcolumn":"productScheduleID","name":"productSchedule"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"redemptionAmountTypeOptions":{"persistent":false,"name":"redemptionAmountTypeOptions"},"eventRegistrations":{"cfc":"EventRegistration","fieldtype":"one-to-many","lazy":"extra","singularname":"eventRegistration","cascade":"all-delete-orphan","fkcolumn":"skuID","inverse":true,"name":"eventRegistrations"},"allowEventWaitlistingFlag":{"ormtype":"boolean","default":0,"name":"allowEventWaitlistingFlag"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"loyaltyRedemptions":{"cfc":"LoyaltyRedemption","linktable":"SwLoyaltyRedemptionSku","fieldtype":"many-to-many","singularname":"loyaltyRedemption","inversejoincolumn":"loyaltyRedemptionID","fkcolumn":"skuID","inverse":true,"type":"array","name":"loyaltyRedemptions"},"registrantCount":{"persistent":false,"type":"integer","name":"registrantCount"},"redemptionAmountType":{"hint":"used for gift card credit calculation. Values sameAsPrice, fixedAmount, Percentage","hb_formfieldtype":"select","ormtype":"string","hb_formattype":"rbKey","name":"redemptionAmountType"},"product":{"cfc":"Product","fieldtype":"many-to-one","hb_cascadecalculate":true,"fkcolumn":"productID","name":"product"},"livePrice":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"livePrice"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"productScheduleSmartList":{"persistent":false,"type":"any","name":"productScheduleSmartList"},"baseProductType":{"persistent":false,"name":"baseProductType"},"availableForPurchaseFlag":{"persistent":false,"name":"availableForPurchaseFlag"},"price":{"ormtype":"big_decimal","hb_formattype":"currency","default":0,"name":"price"},"subscriptionTerm":{"cfc":"SubscriptionTerm","fieldtype":"many-to-one","fkcolumn":"subscriptionTermID","name":"subscriptionTerm"},"eventStatus":{"persistent":false,"type":"any","name":"eventStatus"},"qats":{"persistent":false,"type":"numeric","name":"qats"},"loyaltyAccruements":{"cfc":"LoyaltyAccruement","linktable":"SwLoyaltyAccruSku","fieldtype":"many-to-many","singularname":"loyaltyAccruement","inversejoincolumn":"loyaltyAccruementID","fkcolumn":"skuID","inverse":true,"name":"loyaltyAccruements"},"eventConflictExistsFlag":{"persistent":false,"type":"boolean","name":"eventConflictExistsFlag"},"registeredUserCount":{"persistent":false,"type":"integer","name":"registeredUserCount"},"publishedFlag":{"ormtype":"boolean","default":0,"name":"publishedFlag"},"giftCardExpirationTerm":{"cfc":"Term","fieldtype":"many-to-one","hint":"Term that is used to set the Expiration Date of the ordered gift card.","fkcolumn":"giftCardExpirationTermID","name":"giftCardExpirationTerm"},"activeFlag":{"ormtype":"boolean","default":1,"name":"activeFlag"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"eventEndDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"eventEndDateTime"},"calculatedQATS":{"ormtype":"integer","name":"calculatedQATS"},"orderItems":{"cfc":"OrderItem","fieldtype":"one-to-many","lazy":"extra","singularname":"orderItem","fkcolumn":"skuID","inverse":true,"name":"orderItems"},"assignedSkuBundles":{"cfc":"SkuBundle","fieldtype":"one-to-many","lazy":"extra","singularname":"assignedSkuBundle","cascade":"all-delete-orphan","fkcolumn":"bundledSkuID","inverse":true,"name":"assignedSkuBundles"},"salePriceDetails":{"persistent":false,"type":"struct","name":"salePriceDetails"},"salePriceDiscountAmount":{"persistent":false,"type":"string","name":"salePriceDiscountAmount"},"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"alternateSkuCodes":{"cfc":"AlternateSkuCode","fieldtype":"one-to-many","singularname":"alternateSkuCode","cascade":"all-delete-orphan","fkcolumn":"skuID","inverse":true,"name":"alternateSkuCodes"},"locationConfigurations":{"cfc":"LocationConfiguration","linktable":"SwSkuLocationConfiguration","fieldtype":"many-to-many","singularname":"locationConfiguration","inversejoincolumn":"locationConfigurationID","fkcolumn":"skuID","type":"array","name":"locationConfigurations"},"redemptionAmount":{"hint":"value to be used in calculation conjunction with redeptionAmountType","ormtype":"big_decimal","name":"redemptionAmount"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"waitlistQueueTerm":{"cfc":"Term","fieldtype":"many-to-one","hint":"Term that a waitlisted registrant has to claim offer.","fkcolumn":"termID","name":"waitlistQueueTerm"},"physicals":{"cfc":"Physical","linktable":"SwPhysicalSku","fieldtype":"many-to-many","singularname":"physical","inversejoincolumn":"physicalID","fkcolumn":"skuID","inverse":true,"type":"array","name":"physicals"},"eventAttendanceCode":{"hint":"Unique code to track event attendance","length":8,"ormtype":"string","name":"eventAttendanceCode"},"salePriceExpirationDateTime":{"persistent":false,"hb_formattype":"datetime","type":"date","name":"salePriceExpirationDateTime"},"eventOverbookedFlag":{"persistent":false,"type":"boolean","name":"eventOverbookedFlag"},"bundleFlag":{"ormtype":"boolean","default":0,"name":"bundleFlag"},"imageExistsFlag":{"persistent":false,"type":"boolean","name":"imageExistsFlag"},"accessContents":{"cfc":"Content","linktable":"SwSkuAccessContent","fieldtype":"many-to-many","singularname":"accessContent","inversejoincolumn":"contentID","fkcolumn":"skuID","type":"array","name":"accessContents"},"currentAccountPrice":{"persistent":false,"hb_formattype":"currency","type":"numeric","name":"currentAccountPrice"},"remoteID":{"ormtype":"string","name":"remoteID"},"optionsByOptionGroupIDStruct":{"persistent":false,"name":"optionsByOptionGroupIDStruct"},"optionsIDList":{"persistent":false,"name":"optionsIDList"},"skuDefinition":{"persistent":false,"name":"skuDefinition"},"purchaseEndDateTime":{"ormtype":"timestamp","hb_formattype":"dateTime","name":"purchaseEndDateTime"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"imageFile":{"length":250,"ormtype":"string","name":"imageFile"}};
                	entities['Sku'].className = 'Sku';
                	validations['Sku'] = {"properties":{"price":[{"contexts":"save","dataType":"numeric","required":true,"minValue":0}],"skuCode":[{"contexts":"save","regex":"^[a-zA-Z0-9-_.|:~^]+$","required":true,"unique":true}],"product":[{"contexts":"save","required":true}],"renewalPrice":[{"contexts":"save","dataType":"numeric","minValue":0}],"transactionExistsFlag":[{"contexts":"delete","eq":false}],"listPrice":[{"contexts":"save","dataType":"numeric","minValue":0}],"options":[{"contexts":"save","conditions":"notSkuBundle","method":"hasUniqueOptions"},{"contexts":"save","method":"hasOneOptionPerOptionGroup"}],"physicalCounts":[{"contexts":"delete","maxCollection":0}],"defaultFlag":[{"contexts":"delete","eq":false}]},"conditions":{"notSkuBundle":{"bundleFlag":{"eq":0}}}};
                	defaultValues['Sku'] = {
                	skuID:'',
										activeFlag:1,
									publishedFlag:0,
									skuName:null,
									skuDescription:null,
									skuCode:null,
									eventAttendanceCode:null,
									listPrice:0,
									price:0,
									renewalPrice:0,
									currencyCode:'USD',
										imageFile:null,
									userDefinedPriceFlag:0,
									eventStartDateTime:null,
									eventEndDateTime:null,
									startReservationDateTime:null,
									endReservationDateTime:null,
									purchaseStartDateTime:null,
									purchaseEndDateTime:null,
									bundleFlag:0,
									eventCapacity:null,
									attendedQuantity:null,
									allowEventWaitlistingFlag:0,
									redemptionAmountType:null,
									redemptionAmountPercentage:null,
									redemptionAmount:null,
									calculatedQATS:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	entities['Sku_ChangeEventDates'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"endReservationDateTime":{"hb_formfieldtype":"datetime","name":"endReservationDateTime"},"locationConfigurations":{"name":"locationConfigurations"},"startReservationDateTime":{"hb_formfieldtype":"datetime","name":"startReservationDateTime"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"validations":{"persistent":false,"type":"struct","name":"validations"},"eventStartDateTime":{"hb_formfieldtype":"datetime","name":"eventStartDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"eventEndDateTime":{"hb_formfieldtype":"datetime","name":"eventEndDateTime"},"editScope":{"hint":"Edit this sku schedule or all?","hb_formfieldtype":"select","name":"editScope"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['Sku_ChangeEventDates'].className = 'Sku_ChangeEventDates';
                	validations['Sku_ChangeEventDates'] = {"properties":{"endReservationDateTime":[{"dataType":"date","gtNow":true,"required":true}],"startReservationDateTime":[{"dataType":"date","gtNow":true,"required":true,"ltDateTimeProperty":"endReservationDateTime"}],"eventStartDateTime":[{"dataType":"date","gtNow":true,"required":true,"ltDateTimeProperty":"eventEndDateTime"}],"eventEndDateTime":[{"dataType":"date","gtNow":true,"required":true}]}};
                	defaultValues['Sku_ChangeEventDates'] = {
                	sku:'',
										eventStartDateTime:'',
									eventEndDateTime:'',
									startReservationDateTime:'',
									endReservationDateTime:'',
									locationConfigurations:'',
									editScope:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Sku_AddLocation'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"locationConfigurations":{"name":"locationConfigurations"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"editScope":{"hint":"Edit this sku schedule or all?","hb_formfieldtype":"select","name":"editScope"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Sku_AddLocation'].className = 'Sku_AddLocation';
                	validations['Sku_AddLocation'] = {"properties":{}};
                	defaultValues['Sku_AddLocation'] = {
                	sku:'',
										locationConfigurations:'',
									editScope:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['Sku_RemoveLocation'] = {"preProcessDisplayedFlag":{"name":"preProcessDisplayedFlag"},"populatedFlag":{"name":"populatedFlag"},"locationConfigurations":{"name":"locationConfigurations"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"editScope":{"hint":"Edit this sku schedule or all?","hb_formfieldtype":"select","name":"editScope"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"sku":{"name":"sku"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"},"validations":{"persistent":false,"type":"struct","name":"validations"}};
                	entities['Sku_RemoveLocation'].className = 'Sku_RemoveLocation';
                	validations['Sku_RemoveLocation'] = {"properties":{}};
                	defaultValues['Sku_RemoveLocation'] = {
                	sku:'',
										locationConfigurations:'',
									editScope:'',
									preProcessDisplayedFlag:0,
										populatedFlag:0,
										
						z:''
	                };
                
                	entities['OrderOrigin'] = {"printTemplates":{"persistent":false,"type":"struct","name":"printTemplates"},"simpleRepresentation":{"persistent":false,"type":"string","name":"simpleRepresentation"},"hibachiErrors":{"persistent":false,"type":"any","name":"hibachiErrors"},"orderOriginName":{"ormtype":"string","name":"orderOriginName"},"persistableErrors":{"persistent":false,"type":"array","name":"persistableErrors"},"orderOriginID":{"generator":"uuid","unsavedvalue":"","fieldtype":"id","length":32,"ormtype":"string","default":"","name":"orderOriginID"},"auditSmartList":{"persistent":false,"type":"any","name":"auditSmartList"},"settingValueFormatted":{"persistent":false,"type":"any","name":"settingValueFormatted"},"orderOriginType":{"hb_formfieldtype":"select","ormtype":"string","name":"orderOriginType"},"processObjects":{"persistent":false,"type":"struct","name":"processObjects"},"orders":{"cfc":"Order","fieldtype":"one-to-many","lazy":"extra","singularname":"order","fkcolumn":"orderOriginID","inverse":true,"name":"orders"},"attributeValuesByAttributeCodeStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeCodeStruct"},"emailTemplates":{"persistent":false,"type":"struct","name":"emailTemplates"},"populatedSubProperties":{"persistent":false,"type":"struct","name":"populatedSubProperties"},"rollbackProcessedFlag":{"persistent":false,"type":"boolean","name":"rollbackProcessedFlag"},"modifiedByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"modifiedByAccountID"},"newFlag":{"persistent":false,"type":"boolean","name":"newFlag"},"attributeValuesByAttributeIDStruct":{"persistent":false,"type":"struct","name":"attributeValuesByAttributeIDStruct"},"encryptedPropertiesExistFlag":{"persistent":false,"type":"boolean","name":"encryptedPropertiesExistFlag"},"hibachiMessages":{"persistent":false,"type":"any","name":"hibachiMessages"},"modifiedDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"modifiedDateTime"},"validations":{"persistent":false,"type":"struct","name":"validations"},"remoteID":{"ormtype":"string","name":"remoteID"},"createdByAccount":{"persistent":false,"name":"createdByAccount"},"activeFlag":{"ormtype":"boolean","hb_formattype":"yesno","name":"activeFlag"},"createdDateTime":{"ormtype":"timestamp","hb_populateenabled":false,"name":"createdDateTime"},"announceEvent":{"persistent":false,"type":"boolean","default":true,"name":"announceEvent"},"assignedAttributeSetSmartList":{"persistent":false,"type":"any","name":"assignedAttributeSetSmartList"},"createdByAccountID":{"ormtype":"string","hb_populateenabled":false,"name":"createdByAccountID"},"modifiedByAccount":{"persistent":false,"name":"modifiedByAccount"},"hibachiInstanceApplicationScopeKey":{"PERSISTENT":false,"TYPE":"string","NAME":"hibachiInstanceApplicationScopeKey"}};
                	entities['OrderOrigin'].className = 'OrderOrigin';
                	validations['OrderOrigin'] = {"properties":{"orderOriginName":[{"contexts":"save","required":true}],"orders":[{"contexts":"delete","maxCollection":0}]}};
                	defaultValues['OrderOrigin'] = {
                	orderOriginID:'',
										activeFlag:1,
									orderOriginName:null,
									orderOriginType:null,
									remoteID:null,
									createdDateTime:'',
										createdByAccountID:null,
									modifiedDateTime:'',
										modifiedByAccountID:null,
									
						z:''
	                };
                
                	console.log($delegate);
                angular.forEach(entities,function(entity){
                	$delegate['get'+entity.className] = function(options){
						var entityInstance = $delegate.newEntity(entity.className);
						var entityDataPromise = $delegate.getEntity(entity.className,options);
						entityDataPromise.then(function(response){
							
							if(angular.isDefined(response.processData)){
								entityInstance.$$init(response.data);
								var processObjectInstance = $delegate['new'+entity.className+'_'+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
								processObjectInstance.$$init(response.processData);
								processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
								entityInstance.processObject = processObjectInstance;
							}else{
								entityInstance.$$init(response);
							}
						});
						return {
							promise:entityDataPromise,
							value:entityInstance	
						}
					}
					
					 
					$delegate['get'+entity.className] = function(options){
						var entityInstance = $delegate.newEntity(entity.className);
						var entityDataPromise = $delegate.getEntity(entity.className,options);
						entityDataPromise.then(function(response){
							
							if(angular.isDefined(response.processData)){
								entityInstance.$$init(response.data);
								var processObjectInstance = $delegate['new'+entity.className+options.processContext.charAt(0).toUpperCase()+options.processContext.slice(1)]();
								processObjectInstance.$$init(response.processData);
								processObjectInstance.data[entity.className.charAt(0).toLowerCase()+entity.className.slice(1)] = entityInstance;
								entityInstance.processObject = processObjectInstance;
							}else{
								entityInstance.$$init(response);
							}
						});
						return {
							promise:entityDataPromise,
							value:entityInstance	
						}
					}
					
					$delegate['new'+entity.className] = function(){
						return $delegate.newEntity(entity.className);
					}
					
					entity.isProcessObject = entity.className.indexOf('_') >= 0;
					
					 _jsEntities[ entity.className ]=function() {
				
						this.validations = validations[entity.className];
						
						this.metaData = entity;
						this.metaData.className = entity.className;
						
						this.metaData.$$getRBKey = function(rbKey,replaceStringData){
							return $delegate.rbKey(rbKey,replaceStringData);
						};
						
						
						this.metaData.$$getPropertyTitle = function(propertyName){
							return _getPropertyTitle(propertyName,this);
						}
						
						this.metaData.$$getPropertyHint = function(propertyName){
							return _getPropertyHint(propertyName,this);
						}
		
						this.metaData.$$getManyToManyName = function(singularname){
							var metaData = this;
							for(var i in metaData){
								if(metaData[i].singularname === singularname){
									return metaData[i].name;
								}
							}
						}
						
						
						
						this.metaData.$$getPropertyFieldType = function(propertyName){
							return _getPropertyFieldType(propertyName,this);
						}
						
						this.metaData.$$getPropertyFormatType = function(propertyName){
							return _getPropertyFormatType(propertyName,this);
						}
						
						this.metaData.$$getDetailTabs = function(){
							var deferred = $q.defer();
							var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getDetailTabs&entityName='+this.className;
                  	 		var detailTabs = [];
							$http.get(urlString)
		                    .success(function(data){
		                        deferred.resolve(data);
		                    }).error(function(reason){
		                        deferred.reject(reason);
		                    });
		                    
							return deferred.promise;
						}
						
						this.$$getFormattedValue = function(propertyName,formatType){
							return _getFormattedValue(propertyName,formatType,this);
						}
						
						this.data = {};
						this.modifiedData = {};
						
						var jsEntity = this;
						if(entity.isProcessObject){
							(function(entity){_jsEntities[ entity.className ].prototype = {
								$$getID:function(){
									
									return '';
								}
								,$$getIDName:function(){
									var IDNameString = '';
									return IDNameString;
								}
							}})(entity);
						}
						
						angular.forEach(entity,function(property){
							if(angular.isObject(property) && angular.isDefined(property.name)){
								
								if(angular.isDefined(defaultValues[entity.className][property.name])){
									jsEntity.data[property.name] = defaultValues[entity.className][property.name]; 
								}
							}
						});
							
					};
					 _jsEntities[ entity.className ].prototype = {
						$$getPropertyByName:function(propertyName){
							return this['$$get'+propertyName.charAt(0).toUpperCase() + propertyName.slice(1)]();
						},
						$$isPersisted:function(){
							if(this.$$getID() === ''){
								return false;
							}else{
								return true;
							}
						},
						$$init:function( data ) {
							_init(this,data);
						},
						$$save:function(){
							return _save(this);
						},
						$$delete:function(){
							var deletePromise =_delete(this)
							return deletePromise;
						},
						
						$$getValidationsByProperty:function(property){
							return _getValidationsByProperty(this,property);
						},
						$$getValidationByPropertyAndContext:function(property,context){
							return _getValidationByPropertyAndContext(this,property,context);
						}
						
						,$$getMetaData:function( propertyName ) {
							if(propertyName === undefined) {
								return this.metaData
							}else{
								if(angular.isDefined(this.metaData[propertyName].name) && angular.isUndefined(this.metaData[propertyName].nameCapitalCase)){
									this.metaData[propertyName].nameCapitalCase = this.metaData[propertyName].name.charAt(0).toUpperCase() + this.metaData[propertyName].name.slice(1);
								}
								if(angular.isDefined(this.metaData[propertyName].cfc) && angular.isUndefined(this.metaData[propertyName].cfcProperCase)){
									this.metaData[propertyName].cfcProperCase = this.metaData[propertyName].cfc.charAt(0).toLowerCase()+this.metaData[propertyName].cfc.slice(1);
								}
								return this.metaData[ propertyName ];
							}
						}
					};
					angular.forEach(entity,function(property){
						if(angular.isObject(property) && angular.isDefined(property.name)){
							if(angular.isUndefined(property.persistent)){
								if(angular.isDefined(property.fieldtype)){
									if(['many-to-one'].indexOf(property.fieldtype) >= 0){
										
										
										
										_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {

											var thisEntityInstance = this;

											if(angular.isDefined(this['$$get'+this.$$getIDName().charAt(0).toUpperCase()+this.$$getIDName().slice(1)]())){
												var options = {
													columnsConfig:angular.toJson([
														{
															"propertyIdentifier":"_"+this.metaData.className.toLowerCase()+"_"+property.name
														}
													]),
													joinsConfig:angular.toJson([
														{
															"associationName":property.name,
															"alias":"_"+this.metaData.className.toLowerCase()+"_"+property.name
														}
													]),
													filterGroupsConfig:angular.toJson([{
														"filterGroup":[
															{
																"propertyIdentifier":"_"+this.metaData.className.toLowerCase()+"."+this.$$getIDName(),
																"comparisonOperator":"=",
																"value":this.$$getID()
															}
														]
													}]),
													allRecords:true
												};
												
												var collectionPromise = $delegate.getEntity(entity.className,options);
												collectionPromise.then(function(response){
													for(var i in response.records){
														var entityInstance = $delegate.newEntity(thisEntityInstance.metaData[property.name].cfc);
														//Removed the array index here at the end of local.property.name.
														if(angular.isArray(response.records[i][property.name])){
															entityInstance.$$init(response.records[i][property.name][0]);
														}else{
															entityInstance.$$init(response.records[i][property.name]);//Shouldn't have the array index'
														}
														thisEntityInstance['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)](entityInstance);
													}
												});
												return collectionPromise;
												
											}
											
											return null;
										};
										_jsEntities[ entity.className ].prototype['$$set'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(entityInstance) {
										
											
											var thisEntityInstance = this;
											var metaData = this.metaData;
											var manyToManyName = '';
											if(property.name === 'parent'+this.metaData.className){
												var childName = 'child'+this.metaData.className;
												manyToManyName = entityInstance.metaData.$$getManyToManyName(childName);
												
											}else{
												manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
											}
											
											if(angular.isUndefined(thisEntityInstance.parents)){
												thisEntityInstance.parents = [];
											}
											
											thisEntityInstance.parents.push(thisEntityInstance.metaData[property.name]);
											
											
											if(angular.isDefined(manyToManyName)){
												if(angular.isUndefined(entityInstance.children)){
													entityInstance.children = [];
												}
												
												var child = entityInstance.metaData[manyToManyName];;
												
												if(entityInstance.children.indexOf(child) === -1){
													entityInstance.children.push(child);
												}
												
												if(angular.isUndefined(entityInstance.data[manyToManyName])){
													entityInstance.data[manyToManyName] = [];
												}
												entityInstance.data[manyToManyName].push(thisEntityInstance);
											}
		
											thisEntityInstance.data[property.name] = entityInstance;
										};
									
									}else if(['one-to-many','many-to-many'].indexOf(property.fieldtype) >= 0){
									
									
									
									
										_jsEntities[ entity.className ].prototype['$$add'+property.singularname.charAt(0).toUpperCase()+property.singularname.slice(1)]=function(){

										
										var entityInstance = $delegate.newEntity(this.metaData[property.name].cfc);
										var metaData = this.metaData;
										
										if(metaData[property.name].fieldtype === 'one-to-many'){
											entityInstance.data[metaData[property.name].fkcolumn.slice(0,-2)] = this;
										
										}else if(metaData[property.name].fieldtype === 'many-to-many'){
											
											var manyToManyName = entityInstance.metaData.$$getManyToManyName(metaData.className.charAt(0).toLowerCase() + this.metaData.className.slice(1));
											if(angular.isUndefined(entityInstance.data[manyToManyName])){
												entityInstance.data[manyToManyName] = [];
											}
											entityInstance.data[manyToManyName].push(this);
										}
										
										if(angular.isDefined(metaData[property.name])){
											if(angular.isDefined(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)])){
												
												if(angular.isUndefined(entityInstance.parents)){
													entityInstance.parents = [];
												}
	
												entityInstance.parents.push(entityInstance.metaData[metaData[property.name].fkcolumn.slice(0,-2)]);
											}
											
											if(angular.isUndefined(this.children)){
												this.children = [];
											}
	
											var child = metaData[property.name];
											
											if(this.children.indexOf(child) === -1){
												this.children.push(child);
											}
										}
										if(angular.isUndefined(this.data[property.name])){
											this.data[property.name] = [];
										}
										
										this.data[property.name].push(entityInstance);
										return entityInstance;
									};
									
									
									
										_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
										console.log('test');
											console.log(this);

										var thisEntityInstance = this;
										if(angular.isDefined(this['$$get'+this.$$getIDName().charAt(0).toUpperCase()+this.$$getIDName().slice(1)])){
											var options = {
												filterGroupsConfig:angular.toJson([{
													"filterGroup":[
														{
															"propertyIdentifier":"_"+property.cfc.toLowerCase()+"."+property.fkcolumn.replace('ID','')+"."+this.$$getIDName(),
															"comparisonOperator":"=",
															"value":this.$$getID()
														}
													]
												}]),
												allRecords:true
											};
											
											var collectionPromise = $delegate.getEntity(property.cfc,options);
											collectionPromise.then(function(response){
												
												for(var i in response.records){
													
													var entityInstance = thisEntityInstance['$$add'+thisEntityInstance.metaData[property.name].singularname.charAt(0).toUpperCase()+thisEntityInstance.metaData[property.name].singularname.slice(1)]();
													entityInstance.$$init(response.records[i]);
													if(angular.isUndefined(thisEntityInstance[property.name])){
														thisEntityInstance[property.name] = [];
													}
													thisEntityInstance[property.name].push(entityInstance);
												}
											});
											return collectionPromise;
										}
									};
								}else{

									if(['id'].indexOf(property.fieldtype >= 0)){
										_jsEntities[ entity.className ].prototype['$$getID']=function(){
											//this should retreive id from the metadata
											return this.data[this.$$getIDName()];
										};
										_jsEntities[ entity.className ].prototype['$$getIDName']=function(){
											var IDNameString = property.name;
											return IDNameString;
										};
									}
									
										_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function(){
										return this.data[property.name];
									};
								}
							}else{
								_jsEntities[ entity.className ].prototype['$$get'+property.name.charAt(0).toUpperCase()+property.name.slice(1)]=function() {
									return this.data[property.name];
								};
							}
						}
						}
					});
                });
				$delegate.setJsEntities(_jsEntities);
				
				var _init = function(entityInstance,data){
	                for(var key in data) {
	                    if(key.charAt(0) !== '$' && angular.isDefined(entityInstance.metaData[key])){
	                        var propertyMetaData = entityInstance.metaData[key];
	                        
	                        if(angular.isDefined(propertyMetaData) && angular.isDefined(propertyMetaData.hb_formfieldtype) && propertyMetaData.hb_formfieldtype === 'json'){
	                            if(data[key].trim() !== ''){
	                                entityInstance.data[key] = angular.fromJson(data[key]);
	                            }
	                            
	                        }else{
		                        entityInstance.data[key] = data[key];   
		                    }
	                	}
	           	 	}
	            }
	            
	            var _getPropertyTitle = function(propertyName,metaData){
	                var propertyMetaData = metaData[propertyName];
	                if(angular.isDefined(propertyMetaData['hb_rbkey'])){
	                    return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
	                }else if (angular.isUndefined(propertyMetaData['persistent'])){
	                    if(angular.isDefined(propertyMetaData['fieldtype']) 
	                    && angular.isDefined(propertyMetaData['cfc'])
	                    && ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1){
	                        
	                        return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+"."+propertyName+',entity.'+propertyMetaData.cfc+'_plural');
	                    }else if(angular.isDefined(propertyMetaData.fieldtype)
	                    && angular.isDefined(propertyMetaData.cfc)
	                    && ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
	                        return metaData.$$getRBKey("entity."+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc);
	                    }
	                    return metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
	                }else if(metaData.isProcessObject){
	                    if(angular.isDefined(propertyMetaData.fieldtype) 
	                        && angular.isDefined(propertyMetaData.cfc) 
	                        && ["one-to-many","many-to-many"].indexOf(propertyMetaData.fieldtype) > -1
	                    ){
	                        return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc.toLowerCase()+'_plural');
	                    }else if(angular.isDefined(propertyMetaData.fieldtype) 
	                        && angular.isDefined(propertyMetaData.cfc) 
	                    ){
	                        return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+',entity.'+propertyMetaData.cfc.toLowerCase());
	                    }
	                    return metaData.$$getRBKey('processObject.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
	                    
	                }
	                return metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
	            }
	            
	            var _getPropertyHint = function(propertyName,metaData){
	                var propertyMetaData = metaData[propertyName];
	                var keyValue = '';
	                if(angular.isDefined(propertyMetaData['hb_rbkey'])){
	                    keyValue = metaData.$$getRBKey(propertyMetaData['hb_rbkey']+'_hint');
	                }else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
	                    keyValue = metaData.$$getRBKey('entity.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'_hint');
	                }else{
	                    keyValue = metaData.$$getRBKey('object.'+metaData.className.toLowerCase()+'.'+propertyName.toLowerCase());
	                }
	                if(keyValue.slice(-8) !== '_missing'){
	                    return keyValue;
	                }
	                return '';
	            }
	            
	            
	            
	            var _getPropertyFieldType = function(propertyName,metaData){
	                var propertyMetaData = metaData[propertyName];
	                if(angular.isDefined(propertyMetaData['hb_formfieldtype'])){
	                    return propertyMetaData['hb_formfieldtype'];
	                }
	                
	                if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
	                    var dataType = "";
	                    
	                    if(angular.isDefined(propertyMetaData.ormtype)){
	                        dataType = propertyMetaData.ormtype;
	                    }else if (angular.isDefined(propertyMetaData.type)){
	                        dataType = propertyMetaData.type;
	                    }
	                    if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
	                        return "yesno";
	                    }else if (["date","timestamp"].indexOf(dataType) > -1){
	                        return "dateTime";
	                    }else if ("array" === dataType){
	                        return "select";
	                    }else if ("struct" === dataType){
	                        return "checkboxgroup";
	                    }else if(propertyName.indexOf('password') > -1){
	                        return "password";
	                    }
	                    
	                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-one'){
	                    return 'select';
	                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'one-to-many'){
	                    return 'There is no property field type for one-to-many relationship properties, which means that you cannot get a fieldtype for '+propertyName;
	                }else if(angular.isDefined(propertyMetaData.fieldtype) && propertyMetaData.fieldtype === 'many-to-many'){
	                    return "listingMultiselect";
	                }
	            
	                return "text";
	            }
	            
	            var _getPropertyFormatType = function(propertyName,metaData){
	                var propertyMetaData = metaData[propertyName];
	                
	                if(angular.isDefined(propertyMetaData['hb_formattype'])){
	                    return propertyMetaData['hb_formattype'];
	                }else if(angular.isUndefined(propertyMetaData.fieldtype) || propertyMetaData.fieldtype === 'column'){
	                    var dataType = "";
	                    
	                    if(angular.isDefined(propertyMetaData.ormtype)){
	                        dataType = propertyMetaData.ormtype;
	                    }else if (angular.isDefined(propertyMetaData.type)){
	                        dataType = propertyMetaData.type;
	                    }
	                    
	                    if(["boolean","yes_no","true_false"].indexOf(dataType) > -1){
	                        return "yesno";
	                    }else if (["date","timestamp"].indexOf(dataType) > -1){
	                        return "dateTime";
	                    }else if (["big_decimal"].indexOf(dataType) > -1 && propertyName.slice(-6) === 'weight'){
	                        return "weight";
	                    }else if (["big_decimal"].indexOf(dataType) > -1){
	                        return "currency";
	                    }
	                }
	                return 'none';
	            }
	            
	            var _isSimpleValue = function(value){
	                
	                if( 
	                    angular.isString(value) || angular.isNumber(value) 
	                    || angular.isDate(value) || value === false || value === true
	                ){
	                    return true;
	                }else{
	                    return false;
	                }
	            }
	            
	            var utilityService = {
	                formatValue:function(value,formatType,formatDetails,entityInstance){
	                    if(angular.isUndefined(formatDetails)){
	                        formatDetails = {};
	                    }
	                    var typeList = ["currency","date","datetime","pixels","percentage","second","time","truefalse","url","weight","yesno"];
	                    
	                    if(typeList.indexOf(formatType)){
	                        utilityService['format_'+formatType](value,formatDetails,entityInstance);
	                    }
	                    return value;
	                },
	                format_currency:function(value,formatDetails,entityInstance){
	                    if(angular.isUndefined){
	                        formatDetails = {};
	                    }
	                },
	                format_date:function(value,formatDetails,entityInstance){
	                    if(angular.isUndefined){
	                        formatDetails = {};
	                    }
	                },
	                format_datetime:function(value,formatDetails,entityInstance){
	                    if(angular.isUndefined){
	                        formatDetails = {};
	                    }
	                },
	                format_pixels:function(value,formatDetails,entityInstance){
	                    if(angular.isUndefined){
	                        formatDetails = {};
	                    }
	                },
	                format_yesno:function(value,formatDetails,entityInstance){
	                    if(angular.isUndefined){
	                        formatDetails = {};
	                    }
	                    if(Boolean(value) === true ){
	                        return entityInstance.metaData.$$getRBKey("define.yes");
	                    }else if(value === false || value.trim() === 'No' || value.trim === 'NO' || value.trim() === '0'){
	                        return entityInstance.metaData.$$getRBKey("define.no");
	                    }
	                }
	            }
	            
	            var _getFormattedValue = function(propertyName,formatType,entityInstance){
	                var value = entityInstance.$$getPropertyByName(propertyName);
	                
	                if(angular.isUndefined(formatType)){
	                    formatType = entityInstance.metaData.$$getPropertyFormatType(propertyName);
	                }
	                
	                if(formatType === "custom"){
	                    return entityInstance['$$get'+propertyName+Formatted]();
	                }else if(formatType === "rbkey"){
	                    if(angular.isDefined(value)){
	                        return entityInstance.$$getRBKey('entity.'+entityInstance.metaData.className.toLowerCase()+'.'+propertyName.toLowerCase()+'.'+value);
	                    }else{
	                        return '';
	                    }
	                }
	                if(angular.isUndefined(value)){
	                    var propertyMeta = entityInstance.metaData[propertyName];
	                    if(angular.isDefined(propertyMeta['hb_nullRBKey'])){
	                        return entityInstance.$$getRbKey(propertyMeta['hb_nullRBKey']);
	                    }
	                    
	                    return "";
	                }else if (_isSimpleValue(value)){
	                    var formatDetails = {};
	                    if(angular.isDefined(entityInstance.data['currencyCode'])){
	                        formatDetails.currencyCode = entityInstance.$$getCurrencyCode();
	                    }
	                    
	                    
	                    return utilityService.formatValue(value,formatType,formatDetails,entityInstance);
	                }
	            }
	            
	            var _delete = function(entityInstance){
	                var entityName = entityInstance.metaData.className;
	                var entityID = entityInstance.$$getID();
	                var context = 'delete';
	                var deletePromise = $delegate.saveEntity(entityName,entityID,{},context);
	                return deletePromise;
	            }
	            
	            var _setValueByPropertyPath = function (obj,path, value) {
	                var a = path.split('.');
	                var context = obj;
	                var selector;
	                var myregexp = /([a-zA-Z]+)(\[(\d)\])+/; // matches:  item[0]
	                var match = null;
	
	                for (var i = 0; i < a.length - 1; i += 1) {
	                    match = myregexp.exec(a[i]);
	                    if (match !== null) context = context[match[1]][match[3]];
	                    else context = context[a[i]];
	
	                }
	
	                // check for ending item[xx] syntax
	                match = myregexp.exec([a[a.length - 1]]);
	
	                if (match !== null) context[match[1]][match[3]] = value;
	                else context[a[a.length - 1]] = value;
	
	                
	            }
	            
	            var _getValueByPropertyPath = function(obj,path) {
	                  var paths = path.split('.')
	                    , current = obj
	                    , i;
	
	                  for (i = 0; i < paths.length; ++i) {
	                    if (current[paths[i]] == undefined) {
	                      return undefined;
	                    } else {
	                      current = current[paths[i]];
	                    }
	                  }
	                  return current;
	            }
	            
	            var _addReturnedIDs = function(returnedIDs,entityInstance){
	                
	                for(var key in returnedIDs){
	                    if(angular.isArray(returnedIDs[key])){
	                        var arrayItems = returnedIDs[key];
	                        var entityInstanceArray = entityInstance.data[key];
	                        for(var i in arrayItems){
	                            var arrayItem = arrayItems[i];
	                            var entityInstanceArrayItem = entityInstance.data[key][i];
	                            _addReturnedIDs(arrayItem,entityInstanceArrayItem)
	                        }
	                    }else if(angular.isObject(returnedIDs[key])){
	                        for(var k in returnedIDs[key]){
	                            addReturnedIDs(returnedIDs[key][k],entityInstance.data[key][k]);
	                        }
	                    }else{
	                        entityInstance.data[key] = returnedIDs[key];
	                    }
	                }
	            }


				var _save = function(entityInstance){
                    var deferred = $q.defer();
                    $timeout(function(){
                        //$log.debug('save begin');
                        //$log.debug(entityInstance);

                        var entityID = entityInstance.$$getID();

                        var modifiedData = _getModifiedData(entityInstance);
                        //$log.debug('modifiedData complete');
                        //$log.debug(modifiedData);
                        //timeoutPromise.valid = modifiedData.valid;
                        if(modifiedData.valid){
                            var params = {};
                            params.serializedJsonData = angular.toJson(modifiedData.value);
                            //if we have a process object then the context is different from the standard save
                            var entityName = '';
                            var context = 'save';
                        	if(entityInstance.metaData.isProcessObject === 1){
                            	var processStruct = modifiedData.objectLevel.metaData.className.split('_');
                            	entityName = processStruct[0];
								context = processStruct[1];
                        	}else{
                            	entityName = modifiedData.objectLevel.metaData.className;
                            }
							var savePromise = $delegate.saveEntity(entityName,entityInstance.$$getID(),params,context);
                        	savePromise.then(function(response){
                            	var returnedIDs = response.data;
                            	if(angular.isDefined(response.SUCCESS) && response.SUCCESS === true){
                                	_addReturnedIDs(returnedIDs,modifiedData.objectLevel);
                                	deferred.resolve(returnedIDs);
                            	}else{
                                	deferred.reject(angular.isDefined(response.messages) ? response.messages : response);
                            	}
                        	}, function(reason){
                            	deferred.reject(reason);
                        	});
                    	}else{

                        	//select first, visible, and enabled input with a class of ng-invalid

                        	var target = $('input.ng-invalid:first:visible:enabled');
                        	//$log.debug('input is invalid');
                        	//$log.debug(target);
                        	target.focus();
                        	var targetID = target.attr('id');
                        	$anchorScroll();
                        	deferred.reject('input is invalid');
                    	}
                	});
                	//return timeoutPromise;
                	return deferred.promise;
	                /*
	                
	                
	                
	                
	                */
	            }
	            
	            var _getModifiedData = function(entityInstance){
	                var modifiedData = {};
	                modifiedData = getModifiedDataByInstance(entityInstance);
	                return modifiedData;
	            }
	            
	            var getObjectSaveLevel = function(entityInstance){
	                var objectLevel = entityInstance;
	                
	                var entityID = entityInstance.$$getID();    
	                
	                angular.forEach(entityInstance.parents,function(parentObject){
	                    if(angular.isDefined(entityInstance.data[parentObject.name]) && entityInstance.data[parentObject.name].$$getID() === '' && (angular.isUndefined(entityID) || !entityID.trim().length)){
	                        
	                        
	                        var parentEntityInstance = entityInstance.data[parentObject.name]; 
	                        var parentEntityID = parentEntityInstance.$$getID();
	                        if(parentEntityID === '' && parentEntityInstance.forms){
	                            objectLevel = getObjectSaveLevel(parentEntityInstance);
	                        }
	                    }
	                });
	                
	                return objectLevel;
	            }
	
	            var validateObject = function(entityInstance){
	                
	                var modifiedData = {};
	                var valid = true;
	                
	                var forms = entityInstance.forms;
	                //$log.debug('process base level data');
	                for(var f in forms){
	                    
	                    var form = forms[f];
	                    form.$setSubmitted();   //Sets the form to submitted for the validation errors to pop up.
	                    if(form.$dirty && form.$valid){
	                        for(var key in form){
	                            //$log.debug('key:'+key);
	                            if(key.charAt(0) !== '$'){
	                                var inputField = form[key];
	                                if(angular.isDefined(inputField.$valid) && inputField.$valid === true && inputField.$dirty === true){
	                                    
	                                    
	                                    if(angular.isDefined(entityInstance.metaData[key]) 
	                                    && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) 
	                                    && entityInstance.metaData[key].hb_formfieldtype === 'json'){
	                                        modifiedData[key] = angular.toJson(form[key].$modelValue);      
	                                    }else{
	                                        modifiedData[key] = form[key].$modelValue;
	                                    }
	                                }
	                            }
	                        }
	                    }else{
	                        if(!form.$valid){
	                            valid = false;
	                        }
	                        
	                    }
	                }
	                modifiedData[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                //$log.debug(modifiedData); 
	
	
	                
	                //$log.debug('process parent data');
	                if(angular.isDefined(entityInstance.parents)){
	                    for(var p in entityInstance.parents){
	                        var parentObject = entityInstance.parents[p];
	                        var parentInstance = entityInstance.data[parentObject.name];
	                        if(angular.isUndefined(modifiedData[parentObject.name])){
	                            modifiedData[parentObject.name] = {};
	                        }
	                        var forms = parentInstance.forms;
	                        for(var f in forms){
	                            var form = forms[f];
	                            form.$setSubmitted();
	                            if(form.$dirty && form.$valid){
	                            for(var key in form){
	                                if(key.charAt(0) !== '$'){
	                                    var inputField = form[key];
	                                    if(angular.isDefined(inputField) && angular.isDefined(inputField.$valid) && inputField.$valid === true && inputField.$dirty === true){
	                                        
	                                        if(angular.isDefined(parentInstance.metaData[key]) 
	                                        && angular.isDefined(parentInstance.metaData[key].hb_formfieldtype) 
	                                        && parentInstance.metaData[key].hb_formfieldtype === 'json'){
	                                            modifiedData[parentObject.name][key] = angular.toJson(form[key].$modelValue);       
	                                        }else{
	                                            modifiedData[parentObject.name][key] = form[key].$modelValue;
	                                        }
	                                    }
	                                }
	                            }
	                            }else{
	                                if(!form.$valid){
	                                    valid = false;
	                                }
	                                
	                            }
	                        }
	                        modifiedData[parentObject.name][parentInstance.$$getIDName()] = parentInstance.$$getID();
	                    }
	                }
	                //$log.debug(modifiedData);
	
	                
	                //$log.debug('begin child data');
	                var childrenData = validateChildren(entityInstance);
	                //$log.debug('child Data');
	                //$log.debug(childrenData);
	                angular.extend(modifiedData,childrenData);
	                return {
	                    valid:valid,
	                    value:modifiedData
	                };
	                
	            }
	
	            
	            var validateChildren = function(entityInstance){
	                var data = {}
	                
	                if(angular.isDefined(entityInstance.children) && entityInstance.children.length){
	                    
	                    data = getDataFromChildren(entityInstance);
	                }
	                return data;
	            }
	            
	            var processChild = function(entityInstance,entityInstanceParent){
	     
	                var data = {};
	                var forms = entityInstance.forms;
	                
	                for(var f in forms){
	                    
	                    var form = forms[f];
	                    
	                    angular.extend(data,processForm(form,entityInstance));
	                }
	                
	                if(angular.isDefined(entityInstance.children) && entityInstance.children.length){
	                    
	                    var childData = getDataFromChildren(entityInstance);
	                    angular.extend(data,childData);
	                }
	                if(angular.isDefined(entityInstance.parents) && entityInstance.parents.length){
	                    
	                    var parentData = getDataFromParents(entityInstance,entityInstanceParent);
	                    angular.extend(data,parentData);
	                }
	                
	                return data;
	            }
	
	            var processParent = function(entityInstance){
	                var data = {};
	                if(entityInstance.$$getID() !== ''){
	                    data[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                }
	                
	                //$log.debug('processParent');
	                //$log.debug(entityInstance);
	                var forms = entityInstance.forms;
	                    
	                for(var f in forms){
	                    var form = forms[f];
	                    
	                    data = angular.extend(data,processForm(form,entityInstance));
	                }
	                
	                return data;
	            }
	
	            var processForm = function(form,entityInstance){
	                //$log.debug('begin process form');
	                var data = {};
	                form.$setSubmitted();   
	                for(var key in form){
	                    if(key.charAt(0) !== '$'){
	                        var inputField = form[key];
	                        if(angular.isDefined(inputField) && angular.isDefined(inputField) && inputField.$valid === true && inputField.$dirty === true){ 
	                            
	                            if(angular.isDefined(entityInstance.metaData[key]) && angular.isDefined(entityInstance.metaData[key].hb_formfieldtype) && entityInstance.metaData[key].hb_formfieldtype === 'json'){
	                                data[key] = angular.toJson(form[key].$modelValue);      
	                            }else{
	                                data[key] = form[key].$modelValue;      
	                            }
	                                        
	                        }
	                    }
	                }
	                data[entityInstance.$$getIDName()] = entityInstance.$$getID();
	                //$log.debug('process form data');
	                //$log.debug(data);
	                return data;
	            }
	
	            var getDataFromParents = function(entityInstance,entityInstanceParent){
	                var data = {};
	                
	                for(var c in entityInstance.parents){
	                    var parentMetaData = entityInstance.parents[c];
	                    if(angular.isDefined(parentMetaData)){
	                        var parent = entityInstance.data[parentMetaData.name];
	                        if(angular.isObject(parent) && entityInstanceParent !== parent && parent.$$getID() !== '') {
	                            if(angular.isUndefined(data[parentMetaData.name])){
	                                data[parentMetaData.name] = {};
	                            }
	                            var parentData = processParent(parent);
	                            //$log.debug('parentData:'+parentMetaData.name);
	                            //$log.debug(parentData);
	                            angular.extend(data[parentMetaData.name],parentData);
	                        }else{
	                            
	                        }
	                    }
	                    
	                };
	                
	                return data;
	            }
	
	            var getDataFromChildren = function(entityInstance){
							var data = {};
							
							//$log.debug('childrenFound');
							//$log.debug(entityInstance.children);
				    		for(var c in entityInstance.children){
				    			var childMetaData = entityInstance.children[c];
								var children = entityInstance.data[childMetaData.name];
								//$log.debug(childMetaData);
								//$log.debug(children);
								if(angular.isArray(entityInstance.data[childMetaData.name])){
									if(angular.isUndefined(data[childMetaData.name])){
										data[childMetaData.name] = [];
									}
									angular.forEach(entityInstance.data[childMetaData.name],function(child,key){
										//$log.debug('process child array item')
										var childData = processChild(child,entityInstance);
										//$log.debug('process child return');
										//$log.debug(childData);
										data[childMetaData.name].push(childData);
									});
								}else{
									if(angular.isUndefined(data[childMetaData.name])){
										data[childMetaData.name] = {};
									}
									var child = entityInstance.data[childMetaData.name];
									//$log.debug('begin process child');
									var childData = processChild(child,entityInstance);
									//$log.debug('process child return');
									//$log.debug(childData);
									angular.extend(data,childData);
								}
								 
							}
							//$log.debug('returning child data');
							//$log.debug(data);

							return data;
				    	}
				    	
				    	var getModifiedDataByInstance = function(entityInstance){
				    		var modifiedData = {};
				    		
				    		
				    		
				    		
				    		
				    		var objectSaveLevel = getObjectSaveLevel(entityInstance);
							//$log.debug('objectSaveLevel : ' + objectSaveLevel );
							var valueStruct = validateObject(objectSaveLevel);
							//$log.debug('validateObject data');
							//$log.debug(valueStruct.value);
							
							modifiedData = {
								objectLevel:objectSaveLevel,
								value:valueStruct.value,
								valid:valueStruct.valid
							}
				    		return modifiedData;
				    	}
				    	
				    	var _getValidationsByProperty = function(entityInstance,property){
				    		return entityInstance.validations.properties[property];
				    	}
	            
	            var _getValidationByPropertyAndContext = function(entityInstance,property,context){
	                var validations = _getValidationsByProperty(entityInstance,property);
	                for(var i in validations){
	                    
	                    var contexts = validations[i].contexts.split(',');
	                    for(var j in contexts){
	                        if(contexts[j] === context){
	                            return validations[i];
	                        }
	                    }
	                    
	                }
	            }
				
				return $delegate;
			}]);
		 }]);		
		