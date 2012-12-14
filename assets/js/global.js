/**
 * @depends /jquery-1.7.1.min.js
 * @depends /jquery-ui-1.8.20.custom.min.js
 * @depends /jquery-ui-timepicker-addon-0.9.9.js
 * @depends /jquery-validate-1.9.0.min.js
 * @depends /jquery-typewatch-2.0.js
 * @depends /jquery-hashchange-1.3.min.js
 * @depends /bootstrap.min.js
 * 
 */

var listingUpdateCache = {
	onHold: false,
	tableID: "",
	data: {},
	afterRowID: ""
};
var textAutocompleteCache = {
	onHold: false,
	autocompleteField: undefined,
	data: {},
};
var globalSearchCache = {
	onHold: false
};

jQuery(document).ready(function() {
	
	setupEventHandlers();
	
	initUIElements( 'body' );

	// Looks for a tab to show
	$(window).hashchange();
	
	// Focus on the first tab index
	if(jQuery('.firstfocus').length) {
		jQuery('.firstfocus').focus();	
	}
	
	if(jQuery('#global-search').val() !== '') {
		jQuery('#global-search').keyup(); 
	}
	
});

function initUIElements( scopeSelector ) {
	
	// Datetime Picker
	jQuery( scopeSelector ).find(jQuery('.datetimepicker')).datetimepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat ),
		timeFormat: convertCFMLTimeFormat( slatwall.timeFormat ),
		ampm: true,
		onSelect: function(dateText, inst) {
			
			// Listing Display Updates
			if(jQuery(inst.input).hasClass('range-filter-lower')) {
				var data = {};
				data[ jQuery(inst.input).attr('name') ] = jQuery(inst.input).val() + '^' + jQuery(inst.input).closest('ul').find('.range-filter-upper').val();
				listingDisplayUpdate( jQuery(inst.input).closest('.table').attr('id'), data);
			} else if (jQuery(inst.input).hasClass('range-filter-upper')) {
				var data = {};
				data[ jQuery(inst.input).attr('name') ] = jQuery(inst.input).closest('ul').find('.range-filter-lower').val() + '^' + jQuery(inst.input).val();
				listingDisplayUpdate( jQuery(inst.input).closest('.table').attr('id'), data);
			}
			
		}
	});
	// Setup datetimepicker to stop propigation so that id doesn't close dropdowns
	jQuery( scopeSelector ).find(jQuery('#ui-datepicker-div')).click(function(e){
		e.stopPropagation();
	});
	
	// Date Picker
	jQuery( scopeSelector ).find(jQuery('.datepicker')).datepicker({
		dateFormat: convertCFMLDateFormat( slatwall.dateFormat )
	});
	
	// Time Picker
	jQuery( scopeSelector ).find(jQuery('.timepicker')).timepicker({});
	
	// Dragable
	jQuery( scopeSelector ).find(jQuery('.draggable')).draggable();
	
	// Wysiwyg
	jQuery.each(jQuery( '.wysiwyg' ), function(i, v){
		var editor = CKEDITOR.replace( v );
		CKFinder.setupCKEditor( editor, 'org/ckfinder/' ) ;
	});
	
	// Tooltips
	jQuery( scopeSelector ).find(jQuery('.hint')).tooltip();
	
	// Empty Values
	jQuery.each(jQuery( scopeSelector ).find(jQuery('input[data-emptyvalue]')), function(index, value){
		jQuery(this).blur();
	});
	
	// Form Empty value clear (IMPORTANT!!! KEEP THIS ABOVE THE VALIDATION ASIGNMENT)
	jQuery.each(jQuery( scopeSelector ).find(jQuery('form')), function(index, value) {
		jQuery(value).on('submit', function(e){
			jQuery.each(jQuery( this ).find(jQuery('input[data-emptyvalue]')), function(i, v){
				if(jQuery(v).val() == jQuery(v).data('emptyvalue')) {
					jQuery(v).val('');
				}
			});
		});
	});
	
	// Validation
	jQuery.each(jQuery( scopeSelector ).find(jQuery('form')), function(index, value){
		jQuery(value).validate({
			invalidHandler: function() {

			}
		});
	});
	
	// Table Sortable
	jQuery( scopeSelector ).find(jQuery('.table-sortable .sortable')).sortable({
		update: function(event, ui) {
			tableApplySort(event, ui);
		}
	});

	// Text Autocomplete
	jQuery.each(jQuery( scopeSelector ).find(jQuery('.textautocomplete')), function(ti, tv){
		updateTextAutocompleteUI( jQuery(tv) );
	});
	
	// Table Multiselect
	jQuery.each(jQuery( scopeSelector ).find(jQuery('.table-multiselect')), function(ti, tv){
		updateMultiselectTableUI( jQuery(tv).data('multiselectfield') );
	});
	
	// Table Select
	jQuery.each(jQuery( scopeSelector ).find(jQuery('.table-select')), function(ti, tv){
		updateSelectTableUI( jQuery(tv).data('selectfield') );
	});
	
	// Table Filters
	jQuery.each(jQuery( scopeSelector ).find(jQuery('.listing-filter')), function(i, v){
		if(jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val() !== undefined && typeof jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val() === "string" && jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val().length > 0 ) {
			var hvArr = jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val().split(',');
			if(hvArr.indexOf(jQuery(v).data('filtervalue')) !== -1) {
				jQuery(v).children('.slatwall-ui-checkbox').addClass('slatwall-ui-checkbox-checked').removeClass('slatwall-ui-checkbox');
			}
		}
	});
	
}

