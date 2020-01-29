	<cfscript>
		function getEmailContent(attributeValue){
				try{
			var type = getHibachiScope().getService("typeService").getTypeByTypeID(emailTemplate.getAttributeValue('customerEmailFooter'));
			var content = getHibachiScope().getService("attributeService").getAttributeValueByType(type).getAttributeValue();		
			}catch(e){
				var content = '';
			}
		}

		
	</cfscript>