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
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentWeight" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentWeight" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="minimumShipmentItemPrice" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="maximumShipmentItemPrice" edit="#rc.edit#">
			<hb:HibachiPropertyDisplay object="#rc.shippingMethodRate#" property="defaultAmount" edit="#rc.edit#">
		</hb:HibachiPropertyList>
	</hb:HibachiPropertyRow>
</cfoutput>