function setupEventHandlers() {
	
	// Global Search
	jQuery('body').on('keyup', '#global-search', function(e){
		if(jQuery(this).val().length >= 2) {
			updateGlobalSearchResults(); 
			
			if(jQuery("body").scrollTop() > 0) {
				jQuery("body").animate({scrollTop:0}, 300, function(){
					jQuery('#search-results').animate({'margin-top': '0px'}, 150);
				});
			} else {
				jQuery('#search-results').animate({'margin-top': '0px'}, 150);
			}
		} else {
			jQuery('#search-results').animate({
				'margin-top': '-500px'
			}, 150);
			jQuery('#search-results .result-bucket .nav').html('');
		}
	});
	jQuery('body').on('click', '.search-close', function(e){
		jQuery('#global-search').val('');
		jQuery('#global-search').keyup();
	});
	
	// Bind Hash Change Event
	jQuery(window).hashchange( function(e){
		jQuery('a[href=' + location.hash + ']').tab('show');
	});
	
	// Hints
	jQuery('body').on('click', '.hint', function(e){
		e.preventDefault();
	});
	
	// Tab Selecting
	jQuery('body').on('shown', 'a[data-toggle="tab"]', function(e){
		window.location.hash = jQuery(this).attr('href');
	});
	
	// Empty Value
	jQuery('body').on('focus', 'input[data-emptyvalue]', function(e){
		jQuery(this).removeClass('emptyvalue');
		if(jQuery(this).val() == jQuery(this).data('emptyvalue')) {
			jQuery(this).val('');
		}
	});
	jQuery('body').on('blur', 'input[data-emptyvalue]', function(e){
		if(jQuery(this).val() == '') {
			jQuery(this).val(jQuery(this).data('emptyvalue'));
			jQuery(this).addClass('emptyvalue');
		}
	});
	
	// Alerts
	jQuery('body').on('click', '.alert-confirm', function(e){
		e.preventDefault();
		jQuery('#adminConfirm > .modal-body').html( jQuery(this).data('confirm') );
		jQuery('#adminConfirm .btn-primary').attr( 'href', jQuery(this).attr('href') );
		jQuery('#adminConfirm').modal();
	});
	jQuery('body').on('click', '.alert-disabled', function(e){
		e.preventDefault();
		jQuery('#adminDisabled > .modal-body').html( jQuery(this).data('disabled') );
		jQuery('#adminDisabled').modal();
	});
	
	// Disabled Secure Display Buttons
	jQuery('body').on('click', '.disabled', function(e){
		e.preventDefault();
	});
	
	
	// Modal Loading
	jQuery('body').on('click', '.modalload', function(e){
		
		jQuery('#adminModal').html('');
		var modalLink = jQuery(this).attr( 'href' );
		
		if( modalLink.indexOf("?") !== -1) {
			modalLink = modalLink + '&modal=1';
		} else {
			modalLink = modalLink + '?modal=1';
		}
		
		if( jQuery(this).hasClass('modal-fieldupdate-textautocomplete') ) {
			modalLink = modalLink + '&ajaxsubmit=1';
		}
		
		jQuery('#adminModal').load( modalLink, function(){
			
			initUIElements('#adminModal');
			
			jQuery('#adminModal').css({
				'width': 'auto',
				'margin-left': function () {
		            return -(jQuery('#adminModal').width() / 2);
		        }
			});
		});
	});
	
	// Listing Page - Searching
	jQuery('body').on('submit', '.action-bar-search', function(e){
		e.preventDefault();
	});
	jQuery('body').on('keyup', '.action-bar-search input', function(e){
		var data = {};
		data[ 'keywords' ] = jQuery(this).val();
		
		listingDisplayUpdate( jQuery(this).data('tableid'), data );
	});
	
	// Listing Display - Paging
	jQuery('body').on('click', '.listing-pager', function(e) {
		e.preventDefault();
		
		var data = {};
		data[ 'P:Current' ] = jQuery(this).data('page');
		
		listingDisplayUpdate( jQuery(this).closest('.pagination').data('tableid'), data );
		
	});
	// Listing Display - Paging Show Toggle
	jQuery('body').on('click', '.paging-show-toggle', function(e) {
		e.preventDefault();
		jQuery(this).closest('ul').find('.show-option').toggle();
		jQuery(this).closest('ul').find('.page-option').toggle();
	});
	// Listing Display - Paging Show Select
	jQuery('body').on('click', '.show-option', function(e) {
		e.preventDefault();
		
		var data = {};
		data[ 'P:Show' ] = jQuery(this).data('show');
		
		listingDisplayUpdate( jQuery(this).closest('.pagination').data('tableid'), data );
	});
	
	// Listing Display - Sorting
	jQuery('body').on('click', '.listing-sort', function(e) {
		e.preventDefault();
		var data = {};
		data[ 'OrderBy' ] = jQuery(this).closest('th').data('propertyidentifier') + '|' + jQuery(this).data('sortdirection');
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Filtering
	jQuery('body').on('click', '.listing-filter', function(e) {
		e.preventDefault();
		e.stopPropagation();
		
		var value = jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val();
		var valueArray = [];
		if(value !== '') {
			valueArray = value.split(',');
		}
		var i = jQuery.inArray(jQuery(this).data('filtervalue'), valueArray);
		if( i > -1 ) {
			valueArray.splice(i, 1);
			jQuery(this).children('.slatwall-ui-checkbox-checked').addClass('slatwall-ui-checkbox').removeClass('slatwall-ui-checkbox-checked');
		} else {
			valueArray.push(jQuery(this).data('filtervalue'));
			jQuery(this).children('.slatwall-ui-checkbox').addClass('slatwall-ui-checkbox-checked').removeClass('slatwall-ui-checkbox');
		}
		jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val(valueArray.join(","));
		
		var data = {};
		if(jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val() !== '') {
			data[ 'F:' + jQuery(this).closest('th').data('propertyidentifier') ] = jQuery('input[name="F:' + jQuery(this).closest('th').data('propertyidentifier') + '"]').val();
		} else {
			data[ 'FR:' + jQuery(this).closest('th').data('propertyidentifier') ] = 1;	
		}
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Range Adjustment
	jQuery('body').on('change', '.range-filter-upper', function(e){
		if(!jQuery(this).hasClass('datetimepicker')) {
			var data = {};
			data[ jQuery(this).attr('name') ] = jQuery(this).closest('ul').find('.range-filter-lower').val() + '^' + jQuery(this).val();
			listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);	
		}
	});
	jQuery('body').on('change', '.range-filter-lower', function(e){
		if(!jQuery(this).hasClass('datetimepicker')) {
			var data = {};
			data[ jQuery(this).attr('name') ] = jQuery(this).val() + '^' + jQuery(this).closest('ul').find('.range-filter-upper').val();
			listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
		}
	});
	
	// Listing Display - Searching
	jQuery('body').on('click', '.dropdown input', function(e) {
		e.stopPropagation();
	});
	jQuery('body').on('click', 'table .dropdown-toggle', function(e) {
		jQuery(this).parent().find('.listing-search').focus();
	});
	jQuery('body').on('keyup', '.listing-search', function(e) {
		var data = {};
		
		if(jQuery(this).val() !== '') {
			data[ jQuery(this).attr('name') ] = jQuery(this).val();	
		} else {
			data[ 'FKR:' + jQuery(this).attr('name').split(':')[1] ] = 1;
		}
		listingDisplayUpdate( jQuery(this).closest('.table').attr('id'), data);
	});
	
	// Listing Display - Sort Applying
	jQuery('body').on('click', '.table-action-sort', function(e) {
		e.preventDefault();
	});
	
	// Listing Display - Multiselect
	jQuery('body').on('click', '.table-action-multiselect', function(e) {
		e.preventDefault();
		if(!jQuery(this).hasClass('disabled')){
			tableMultiselectClick( this );
		}
	});
	
	// Listing Display - Select
	jQuery('body').on('click', '.table-action-select', function(e) {
		e.preventDefault();
		if(!jQuery(this).hasClass('disabled')){
			tableSelectClick( this );
		}
	});
	
	// Listing Display - Expanding
	jQuery('body').on('click', '.table-action-expand', function(e) {
		e.preventDefault();
		
		// If this is an expand Icon
		if(jQuery(this).children('i').hasClass('icon-plus')) {
			
			jQuery(this).children('i').removeClass('icon-plus').addClass('icon-minus');
			
			if( !showLoadedRows( jQuery(this).closest('table').attr('ID'), jQuery(this).closest('tr').attr('id') ) ) {
				var data = {};
				
				data[ 'F:' + jQuery(this).closest('table').data('parentidproperty') ] = jQuery(this).closest('tr').attr('id');
				data[ 'OrderBy' ] = jQuery(this).closest('table').data('expandsortproperty') + '|DESC';
				
				listingDisplayUpdate( jQuery(this).closest('table').attr('id'), data, jQuery(this).closest('tr').attr('id') );
			}
		
		// If this is a colapse icon
		} else if (jQuery(this).children('i').hasClass('icon-minus')) {
			
			jQuery(this).children('i').removeClass('icon-minus').addClass('icon-plus');
			
			//jQuery(this).closest('tbody').find('tr[data-parentid="' + jQuery(this).closest('tr').attr('id') + '"]').hide();
			hideLoadedRows( jQuery(this).closest('table').attr('ID'), jQuery(this).closest('tr').attr('id') );
			
		}
		
	});
	
	// Text Autocomplete
	jQuery('body').on('keyup', '.textautocomplete', function(e){
		if(jQuery(this).val().length >= 1) {
			updateTextAutocompleteSuggestions( jQuery(this) );
		} else {
			jQuery( '#' + jQuery(this).data('sugessionsid') ).html('');
		}
	});
	jQuery('body').on('click', '.textautocompleteremove', function(e) {
		e.preventDefault();
		
		var autocompleteField = jQuery(this).closest('.autoselect-container').find('.textautocomplete');
		
		// Update Hidden Value
		jQuery( 'input[name="' + jQuery( autocompleteField ).data('acfieldname') + '"]' ).val( '' );
		
		// Re-enable the search box
		jQuery( autocompleteField ).removeAttr("disabled");
		jQuery( autocompleteField ).focus();
		
		// Set the html for suggestoins to blank and show it
		jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).html('');
		
		// Hide the simple rep display
		jQuery(this).closest('.autocomplete-selected').hide();
	});
	jQuery('body').on('click', '.textautocompleteadd', function(e){
		e.preventDefault();
	});
	jQuery('body').on('mousedown', '.textautocompleteadd', function(e){
		//e.preventDefault();
		
		var autocompleteField = jQuery(this).closest('.autoselect-container').find('.textautocomplete');
		
		if(jQuery( autocompleteField ).attr("disabled") === undefined) {
			// Set hidden input
			jQuery( 'input[name="' + jQuery( autocompleteField ).data('acfieldname') + '"]' ).val( jQuery(this).data('acvalue') );
			
			// Set the simple rep display
			jQuery( autocompleteField ).closest('.autoselect-container').find('.autocomplete-selected').show();
			jQuery( '#selected-' + jQuery( autocompleteField ).data('sugessionsid') ).html( jQuery(this).data('acname') ) ;
			
			// update the suggestions and searchbox
			jQuery( autocompleteField ).attr("disabled", "disabled");
			jQuery( autocompleteField ).val('');
			
			// Udate the suggestions to only show 1
			jQuery.each( jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).children(), function(i, v) {
				if( jQuery(v).find('.textautocompleteadd').data('acvalue') !== jQuery( 'input[name="' + jQuery( autocompleteField ).data('acfieldname') + '"]' ).val() ) {
					jQuery(v).remove();
				}
			});
			
			jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).parent().hide();
		}
	});
	jQuery('body').on('blur', '.textautocomplete', function(e){
		// update the suggestions and searchbox
		jQuery( this ).val('');
		jQuery( '#' + jQuery( this ).data('sugessionsid') ).html('');
		jQuery( '#' + jQuery( this ).data('sugessionsid') ).parent().hide();
	});
	jQuery('body').on('mouseenter', '.autocomplete-selected', function(e) {
		var autocompleteField = jQuery(this).closest('.autoselect-container').find('.textautocomplete');
		jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).parent().show();
	});
	jQuery('body').on('mouseleave', '.autocomplete-selected', function(e) {
		var autocompleteField = jQuery(this).closest('.autoselect-container').find('.textautocomplete');
		jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).parent().hide();
	});
}

