component output="false" accessors="true" extends="Slatwall.org.Hibachi.HibachiProcess" {

    //injected properties
	property name="integration";

    // data-properties
    property name="erpQuery" hb_formFieldType="textarea";
    property name="columns" default="*";
    property name="amountPerPage" default="10";
    property name="offset" default="0";
	

}