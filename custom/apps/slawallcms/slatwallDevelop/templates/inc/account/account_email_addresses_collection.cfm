<!--- Phone Numbers Collection --->
<cfset local.emailAddressesCollection = $.slatwall.getService("accountService").getAccountEmailAddressCollectionList() />
<cfset local.emailAddressesCollection.addFilter("account.accountID", "#$.slatwall.account().getAccountID()#", "=") /> 
<cfset local.emailAddressesCollection.addDisplayProperty('createdByAccountID') />
<cfset local.emailAddressesCollection.addDisplayProperty('createdDateTime|DESC') />
<cfset local.emailAddressesCollection.applyData()>
<cfset local.emailAddressesCollection.setPageRecordsShow(10)>
<cfset local.emailAddresses = local.emailAddressesCollection.getPageRecords() />