function textAutocompleteHold( autocompleteField, data ) {
	if(!textAutocompleteCache.onHold) {
		textAutocompleteCache.onHold = true;
		return false;
	}
	
	textAutocompleteCache.autocompleteField = autocompleteField;
	textAutocompleteCache.data = data;
	
	return true;
}

function textAutocompleteRelease( ) {
	
	textAutocompleteCache.onHold = false;
	
	if(listingUpdateCache.autocompleteField !== undefined) {
		updateTextAutocompleteSuggestions( textAutocompleteCache.autocompleteField, textAutocompleteCache.data );
	}
	
	textAutocompleteCache.autocompleteField = undefined;
	textAutocompleteCache.data = {};
}

function updateTextAutocompleteUI( autocompleteField ) {
	// If there is a value set, then we can go out and get the necessary quickview value
	if(jQuery( 'input[name="' + jQuery(autocompleteField).data('acfieldname') + '"]' ).val().length) {
		//Update UI with pre-selected value
	}
}
function updateTextAutocompleteSuggestions( autocompleteField, data ) {
	if(jQuery(autocompleteField).val().length) {
		// Setup the correct data
		var thisData = {
			slatAction: 'admin:ajax.updatelistingdisplay',
			entityName: jQuery( autocompleteField ).data('entityname'),
			propertyIdentifiers: jQuery( autocompleteField ).data('acpropertyidentifiers'),
			keywords: jQuery(autocompleteField).val()
		};
		thisData["f:activeFlag"] = 1;
		thisData["P:Show"] = 4;
		var piarr = jQuery(autocompleteField).data('acpropertyidentifiers').split(',');
		if( piarr.indexOf( jQuery(autocompleteField).data('acvalueproperty') ) === -1 ) {
			thisData["propertyIdentifiers"] += ',' + jQuery(autocompleteField).data('acvalueproperty');
		}
		if( piarr.indexOf( jQuery(autocompleteField).data('acnameproperty') ) === -1 ) {
			thisData["propertyIdentifiers"] += ',' + jQuery(autocompleteField).data('acnameproperty');
		}
		
		if( data !== undefined ) {
			if( data["keywords"] !== undefined) {
				thisData["keywords"] = data["keywords"];
			}
			if( data["P:Show"] !== undefined) {
				thisData["P:Show"] = data["P:Show"];
			}
		}
		
		// Verify that an update isn't already running
		if(!textAutocompleteHold(autocompleteField, thisData)) {
			jQuery.ajax({
				url: slatwall.rootURL + '/',
				method: 'post',
				data: thisData,
				dataType: 'json',
				beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
				error: function( er ) {
					console.log( er );
					alert('An Error Occured');
				},
				success: function(r) {
					jQuery( '#' + jQuery(autocompleteField).data('sugessionsid') ).html('');
					jQuery.each( r["pageRecords"], function(ri, rv) {
						var innerLI = '<li><a href="#" class="textautocompleteadd" data-acvalue="' + rv[ jQuery(autocompleteField).data('acvalueproperty') ] + '" data-acname="' + rv[ jQuery(autocompleteField).data('acnameproperty') ] + '">';
						
						jQuery.each( piarr, function(pi, pv) {
							innerLI += '<span class="' + pv + '">' + rv[ pv ] + '</span>';
						});
						innerLI += '</a></li>';
						jQuery( '#' + jQuery(autocompleteField).data('sugessionsid') ).append( innerLI );
					});
					jQuery( '#' + jQuery( autocompleteField ).data('sugessionsid') ).parent().show();
					
					textAutocompleteRelease();
				}
			});
		}
	}
}


