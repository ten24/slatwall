<cfoutput>
    <div class="s-property form-horizontal">
        
        <!----- let's get all shipping integrations -------->
        
        <cfset local.shippingIntegrationCollectionList = $.slatwall.getService('IntegrationService').getIntegrationCollectionList() />
        <cfset local.shippingIntegrationCollectionList.addFilter('integrationTypeList','shipping') />
        <cfset local.shippingIntegrationCollectionList.addFilter('activeFlag','true') />
        <cfset local.shippingIntegrationsStruct = local.shippingIntegrationCollectionList.getRecords() />
        
        <cfloop array="#local.shippingIntegrationsStruct#" index="local.shippingIntegrationStruct">
        	
        	<cfset local.shippingIntegration = $.slatwall.getService('IntegrationService').getIntegrationByIntegrationID(local.shippingIntegrationStruct.integrationID) />
        	
        	<cfif NOT isNull(local.shippingIntegration)>
        		
        		<cfset local.shippingMethodOptions = local.shippingIntegration.getShippingMethodOptions(local.shippingIntegration.getIntegrationID()) />
        		
        		<!----- this form will let us create the entity that associates manual rates and shipping integration options -------->
        		
        		<div class="form-group">
        			<label for="manualRateIntegrationMethod.shippingIntegrationID" class="control-label col-sm-4">
        				<span class="s-title">#local.shippingIntegrationStruct.integrationName# method</span>
        			</label>
        			<div class="col-sm-8">
        			<input type="hidden" name="manualRateIntegrationIDs" value="#local.shippingIntegrationStruct.integrationID#" />
        			 <select 
        			    class="form-control j-custom-select" 
        			    name="shippingIntegrationMethods"
        			    <cfif !rc.edit>
        			     disabled
        			    </cfif>
        			    >
        			 	<option value="none">
        			 		None
        			 	</option>
        			 	<cfloop array="#local.shippingMethodOptions#" index="option">
        			 		<cfset isSelectedFlag = rc.shippingMethodRate.hasShippingMethodRateIntegrationMethod(option.value,local.shippingIntegrationStruct.integrationID) />
        			 		<option
        			 		value="#option.value#"
        			 		<cfif isSelectedFlag> selected </cfif>
        			 		>
        						#option.name#
        					</option>
        			 	</cfloop>
        			 </select>	
        			</div>
        		</div>
        	</cfif>
        </cfloop>
    </div>   
</cfoutput>