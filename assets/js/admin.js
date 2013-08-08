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
	
	/*
jQuery('body').on('click', '.update-inventory-plus', function(e) {
		
		var data = {
			slatAction: 'admin:ajax.updateInventoryTable',
			locationID: jQuery(this).data('locationid'),
			skuID: jQuery(this).data('skuid')
		};
		
		console.log(data);
		console.log(jQuery(this).attr('href'));
		
		jQuery.ajax({
			url: jQuery(this).attr('href'),
			method: 'post',
			data: data,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) },
			success: function( r ) {
				console.log("success");
				console.log(r);
				var newTR = '<tr>';
			},
			error: function( r ) {
				console.log("failure");
				console.log(r);
			}
		});
	});
*/
	
	 $( '.update-inventory-plus' ).click(function() {
		var data = {
			slatAction: 'admin:ajax.updateInventoryTable',
			locationID: jQuery(this).data('locationid'),
			skuID: jQuery(this).data('skuid')
		};
		
		var currentDepth = jQuery(this).data('depth');
		var newDepth = 0;
		if(String(currentDepth).length) {
			var newDepth = Number(currentDepth) + 1;
		}
		
		var jqxhr = $.ajax({
			"url": jQuery(this).attr('href'),
			"data": data,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) }
		}).done(function(r){
			console.log("success");
			var invDataArr = r.inventoryData;
			if (invDataArr) {
				for(var i=0;i<invDataArr.length;i++) {
					var invData = invDataArr[i];
					var newTR = ["<tr class='stock'>", 
						"<td><a href='' class='update-inventory-plus depth"+newDepth+"' data-depth='"+newDepth+"' data-locationid='"+invData.locationID+"' data-skuid='"+invData.skuID+"'><i class='icon-plus'></i></a> <strong>"+invData.locationName+"</strong></td>",
						"<td>"+invData.QOH+"</td>",
						"<td>"+invData.QOSH+"</td>",
						"<td>"+invData.QNDOO+"</td>",
						"<td>"+invData.QNDORVO+"</td>",
						"<td>"+invData.QNDOSA+"</td>",
						"<td>"+invData.QNRORO+"</td>",
						"<td>"+invData.QNROVO+"</td>",
						"<td>"+invData.QNROSA+"</td>",
						"<td>"+invData.QC+"</td>",
						"<td>"+invData.QE+"</td>",
						"<td>"+invData.QNC+"</td>",
						"<td>"+invData.QATS+"</td>",
						"<td>"+invData.QIATS+"</td>",
					"</tr>"].join('\n');
					$('#inventory-table tr:last').after(newTR);
				}
			}
			
		}).fail(function(r){
			console.log("failure");
		});
	});
	
	
	
	
	
	
	
});