function hideLoadedRows( tableID, parentID ) {
	jQuery.each( jQuery( '#' + tableID).find('tr[data-parentid="' + parentID + '"]'), function(i, v) {
		jQuery(v).hide();
		
		hideLoadedRows( tableID, jQuery(v).attr('ID') );
	});
}

function showLoadedRows( tableID, parentID ) {
	var found = false;
	
	jQuery.each( jQuery( '#' + tableID).find('tr[data-parentid="' + parentID + '"]'), function(i, v) {
		
		found = true;
		
		jQuery(v).show();
		
		// If this row has a minus indicating that it is supposed to be open, then recusivly re-call this method
		if( jQuery(v).find('.icon-minus').length ) {
			showLoadedRows( tableID, jQuery(v).attr('ID') );
		}
		
	});
	
	return found;
}

function listingUpdateHold( tableID, data, afterRowID) {
	if(!listingUpdateCache.onHold) {
		listingUpdateCache.onHold = true;
		return false;
	}
	
	listingUpdateCache.tableID = tableID;
	listingUpdateCache.data = data;
	listingUpdateCache.afterRowID = afterRowID;
	
	return true;
}

function listingUpdateRelease( ) {
	
	listingUpdateCache.onHold = false;
	
	if(listingUpdateCache.tableID.length > 0) {
		listingDisplayUpdate( listingUpdateCache.tableID, listingUpdateCache.data, listingUpdateCache.afterRowID );
	}
	
	listingUpdateCache.tableID = "";
	listingUpdateCache.data = {};
	listingUpdateCache.afterRowID = "";
}

