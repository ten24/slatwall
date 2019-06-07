component {
    property name="commissionBonusVolumeTotal" persistent="false" hb_formatType="currency";
    property name="commissionPeriodStartDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="commissionPeriodEndDateTime" ormtype="timestamp" hb_formatType="dateTime" hb_nullRBKey="define.forever";
    property name="returnReasonType" cfc="Type" fieldtype="many-to-one" fkcolumn="returnReasonTypeID";
}