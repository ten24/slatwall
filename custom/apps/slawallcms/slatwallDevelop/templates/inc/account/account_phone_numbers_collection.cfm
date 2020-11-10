<!--- Phone Numbers Collection --->
<cfset local.phoneNumbersCollection = $.slatwall.getService("accountService").getAccountPhoneNumberCollectionList() />
<cfset local.phoneNumbersCollection.addFilter("account.accountID", "#$.slatwall.account().getAccountID()#", "=") /> 
<cfset local.phoneNumbersCollection.addDisplayProperty('createdByAccountID') />
<cfset local.phoneNumbersCollection.addDisplayProperty('createdDateTime|DESC') />
<cfset local.phoneNumbersCollection.applyData()>
<cfset local.phoneNumbersCollection.setPageRecordsShow(10)>
<cfset local.phoneNumbers = local.phoneNumbersCollection.getPageRecords() />