function listingDisplayUpdate( tableID, data, afterRowID ) {
	
	if( !listingUpdateHold( tableID, data, afterRowID ) ) {
		
		addLoadingDiv( tableID );
		
		data[ 'slatAction' ] = 'admin:ajax.updateListingDisplay';
		data[ 'propertyIdentifiers' ] = jQuery('#' + tableID).data('propertyidentifiers');
		data[ 'savedStateID' ] = jQuery('#' + tableID).data('savedstateid');
		data[ 'entityName' ] = jQuery('#' + tableID).data('entityname');
		
		var idProperty = jQuery('#' + tableID).data('idproperty');
		var nextRowDepth = 0;
		
		if(afterRowID) {
			nextRowDepth = jQuery('#' + afterRowID).find('[data-depth]').attr('data-depth');
			nextRowDepth++;
		}
		
		jQuery.ajax({
			url: slatwall.rootURL + '/',
			method: 'post',
			data: data,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
			error: function(result) {
				removeLoadingDiv( tableID );
				listingUpdateRelease();
				alert('Error During Listing Display Update.');
			},
			success: function(r) {
				
				// Setup Selectors
				var tableBodySelector = '#' + tableID + ' tbody';
				var tableHeadRowSelector = '#' + tableID + ' thead tr';
				
				// Clear out the old Body, if there is no afterRowID
				if(!afterRowID) {
					jQuery(tableBodySelector).html('');
				}
				
				// Loop over each of the records in the response
				jQuery.each( r["pageRecords"], function(ri, rv) {
					
					var rowSelector = jQuery('<tr></tr>');
					jQuery(rowSelector).attr('id', rv[ idProperty ]);
					
					if(afterRowID) {
						jQuery(rowSelector).attr('data-idpath', rv[ idProperty + 'Path' ]);
						jQuery(rowSelector).data('idpath', rv[ idProperty + 'Path' ]);
						jQuery(rowSelector).attr('data-parentid', afterRowID);
						jQuery(rowSelector).data('parentid', afterRowID);
					}
					
					// Loop over each column of the header to pull the data out of the response and populate new td's
					jQuery.each(jQuery(tableHeadRowSelector).children(), function(ci, cv){
						var newtd = '';
						var link = '';
						
						if( jQuery(cv).hasClass('data') ) {
							
							if( typeof rv[jQuery(cv).data('propertyidentifier')] === 'boolean' && rv[jQuery(cv).data('propertyidentifier')] ) {
								newtd += '<td class="' + jQuery(cv).attr('class') + '">Yes</td>';
							} else if ( typeof rv[jQuery(cv).data('propertyidentifier')] === 'boolean' && !rv[jQuery(cv).data('propertyidentifier')] ) {
								newtd += '<td class="' + jQuery(cv).attr('class') + '">No</td>';
							} else {
								if(jQuery(cv).hasClass('primary') && afterRowID) {
									newtd += '<td class="' + jQuery(cv).attr('class') + '"><a href="#" class="table-action-expand depth' + nextRowDepth + '" data-depth="' + nextRowDepth + '"><i class="icon-plus"></i></a> ' + rv[jQuery(cv).data('propertyidentifier')] + '</td>';
								} else {
									newtd += '<td class="' + jQuery(cv).attr('class') + '">' + rv[jQuery(cv).data('propertyidentifier')] + '</td>';
								}
							}
							
						} else if( jQuery(cv).hasClass('sort') ) {
							
							newtd += '<td><a href="#" class="table-action-sort" data-idvalue="' + rv[ idProperty ] + '" data-sortpropertyvalue="' + rv.sortOrder + '"><i class="icon-move"></i></a></td>';
						
						} else if( jQuery(cv).hasClass('multiselect') ) {
							
							newtd += '<td><a href="#" class="table-action-multiselect';
							if(jQuery(cv).hasClass('disabled')) {
								newtd += ' disabled';
							}
							newtd += '" data-idvalue="' + rv[ idProperty ] + '"><i class="slatwall-ui-checkbox"></i></a></td>';
							
						} else if( jQuery(cv).hasClass('select') ) {
							
							newtd += '<td><a href="#" class="table-action-select';
							if(jQuery(cv).hasClass('disabled')) {
								newtd += ' disabled';
							}
							newtd += '" data-idvalue="' + rv[ idProperty ] + '"><i class="slatwall-ui-radio"></i></a></td>';
								
								
						} else if ( jQuery(cv).hasClass('admin') ){
							
							newtd += '<td>';
							
	
							if( jQuery(cv).data('detailaction') !== undefined ) {
								link = '?slatAction=' + jQuery(cv).data('detailaction') + '&' + idProperty + '=' + rv[ idProperty ];
								if( jQuery(cv).data('detailquerystring') !== undefined ) {
									link += '&' + jQuery(cv).data('detailquerystring');
								}
								if( jQuery(cv).data('detailmodal') ) {
									newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-eye-open"></i></a> ';
								} else {
									newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-eye-open"></i></a> ';	
								}
							}
							
							if( jQuery(cv).data('editaction') !== undefined ) {
								link = '?slatAction=' + jQuery(cv).data('editaction') + '&' + idProperty + '=' + rv[ idProperty ];
								if( jQuery(cv).data('editquerystring') !== undefined ) {
									link += '&' + jQuery(cv).data('editquerystring');
								}
								if( jQuery(cv).data('editmodal') ) {
									newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-pencil"></i></a> ';
								} else {
									newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-pencil"></i></a> ';	
								}
							}
							
							if( jQuery(cv).data('deleteaction') !== undefined ) {
								link = '?slatAction=' + jQuery(cv).data('deleteaction') + '&' + idProperty + '=' + rv[ idProperty ];
								if( jQuery(cv).data('deletequerystring') !== undefined ) {
									link += '&' + jQuery(cv).data('deletequerystring');
								}
								newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-trash"></i></a> ';
							}
							/*
							if( jQuery(cv).data('processaction') !== undefined ) {
								link = '?slatAction=' + jQuery(cv).data('processaction') + '&' + idProperty + '=' + rv[ idProperty ];
								if( jQuery(cv).data('processquerystring') !== undefined ) {
									link += '&' + jQuery(cv).data('processquerystring');
								}
								if( jQuery(cv).data('processmodal') ) {
									newtd += '<a class="btn btn-mini modalload" href="' + link + '" data-toggle="modal" data-target="#adminModal"><i class="icon-cog"></i> Process</a> ';
								} else {
									newtd += '<a class="btn btn-mini" href="' + link + '"><i class="icon-cog"></i> Process</a> ';	
								}
							}
							*/
							newtd += '</td>';
							
						}
						
						jQuery(rowSelector).append(newtd);
					});
					
					if(!afterRowID) {
						jQuery(tableBodySelector).append(jQuery(rowSelector));
					} else {
						jQuery(tableBodySelector).find('#' + afterRowID).after(jQuery(rowSelector));
					}
				});
				
				// Update the paging nav
				jQuery('div[class="pagination"][data-tableid="' + tableID + '"]').html(buildPagingNav(r["currentPage"], r["totalPages"], r["pageRecordsStart"], r["pageRecordsEnd"], r["recordsCount"]));
				
				// Update the saved state ID of the table
				jQuery('#' + tableID).data('savedstateid', r["savedStateID"]);
				jQuery('#' + tableID).attr('data-savedstateid', r["savedStateID"]);
				
				if(jQuery('#' + tableID).data('multiselectfield')) {
					updateMultiselectTableUI( jQuery('#' + tableID).data('multiselectfield') );
				}
				
				if(jQuery('#' + tableID).data('selectfield')) {
					updateSelectTableUI( jQuery('#' + tableID).data('selectfield') );
				}
				
				// Unload the loading icon
				removeLoadingDiv( tableID );
				
				// Release the hold
				listingUpdateRelease();
			}
		});
	
	}
}

