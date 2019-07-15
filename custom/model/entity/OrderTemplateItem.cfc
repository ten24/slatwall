component {

	property name="commissionableVolumeTotal" persistent="false"; 
	property name="personalVolumeTotal" persistent="false"; 

	public numeric function getCommissionVolumeTotal(){
		if(!structKeyExists(variables, 'commissionVolumeTotal')){
			variables.commissionVolumeTotal = 0; 
			
			if( !isNull(this.getSku()) && 
				!isNull(this.getSku().getcommissionVolume()) && 
				!isNull(this.getQuantity())
			){
				variables.commissionVolumeTotal += (this.getSku().getCommissionVolume() * this.getQuantity()); 
			}	
		}
		return variables.commissionVolumeTotal; 	
	}	

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
