component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="tracker" hb_formFieldType="select";
    property name="dateTimeSince" hb_formFieldType="datetime";
    
	public array function getTrackerOptions() {
		var options = [
			{name="Accounts", value="accounts"},
			{name="Orders", value="orders"},
			{name="Order Items", value="orderItems"},
			{name="Order Payments", value="orderPayments"},
			{name="Order Deliveries", value="orderDeliveries"},
		];
		return options;
	}
	
	public any function getDateTimeSince(){
	    if(isNull(variables.dateTimeSince)){
	        variables.dateTimeSince = dateTimeFormat( 
	            DateAdd('n', -10, now() ), 
	            'medium' 
	       ); // since 10 minutes ago
	    }
	    return variables.dateTimeSince;
	}
	

}