function addLoadingDiv( elementID ) {
	var loadingDiv = '<div id="loading' + elementID + '" style="position:absolute;float:left;text-align:center;background-color:#FFFFFF;opacity:.9;z-index:900;"><img src="' + slatwall.rootURL + '/assets/images/loading.gif" title="loading" /></div>';
	jQuery('#' + elementID).before(loadingDiv);
	jQuery('#loading' + elementID).width(jQuery('#' + elementID).width() + 2);
	jQuery('#loading' + elementID).height(jQuery('#' + elementID).height() + 2);
	if(jQuery('#' + elementID).height() > 66) {
		jQuery('#loading' + elementID + ' img').css('margin-top', ((jQuery('#' + elementID).height() / 2) - 66) + 'px');
	}
}

function removeLoadingDiv( elementID ) {
	jQuery('#loading' + elementID).remove();
}


function buildPagingNav(currentPage, totalPages, pageRecordStart, pageRecordEnd, recordsCount) {
	var nav = '';
	
	currentPage = parseInt(currentPage);
	totalPages = parseInt(totalPages);
	pageRecordStart = parseInt(pageRecordStart);
	pageRecordEnd = parseInt(pageRecordEnd);
	recordsCount = parseInt(recordsCount);
	
	if(totalPages > 1){
		nav = '<ul>';
	
		var pageStart = 1;
		var pageCount = 5;
		
		if(totalPages > 6) {
			if (currentPage > 3 && currentPage < totalPages - 3) {
				pageStart = currentPage - 1;
				pageCount = 3;
			} else if (currentPage >= totalPages - 4) {
				pageStart = totalPages - 4;
			}
		} else {
			pageCount = totalPages;
		}
		
		
		nav += '<li><a href="##" class="paging-show-toggle">Show <span class="details">(' + pageRecordStart + ' - ' + pageRecordEnd + ' of ' + recordsCount + ')</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="10">10</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="25">25</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="50">50</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="100">100</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="500">500</a></li>';
		nav += '<li><a href="##" class="show-option" data-show="ALL">ALL</a></li>';
		
		
		if(currentPage > 1) {
			nav += '<li><a href="#" class="listing-pager page-option prev" data-page="' + (currentPage - 1) + '">&laquo;</a></li>';
		} else {
			nav += '<li class="disabled prev"><a href="#" class="page-option">&laquo;</a></li>';
		}
		
		if(currentPage > 3 && totalPages > 6) {
			nav += '<li><a href="#" class="listing-pager page-option" data-page="1">1</a></li>';
			nav += '<li class="disabled"><a href="#" class="page-option">...</a></li>';
		}
	
		for(var i=pageStart; i<pageStart + pageCount; i++){
			
			if(currentPage == i) {
				nav += '<li class="active"><a href="#" class="listing-pager page-option" data-page="' + i + '">' + i + '</a></li>';
			} else {
				nav += '<li><a href="#" class="listing-pager page-option" data-page="' + i + '">' + i + '</a></li>';
			}
		}
		
		if(currentPage < totalPages - 3 && totalPages > 6) {
			nav += '<li class="disabled"><a href="#" class="page-option">...</a></li>';
			nav += '<li><a href="#" class="listing-pager page-option" data-page="' + totalPages + '">' + totalPages + '</a></li>';
		}
		
		if(currentPage < totalPages) {
			nav += '<li><a href="#" class="listing-pager page-option next" data-page="' + (currentPage + 1) + '">&raquo;</a></li>';
		} else {
			nav += '<li class="disabled next"><a href="#" class="page-option">&raquo;</a></li>';
		}
		
		nav += '</ul>';
	}
	
	return nav;
}

