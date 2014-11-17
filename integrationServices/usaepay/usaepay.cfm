<!--- ColdFusion v.2.0 --->

<!----------------------------------------------------------------------
  Set defaults for common parameters
  
  You can find definition of all these parameters on http://www.usaepay.com
  ---------------------------------------------------------------------->
<!-- Required for all transactions ---->
<cfparam name="attributes.queryname" default="q_auth">
<cfparam name="attributes.key" default="">
<cfparam name="attributes.pin" default="">
<cfparam name="attributes.amount" default="">
<cfparam Name="attributes.invoice" default="">
<cfparam Name="attributes.testmode" default="false">
<cfparam Name="attributes.url" default="https://www.usaepay.com/gate.php">

<!-- Required for Commercial Card support ----->
<cfparam name="attributes.ponum" default="">
<cfparam name="attributes.tax" default="">
<cfparam name="attributes.nontaxable" default="">

<!-- Amount details (optional) ----->
<cfparam name="attributes.shipping" default="">
<cfparam name="attributes.discount" default="">
<cfparam name="attributes.subtotal" default="">
<cfparam Name="attributes.tip" default="">
<cfparam name="attributes.allowpartialauth" default="">
<cfparam name="attributes.currency" default="">

<!-- Required Fields for Card Not Present transacitons (Ecommerce) ---->
<cfparam Name="attributes.card" default="">
<cfparam Name="attributes.expdate" default="">
<cfparam Name="attributes.cardholder" default="">
<cfparam Name="attributes.street" default="">
<cfparam Name="attributes.zip" default="">

<!--Fields for Card Present (POS) -->
<cfparam Name="attributes.magstripe" default="">
<cfparam Name="attributes.cardpresent" default="false">
<cfparam Name="attributes.termtype" default="">
<cfparam Name="attributes.magsupport" default="">
<cfparam Name="attributes.contactless" default="">
<cfparam Name="attributes.dukpt" default="">
<cfparam Name="attributes.signature" default="">

<!-- fields required for check transactions -->
<cfparam name="attributes.routing" default="">
<cfparam name="attributes.account" default="">
<cfparam name="attributes.ssn" default="">
<cfparam name="attributes.dlnum" default="">
<cfparam name="attributes.dlstate" default="">
<cfparam name="attributes.checknum" default="">
<cfparam name="attributes.checkformat" default="">
<cfparam name="attributes.checkimagefront" default="">
<cfparam name="attributes.checkimageback" default="">
<cfparam name="attributes.auxonus" default="">
<cfparam name="attributes.epccode" default="">
<cfparam name="attributes.accounttype" default="">

<!-- Fields required for Secure Vault Payments (Direct Pay)--->
<cfparam name="attributes.svpbank" default="">
<cfparam name="attributes.svpreturnurl" default="">
<cfparam name="attributes.svpcancelurl" default="">

<!--Option parameters  ----->
<cfparam name="attributes.origauthcode" default="">
<cfparam name="attributes.command" default="sale">
<cfparam name="attributes.orderid" default="">
<cfparam Name="attributes.custid" default="">
<cfparam name="attributes.description" default="Online Order">
<cfparam Name="attributes.cvv" default="">
<cfparam name="attributes.custemail" Default="">
<cfparam name="attributes.custReceipt" default="">
<cfparam name="attributes.custReceiptName" default="">
<cfparam name="attributes.ignoreduplicate" default="">
<cfparam Name="attributes.clientip" default="">
<cfparam name="attributes.sandbox" default="false">
<cfparam name="attributes.timeout" default="45">

<!-- Card Authorization - Verified By Visa and Mastercard SecureCode --->
<cfparam name="attributes.cardauth" default="">
<cfparam name="attributes.pares" default="">
<cfparam name="attributes.xid" default="">
<cfparam name="attributes.cavv" default="">
<cfparam name="attributes.eci" default="">

<!-- Customer Database -->
<cfparam name="attributes.addcustomer" default="">
<cfparam name="attributes.schedule" default="">
<cfparam name="attributes.numleft" default="">
<cfparam name="attributes.start" default="">
<cfparam name="attributes.end" default="">
<cfparam name="attributes.billamount" default="">
<cfparam name="attributes.billtax" default="">
<cfparam name="attributes.billsourcekey" default="">

