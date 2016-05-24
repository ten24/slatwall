<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />

<cfparam name="rc.shippingMethodRate" type="any">
<cfparam name="rc.edit" type="boolean">

<cfoutput>
	<hb:HibachiPropertyRow>
		<hb:HibachiPropertyList>
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="activeFlag" edit="#rc.edit#">
			<cfif isObject(rc.integration)>
				<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="shippingIntegration" edit="false" value="#rc.integration.getIntegrationName()#">
				<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="shippingIntegrationMethod" edit="#rc.edit#" fieldtype="select" valueOptions="#rc.integration.getShippingMethodOptions(rc.integration.getIntegrationID())#">
			</cfif>
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="addressZone" edit="#rc.edit#">
			
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentQuantity" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.minimumShipmentQuantity'">
        	<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentQuantity" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.maximumShipmentQuantity'">
		
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentWeight" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.minimumShipmentWeight'">
        	<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentWeight" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.maximumShipmentWeight'">
		
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentItemPrice" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.minimumShipmentItemPrice'">
        	<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentItemPrice" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.maximumShipmentItemPrice'">
			
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="defaultAmount" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.defaultAmount'">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="rateMultiplierAmount" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.rateMultiplierAmount'">
			
			<!--- display a sample of the calculations that will be used with the upcharge --->
			<div ng-if="shippingMethodRate.rateMultiplierAmount && (shippingMethodRate.minimumShipmentWeight || shippingMethodRate.minimumShipmentQuantity)" class="ng-cloak">
				<b>When using a rate multiplier the charge is calculated as follows: rate multiplier * {quantity or weight} + base amount = charge</b><br>
				 
				<span ng-if="shippingMethodRate.minimumShipmentQuantity" ng-repeat="n in [1,2,3] track by $index">
					<br><span><b>Quantity</b> [{{(shippingMethodRate.minimumShipmentQuantity*1*n+1)}}] X <b>rate multiplier amount</b> [{{shippingMethodRate.rateMultiplierAmount|currency}}] + default amount [{{shippingMethodRate.defaultAmount|currency}}] = </span>
					<span>{{((shippingMethodRate.defaultAmount * 1)+((shippingMethodRate.minimumShipmentQuantity*1*n+1)*(shippingMethodRate.rateMultiplierAmount*1))|currency)}}</span></b>
				</span>
				<span ng-if="shippingMethodRate.minimumShipmentWeight" ng-repeat="n in [1,2,3] track by $index">
					<br><span><b>Weight</b> {{(shippingMethodRate.minimumShipmentWeight*1*n+1)}} lbs. X <b>Rate Multiplier Amount</b> {{shippingMethodRate.rateMultiplierAmount|currency}} + <b>Default Amount</b> {{shippingMethodRate.defaultAmount|currency}} = </span>
					<span><b>{{((shippingMethodRate.defaultAmount * 1)+((shippingMethodRate.minimumShipmentWeight*1*n+1)*(shippingMethodRate.rateMultiplierAmount*1))|currency)}}</b></span>
				</span>			
			</div>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>