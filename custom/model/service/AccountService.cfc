component extends="Slatwall.model.service.AccountService" {

	public any function processAccount_applyReferAFriendGiftCard(required any account, any processObject){

		var newGiftCard = getGiftCardService().newGiftCard(); 
		var createGiftCardProcessObject = newGiftCard.getProcessObject('create'); 

		createGiftCardProcessObject.setCurrencyCode(arguments.processObject.getCurrencyCode());
		createGiftCardProcessObject.setOwnerAccount(arguments.account); 

		newGiftCard = getGiftCardService().processGiftCard_Create(newGiftCard,createGiftCardProcessObject);  

		var creditGiftCardProcessObject = newGiftCard.getProcessObject('addCredit'); 

		creditGiftCardProcessObject.setCreditAmount(arguments.processObject.getGiftCardAmount());

		newGiftCard = getGiftCardService().processGiftCard_addCredit(newGiftCard, creditGiftCardProcessObject);

		if(newGiftCard.hasErrors()){
			arguments.account.addErrors(newGiftCard.getErrors());
		} else {
			arguments.account = this.saveAccount(arguments.account);  
		} 

		return arguments.account; 
	} 

}
