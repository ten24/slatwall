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
	    if( isNull(variables.dateTimeSince) ){
	        variables.dateTimeSince = DateTimeFormat( 
	            DateAdd('h', -2, now() ), // since 2 hours ago  ---  https://cfdocs.org/dateadd
	            'medium' // mmm d, yyyy h:nn:ss tt
	        );
	    }
	    return variables.dateTimeSince;
	}
	

}