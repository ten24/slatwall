(function( $ ){
	
	/* Create the Hibachi Object */
	Hibachi = function( cfg ) {
		
		// Define the global config
		var config = {
			dateFormat : 'MM/DD/YYYY',
			timeFormat : 'HH:MM',
			baseURL : '/',
			applicationKey : 'Hibachi'
		}
		
		$.extend(config, cfg);
		
		// Define all of the methods for this class
		var methods = {
				
			setConfig : function( o, v ) {
				if(o != null && typeof o === 'object') {
					$.extend(config, options);
				} else if (o != null && v != null && typeof o === 'string') {
					config[o] = v;
				}
			},
			
			getConfig : function( ) {
				return config;
			},
			
			doAction: function( action, data, cbs, cbf ) {
				var doasync = arguments.length > 2;
				var s = cbs || function(r) {result=r};
				var f = cbf || s;
				var result = {};
				
				$.ajax({
					url: config.baseURL + '/index.cfm?slatAction=' + action + '&entityID=' + entityID,
					method: 'post',
					async: doasync,
					data: data,
					dataType: 'json',
					beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
					success: s,
					error: f
				});
				
				return result;
			},
			
			getEntity : function( entityName, entityID, cbs, cbf ) {
				
				var doasync = arguments.length > 2;
				var s = cbs || function(r) {result=r};
				var f = cbf || s;
				var result = {};
				
				$.ajax({
					url: config.baseURL + '/index.cfm?slatAction=admin:api.get&entityName=' + entityName + '&entityID=' + entityID,
					method: 'get',
					async: doasync,
					dataType: 'json',
					beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
					success: s,
					error: f
				});
				
				return result;
			},
			
			saveEntity : function( entityName, entityID, cbs, cbf ) {
				
			},
			
			deleteEntity : function( entityName, entityID, cbs, cbf ) {
				
			},
			
			processEntity : function( entityName, entityID, cbs, cbf ) {
				
			},
			
			getSmartList : function( entityName, data, cbs, cbf ) {
				
				var doasync = arguments.length > 2;
				var s = cbs || function(r) {result=r};
				var f = cbf || s;
				var result = {};
				
				$.ajax({
					url: config.baseURL + '/index.cfm?slatAction=admin:api.get&entityName=' + entityName,
					method: 'get',
					async: doasync,
					dataType: 'json',
					data: data,
					beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
					success: s,
					error: f
				});
				
				return result;
			}
			
		}
		
		// Define Public API Methods
		this.setConfig = methods.setConfig;
		this.getConfig = methods.getConfig;
		this.doAction = methods.doAction;
		this.getEntity = methods.getEntity;
		this.getSmartList = methods.getSmartList;
		this.onError = methods.onError;
	}
	
})( jQuery );