function tableApplySort(event, ui) {
	
	var data = {
		slatAction : 'admin:ajax.updateSortOrder',
		recordID : jQuery(ui.item).attr('ID'),
		recordIDColumn : jQuery(ui.item).closest('table').data('idproperty'), 
		tableName : jQuery(ui.item).closest('table').data('entityname'),
		contextIDColumn : jQuery(ui.item).closest('table').data('sortcontextidcolumn'),
		contextIDValue : jQuery(ui.item).closest('table').data('sortcontextidvalue'),
		newSortOrder : 0
	};
	 
	var allOriginalSortOrders = jQuery(ui.item).parent().find('.table-action-sort').map( function(){ return jQuery(this).data("sortpropertyvalue");}).get();
	var minSortOrder = Math.min.apply( Math, allOriginalSortOrders );
	
	jQuery.each(jQuery(ui.item).parent().children(), function(index, value) {
		jQuery(value).find('.table-action-sort').data('sortpropertyvalue', index + minSortOrder);
		jQuery(value).find('.table-action-sort').attr('data-sortpropertyvalue', index + minSortOrder);
		if(jQuery(value).attr('ID') == data.recordID) {
			data.newSortOrder = index + minSortOrder;
		}
	});
	
	jQuery.ajax({
		url: slatwall.rootURL + '/',
		async: false,
		data: data,
		dataType: 'json',
		beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
		error: function(r) {
			alert('Error Updating the Sort Order for this table');
		}
	});

}



function updateMultiselectTableUI( multiselectField ) {
	var inputValue = jQuery('input[name=' + multiselectField + ']').val();
	
	if(inputValue !== undefined) {
		jQuery.each(inputValue.split(','), function(vi, vv) {
			jQuery(jQuery('table[data-multiselectfield="' + multiselectField  + '"]').find('tr[id=' + vv + '] .slatwall-ui-checkbox').addClass('slatwall-ui-checkbox-checked')).removeClass('slatwall-ui-checkbox');
		});
	}
}

function tableMultiselectClick( toggleLink ) {
	
	var field = jQuery( 'input[name="' + jQuery(toggleLink).closest('table').data('multiselectfield') + '"]' );
	var currentValues = jQuery(field).val().split(',');
	
	var blankIndex = currentValues.indexOf('');
	if(blankIndex > -1) {
		currentValues.splice(blankIndex, 1);
	}
	
	if( jQuery(toggleLink).children('.slatwall-ui-checkbox-checked').length ) {
		
		var icon = jQuery(toggleLink).children('.slatwall-ui-checkbox-checked');
		
		jQuery(icon).removeClass('slatwall-ui-checkbox-checked');
		jQuery(icon).addClass('slatwall-ui-checkbox');
		
		var valueIndex = currentValues.indexOf( jQuery(toggleLink).data('idvalue') );
		
		currentValues.splice(valueIndex, 1);
		
	} else {
		
		var icon = jQuery(toggleLink).children('.slatwall-ui-checkbox');
		
		jQuery(icon).removeClass('slatwall-ui-checkbox');
		jQuery(icon).addClass('slatwall-ui-checkbox-checked');
		
		currentValues.push( jQuery(toggleLink).data('idvalue') );
	}
	
	jQuery(field).val(currentValues.join(','));
}

