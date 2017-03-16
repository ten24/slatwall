<cfparam name="rc.orderSmartList" type="any" />

<cfoutput>
<cf_HibachiEntityActionBar type="listing" pageTitle="Amazon S3 Order Listing" object="#rc.orderSmartList#" showCreate="false">
</cf_HibachiEntityActionBar>

<cf_HibachiListingDisplay smartList="#rc.orderSmartList#"
	recordDetailAction="s3:admin.detailorder">

	<cf_HibachiListingColumn propertyIdentifier="orderNumber" />
	<cf_HibachiListingColumn propertyIdentifier="orderOpenDateTime" />
	<cf_HibachiListingColumn propertyIdentifier="account.firstName" />
	<cf_HibachiListingColumn propertyIdentifier="account.lastName" />
	<cf_HibachiListingColumn tdclass="primary" propertyIdentifier="account.company" />
	<cf_HibachiListingColumn propertyIdentifier="orderType.type" />
	<cf_HibachiListingColumn propertyIdentifier="orderStatusType.type" title="#$.slatwall.rbKey('define.status')#" />
	<cf_HibachiListingColumn propertyIdentifier="createdDateTime" />
	<cf_HibachiListingColumn propertyIdentifier="calculatedTotal" />
</cf_HibachiListingDisplay>
</cfoutput>