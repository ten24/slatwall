component displayname="Promotion Qualifier Message" entityname="SlatwallPromotionQualifierMessage" table="SwPromoQualMessage" persistent="true" extends="HibachiEntity" cacheuse="transactional" hb_serviceName="promotionService" hb_permission="promotionPeriod.promotionQualifiers" {

    property name="promotionQualifierMessageID" ormtype="string" length="32" fieldtype="id" generator="uuid" unsavedvalue="" default="";
    property name="message" ormtype="string" length="2000";
    
    // Related Entities (many-to-one)
    property name="promotionQualifier" cfc="PromotionQualifier" fieldtype="many-to-one" fkcolumn="promotionQualifierID";
    
}