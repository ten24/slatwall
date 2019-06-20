component accessors="true" extends="Slatwall.org.Hibachi.HibachiTransient"{

	public string function strictSerializeJSON(required any data){
		if(isStruct(data)){
			var json = "{";
			for(var key in data){
				json &= '"#key#":';
				if(!isSimpleValue(data[key])){
					json &= strictSerializeJSON(data[key]);
					json &= ',';
				}else{
					json &= '"#data[key]#",';
				}
			}
			json = REReplace(json, ",$", "");
			json &= "}";
		}else if(isArray(data)){
			var json="[";
			for(var value in data){
				if(!isSimpleValue(value)){
					json &= strictSerializeJSON(value);
					json &= ',';
				}else{
					json &= '"#value#",';
				}
			}
			json = REReplace(json, ",$", "");
			json &= "]";
		}
		return json;
	}

}