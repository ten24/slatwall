<cfimport prefix="swa" taglib="../../../../../tags" />
<cfimport prefix="hb" taglib="../../../../../org/Hibachi/HibachiTags" />

<cfoutput>
	<hb:HibachiPropertyRow>
			
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="orderNumber" edit="false" valuelink="#getHibachiScope().buildURL(action=rc.entityActionDetails.detailAction, queryString='orderID=#rc.order.getOrderID()#')#" title="#$.slatwall.rbKey('entity.order')#">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="true" fieldAttributes="disabled">
		</hb:HibachiPropertyList>

		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionableVolumeTotal" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="total" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="commissionPeriod" edit="true" fieldAttributes="disabled">
			<hb:HibachiPropertyDisplay object="#rc.order#" property="personalVolumeTotal" edit="true" fieldAttributes="disabled">
		</hb:HibachiPropertyList>
		
		
		<!---
		<hb:HibachiPropertyList divclass="col-md-6">
			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList divclass="col-md-6">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="subTotal" edit="false" displayType="table">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="taxTotal" edit="false" displayType="table">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="discountTotal" edit="false" displayType="table">
				</hb:HibachiPropertyList>
				<hb:HibachiPropertyList divclass="col-md-6" edit="false">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="orderNumber" edit="false" displayType="table" valuelink="#getHibachiScope().buildURL(action=rc.entityActionDetails.detailAction, queryString='orderID=#rc.order.getOrderID()#')#" title="#$.slatwall.rbKey('entity.order')#">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="fulfillmentTotal" edit="false" displayType="table">
					<hb:HibachiPropertyDisplay object="#rc.order#" property="total" edit="false" displayType="table" titleClass="table-total" valueClass="table-total">
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>

			<hb:HibachiPropertyRow>
				<hb:HibachiPropertyList divclass="col-md-6">
					<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="fullName" edit="false" displayType="table" valuelink="#getHibachiScope().buildURL(action='entity.detailAccount', queryString='accountID=#rc.order.getAccount().getAccountID()#')#" title="#$.slatwall.rbKey('entity.account')#">
					<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="company" edit="false" displayType="table">
				</hb:HibachiPropertyList>

				<hb:HibachiPropertyList divclass="col-md-6" edit="false">
					<hb:HibachiPropertyDisplay object="#rc.order.getAccount()#" property="distributorID" edit="false" displayType="table">
				</hb:HibachiPropertyList>
			</hb:HibachiPropertyRow>
		</hb:HibachiPropertyList>	
		--->

			<!--- <hb:HibachiPropertyTable>
				<hb:HibachiPropertyTableBreak header="#getHibachiScope().rbKey('admin.entity.detailorder.overview')#" />
				<hb:HibachiPropertyTableBreak header="Customer Information" />
			</hb:HibachiPropertyTable> --->

	</hb:HibachiPropertyRow>
</cfoutput>