<!-- Billing Fields -->
<cfparam name="attributes.billfname" default="">
<cfparam name="attributes.billlname" default="">
<cfparam name="attributes.billcompany" default="">
<cfparam name="attributes.billstreet" default="">
<cfparam name="attributes.billstreet2" default="">
<cfparam name="attributes.billcity" default="">
<cfparam name="attributes.billstate" default="">
<cfparam name="attributes.billzip" default="">
<cfparam name="attributes.billcountry" default="">
<cfparam name="attributes.billphone" default="">
<cfparam name="attributes.email" default="">
<cfparam name="attributes.fax" default="">
<cfparam name="attributes.website" default="">

<!-- Shipping fields -->
<cfparam name="attributes.shipfname" default="">
<cfparam name="attributes.shiplname" default="">
<cfparam name="attributes.shipcompany" default="">
<cfparam name="attributes.shipstreet" default="">
<cfparam name="attributes.shipstreet2" default="">
<cfparam name="attributes.shipcity" default="">
<cfparam name="attributes.shipstate" default="">
<cfparam name="attributes.shipzip" default="">
<cfparam name="attributes.shipcountry" default="">
<cfparam name="attributes.shipphone" default="">
<cfparam name="attributes.custreceiptname" default="">

<!-- Custom fields -->
<cfparam name="attributes.custom1" default="">
<cfparam name="attributes.custom2" default="">
<cfparam name="attributes.custom3" default="">
<cfparam name="attributes.custom4" default="">
<cfparam name="attributes.custom5" default="">
<cfparam name="attributes.custom6" default="">
<cfparam name="attributes.custom7" default="">
<cfparam name="attributes.custom8" default="">
<cfparam name="attributes.custom9" default="">
<cfparam name="attributes.custom10" default="">
<cfparam name="attributes.custom11" default="">
<cfparam name="attributes.custom12" default="">
<cfparam name="attributes.custom13" default="">
<cfparam name="attributes.custom14" default="">
<cfparam name="attributes.custom15" default="">
<cfparam name="attributes.custom16" default="">
<cfparam name="attributes.custom17" default="">
<cfparam name="attributes.custom18" default="">
<cfparam name="attributes.custom19" default="">
<cfparam name="attributes.custom20" default="">

<!--Line items  --->
<cfloop from="1" to="100" index="i">
<cfparam name="attributes.lineitem#i#sku" default="">
<cfparam name="attributes.lineitem#i#name" default="">
<cfparam name="attributes.lineitem#i#description" default="">
<cfparam name="attributes.lineitem#i#cost" default="">
<cfparam name="attributes.lineitem#i#qty" default="">
<cfparam name="attributes.lineitem#i#taxable" default="">
</cfloop>

<!--Split payments--->
<cfloop from="2" to="10" index="i">
<cfparam name="attributes.key#i#" default="">
<cfparam name="attributes.amount#i#" default="">
<cfparam Name="attributes.invoice#i#" default="">
<cfparam name="attributes.command#i#" default="sale">
<cfparam name="attributes.orderid#i#" default="">
<cfparam name="attributes.description#i#" default="">
<cfparam Name="attributes.cvv#i#" default="">

<cfparam name="attributes.result#i#" default="Error">
<cfparam name="attributes.resultcode#i#" default="E">
<cfparam name="attributes.refNum#i#" default="">
<cfparam name="attributes.authCode#i#" default="">
</cfloop>
<cfparam Name="attributes.onerror" default="stop">

<cfparam name="attributes.comments" default="">
<cfparam name="attributes.software" default="USAePay Coldfusion Library v2.0">

<!-- Response fields --->
<cfparam name="attributes.refNum" default="">
<cfparam name="attributes.authCode" default="">

<cfparam name="attributes.custnum" default="">
<cfparam name="attributes.authamount" default="">
<cfparam name="attributes.balance" default="">
<cfparam name="attributes.cardlevelresult" default="">
<cfparam name="attributes.procrefnum" default="">

<cfparam name="attributes.redir" default="">
<cfparam name="attributes.redirApproved" default="">
<cfparam name="attributes.redirDeclined" default="">
<cfparam name="attributes.echofields" default="">




<!----------------------------------------------------------------------
  Format variables to ePay specs before validating.
  ---------------------------------------------------------------------->

<cfset attributes.card = REreplace(attributes.card, "[^0-9]", "", "ALL")>
<cfset attributes.expdate = REreplace(attributes.expdate, "[^0-9]", "", "ALL")>
  

<!----------------------------------------------------------------------
  Check for required variables before sending to ePay
  ---------------------------------------------------------------------->

<cfif attributes.key LTE "                                ">
<center>Source key is required</center>
<cfabort>
</cfif>

