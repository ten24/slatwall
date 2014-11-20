<!---

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

--->
<cfparam name="rc.entities" />

<cfcontent type="text/javascript">
<cfset local.jsOutput = "" />
<cfsavecontent variable="local.jsOutput">
	<cfoutput>
		angular.module('ngSlatwall',[])
		.provider('$slatwall',[
		function(){
			var _deferred = {};
			
			var _config = {
				dateFormat : 'MM/DD/YYYY',
				timeFormat : 'HH:MM',
				rbLocale : '#request.slatwallScope.getRBLocal()#',
				baseURL : '/',
				applicationKey : 'Slatwall',
				debugFlag : #request.slatwallScope.getApplicationValue('debugFlag')#
			};
			
			if(slatwallConfig){
				angular.extend(_config,slatwallConfig);
			}
			
			return {
				
			    $get:['$q','$http','$log', function ($q,$http,$log)
			    {
			    	var slatwallService = {
			    		//basic entity getter where id is optional, returns a promise
				  		getDefer:function(deferKey){
				  			return _deferred[deferKey];
				  		},
				  		cancelPromise:function(deferKey){
				  			var deferred = this.getDefer(deferKey);
				  			if(angular.isDefined(deferred)){
				  				deferred.resolve({messages:[{messageType:'error',message:'User Cancelled'}]});
				  			}
				  		},
				      	newEntity:function(entityName){
				      		return new _jsEntities[entityName];
				      	},
				      	
				      	//basic entity getter where id is optional, returns a promise
				  		getEntity:function(entityName, options){
				  			/*
				  			 *
				  			 * getEntity('Product', '12345-12345-12345-12345');
				  			 * getEntity('Product', {keywords='Hello'});
				  			 * 
				  			 */
				  			if(angular.isDefined(options.deferKey)){
			    	  			this.cancelPromise(options.deferKey);
			    	  		}
			    	  		
				  			var params = {};
				  			if(typeof options === 'String') {
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName+'&entityID='+options.id;
				  			} else {
				  				params['P:Current'] = options.currentPage || 1;
				  				params['P:Show'] = options.pageShow || 10;
				  				params.keywords = options.keywords || '';
				  				params.columnsConfig = options.columnsConfig || '';
				  				params.filterGroupsConfig = options.filterGroupsConfig || '';
				  				params.joinsConfig = options.joinsConfig || '';
				  				params.isDistinct = options.isDistinct || false;
				  				params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  				params.allRecords = options.allRecords || '';
				  				params.defaultColumns = options.defaultColumns || true;
				  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.get&entityName='+entityName;
				  			}
				  			
				  			var deferred = $q.defer();
				  			if(angular.isDefined(options.id)) {
				  				urlString += '&entityId='+options.id;	
				  			}
				  			
				  			$http.get(urlString,{params:params,timeout:deferred.promise})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			if(options.deferKey){
				  				_deferred[options.deferKey] = deferred;
				  			}
				  			return deferred.promise;
				  			
				  		},
				  		getEventOptions:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getEventOptionsByEntityName&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getValidation:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getValidation&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayData:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayData&entityName='+entityName;
				  			var params = {};
				  			params.propertyIdentifiersList = options.propertyIdentifiersList || '';
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		getPropertyDisplayOptions:function(entityName,options){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getPropertyDisplayOptions&entityName='+entityName;
				  			var params = {};
				  			params.property = options.property || '';
				  			if(angular.isDefined(options.argument1)){
				  				params.argument1 = options.argument1;
				  			}
				  			
				  			$http.get(urlString,{params:params})
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			
				  			return deferred.promise;
				  		},
				  		saveEntity:function(entityName,id,params,context){
				  			$log.debug('save'+ entityName);
				  			var deferred = $q.defer();
			
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.post';	
				  			
				  			if(angular.isDefined(entityName)){
				  				params.entityName = entityName;
				  			}
				  			if(angular.isDefined(id)){
				  				params.entityID = id;
				  			}
			
				  			if(angular.isDefined(context)){
				  				params.context = context;
				  			}
				  			
				  			
				  			$http({
				  				url:urlString,
				  				method:'POST',
				  				data: $.param(params),
				  				headers: {'Content-Type': 'application/x-www-form-urlencoded'}
				  			})
				  			.success(function(data){
				  				deferred.resolve(data);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getExistingCollectionsByBaseEntity:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getExistingCollectionsByBaseEntity&entityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  			
				  		},
				  		getFilterPropertiesByBaseEntityName:function(entityName){
				  			var deferred = $q.defer();
				  			var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getFilterPropertiesByBaseEntityName&EntityName='+entityName;
				  			
				  			$http.get(urlString)
				  			.success(function(data){
				  				deferred.resolve(data);
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		loadResourceBundle:function(locale){
				  			var deferred = $q.defer();
				  			$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
				  				deferred.resolve(response);
				  				
				  			}).error(function(reason){
				  				deferred.reject(reason);
				  			});
				  			return deferred.promise;
				  		},
				  		getResourceBundle:function(locale){
				  			var locale = locale || _config.rbLocale;
				  			
			  				if(_resourceBundle[locale]){
			  					return _resourceBundle[locale];
			  				}
			  				
			  				var urlString = _config.baseURL+'/index.cfm/?slatAction=api:main.getResourceBundle'
				  			var params = {
				  				locale:locale,
				  			};
			  				$http.get(urlString,{params:params}).success(function(response){
			  					_resourceBundle[locale] = response.data;
			  				});
			  					
				  		},
						
				  		<!---replaceStringTemplate:function(template,object,formatValues,removeMissingKeys){
				  			/*formatValues = formatValues || false;
				  			removeMissingKeys = removeMissingKeys || false;
				  			//var res = str.replace(/microsoft/i, "W3Schools");
				  			var templateKeys = template.replace(\${[^}]+},);
				  			var replacementArray = [];
				  			var returnString = template;
				  			
				  			for(var i=0; i > templateKeys.length;i++){
				  				
				  			}*/
				  		}--->
				  		rbKey:function(key,replaceStringData){
				  			var keyValue = this.getRBKey(key,_config.locale);
				  			<!---if(angular.isDefined(replaceStringData) && ('"${'.toLowerCase().indexOf(keyValue))){
				  				keyValue = slatwallService.replaceStringTemplate(keyValue,replaceStringData);
				  			}--->
				  			return keyValue;
				  		},
				  		getRBKey:function(key,locale,checkedKeys,originalKey){
				  			checkedKeys = checkedKeys || "";
				  			locale = locale || 'en_us';
				  			
				  			<!---// Check to see if a list was passed in as the key--->
				  			var keyListArray = key.split(',');
				  			
							if(keyListArray.length > 1) {
								
								<!---// Set up "" as the key value to be passed as 'checkedKeys'--->
								var keyValue = "";
								
								<!---// If there was a list then try to get the key for each item in order--->
								for(var i=0; i<keyListArray.length; i++) {
									
									<!---// Get the keyValue from this iteration--->
									var keyValue = this.getRBKey(keyListArray[i], locale, keyValue);
									
									<!---// If the keyValue was found, then we can break out of the loop--->
									if(keyValue.slice(-8) != "_missing") {
										break;
									}
								}
								
								return keyValue;
							}
							
							<!---// Check the exact bundle file--->
							var bundle = slatwallService.getResourceBundle(locale);
							if(angular.isDefined(bundle[key])) {
								return bundle[key];
							}
							
							<!---// Because the value was not found, we can add this to the checkedKeys, and setup the original Key--->
							var checkedKeysListArray = checkedKeys.split(',');
							checkedKeysListArray.push(key+'_'+locale+'_missing');
							checkedKeys = checkedKeysListArray.join(",");
							if(angular.isUndefined(originalKey)){
								originalKey = key;
							}
							<!---// Check the broader bundle file--->
							var localeListArray = locale.split('_');
							if(localeListArray.length === 2){
								bundle = slatwallService.getResourceBundle(localeListArray[0]);
								if(angular.isDefined(bundle[key])){
									return bundle[key];
								}
								<!---// Add this more broad term to the checked keys--->
								checkedKeysListArray.push(key+'_'+localeListArray[0]+'_missing');
								checkedKeys = checkedKeysListArray.join(",");
							}
							<!---// Recursivly step the key back with the word 'define' replacing the previous.  Basically Look for just the "xxx.yyy.define.zzz" version of the end key and then "yyy.define.zzz" and then "define.zzz"--->
							var keyDotListArray = key.split('.');
							if(	keyDotListArray.length >= 3
								&& keyDotListArray[keyDotListArray.length - 2] === 'define'
							){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length - 3]+'.define','define');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}else if( keyDotListArray.length >= 2 && keyDotListArray[keyDotListArray.length - 2] !== 'define'){
								var newKey = key.replace(keyDotListArray[keyDotListArray.length -2]+'.','define.');
								return this.getRBKey(newKey,locale,checkedKeys,originalKey);
							}
							if(localeListArray[0] !== "en"){
								
								return this.getRBKey(originalKey,'en',checkedKeys);
							}
				  			return checkedKeys;
				  		},
				  		 getConfig:function(){
					    	return _config;
					    },
					    getConfigValue:function(key){
					    	return _config[key];
					    },
					    setConfigValue:function(key,value){
					    	_config[key] = value;
					    },
					    setConfig:function(config){
					    	_config = config;
					    }
				      };
				  			 
			    	var _resourceBundle = {};
			    	var _jsEntities = {};
			    	
			    	var _init = function(entityInstance,data){
						for(var key in data) {
							if(key.charAt(0) !== '$'){
								entityInstance.data[key] = data[key];
							}
						}
					}
			    	
			    	var _getPropertyTitle = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
									
						if(angular.isDefined(propertyMetaData['hb_rbkey'])){
							return metaData.$$getRBKey(propertyMetaData['hb_rbkey']);
						}else if (angular.isUndefined(propertyMetaData['persistent']) || (angular.isDefined(propertyMetaData['persistent']) && propertyMetaData['persistent'] === true)){
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
			    	
			    	<!---var _getPropertyFieldName = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		if(angular.isDefined(propertyMetaData.fieldtype)
						&& angular.isDefined(propertyMetaData.cfc)
						&& ["many-to-one"].indexOf(propertyMetaData.fieldtype) > -1){
							
						}
			    	}--->
			    	
			    	var _getPropertyFieldType = function(propertyName,metaData){
			    		var propertyMetaData = metaData[propertyName];
			    		console.log(metaData);
			    		console.log(propertyName);
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
							}
							if(propertyName === 'password'){
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
			    		<!---string, number, Boolean, or date/time value; False --->
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
			    		formatValue:function(value,formatType,formatDetails){
			    			if(angular.isUndefined(formatDetails)){
			    				formatDetails = {};
			    			}
							var typeList = ["currency","date","datetime","pixels","percentage","second","time","truefalse","url","weight","yesno"];
							
							if(typeList.indexOf(formatType)){
								utilityService['format'+formatType](value,formatDetails);
							}
							return value;
			    		},
			    		format_currency:function(){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_date:function(){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_datetime:function(){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_pixels:function(){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
			    		},
			    		format_yesno:function(value,formatDetails){
			    			if(angular.isUndefined){
			    				formatDetails = {};
			    			}
							if(value === true){
								return entityInstance.$$getRBKey("define.yes");
							}else if(value === false){
								return entityInstance.$$getRBKey("define.no");
							}
			    		}
			    	}
			    	
			    	var _getFormattedValue = function(propertyName,formatType,entityInstance){
			    		var value = entityInstance['$$get'+propertyName]();
			    		
			    		if(angular.isUndefined(formatType)){
			    			formatType = entityInstance.getPropertyFormatType(propertyName);
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
			    			<!---return getService("hibachiUtilityService").formatValue(value=arguments.value, formatType=arguments.formatType, formatDetails=formatDetails); --->
			    			return '';
			    		}
			    	}
			    	
			    	var _save = function(entityInstance){
			    		console.log('save');
			    		console.log(entityInstance);
			    		var modifiedData = _getModifiedData(entityInstance);
			    		var entityName = entityInstance.metaData.className;
			    		var entityID = entityInstance.$$getID();
			    		var params = modifiedData;
			    		var context = 'save';
			    		<!---validate based on context --->
			    		<!---probably need to validat against data to make sure existing data passes and then against modified? --->
			    		
			    		var savePromise = slatwallService.saveEntity(entityName,entityID,params,context);
			    		savePromise.then(function(value){
							entityInstance.form.$setPristine();
							
						});
			    		console.log(modifiedData);
			    	}
			    	
			    	var _getValidationsByProperty = function(entityInstance,property){
			    		return entityInstance.validations.properties[property];
			    	}
			    	
			    	var _getValidationByPropertyAndContext = function(entityInstance,property,context){
			    		var validations = _getValidationsByProperty(entityInstance,property);
			    		for(var i in validations){
			    			<!---get list of contexts for this validation --->
			    			var contexts = validations[i].contexts.split(',');
			    			for(var j in contexts){
			    				if(contexts[j] === context){
				    				return validations[i];
				    			}
			    			}
			    			
			    		}
			    	}
			    	
			    	var _getParentObjectIDs = function(){
			    		if(angular.isDefined(form.$$swFormInfo.parentObject)){
			    			var parentObject = form.$$swFormInfo.parentObject;
			    			parentObject.modifiedData[parentObject.$$getIDName()] = parentObject.$$getID();
			    		}
			    	}
			    	
			    	var _getModifiedData = function(entityInstance){
			    		var form = entityInstance.form;
			    		
			    		entityInstance.modifiedData = {};
			    		
			    		//var parentObjectIDs = getParentObjectID
			    		console.log(form);
			    		for(key in form){
			    			if(key.charAt(0) !== '$'){
			    				var inputField = form[key];
			    				if(inputField.$valid === true && inputField.$dirty === true){
		    						entityInstance.modifiedData[key] = form[key].$modelValue;
			    				}
			    			}
			    		}
			    		return entityInstance.modifiedData;
			    	}
			
					<cfloop array="#rc.entities#" index="local.entity">
						<cftry>
							
							<!---
									/*
						  			 *
						  			 * getEntity('Product', '12345-12345-12345-12345');
						  			 * getEntity('Product', {keywords='Hello'});
						  			 * 
						  			 */
								 --->
							 <!---decorate slatwallService --->
							slatwallService.get#local.entity.getClassName()# = function(options){
								var entityInstance = slatwallService.newEntity('#local.entity.getClassName()#');
								var entityDataPromise = slatwallService.getEntity('#lcase(local.entity.getClassName())#',options);
								entityDataPromise.then(function(response){
									<!--- Set the values to the values in the data passed in, or API promisses, excluding methods because they are prefaced with $ --->
									entityInstance.$$init(response);
								});
								return entityInstance
							}
							
							slatwallService.new#local.entity.getClassName()# = function(){
								return slatwallService.newEntity('#local.entity.getClassName()#');
							}
							
							_jsEntities[ '#local.entity.getClassName()#' ]=function() {
								
								this.validations = #serializeJSON($.slatwall.getService('hibachiValidationService').getValidationStruct(local.entity))#;
								
								this.metaData = #serializeJSON(local.entity.getPropertiesStruct())#;
								this.metaData.className = '#local.entity.getClassName()#';
								
								this.metaData.$$getRBKey = function(rbKey,replaceStringData){
									return slatwallService.rbKey(rbKey,replaceStringData);
								};
								<!---// @hint public method for getting the title to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyTitle = function(propertyName){
									return _getPropertyTitle(propertyName,this);
								}
								<!---// @hint public method for getting the title hint to be used for a property from the rbFactory, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyHint = function(propertyName){
									return _getPropertyHint(propertyName,this);
								}
								<!---// @hint public method for returning the name of the field for this property, this is used a lot by the PropertyDisplay --->
								<!---this.metaData.$$getPropertyFieldName = function(propertyName){
									return _getPropertyFieldName(propertyName,this);
								}--->
								<!---// @hint public method for inspecting the property of a given object and determining the most appropriate field type for that property, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyFieldType = function(propertyName){
									return _getPropertyFieldType(propertyName,this);
								}
								<!---// @hint public method for getting the display format for a given property, this is used a lot by the HibachiPropertyDisplay --->
								this.metaData.$$getPropertyFormatType = function(propertyName){
									return _getPropertyFormatType(propertyName,this);
								}
								
								this.metaData.$$getDetailTabs = function(){
									<cfset local.tabsDirectory = expandPath( '/Slatwall/admin/client/js/directives/partials/entity/#local.entity.getClassName()#/' )>
									<cfdirectory
									    action="list"
									    directory="#local.tabsDirectory#"
									    listinfo="name"
									    name="local.tabsFileList"
									    filter="*.html"
								    />
								    var detailsTab = [
								    	<cfset tabCount = 0 />
								    	<cfloop query="local.tabsFileList">
								    		<cfset tabCount++ />
								    		
								    		<cfif tabCount neq local.tabsFileList.recordCount>
								    			'#name#',
								    		<cfelse>
								    			'#name#'
								    		</cfif>
								   		</cfloop>
								    ];
								    
									return detailsTab;
								}
								
								this.$$getFormattedValue = function(propertyName,formatType){
									return _getFormattedValue(propertyName,formatType,this);
								}
								
								this.data = {};
								this.modifiedData = {};
								
								<!--- Loop over properties --->
								<cfloop array="#local.entity.getProperties()#" index="local.property">
									<!--- Make sure that this property is a persistent one --->
									<cfif !structKeyExists(local.property, "persistent") && ( !structKeyExists(local.property,"fieldtype") || listFindNoCase("column,id", local.property.fieldtype) )>
										<!--- Find the default value for this property --->
										<cfset local.defaultValue = local.entity.invokeMethod('get#local.property.name#') />
							
										<cfif isNull(local.defaultValue)>
											this.data.#local.property.name# = null;
										<cfelseif structKeyExists(local.property, "ormType") and listFindNoCase('boolean,int,integer,float,big_int,string,big_decimal', local.property.ormType)>
											this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
										<cfelseif structKeyExists(local.property, "ormType") and local.property.ormType eq 'timestamp'>
											<cfif local.entity.invokeMethod('get#local.property.name#') eq ''>
												this.data.#local.property.name# = '';
											<cfelse>
												this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#').getTime()#';
											</cfif>
										<cfelse>
											this.data.#local.property.name# = '#local.entity.invokeMethod('get#local.property.name#')#';
										</cfif>
									<cfelse>
									</cfif>
									
								</cfloop>
								
							};
							_jsEntities[ '#local.entity.getClassName()#' ].prototype = {
								$$getID:function(){
									return this['$$get'+this.metaData.className+'ID']();
								},
								$$getIDName:function(){
									var IDNameString = this.metaData.className+'ID';
									IDNameString = IDNameString.charAt(0).toLowerCase() + entityName.slice(1);
									return IDNameString;
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
									_save(this);
								},
								$$getValidationsByProperty:function(property){
									return _getValidationsByProperty(this,property);
								},
								$$getValidationByPropertyAndContext:function(property,context){
									return _getValidationByPropertyAndContext(this,property,context);
								}
								<!--- used to retrieve info about the object properties --->
								,$$getMetaData:function( propertyName ) {
									if(propertyName === undefined) {
										return this.metaData
									}
									return this.metaData[ propertyName ];
								}
								
								<cfloop array="#local.entity.getProperties()#" index="local.property">
									<cfif !structKeyExists(local.property, "persistent")>
										<cfif structKeyExists(local.property, "fieldtype")>
											
											<cfif listFindNoCase('many-to-one', local.property.fieldtype)>
												<!---get many-to-one options --->
												<!---,$$get#local.property.name#Options:function(args) {
													var options = {
														property:'#local.property.name#',
														args:args || []
													};
													var collectionOptionsPromise = slatwallService.getPropertyDisplayOptions('#local.entity.getClassName()#',options);
													return collectionOptionsPromise;
												}--->
												<!---get many-to-one  via REST--->
												,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
													if(angular.isDefined(this.$$get#local.entity.getClassName()#ID())){
														var options = {
															columnsConfig:angular.toJson([
																{
																	"propertyIdentifier":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															joinsConfig:angular.toJson([
																{
																	"associationName":"#local.property.name#",
																	"alias":"_#lcase(local.entity.getClassName())#_#local.property.name#"
																}
															]),
															filterGroupsConfig:angular.toJson([{
																"filterGroup":[
																	{
																		"propertyIdentifier":"_#lcase(local.entity.getClassName())#.#lcase(local.entity.getClassName())#ID",
																		"comparisonOperator":"=",
																		"value":this.$$get#local.entity.getClassName()#ID()
																	}
																]
															}]),
															allRecords:true
														};
														
														var collection = (function(thisEntityInstance,options){
															var collection = {};
															var collectionPromise = slatwallService.getEntity('#local.entity.getClassName()#',options);
															collectionPromise.then(function(response){
																for(var i in response.records){
																	var entityInstance = slatwallService.newEntity(thisEntityInstance.metaData['#local.property.name#'].cfc);
																	entityInstance.$$init(response.records[i]);
																	collection=entityInstance;
																}
															});
															return collection;
														})(this,options);
														
														return collection;
													}
													
													return null;
												}
											<cfelseif listFindNoCase('one-to-many,many-to-many', local.property.fieldtype)>
												<!--- get one-to-many, many-to-many via REST --->
												,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
													if(angular.isDefined(this.$$get#local.entity.getClassName()#ID())){
														var options = {
															filterGroupsConfig:angular.toJson([{
																"filterGroup":[
																	{
																		"propertyIdentifier":"_#lcase(local.property.cfc)#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#.#ReReplace(local.entity.getClassName(),"\b(\w)","\l\1","ALL")#ID",
																		"comparisonOperator":"=",
																		"value":this.$$get#local.entity.getClassName()#ID()
																	}
																]
															}]),
															allRecords:true
														};
														
														var collection = (function(thisEntityInstance,options){
															var collection = [];
															var collectionPromise = slatwallService.getEntity('#local.property.cfc#',options);
															collectionPromise.then(function(response){
																for(var i in response.records){
																	var entityInstance = slatwallService.newEntity(thisEntityInstance.metaData['#local.property.name#'].cfc);
																	entityInstance.$$init(response.records[i]);
																	for(var key in entityInstance.data){
																		thisEntityInstance.data['#local.property.name#['+i+']'+'.'+key] = entityInstance.data[key];
																	}
																	collection.push(entityInstance);
																}
															});
															return collection;
														})(this,options);
														
														return collection;
													}
												}
											<cfelse>
												,$$get#ReReplace(local.property.name,"\b(\w)","\u\1","ALL")#:function() {
													return this.data.#local.property.name#;
												}
											</cfif>
										</cfif>
									</cfif>
								</cfloop>
							};
							
							
							<cfcatch>
								<cfcontent type="text/html">
								<cfdump var="#local.entity.getClassName()#" />
								<cfdump var="#cfcatch#" />
								<cfabort />
							</cfcatch>
						</cftry>
						
					</cfloop>
				
		      return slatwallService;
	       }],
		    setJsEntities: function(jsEntities){
		    	_jsEntities=jsEntities;
		    },
		    getJsEntities: function(){
		    	return _jsEntities;
		    },
		    getConfig:function(){
		    	return _config;
		    },
		    getConfigValue:function(key){
		    	return _config[key];
		    },
		    setConfigValue:function(key,value){
		    	_config[key] = value;
		    },
		    setConfig:function(config){
		    	_config = config;
		    }
		};
		}]).config(function ($slatwallProvider) {
			/* $slatwallProvider.setConfigValue($.slatwall.getConfig().baseURL); */
		}).run(function($slatwall){
			var localeListArray = $slatwall.getConfigValue('rbLocale').split('_');
			$slatwall.getResourceBundle($slatwall.getConfigValue('rbLocale'));
			if(localeListArray.length === 2){
				$slatwall.getResourceBundle(localeListArray[0]);
			}
			if(localeListArray[0] != 'en'){
				$slatwall.getResourceBundle('en_us');
				$slatwall.getResourceBundle('en');
			}	
		});
	</cfoutput>
</cfsavecontent>

<cfif request.slatwallScope.getApplicationValue('debugFlag')>
	<cfset getPageContext().getOut().clearBuffer() />
	<cfoutput>#local.jsOutput#</cfoutput>	
<cfelse>
	<!---
	<cfset local.oYUICompressor = createObject("component", "Slatwall.org.Hibachi.YUIcompressor.YUICompressor").init(javaLoader = 'Slatwall.org.Hibachi.YUIcompressor.javaloader.JavaLoader', libPath = expandPath('/Slatwall/org/Hibachi/YUIcompressor/lib')) />
	<cfset local.jsOutputCompressed = oYUICompressor.compress(
												inputType = 'js'
												,inputString = local.jsOutput
												) />
												
	<cfoutput>#local.jsOutputCompressed#</cfoutput>
	--->
	<cfset getPageContext().getOut().clearBuffer() />
	<cfoutput>#local.jsOutput#</cfoutput>
</cfif>
