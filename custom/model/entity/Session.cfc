component{
	
	property name="currentFlexship" type="any" cfc="OrderTemplate" fieldtype="many-to-one" fkcolumn="currentFlexshipID"; 
	property name="countryCode" ormtype="string";
	
	public any function getCountryCode(){
		if(structKeyExists(variables, 'countryCode')){
			return variables.countryCode;
		}
		
		if(getHibachiScope().getApplicationValue('applicationEnvironment') == 'local'){
			variables.countryCode = 'US';
			return variables.countryCode;
		}
		
		if(getHibachiScope().hasSessionValue('requestCountryOrigin')){
			variables.countryCode = getHibachiScope().getSessionValue('requestCountryOrigin');
			return variables.countryCode;
		}
		
		var currentIPAddress = listFirst(getRemoteAddress());
		if(len(currentIPAddress) && !IsIPv6(currentIPAddress)){

			var ips_parts = ListToArray(currentIPAddress, ".");
			var ipNumber =   16777216 * ips_parts[1] + 65536 * ips_parts[2] + 256 * ips_parts[3] + ips_parts[4];
			var geoIpQuery = new query();
			geoIpQuery.setSQL('SELECT country_code FROM ip2location  WHERE ip_from <= :ip_number AND ip_to >= :ip_number');
			geoIpQuery.addParam(name="ip_number",value=ipNumber);
			var queryResult = geoIpQuery.execute().getResult();
			if(queryResult.recordCount){
				variables.countryCode = queryResult.country_code;
				getHibachiScope().setSessionValue('requestCountryOrigin', variables.countryCode);
				return variables.countryCode;
			}else{
				getHibachiScope().setSessionValue('requestCountryOrigin', 'US');
			}
		}
		return 'US';
	}
	
	public void function preInsert(){
		super.preInsert();
		getCountryCode();
	}

}
