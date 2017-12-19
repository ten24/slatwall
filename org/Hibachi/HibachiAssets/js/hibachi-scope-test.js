
$.slatwall = new Hibachi(
	{"rbLocale":"en_us","timeFormat":"hh:mm tt","applicationKey":"Slatwall",
	"instantiationKey":"C982DA60-BB85-DB60-F5913BC68E4584D6",
	"debugFlag":true,
	"action":"slataction",
	"dateFormat":"mmm dd, yyyy",
	"baseURL":"http://cf10.slatwall"});

$.slatwall['instantiationKey']="C982DA60-BB85-DB60-F5913BC68E4584D6";
$.slatwall['debugFlag']=true;
$.slatwall['action']="slataction";
$.slatwall['dateFormat']="mmm dd, yyyy";
$.slatwall['baseUrl']="http://cf10.slatwall";
$.slatwall['rbLocale']="en_us";
$.slatwall['timeFormat']="hh:mm tt";
$.slatwall['applicationKey']="Slatwall";
var hibachiConfig = $.slatwall.getConfig();
hibachiConfig.baseURL = 'http://cf10.slatwall';
var appConfig = hibachiConfig;