component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="tableName" hb_formFieldType="select";
    property name="enabled" hb_formFieldType="yesNo" default=true;
    
    
    
	public array function getTableNameOptions() {
		var options = [
			{name="Customer", value="customer"},
			{name="OE Head", value="oe_head"},
			{name="OE Line", value="oe_line"}
		];
		return options;
	}
	

}