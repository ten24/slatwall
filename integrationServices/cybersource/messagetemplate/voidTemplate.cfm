<cfoutput>
<merchantID>#requestMessageData.merchantID#</merchantID>
<merchantReferenceCode>#requestMessageData.merchantReferenceCode#</merchantReferenceCode>
<voidService run="true">
	<voidRequestID>#requestMessageData.voidRequestID#</voidRequestID>
</voidService>
</cfoutput>