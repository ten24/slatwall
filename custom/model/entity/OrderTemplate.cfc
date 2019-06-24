component {

	property name="personalVolumeTotal" persistent="false"; 


	public numeric function getPersonalVolumeTotal(){
	
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = 0; 

			var orderTemplateItems = this.getOrderTemplateItems();

			for(var orderTemplateItem in orderTemplateItems){ 
				variables.personalVolumeTotal += orderTemplateItem.getPersonalVolumeTotal();
			}
		}	
		return variables.personalVolumeTotal; 	
	} 
}
