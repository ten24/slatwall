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
			
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentQuantity" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.minimumShipmentQuantity' ng-init=""shippingMethodRate.minimumShipmentQuantity='#rc.shippingMethodRate.getMinimumShipmentQuantity()#'""">
        	<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentQuantity" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.maximumShipmentQuantity' ng-init=""shippingMethodRate.maximumShipmentQuantity='#rc.shippingMethodRate.getMaximumShipmentQuantity()#'""">
		
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentWeight" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.minimumShipmentWeight' ng-init=""shippingMethodRate.minimumShipmentWeight='#rc.shippingMethodRate.getMinimumShipmentWeight()#'""">
        	<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentWeight" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.maximumShipmentWeight' ng-init=""shippingMethodRate.maximumShipmentWeight='#rc.shippingMethodRate.getMaximumShipmentWeight()#'""">
		
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentItemPrice" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="splitShipmentWeight" edit="#rc.edit#"> 
			
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="defaultAmount" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.defaultAmount' ng-init=""shippingMethodRate.defaultAmount='#rc.shippingMethodRate.getDefaultAmount()#'""">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="rateMultiplierAmount" edit="#rc.edit#" fieldAttributes="ng-model='shippingMethodRate.rateMultiplierAmount' ng-init=""shippingMethodRate.rateMultiplierAmount='#rc.shippingMethodRate.getRateMultiplierAmount()#'""">
			
			<!--- display a sample of the calculations that will be used with the upcharge --->
			<div ng-if="shippingMethodRate.rateMultiplierAmount && (shippingMethodRate.minimumShipmentWeight || shippingMethodRate.minimumShipmentQuantity)" class="ng-cloak">
				<ul class="list-group" > 
					
					<small>When using a rate multiplier the charge is calculated as follows: rate multiplier * {quantity or weight} + base amount = charge</small>
					
					<li class="list-group-item" ng-if="shippingMethodRate.minimumShipmentQuantity" ng-repeat="n in [0,1,2,3,4] track by $index">
						<br><span><b>Quantity</b> [{{(shippingMethodRate.minimumShipmentQuantity*1+n)}}] X <b>Rate Multiplier Amount</b> [{{shippingMethodRate.rateMultiplierAmount|currency}}] + <b>Default Amount</b> [{{shippingMethodRate.defaultAmount|currency}}] = </span>
						<span class="badge">{{((shippingMethodRate.defaultAmount * 1)+((shippingMethodRate.minimumShipmentQuantity*1+n)*(shippingMethodRate.rateMultiplierAmount*1))|currency)}}</span></b>
					</li>
					<li class="list-group-item" ng-if="shippingMethodRate.minimumShipmentWeight" ng-repeat="n in [0,1,2,3,4] track by $index">
						<br><span><b>Weight</b> {{(shippingMethodRate.minimumShipmentWeight*1+n)}} lbs. X <b>Rate Multiplier Amount</b> {{shippingMethodRate.rateMultiplierAmount|currency}} + <b>Default Amount</b> {{shippingMethodRate.defaultAmount|currency}} = </span>
						<span class="badge"><b>{{((shippingMethodRate.defaultAmount * 1)+((shippingMethodRate.minimumShipmentWeight*1+n)*(shippingMethodRate.rateMultiplierAmount*1))|currency)}}</b></span>
					</li>	
				</ul>		
			</div>
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>