<cfset lineitems = ArrayNew(1)> 
<cfloop from="1" to="5" index="i">
<cfif evaluate("attributes.lineitem"&i&"sku") GTE "                                ">
<cfset lineitems[i] = StructNew()>
<cfset lineitems[i].sku = evaluate("attributes.lineitem"&i&"sku")>
<cfset lineitems[i].name = evaluate("attributes.lineitem"&i&"name")>
<cfset lineitems[i].description = evaluate("attributes.lineitem"&i&"description")>
<cfset lineitems[i].cost = evaluate("attributes.lineitem"&i&"cost")>
<cfset lineitems[i].qty = evaluate("attributes.lineitem"&i&"qty")>
<cfset lineitems[i].taxable = evaluate("attributes.lineitem"&i&"taxable")>
</cfif>
</cfloop>


<cfswitch expression="#attributes.command#">
<cfcase value="cc:capture,cc:refund,refund,check:refund,capture,creditvoid" delimiters=",">
<cfif attributes.refNum LTE "                                ">
 <center>Reference Number is required</center>
 <cfabort>
 </cfif>
</cfcase>
<cfcase value="check:sale,check:credit,check,checkcredit" delimiters=",">
<cfif attributes.routing LTE "                                " OR
 	 	attributes.account LTE "                                " OR
 	 	attributes.cardholder LTE "                                ">
	   <center>Check information is required</center>
       <cfabort>
 </cfif>
</cfcase>
<cfdefaultcase>
<cfif attributes.magstripe LTE "                                ">
	<cfif attributes.card LTE "                                " OR
	   attributes.expdate LTE "                                ">
	  <center>Credit card information is required</center>
       <cfabort>
 	</cfif>
</cfif>
</cfdefaultcase>
</cfswitch> 

<cfif attributes.amount LTE "                                " OR
	  attributes.invoice LTE "                                ">	
      <center>Error missing parameter</center>	
      <cfabort>
</cfif>

<cfif attributes.sandbox IS "yes">
	  <cfset attributes.url="https://sandbox.usaepay.com/gate.php">
      <cfelse><cfset attributes.url="https://www.usaepay.com/gate.php">
</cfif>

<!--------------------------------------------------------------------------
 Create hash if pin has been set.
--------------------------------------------------------------------------->	
<cfset UMhash="">	
<cfif attributes.pin GTE "                                ">    
		<!-- generate random seed value-->
		<!--- Create a random number. --->   
		<cfset randomnum=RAND()*1000000000> 
        <!--- Concatenate the first random number, the time and date > stamp, and > the second random number. ---> 
		<cfset seed="#randomnum#">
			
		<!-- assemble prehash data-->
		<cfset prehash = attributes.command & ":" & trim(attributes.pin) & ":" & attributes.amount & ":" & attributes.invoice & ":" & seed>
			
		<!-- create sha1 hash -->
		<cfset UMhash = "s/" & seed & "/" & hash(prehash, "SHA") & "/n">		
</cfif>		

<cfif attributes.nontaxable is "yes">    
		<cfset attributes.nontaxable = "Y">				
</cfif>		

<cfif attributes.checkimagefront GTE "                                "> 
      <cfset attributes.checkimagefront = ToBase64(attributes.checkimagefront)> 
      <cfset attributes.checkimageencoding = "base64">	
</cfif>
		
<cfif attributes.checkimageback GTE "                                "> 
      <cfset attributes.checkimageback = ToBase64(attributes.checkimageback)>
      <cfset attributes.checkimageencoding = "base64">	
</cfif>

<cfif attributes.billsourcekey GTE "                                "> 
      <cfset attributes.billsourcekey = "yes"> 
</cfif>

<cfif attributes.cardpresent GTE "                                "> 
      <cfset attributes.cardpresent = "1"> 
</cfif>

<cfif attributes.allowpartialauth is true> 
      <cfset attributes.allowpartialauth = "1">
</cfif>
 
<!----------------------------------------------------------------------
  Post to USA ePay
  ---------------------------------------------------------------------->

