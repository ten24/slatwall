component{
	
	property name="currentFlexship" type="any" cfc="OrderTemplate" fieldtype="many-to-one" fkcolumn="currentFlexshipID"; 
	property name="countryCode" ormtype="string";
	
	public any function getCountryCode(){
		if(structKeyExists(variables, 'countryCode')){
			return variables.countryCode;
		}
		
		var currentIPAddress = listLast(getRemoteAddress());
		if(len(currentIPAddress)){
			var ips_parts = ListToArray(currentIPAddress, ".");
			var ipNumber = ( ( 16777216 * ips_parts[1] ) + ( 65536 * ips_parts[2] ) + ( 256 * ips_parts[3] ) + ips_parts[4] );
			
			var geoIpQuery = new query();
			geoIpQuery.setSQL('SELECT country_code FROM ip2location  WHERE ip_from <= :ip_number AND ip_to >= :ip_number');
			geoIpQuery.addParam(name="ip_number",value=ipNumber);
			var queryResult = geoIpQuery.execute().getResult();
			if(queryResult.recordCount){
				variables.countryCode = queryResult.country_code;
				return variables.countryCode
			}
		}
		return 'UNK';
	}

}
