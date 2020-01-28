<cfoutput>
	<cfscript>
		try{
			var type = getHibachiScope().getService("typeService").getTypeByTypeID(emailTemplate.getAttributeValue('customerEmailHeader'));
			var content = getHibachiScope().getService("attributeService").getAttributeValueByType(type).getAttributeValue();		
		}catch(e){
			var content = '';
		}
		
	</cfscript>
	#content#
</cfoutput>