function updateSelectTableUI( selectField ) {
	var inputValue = jQuery('input[name="' + selectField + '"]').val();
	
	if(inputValue !== undefined) {
		jQuery('table[data-selectfield="' + selectField  + '"]').find('tr[id=' + inputValue + '] .slatwall-ui-radio').addClass('slatwall-ui-radio-checked').removeClass('slatwall-ui-radio');
	}
}

function tableSelectClick( toggleLink ) {
	
	if( jQuery(toggleLink).children('.slatwall-ui-radio').length ) {
		
		// Remove old checked icon
		jQuery( toggleLink ).closest( 'table' ).find('.slatwall-ui-radio-checked').addClass('slatwall-ui-radio').removeClass('slatwall-ui-radio-checked');
		
		// Set new checked icon
		jQuery( toggleLink ).children('.slatwall-ui-radio').addClass('slatwall-ui-radio-checked').removeClass('slatwall-ui-radio');
		
		// Update the value
		jQuery( 'input[name="' + jQuery( toggleLink ).closest( 'table' ).data('selectfield') + '"]' ).val( jQuery( toggleLink ).data( 'idvalue' ) );
		
	}
}

function globalSearchHold() {
	if(!globalSearchCache.onHold) {
		globalSearchCache.onHold = true;
		return false;
	}
	
	return true;
}

function globalSearchRelease() {
	globalSearchCache.onHold = false;
}

function updateGlobalSearchResults() {
	
	if(!globalSearchHold()) {
		addLoadingDiv( 'search-results' );
		
		var data = {
			slatAction: 'admin:ajax.updateGlobalSearchResults',
			keywords: jQuery('#global-search').val()
		};
		
		jQuery.ajax({
			url: slatwall.rootURL + '/',
			method: 'post',
			data: data,
			dataType: 'json',
			beforeSend: function (xhr) { xhr.setRequestHeader('X-Slatwall-AJAX', true) },
			error: function(result) {
				removeLoadingDiv( 'search-results' );
				globalSearchRelease();
				alert('Error Loading Global Search');
			},
			success: function(result) {
				
				var buckets = {
					product: {primaryIDProperty:'productID', listAction:'admin:product.listproduct', detailAction:'admin:product.detailproduct'},
					productType: {primaryIDProperty:'productTypeID', listAction:'admin:product.listproducttype', detailAction:'admin:product.detailproducttype'},
					brand: {primaryIDProperty:'brandID', listAction:'admin:product.listbrand', detailAction:'admin:product.detailbrand'},
					promotion: {primaryIDProperty:'promotionID', listAction:'admin:pricing.listpromotion', detailAction:'admin:pricing.detailpromotion'},
					order: {primaryIDProperty:'orderID', listAction:'admin:order.listorder', detailAction:'admin:order.detailorder'},
					account: {primaryIDProperty:'accountID', listAction:'admin:account.listaccount', detailAction:'admin:account.detailaccount'},
					vendorOrder: {primaryIDProperty:'vendorOrderID', listAction:'admin:order.listvendororder', detailAction:'admin:order.detailvendororder'},
					vendor: {primaryIDProperty:'vendorID', listAction:'admin:vendor.listvendor', detailAction:'admin:vendor.detailvendor'}
				};
				for (var key in buckets) {
					jQuery('#golbalsr-' + key).html('');
					var records = result[key]['records'];
				    for(var r=0; r < records.length; r++) {
				    	jQuery('#golbalsr-' + key).append('<li><a href="' + slatwall.rootURL + '/?slatAction=' + buckets[key]['detailAction'] + '&' + buckets[key]['primaryIDProperty'] + '=' + records[r]['value'] + '">' + records[r]['name'] + '</a></li>');
				    }
				    if(result[key]['recordCount'] > 10) {
				    	jQuery('#golbalsr-' + key).append('<li><a href="' + slatwall.rootURL + '/?slatAction=' + buckets[key]['listAction'] + '&keywords=' + jQuery('#global-search').val() + '">...</a></li>');
				    } else if (result[key]['recordCount'] == 0) {
				    	jQuery('#golbalsr-' + key).append('<li><em>none</em></li>');
				    }
				}
				
				removeLoadingDiv( 'search-results' );
				globalSearchRelease();
			}
			
		});
	}
}

/*
function getEntityAutocompleteTemplate( entityName, data ) {
	var output = "";
	if( entityName === 'Account') {
		output += '<span class="image"><img src="';
		output += data.gravatarURL;
		output += '" /></span>';
		output += '<span class="image">';
		output += '</span>';
		output += '<span class="image">';
		output += '</span>';
		output += '<span class="image">';
		output += '</span>';
	}
	return output;
}
*/

// ========================= START: HELPER METHODS ================================

function convertCFMLDateFormat( dateFormat ) {
	dateFormat = dateFormat.replace('mmm', 'M');
	dateFormat = dateFormat.replace('yyyy', 'yy');
	return dateFormat;
}

function convertCFMLTimeFormat( timeFormat ) {
	timeFormat = timeFormat.replace('tt', 'TT');
	return timeFormat;
}

// =========================  END: HELPER METHODS =================================
