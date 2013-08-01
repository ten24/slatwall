$(document).ready(function(e){
	$('body').on('change', '.slatwall-address-countryCode', function(e){
		
		var country = $.slatwall.getEntity('Country', jQuery(this).val() );
		
		// Loop over the keys in the country to show/hide fields and also to update the labels
		for (var key in country) {
			
			if (country.hasOwnProperty(key)) {
				
				if ( key.substring(key.length - 5, key.length) === "Label" ) {
					
					var classSelector = '.slatwall-address-' + key.substring(0, key.length - 5);
					jQuery( this ).closest('.slatwall-address-container').find( classSelector ).closest('.control-group').find('label').html(country[key]);
					
				} else if ( key.substring(key.length - 8, key.length) === "ShowFlag" ) {
					
					var classSelector = '.slatwall-address-' + key.substring(0, key.length - 8);
					var block = jQuery( this ).closest('.slatwall-address-container').find( classSelector ).closest('.control-group');
					if( country[key] && jQuery(block).hasClass('hide') ) {
						jQuery(block).removeClass('hide');
					} else if ( !country[key] && !jQuery(block).hasClass('hide') ) {
						jQuery(block).addClass('hide');
					}
					
				} else if ( key.substring(key.length - 12, key.length) === "RequiredFlag" ) {
					
					var classSelector = '.slatwall-address-' + key.substring(0, key.length - 12);
					var input = jQuery( this ).closest('.slatwall-address-container').find( classSelector );
					if( !country[key] && jQuery(block).hasClass('required') ) {
						jQuery(block).removeClass('required');
					} else if ( country[key] && !jQuery(block).hasClass('required') ) {
						jQuery(block).addClass('required');
					}
					
				}
				
			}
			
		}
		
		// Check to see if there is a state field showing.
		var stateField = jQuery( this ).closest('.slatwall-address-container').find( '.slatwall-address-stateCode' );
		
		if(stateField !== undefined) {
			
			var stateSmartList = $.slatwall.getSmartList('State', {
				'f:countryCode':jQuery(this).val(),
				'p:show':'all',
				'propertyIdentifiers':'stateCode,stateName'
			});
			
			if(stateSmartList.recordsCount > 0) {
				if( jQuery(stateField)[0].tagName === "INPUT" ) {
					var newSelectInput = '<select name="' + jQuery(stateField).attr('name') + '" class="' + jQuery(stateField).attr('class') + '" /></select>';
					jQuery( stateField ).replaceWith( newSelectInput );
					var stateField = jQuery( this ).closest('.slatwall-address-container').find( '.slatwall-address-stateCode' );
				}
				jQuery(stateField).html('');
				jQuery.each(stateSmartList.pageRecords, function(i, v){
					jQuery( stateField ).append('<option value="' + v['stateCode'] + '">' + v['stateName'] + '</option>');
				});
			} else {
				// If the tag is currently a select, then we need to replace it with a text box
				if( jQuery(stateField)[0].tagName === "SELECT" ) {
					var newTextInput = '<input type="text" name="' + jQuery(stateField).attr('name') + '" value="" class="' + jQuery(stateField).attr('class') + '" />';
					jQuery( stateField ).replaceWith(newTextInput);
				}
			}
			
		}
	});
	
		$(function () {
	        $("[data-toggle='tooltip']").tooltip();
	    });
});