
	<script type="text/javascript">
		jQuery(document).ready(function() {
			
	        $(function() {
    			$('.date-picker').datepicker(
                    {
                        dateFormat: "yy/mm",
                        changeMonth: true,
                        changeYear: true,
                        showButtonPanel: true,
                        minViewMode: "months",
                        onClose: function(dateText, inst) {


                            function isDonePressed(){
                                return ($('#ui-datepicker-div').html().indexOf('ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all ui-state-hover') > -1);
                            }

                            if (isDonePressed()){
                                var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
                                var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
                                $(this).datepicker('setDate', new Date(year, month, 1)).trigger('change');
                                
                                 $('.date-picker').focusout()//Added to remove focus from datepicker input box on selecting date
                            }
                        },
                        beforeShow : function(input, inst) {

                            inst.dpDiv.addClass('month_year_datepicker')

                            if ((datestr = $(this).val()).length > 0) {
                                year = datestr.substring(datestr.length-4, datestr.length);
                                month = datestr.substring(0, 2);
                                $(this).datepicker('option', 'defaultDate', new Date(year, month-1, 1));
                                $(this).datepicker('setDate', new Date(year, month-1, 1));
                                $(".ui-datepicker-calendar").hide();
                            }
                        }
                    })
				});
    
			<cfoutput>
				jQuery('body').on('click', '##ApplyBtn', function(e){
					e.preventDefault();
					jQuery("input[name='slatAction']").val('#rc.slatAction#');
					jQuery('##revrecognition').submit();
				});
				
				jQuery('body').on('click', '##ExportBtn', function(e){
					e.preventDefault();
					
					//creates a hidden form based on current form and alters for export
					if(jQuery('##revrecognitionexport')){
						jQuery('##revrecognitionexport').remove();
					}
					
					var exportForm = jQuery('##revrecognition').clone();
					exportForm.children('input[name="slatAction"]').val(jQuery("input[name='slatAction']").val()+'export');
					exportForm.attr('id','revrecognitionexport');
					exportForm.hide();
					jQuery(document.body).append(exportForm);
					exportForm.submit();
					
				});
			</cfoutput>
		});
		
	</script>
	<style>
	    .ui-datepicker-calendar {
	        display: none;
	    }
    </style>
