(function($){
	gigya.services.socialize.addEventHandlers({
		onLogin:gigyaOnLogin
	   }
	);
})( jQuery )

function gigyaAdminUnregisteredUser( eventObj ) {
	jQuery('#' + eventObj.context.accountLoginFormID ).prepend( '<p class="alert alert-info">We were unable to locate an account that matches your social login, please login with your standard Slatwal username & password and your <strong>' + eventObj.provider + '</strong> profile will get attached to your account for future logins.</p>' );
}

function gigyaOnLogin( eventObj ) {
	
	if( eventObj.user.isSiteUID ) {
		
		var thisData = {
			'slatAction': 			'gigya:main.loginGigyaUser',
			'uid':					eventObj.UID,
			'uidSignature':			eventObj.UIDSignature,
			'signatureTimestamp':	eventObj.signatureTimestamp,
		};
		
		jQuery.ajax({
			url: $.slatwall.getConfig().baseURL + '/',
			method: 'post',
			data: thisData,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
			error: function( error ) {
				alert( 'An Unexpected Error Occured' );
			},
			success: function( result ) {
				
				if( 'context' in eventObj && 'accountLoginFormID' in eventObj.context ) {
					var redirectURL = jQuery('#' + eventObj.context.accountLoginFormID ).find('input[name="sRedirectURL"]').val();
					if(redirectURL != undefined) {
						window.location.href = redirectURL;
					} else {
						window.location.reload();
					}
				}
				
			}
		});
		
	} else {
		
		// Create the gigya inputs to add to the form
		var gigyaInputs = '<input type="hidden" name="gigyaUID" value="' + encodeURIComponent(eventObj.UID) + '" /><input type="hidden" name="gigyaUIDSignature" value="' + encodeURIComponent(eventObj.UIDSignature) + '" /><input type="hidden" name="gigyaSignatureTimestamp" value="' + encodeURIComponent(eventObj.signatureTimestamp) + '" />';
		
		// Add the gigya inputs to the login form if it exists
		if( 'context' in eventObj && 'accountLoginFormID' in eventObj.context ) {
			jQuery('#' + eventObj.context.accountLoginFormID).prepend( gigyaInputs );
		}
		
		// Add the gigya input to the create form if it exists
		if( 'context' in eventObj && 'accountCreateFormID' in eventObj.context ) {
			jQuery('#' + eventObj.context.accountCreateFormID).prepend( gigyaInputs );
		}
		
		if( 'context' in eventObj && 'unregisterdUserCallback' in eventObj.context ) {
			window[ eventObj.context.unregisterdUserCallback ]( eventObj );
		}
		
	}	
	
}