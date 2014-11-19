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
					var newSelectInput = '<span class="s-custom-select-wrapper"><select name="' + jQuery(stateField).attr('name') + '" class="s-custom-select' + jQuery(stateField).attr('class') + '" /></select></span>';
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
	
	// Used on sku inventory page to collapse sub location hierarchy
	 $( 'body' ).delegate('.update-inventory-minus','click',function() {
	 	$(this).unbind('click');  
		var currentTableRow = $(this).parent().parent();
		var parentLocationID = $(this).data('locationid');
		if($('tr[data-parentlocationid="'+parentLocationID+'"]').length) {
		 	$(this).children(".icon-minus").removeClass("icon-minus").addClass("icon-plus");
			$('tr[data-parentlocationid="'+parentLocationID+'"]').remove();
		 	$(this).removeClass("update-inventory-minus").addClass("update-inventory-plus");
		}
	 });
		
	// Used on sku inventory page to expand sub location hierarchy
	 $( 'body' ).delegate('.update-inventory-plus','click',function() {
	 	$(this).unbind('click');  
	 	$(this).removeClass("update-inventory-plus").addClass("update-inventory-minus");
	 	$(this).children(".icon-plus").removeClass("icon-plus").addClass("icon-minus");
		var parentLocationID = $(this).data('locationid');	
		var currentTableRow = $(this).parent().parent();
		
		var data = {
			slatAction: 'admin:ajax.updateInventoryTable',
			locationID: $(this).data('locationid'),
			skuID: $(this).data('skuid')
		};
		
		var currentDepth = $(this).data('depth');
		var newDepth = 0;
		if(String(currentDepth).length) {
			var newDepth = Number(currentDepth) + 1;
		}
		
		var jqxhr = $.ajax({
			url: $(this).attr('href'),
			data: data,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Hibachi-AJAX', true) }
		}).done(function(r){
			var invDataArr = r.inventoryData;
			if (invDataArr.length) {
				for(var i=0;i<invDataArr.length;i++) {
					var invData = invDataArr[i];
					var newTR = ["<tr class='stock' data-parentlocationid='"+parentLocationID+"'>", 
						"<td><a href='#' class='update-inventory-plus depth"+newDepth+"' data-depth='"+newDepth+"' data-locationid='"+invData.locationID+"' data-skuid='"+invData.skuID+"'><i class='icon-plus'></i></a> <strong>"+invData.locationName+"</strong></td>",
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
					$(currentTableRow).after(newTR);
				}
			}
			
		}).fail(function(r){
			alert("An Unexpected error occurred.");
		});
		
	});
	
	
	
});