component accessors="true" output="false" extends="HibachiService" {

	public any function getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegration(required string baseObject, required string baseID, required string entityQueueType, required any integration){
		return getDao('hibachiEntityQueueDao').getEntityQueueByBaseObjectAndBaseIDAndEntityQueueTypeAndIntegration(argumentCollection=arguments);
	}
}
