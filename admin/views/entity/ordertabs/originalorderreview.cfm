<cfimport prefix="swa" taglib="../../../../tags" />
<cfimport prefix="hb" taglib="../../../../org/Hibachi/HibachiTags" />
<cfset local.OrderJSON = rc.order.getEncodedJsonRepresentation()>
<cfoutput>
	<hb:HibachiPropertyRow>
			
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderNumber" edit="false" valuelink="#getHibachiScope().buildURL(action=rc.entityActionDetails.detailAction, queryString='orderID=#rc.order.getOrderID()#')#" title="#$.slatwall.rbKey('entity.order')#">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderCloseDateTime" edit="false" >
		</hb:HibachiPropertyList>

		<hb:HibachiPropertyList divclass="col-md-6">
			<sw-simple-property-display object="#OrderJSON#" property="calculatedSubTotal" title="Subtotal" currency-flag="true" edit="false" display-type="form-group" ></sw-simple-property-display>
			<sw-simple-property-display object="#OrderJSON#" property="calculatedFulfillmentTotal" title="Delivery Charges" currency-flag="true" edit="false" display-type="form-group" ></sw-simple-property-display>
			<sw-simple-property-display object="#OrderJSON#" property="calculatedDiscountTotal" title="Discount" currency-flag="true" edit="false" display-type="form-group" ></sw-simple-property-display>
			<sw-simple-property-display object="#OrderJSON#" property="calculatedTaxTotal" title="Tax Total" currency-flag="true" edit="false" display-type="form-group" ></sw-simple-property-display>
			<sw-simple-property-display object="#OrderJSON#" property="calculatedTotal" title="Total" currency-flag="true" edit="false" display-type="form-group" ></sw-simple-property-display>
		</hb:HibachiPropertyList>

	</hb:HibachiPropertyRow>
</cfoutput>