/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/

component accessors="true" output="false" displayname="Endicia" implements="Slatwall.integrationServices.ShippingInterface" extends="Slatwall.integrationServices.BaseShipping" {
	
	public any function init() {
		// Insert Custom Logic Here 
		variables.shippingMethods = {
			First="First-Class Mail",
			Priority="Priority Mail",
			Express="Express Mail",
			LibraryMail="Library Mail",
			MediaMail="Media Mail",
			ParcelPost="Parcel Post",
			FirstClassMailInternational="First Class Mail International",
			PriorityMailInternational="Priority Mail International",
			ExpressMailInternational="Express Mail International"
		};
		
		return this;
	}
	
	public struct function getShippingMethods() {
		return variables.shippingMethods;
	}
	
	public string function getTrackingURL() {
		return "http://usps.com/Tracking?tracknumber=${trackingNumber}";
	}
	
	public any function getRates(required any requestBean) {
		var totalItemsWeight = 0;
		var totalItemsValue = 0;
		
		// Loop over all items to get a price and weight for shipping
		for(var i=1; i<=arrayLen(arguments.requestBean.getShippingItemRequestBeans()); i++) {
			if(isNumeric(arguments.requestBean.getShippingItemRequestBeans()[i].getWeight())) {
				totalItemsWeight +=	arguments.requestBean.getShippingItemRequestBeans()[i].getWeight();
			}
			 
			totalItemsValue += arguments.requestBean.getShippingItemRequestBeans()[i].getValue();
		}
		
		if(totalItemsWeight < 1) {
			totalItemsWeight = 1;
		}
		
		// Build Request XML
		var xmlPacket = "";
		
		savecontent variable="xmlPacket" {
			include "PostageRatesRequestTemplate.cfm";
        }
        
        // Setup Request to push to Endicia
        var httpRequest = new http();
        httpRequest.setMethod("POST");
		httpRequest.setPort("443");
		httpRequest.setTimeout(45);
		httpRequest.setUrl("https://www.envmgr.com/LabelService/EwsLabelService.asmx/CalculatePostageRatesXML");
		httpRequest.setResolveurl(false);
		
		httpRequest.addParam(type="header",name="Content-Type",VALUE="application/x-www-form-urlencoded");
		httpRequest.addParam(type="header",name="Content-Length",VALUE="#len(xmlPacket)#");
		
		httpRequest.addParam(type="body",value="postageRatesRequestXML=#trim(xmlPacket)#");
		
		var xmlResponse = XmlParse(REReplace(httpRequest.send().getPrefix().fileContent, "^[^<]*", "", "one"));
		
		var ratesResponseBean = new Slatwall.model.transient.fulfillment.ShippingRatesResponseBean();
		ratesResponseBean.setData(xmlResponse);
		
		if(isDefined('xmlResponse.Fault')) {
			// If XML fault then log error message
			ratesResponseBean.addMessage(messageName="communicationError", message="An unexpected communication error occured, please notify system administrator.");
			ratesResponseBean.addError("unknown", "An unexpected communication error occured, please notify system administrator.");
		} else {
			// Log all messages from Endicia into the response bean
			
			if(xmlResponse.PostageRatesResponse.Status.xmltext neq "0") {
				ratesResponseBean.addMessage(
					messageName=xmlResponse.PostageRatesResponse.Status.xmltext,
					message=xmlResponse.PostageRatesResponse.ErrorMessage.xmltext
				);
				ratesResponseBean.addError(
					xmlResponse.PostageRatesResponse.Status.xmltext,
					xmlResponse.PostageRatesResponse.ErrorMessage.xmltext
				);
			} else {
				ratesResponseBean.addMessage(
					"0",
					"Successful"
				);
			}
			
			if(!ratesResponseBean.hasErrors()) {
				for(var i=1; i<=arrayLen(xmlResponse.PostageRatesResponse.PostagePrice); i++) {
					var shippingMethod = xmlResponse.PostageRatesResponse.PostagePrice[i].MailClass.xmltext;
					//var shippingMethod = UCASE(Replace(Replace(xmlResponse.PostageRatesResponse.PostagePrice[i].Postage.MailService.xmltext, "-", "_", "all")," ", "_", "all"));
					ratesResponseBean.addShippingMethod(
						shippingProviderMethod=shippingMethod,
						totalCharge=xmlResponse.PostageRatesResponse.PostagePrice[i].Postage.XmlAttributes.TotalAmount
					);
				}
			}
			
		}
		return ratesResponseBean;
	}
	
	private numeric function convertPoundsToOunces(required numeric pounds) {
		return arguments.pounds * 16;
	}
	
	public string function getUSPSCountryFromCountryCode(required any countryCode) {
		var countries = {};
		
		countries.AD="Andorra";
		countries.AE="United Arab Emirates";
		countries.AF="Afghanistan";
		countries.AG="Antigua and Barbuda";
		countries.AI="Anguilla";
		countries.AL="Albania";
		countries.AM="Armenia";
		countries.AO="Angola";
		countries.AQ="Antarctica";
		countries.AR="Argentina";
		countries.AS="American Samoa";
		countries.AT="Austria";
		countries.AU="Australia";
		countries.AW="Aruba";
		countries.AX="Aland Island";
		countries.AZ="Azerbaijan";
		countries.BA="Bonsia and Herzegovia";
		countries.BB="Barbados";
		countries.BD="Bangladesh";
		countries.BE="Belgium";
		countries.BF="Burkina Faso";
		countries.BG="Bulgaria";
		countries.BH="Bahrain";
		countries.BI="Burundi";
		countries.BJ="Benin";
		countries.BL="Saint Barthelemy";
		countries.BM="Bermuda";
		countries.BN="Brunei Darussalam";
		countries.BO="Bolivia";
		countries.BQ="Bonaire, Sint Eustatuis and Saba";
		countries.BR="Brazil";
		countries.BS="Bahamas";
		countries.BT="Bhutan";
		countries.BV="Bouvet Island";
		countries.BW="Botswana";
		countries.BY="Belarus";
		countries.BZ="Belize";
		countries.CA="Canada";
		countries.CC="Cocos (Keeling) Islands";
		countries.CD="Congo, The Democratic Rebublic Of The";
		countries.CF="Central African Republic";
		countries.CG="Congo, Republic";
		countries.CH="Switzerland";
		countries.CI="Ivory Coast";
		countries.CK="Cook Islands";
		countries.CL="Chile";
		countries.CM="Cameroon";
		countries.CN="China";
		countries.CO="Colombia";
		countries.CR="Costa Rica";
		countries.CU="Cuba";
		countries.CV="Cape Verde";
		countries.CW="Curacao";
		countries.CX="Christmas Island";
		countries.CY="Cyprus";
		countries.CZ="Czech Republic";
		countries.DE="Germany";
		countries.DJ="Djibouti";
		countries.DK="Denmark";
		countries.DM="Dominica";
		countries.DO="Dominican Republic";
		countries.DZ="Algeria";
		countries.EC="Ecuador";
		countries.EE="Estonia";
		countries.EG="Egypt";
		countries.EH="Western Sahara";
		countries.ER="Eritrea";
		countries.ES="Spain";
		countries.ET="Ethiopia";
		countries.FI="Finland";
		countries.FJ="Fiji";
		countries.FK="Falkland Islands (Malvinas)";
		countries.FM="Micronesia, Federated States Of";
		countries.FO="Faroe Islands";
		countries.FR="France";
		countries.GA="Gabon";
		countries.GB="United Kingdom";
		countries.GD="Grenada";
		countries.GE="Georgia";
		countries.GF="French Guiana";
		countries.GG="Guernsey";
		countries.GH="Ghana";
		countries.GI="Gibraltar";
		countries.GL="Greenland";
		countries.GM="Gambia";
		countries.GN="Guinea";
		countries.GP="Guadeloupe";
		countries.GQ="Equatorial Guinea";
		countries.GR="Greece";
		countries.GS="South Georgia and the South Sandwich Islands";
		countries.GT="Guatemala";
		countries.GU="Guam";
		countries.GW="Guinea-Bissau";
		countries.GY="Guyana";
		countries.HK="Hong Kong";
		countries.HM="Heard Island and Mcdonald Islands";
		countries.HN="Honduras";
		countries.HR="Croatia";
		countries.HT="Haiti";
		countries.HU="Hungary";
		countries.ID="Indonesia";
		countries.IE="Ireland";
		countries.IL="Israel";
		countries.IM="Isle of Man";
		countries.IN="India";
		countries.IO="Britich Indian Ocean Territory";
		countries.IQ="Iraq";
		countries.IR="Iran";
		countries.IS="Iceland";
		countries.IT="Italy";
		countries.JE="Jersey";
		countries.JM="Jamaica";
		countries.JO="Jordan";
		countries.JP="Japan";
		countries.KE="Kenya";
		countries.KG="Kyrgyzstan";
		countries.KH="Cambodia";
		countries.KI="Kiribati";
		countries.KM="Comoros";
		countries.KN="St. Christopher";
		countries.KP="Korea, Democratic People's Republic of";
		countries.KR="South Korea";
		countries.KW="Kuwait";
		countries.KY="Cayman Islands";
		countries.KZ="Kazakhstan";
		countries.LA="Laos";
		countries.LB="Lebanon";
		countries.LC="Saint Lucia";
		countries.LI="Liechtenstein";
		countries.LK="Sri Lanka";
		countries.LR="Liberia";
		countries.LS="Lesotho";
		countries.LT="Lithuania";
		countries.LU="Luxembourg";
		countries.LV="Latvia";
		countries.LY="Libya";
		countries.MA="Morocco";
		countries.MC="Monaco";
		countries.MD="Moldova";
		countries.ME="Montenegro";
		countries.MF="Saint Martin (French Part)";
		countries.MG="Madagascar";
		countries.MH="Marshall Islands";
		countries.MK="Macedonia";
		countries.ML="Mali";
		countries.MM="Burma (Myanmar)";
		countries.MN="Mongolia";
		countries.MO="Macao";
		countries.MP="Northern Mariana Islands";
		countries.MQ="Martinique";
		countries.MR="Mauritania";
		countries.MS="Montserrat";
		countries.MT="Malta";
		countries.MU="Mauritius";
		countries.MV="Maldives";
		countries.MW="Malawi";
		countries.MX="Mexico";
		countries.MY="Malaysia";
		countries.MZ="Mozambique";
		countries.NA="Namibia";
		countries.NC="New Caledonia";
		countries.NE="Niger";
		countries.NF="Norfolk Island";
		countries.NG="Nigeria";
		countries.NI="Nicaragua";
		countries.NL="Netherlands";
		countries.NO="Norway";
		countries.NP="Nepal";
		countries.NR="Nauru";
		countries.NU="Niue";
		countries.NZ="New Zealand";
		countries.OM="Oman";
		countries.PA="Panama";
		countries.PE="Peru";
		countries.PF="French Polynesia";
		countries.PG="Papua New Guinea";
		countries.PH="Philippines";
		countries.PK="Pakistan";
		countries.PL="Poland";
		countries.PM="Saint Pierre and Miquelon";
		countries.PN="Pitcairn Island";
		countries.PR="Puerto Rico";
		countries.PS="Palestinian Territory, Occupied";
		countries.PT="Portugal";
		countries.PW="Palau";
		countries.PY="Paraguay";
		countries.QA="Qatar";
		countries.RE="Reunion";
		countries.RO="Romania";
		countries.RS="Serbia";
		countries.RU="Russian Federation";
		countries.RW="Rwanda";
		countries.SA="Saudi Arabia";
		countries.SB="Solomon Islands";
		countries.SC="Seychelles";
		countries.SD="Sudan";
		countries.SE="Sweden";
		countries.SG="Singapore";
		countries.SH="Saint Helena";
		countries.SI="Slovenia";
		countries.SJ="Savalbard and Jan Mayen";
		countries.SK="Slovakia";
		countries.SL="Sierra Leone";
		countries.SM="San Marino";
		countries.SN="Senegal";
		countries.SO="Somalia";
		countries.SR="Suriname";
		countries.SS="South Sudan";
		countries.ST="Sao Tome and Principe";
		countries.SV="El Salvador";
		countries.SX="Sint Maarten (Dutch Part)";
		countries.SY="Syria";
		countries.SZ="Swaziland";
		countries.TC="Turks and Caicos Islands";
		countries.TD="Chad";
		countries.TF="French Southern Territories";
		countries.TG="Togo";
		countries.TH="Thailand";
		countries.TJ="Tajikistan";
		countries.TK="Tokelau";
		countries.TL="Timor-Leste";
		countries.TM="Turkmenistan";
		countries.TN="Tunisia";
		countries.TO="Tonga";
		countries.TR="Turkey";
		countries.TT="Trinidad and Tobago";
		countries.TV="Tuvalu";
		countries.TW="Taiwan";
		countries.TZ="Tanzania";
		countries.UA="Ukraine";
		countries.UG="Uganda";
		countries.UM="United States Minor Outlying Islands";
		countries.US="United States";
		countries.UY="Uruguay";
		countries.UZ="Uzbekistan";
		countries.VA="Vatican City";
		countries.VC="Saint Vincent and Grenadi";
		countries.VE="Venezuela";
		countries.VG="Virgin Islands, British";
		countries.VI="Virgin Islands, US";
		countries.VN="Vietnam";
		countries.VU="Vanuatu";
		countries.WF="Futuna Islands";
		countries.WS="Western Samoa";
		countries.YE="Yemen";
		countries.YT="Mayotte";
		countries.ZA="South Africa";
		countries.ZM="Zambia";
		countries.ZW="Zimbabwe";

		return countries[ arguments.countryCode ];
	}
}