<CFHTTP METHOD="Post" URL="#attributes.url#">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.key#"
        NAME="UMkey">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.command#"
        NAME="UMcommand">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.origauthcode#"
        NAME="UMauthCode">   
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.card#"
        NAME="UMcard">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.expdate#"
        NAME="UMexpir">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billAmount#"
        NAME="UMbillamount">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.amount#"
        NAME="UMamount">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.invoice#"
        NAME="UMinvoice">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.orderid#"
        NAME="UMorderid">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.ponum#"
        NAME="UMponum">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.tax#"
        NAME="UMtax">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.nontaxable#"
        NAME="UMnontaxable">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.tip#"
        NAME="UMtip">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipping#"
        NAME="UMshipping">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.discount#"
        NAME="UMdiscount">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.subtotal#"
        NAME="UMsubtotal">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.currency#"
        NAME="UMcurrency">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.cardholder#"
        NAME="UMname">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.street#"
        NAME="UMstreet">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.zip#"
        NAME="UMzip">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.description#"
        NAME="UMdescription">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.comments#"
        NAME="UMcomments">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.cvv#"
        NAME="UMcvv2">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.clientip#"
        NAME="UMip">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.clientip#"
        NAME="UMip">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.email#"
        NAME="UMcustemail">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custReceipt#"
        NAME="UMcustreceipt">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.routing#"
        NAME="UMrouting">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.account#"
        NAME="UMaccount">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.ssn#"
        NAME="UMssn">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.dlnum#"
        NAME="UMdlnum">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.dlstate#"
        NAME="UMdlstate">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.checknum#"
        NAME="UMchecknum">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.accounttype#"
        NAME="UMaccounttype">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.checkformat#"
        NAME="UMcheckformat">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.checkimageback#"
        NAME="UMcheckimageback">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.checkimagefront#"
        NAME="UMcheckimagefront">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.addcustomer#"
        NAME="UMaddcustomer">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billtax#"
        NAME="UMbilltax">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.schedule#"
        NAME="UMschedule">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.numleft#"
        NAME="UMnumleft">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.start#"
        NAME="UMstart">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billsourcekey#"
        NAME="UMbillsourcekey">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billfname#"
        NAME="UMbillfname">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billlname#"
        NAME="UMbilllname">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billcompany#"
        NAME="UMbillcompany">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billstreet#"
        NAME="UMbillstreet">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billstreet2#"
        NAME="UMbillstreet2">
   	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billcity#"
        NAME="UMbillcity">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billstate#"
        NAME="UMbillstate">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billzip#"
        NAME="UMbillzip">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billcountry#"
        NAME="UMbillcountry">
	  <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.billphone#"
        NAME="UMbillphone">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.email#"
        NAME="UMemail">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.fax#"
        NAME="UMfax">
	 <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.website#"
        NAME="UMwebsite">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipfname#"
        NAME="UMshipfanme">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shiplname#"
        NAME="UMshiplname">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipcompany#"
        NAME="UMshipcompany">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipstreet#"
        NAME="UMshipstreet">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipstreet2#"
        NAME="UMshipstreet2">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipcity#"
        NAME="UMshipcity">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipstate#"
        NAME="UMshipstate">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipzip#"
        NAME="UMshipzip">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipcountry#"
        NAME="UMshipcountry">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.shipphone#"
        NAME="UMshipphone">    
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.cardauth#"
        NAME="UMcardauth">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.pares#"
        NAME="UMpares">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.xid#"
        NAME="UMxid">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.cavv#"
        NAME="UMcavv">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.eci#"
        NAME="UMeci">	
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custid#"
        NAME="UMcustid">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.cardpresent#"
        NAME="UMcardpresent">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.magstripe#"
        NAME="UMmagstripe">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.dukpt#"
        NAME="UMdukpt">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.termtype#"
        NAME="UMtermtype">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.magsupport#"
        NAME="UMmagsupport">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.contactless#"
        NAME="UMcontactless">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.signature#"
        NAME="UMsignature">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.software#"
        NAME="UMsoftware">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.ignoreduplicate#"
        NAME="UMignoreduplicate">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#UMhash#"
        NAME="UMhash">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.refNum#"
        NAME="UMrefNum">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.auxonus#"
        NAME="UMauxonus">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.epccode#"
        NAME="UMepccode">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custreceiptname#"
        NAME="UMcustreceiptname">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.allowpartialauth#"
        NAME="UMallowpartialauth">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.redir#"
        NAME="UMredir">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.redirApproved#"
        NAME="UMredirApproved">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.redirDeclined#"
        NAME="UMredirDeclined">
	<CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.echofields#"
        NAME="UMechofields">       
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom1#"
        NAME="UMcustom1">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom2#"
        NAME="UMcustom2">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom3#"
        NAME="UMcustom3">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom4#"
        NAME="UMcustom4">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom5#"
        NAME="UMcustom5">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom6#"
        NAME="UMcustom6">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom7#"
        NAME="UMcustom7">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom8#"
        NAME="UMcustom8">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom9#"
        NAME="UMcustom9">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom10#"
        NAME="UMcustom10">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom11#"
        NAME="UMcustom11">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom12#"
        NAME="UMcustom12">
    <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom13#"
        NAME="UMcustom13">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom14#"
        NAME="UMcustom14">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom15#"
        NAME="UMcustom15">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom16#"
        NAME="UMcustom16">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom17#"
        NAME="UMcustom17">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom18#"
        NAME="UMcustom18">
     <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom19#"
        NAME="UMcustom19">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.custom20#"
        NAME="UMcustom20">
      <cfloop from="1" to="#ArrayLen(lineitems)#" index="i">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].sku#"
        NAME="UMline#i#sku">
      <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].name#"
        NAME="UMline#i#name">
       <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].description#"
        NAME="UMline#i#description">
       <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].cost#"
        NAME="UMline#i#cost">
       <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].qty#"
        NAME="UMline#i#qty">
       <CFHTTPPARAM TYPE="Formfield"
        VALUE="#lineitems[i].taxable#"
        NAME="UMline#i#taxable">
      </cfloop>
      <cfloop from="2" to="9" index="i">
        <cfif evaluate("attributes.key"&i) GTE "                                ">
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.key"&i)#"
        NAME="UM0#i#key"> 
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.amount"&i)#"
        NAME="UM0#i#amount">   
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.invoice"&i)#"
        NAME="UM0#i#invoice"> 
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.command"&i)#"
        NAME="UM0#i#command">
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.orderid"&i)#"
        NAME="UM0#i#orderid">     
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.description"&i)#"
        NAME="UM0#i#description">    
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.cvv"&i)#"
        NAME="UM0#i#cvv">   
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.result"&i)#"
        NAME="UM0#i#result">     
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.resultcode"&i)#"
        NAME="UM0#i#resultcode">   
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.refnum"&i)#"
        NAME="UM0#i#refnum">
        <CFHTTPPARAM TYPE="Formfield"
        VALUE="#evaluate("attributes.authCode"&i)#"
        NAME="UM0#i#authCode">
        </cfif>
       </cfloop>
       <CFHTTPPARAM TYPE="Formfield"
        VALUE="#attributes.onerror#"
        NAME="UMonError">
	   
