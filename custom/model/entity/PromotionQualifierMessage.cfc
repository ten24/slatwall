component{
    property name="qualifierProgressTemplate" ormtype="string";
    property name="qualifierProgress" type="integer" persistent="false";

    public any function getQualifierProgress(required any order){
        if(!structKeyExists(variables,'qualifierProgress') && structKeyExists(variables,'qualifierProgressTemplate')){
            var qualifierProgress = getInterpolatedField(arguments.order,getQualifierProgressTemplate());
            if(!isNull(qualifierProgress) && isNumeric(qualifierProgress)){
                variables.qualifierProgress = round(qualifierProgress);
            }
        }
        if(structKeyExists(variables,'qualifierProgress')){
            return variables.qualifierProgress;
        }
    }
    
	public string function getInterpolatedField(required any order, required fieldValue){
		var returnValue = arguments.order.stringReplace(arguments.fieldValue,false,true);
		var orderRecord = getOrderDataFromRequirementsCollection(arguments.order.getOrderID());
		orderRecord['calculatedPurchasePlusTotal'] = arguments.order.getPurchasePlusTotal();
		returnValue = getService('HibachiUtilityService').replaceStringTemplateFromStruct(returnValue,orderRecord);
    	returnValue = getService('HibachiUtilityService').replaceFunctionTemplate(returnValue);
    	return returnValue;
	}	
	
}