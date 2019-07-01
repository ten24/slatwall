component {

	property name="personalVolumeTotal" persistent="false"; 
	
	public numeric function getPersonalVolumeTotal(){
		if(!structKeyExists(variables, 'personalVolumeTotal')){
			variables.personalVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getSku().getPersonalVolume()) && 
				!isNull(this.getQuantity())
			){
				variables.personalVolumeTotal += (this.getSku().getPersonalVolume() * this.getQuantity()); 
			}	
		}
		return variables.personalVolumeTotal; 	
	} 
}