</CFHTTP>

 <!----------------------------------------------------------------------
  Create a local query object for result
  ---------------------------------------------------------------------->

 <cfset q_auth =QueryNew("UMversion,UMstatus,UMauthCode,UMrefNum,UMavsResult,UMavsResultCode,UMcvv2Result,UMcvv2ResultCode,UMresult,UMerror,UMfiller")>
 <cfset nil = QueryAddRow(q_auth)>

<cfif ListLen(cfhttp.FileContent,",") IS 0>
  <cfset nil = QuerySetCell( q_auth, "UMstatus", "Error")>
  <cfset nil = QuerySetCell( q_auth, "UMauthCode", "000000")>
  <cfset nil = QuerySetCell( q_auth, "UMavsResult", "Invalid Response from USA ePay")>
  <cfset nil = QuerySetCell( q_auth, "UMavsResultCode", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMcvv2Result", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMcvv2ResultCode", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMrefNum", "000000")>
  <cfset nil = QuerySetCell( q_auth, "UMversion", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMresult", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMerror", "n/a")>
  <cfset nil = QuerySetCell( q_auth, "UMfiller", "n/a")>
<cfelse>
  <cfloop index = "i" list = "#cfhttp.FileContent#" delimiters = "&">
      <cfset responseHash = ArrayNew(1)>
      <cfset responseHash = ListToArray(i,"=")>
      <cfif responseHash[1] IS "UMstatus">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMstatus", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMstatus","Error")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMauthCode">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMauthCode", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMauthCode","000000")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMavsResult">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMavsResult", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMavsResult","Invalid Response from USA ePay")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMavsResultCode">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMavsResultCode", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMavsResultCode","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMcvv2Result">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMcvv2Result", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMcvv2Result","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMcvv2ResultCode">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMcvv2ResultCode", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMcvv2ResultCode","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMrefNum">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMrefNum", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMrefNum","000000")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMversion">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMversion", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMversion","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMresult">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMresult", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMresult","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMerror">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMerror", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMerror","n/a")>
           </cfcatch>
           </cftry>
      </cfif>

      <cfif responseHash[1] IS "UMfiller">
          <cftry>
  	<cfset nil = QuerySetCell( q_auth, "UMfiller", URLDecode(responseHash[2]))>
          <cfcatch>
  	<cfset nil = QuerySetCell( q_auth, "UMfiller","n/a")>
           </cfcatch>
           </cftry>
      </cfif>
  </cfloop>
</cfif>

 <!----------------------------------------------------------------------
  Set caller query object
  ---------------------------------------------------------------------->
 <CFSET "Caller.#attributes.queryname#" = #q_auth#>


