component extends="Slatwall.org.Hibachi.HibachiTransient" output="false" accessors="true"{
	property name="xipayvbresult" type="boolean" default="false";
	property name="packets" type="array";


	public any function getCount(){
		return arrayLen(getPackets());
	}

	public array function getPackets(){
		if(isNull(variables.packets)){
			variables.packets = [];
		}
		return variables.packets;
	}

	public void function addPacket(required any transactionHeader){
		ArrayAppend(getPackets(),transactionHeader);
	}

	public any function getRequestData(required any xmlData){

		var IPackets = XmlElemNew(xmlData, 'mes','mes:pPacketsIn');

		var count = XmlElemNew(xmlData, 'mes','mes:count');
		count.xmlText = getCount();
		arrayAppend(IPackets.XmlChildren, count);

		var vbResult = XmlElemNew(xmlData, 'mes','mes:xipayvbresult');
		vbResult.xmlText = getXipayvbresult();
		arrayAppend(IPackets.XmlChildren, vbResult);

		var packets = XmlElemNew(xmlData, 'mes','mes:packets');
		for(var packet in getPackets()){
			arrayAppend(packets.XmlChildren, packet.getRequestData(xmlData));
		}
		arrayAppend(IPackets.XmlChildren, packets);
		return IPackets;
	}

	public any function getResponse(){
		//Do soap op and then
		setXiPayVbResult(response.xipayvbresult);
		setPackets([]);
		for(var packet in response.packets){
			
		}
	}
}