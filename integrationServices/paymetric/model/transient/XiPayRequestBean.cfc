component extends="Slatwall.model.transient.data.DataRequestBean" accessors="true" persistent="false" output="true"{
	property name="packetsObj" type="any";
	property name="username" type="string";
	property name="password" type="string";

	public any function getResponseBean(){
		if(isNull(getPacketsObj())){
			addError('PacketsObj','IPacketsObject is required.');
			return;
		}
		var xmlData = XmlNew(true);
		xmlData['soapenv:Envelope'] = XmlElemNew(xmlData, 'soapenv', 'soapenv:Envelope');
		var soapHeader = XmlElemNew(xmlData, 'soapenv', 'soapenv:Header');
		var soapBody = XmlElemNew(xmlData, 'soapenv', 'soapenv:Body');
		var soapOp = XmlElemNew(xmlData, 'mes', 'mes:SoapOp');
		var packetNode = getPacketsObj().getRequestData(xmlData);
		arrayAppend(soapOp.XmlChildren,packetNode);
		arrayAppend(soapBody.XmlChildren, soapOp);
		arrayAppend(xmlData['soapenv:Envelope'].XmlChildren,soapHeader);
		arrayAppend(xmlData['soapenv:Envelope'].XmlChildren,soapBody);
		xmlData['soapenv:Envelope'].xmlAttributes = {
			'xmlns:soapenv'="http://schemas.xmlsoap.org/soap/envelope/",
			'xmlns:mes'="http://Paymetric/XiPaySoap30/message/"
		};
		xmlData['soapenv:Envelope']['soapenv:Body']['mes:SoapOp'].xmlAttributes = {'xmlns:mes'="http://Paymetric/XiPaySoap30/message/"};
		setMethod('POST');
		setBody(toString(xmlData));
		setContentType('text/xml');
		setNTMLAuth(getUsername(), getPassword());
		return super.getResponseBean();
	}

	private function setNTMLAuth(required string username, required string password){
		getHttpRequest().setAuthType('NTLM');
		getHttpRequest().setUsername(arguments.username);
		getHttpRequest().setPassword(arguments.password);
		getHttpRequest().setDomain('PAYMETRIC');
		getHttpRequest().setWorkstation('WORKSTATION');
	}
}