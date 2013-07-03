component output="false" accessors="true" extends="HibachiProcess" {
	
	// Injected Entity
	property name="accountPaymentMethod";

	// Data Properties
	property name="amount";
	property name="transactionType" hb_formFieldType="select";
	
	// Option Properties
	property name="transactionTypeOptions";
	
	public array function getTransactionTypeOptions() {
		if(!structKeyExists(variables, "transactionTypeOptions")) {
			
			variables.transactionTypeOptions = [];
			
			if(getAccountPaymentMethod().getPaymentMethod().getPaymentMethodType() eq "creditCard") {
				arrayAppend(variables.transactionTypeOptions, {name=rbKey('define.generateToken'), value="generateToken"});
			}
			
		}
		return variables.transactionTypeOptions;
	}
	
	public numeric function getAmount() {
		if(!structKeyExists(variables, "amount")) {
			variables.amount = 0;
		}
		return variables.amount;
	}
		
}