<cfoutput>
	<div id="reporting-top">
		
		<form id="revrecognition" action="?s=1" method="post">
		
			<input type="hidden" name="slatAction" value="#rc.slatAction#"/>
			<div id="u119_state0" class="panel_state" data-label="State1" style="">
				<div class="flex flex-space-bettween align-items-end">
					<div class="col flex align-items-end">
						<!--- BACKEND TODO: Add logic for subscription name --->
						<h3>[Report Name Here]</h3>
					</div>
					
                    <!-- Button (Rectangle) -->
					<div class="col flex flex-end">	
						<div class="report-select">
	                        <!--- BACKEND TODO: Wireup subscription report dropdown --->
	                        <select name="report" data-live-search="true" data-width="auto">
	                        	<option value="##">Subscription Reports ...</option>
	                        	 <option value="##">Deferred Revenue Report</option>
	                        	 <option value="##">Earned Revenue Report</option>
	                        	 <option value="##">New Subscription Orders Report</option>
	                        	 <option value="##">Cancelled Orders Report</option>
	                        </select>
	                    </div>
				        <div id="u123" class="ax_default shape" data-label="Button" style="cursor: pointer;">
				            <div id="u123_div" class="" tabindex="0"></div>
				            <div id="u123_text" class="text single-select">
				                <button id="ExportBtn" type="button" class="btn btn-secondary" ><i class="fas fa-download"></i> Export</button>
				                <button id="ApplyBtn" type="button" class="btn btn-success" ><i class="fas fa-check"></i> Apply</button>
				            </div>
				        </div>
			        </div>
				</div>
			    <div id="u119_state0_content" class="panel_state_content flex flex-space-bettween">
			    	<div class="col larger">	
					    <div class="single-select">
				            <sw-typeahead-input-field
				            		data-entity-name="Product"
				                    data-property-to-save="productID"
				                    data-property-to-show="productName"
				                    data-properties-to-load="productName"
				                    data-placeholder-text="Product"
				                    data-multiselect-mode="false"
				                    data-filter-flag="true"
				                    data-max-records="250"
				                    data-field-name="productID"
				                    data-order-by-list="productName|ASC"
				                    <cfif structKeyExists(rc,'productID') and len(rc.productID)>
				            			data-initial-entity-id="#HTMLEditFormat(rc.productID)#"
				            		</cfif>
				                    >
				            
				                <sw-collection-config
				                        data-entity-name="Product"
				                        data-collection-config-property="typeaheadCollectionConfig"
				                        data-parent-directive-controller-as-name="swTypeaheadInputField"
				                        data-all-records="true">
				                	
				                								<!--- Columns --->
				             		<sw-collection-columns>
				             			<sw-collection-column data-property-identifier="productName" is-searchable="true"></sw-collection-column>
				             			<sw-collection-column data-property-identifier="productID" is-searchable="false"></sw-collection-column>
				             		</sw-collection-columns>
				             		
				             		<!--- Order By --->
				                 	<sw-collection-order-bys>
				                     	<sw-collection-order-by data-order-by="productName|ASC"></sw-collection-order-by>
				                 	</sw-collection-order-bys>
				            
				                	<!--- Filters --->
				                	<sw-collection-filters>
				                    	<sw-collection-filter data-property-identifier="productType.productTypeIDPath" data-comparison-operator="like" data-comparison-value="444df2f9c7deaa1582e021e894c0e299%"></sw-collection-filter>
				                    </sw-collection-filters>
				                </sw-collection-config>
				            
				            	<span sw-typeahead-search-line-item data-property-identifier="productName" is-searchable="true"></span><br>
				            
				            </sw-typeahead-input-field>
			            </div>
				    </div>
			    	
			    	<div class="col flex content-right">
			    		<div class="col">
					        <!--get avaiable order item subscripiont type-->
					        <cfset subscriptionOrderItemTypeCollectionList = $.slatwall.getService('hibachiService').getTypeCollectionList()/>
					        <cfset subscriptionOrderItemTypeCollectionList.setDisplayProperties('systemCode,typeName')/>
					        <cfset subscriptionOrderItemTypeCollectionList.addFilter('typeIDPath','444df3100babdbe1086cf951809a60ca,%','like')/>
					         <div class="multi-select">
		                        <label>Subscription Type</label>
		                        <select name="subscriptionType" class="selectpicker" data-live-search="true" data-width="auto" multiple>
		                          <cfloop array="#subscriptionOrderItemTypeCollectionList.getRecords()#" index="subscriptionOrderItemTypeRecord">
		                        	 <option value="#subscriptionOrderItemTypeRecord['systemCode']#" <cfif structKeyExists(rc,'subscriptionType') && listFind(rc.subscriptionType,subscriptionOrderItemTypeRecord['systemCode'])>selected</cfif>>#subscriptionOrderItemTypeRecord['typeName']#</option>
		                          </cfloop>
		                        </select>
		                    </div>
				        </div>
				        
			        </div>
			        <div class="col">
			        	
				        <!-- get available subscription product types -->
				        <cfset productTypeCollectionList = $.slatwall.getService('hibachiService').getProductTypeCollectionList()/>
				        <cfset productTypeCollectionList.setDisplayProperties('productTypeID,productTypeName')/>
				        <cfset productTypeCollectionList.addFilter('productTypeIDPath','444df2f9c7deaa1582e021e894c0e299,%','like')/>
	                    <div class="multi-select">
	                        <h4>Product Type</h4>
	                        <select name="productType" class="selectpicker" data-live-search="true" data-width="auto" multiple>
	                          <cfloop array="#productTypeCollectionList.getRecords()#" index="productTypeRecord">
	                        	 <option value="#productTypeRecord['productTypeID']#" <cfif structKeyExists(rc,'productType') && listFind(rc.productType,productTypeRecord['productTypeID'])>selected</cfif>>#productTypeRecord['productTypeName']#</option>
	                          </cfloop>
	                        </select>
	                    </div>
				    </div>
	                    <div class="col">
	                        <div class="single-select flex">
	                        	<div class="col">
	                            	<h4>From Date</h4>
		                            <!---<select name="reportYear" class="selectpicker" data-live-search="true" data-width="auto" >
						                <cfloop array="#possibleYearsRecords#" index="possibleYearsRecord">
						                    <option 
						                    	value="#possibleYearsRecord#"
						                    	<cfif structKeyExists(rc,'reportYear') && rc.reportYear eq possibleYearsRecord>selected</cfif>
						                    >#possibleYearsRecord#
						                    </option>
						                </cfloop>
						            </select>--->
						            <input id="minDate" name="minDate" class="date-picker form-control" value="#dateFormat(rc.minDate,'yyyy/mm')#" />
					            </div>
					            <div class="col">
						            <h4>To Date</h4>
						            <input id="maxDate" name="maxDate" class=" date-picker form-control" value="#dateFormat(rc.maxDate,'yyyy/mm')#" />
						        </div>
	                        </div>
	                        <!-- Button (Rectangle) -->
							<div class="col flex flex-end">	
						        <div id="u123" class="ax_default shape" data-label="Button" style="cursor: pointer;">
						            <div id="u123_div" class="" tabindex="0"></div>
						            <div id="u123_text" class="text single-select ">
						                <button id="ApplyBtn" type="button" class="btn btn-primary" >Apply</button>
						                <button id="ExportBtn" type="button" class="btn btn-primary" >Export</button>
						            </div>
						        </div>
					        </div>
	                    </div>
	                    
			    </div><!-- end of .flex -->
			</div>
		</form>
	</div>
</cfoutput>
