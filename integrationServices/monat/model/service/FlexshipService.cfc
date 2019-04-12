component extends="Slatwall.org.Hibachi.HibachiService" accessors="true" output="false" {

	property name="OrderService";
	property name="TypeService"; 

	public any function processFlexshipSurveyResponse_Create(any flexshipSurveyResponse, any processObject, struct data={}){
		
		if(!structKeyExists(arguments.data, 'orderTemplateID')){
			return arguments.flexshipSurveyResponse;
		}

		var orderTemplate = getOrderService().getOrderTemplate(arguments.data.orderTemplateID); 
		var reasonForChangeType = getTypeService().getType(arguments.data.orderTemplateScheduleDateChangeReasonTypeID);

		arguments.flexshipSurveyResponse.setOrderTemplate(orderTemplate);
		arguments.flexshipSurveyResponse.setAccount(orderTemplate.getAccount()); 
		arguments.flexshipSurveyResponse.setOrderTemplateScheduleDateChangeReasonType(reasonForChangeType);  

		if(structKeyExists(arguments.data, 'otherScheduleDateChangeReasonNotes')){
			arguments.flexshipSurveyResponse.setOtherScheduleDateChangeReasonNotes(arguments.data.otherScheduleDateChangeReasonNotes); 
		}

		arguments.flexshipSurveyResponse = this.saveFlexshipSurveyResponse(arguments.flexshipSurveyResponse);

		return arguments.flexshipSurveyResponse; 
	} 
}
