<?xml version="1.0" encoding="UTF-8"?>
<Table tableName="SwMeasurementUnit">
	<Columns>
		<column name="unitCode" fieldtype="id" />
		<column name="measurementType" />
		<column name="unitName" />
		<column name="conversionRatio" datatype="double" />
	</Columns>
	<Records>
		<Record unitCode="lb" measurementType="weight" unitName="Pound" conversionRatio="1" />
		<Record unitCode="oz" measurementType="weight" unitName="Ounce" conversionRatio="16" />
		<Record unitCode="kg" measurementType="weight" unitName="Kilogram" conversionRatio="0.45359237" />
		<Record unitCode="g" measurementType="weight" unitName="Gram" conversionRatio="453.59237" />
		<Record unitCode="mg" measurementType="weight" unitName="Milligram" conversionRatio="453592.37" />
		<Record unitCode='mL' measurementType="volume" unitName="Milliliter" conversionRatio="1000" />
		<Record unitCode='L' measurementType="volume" unitName="Liter" conversionRatio="1" />
	</Records>
</Table>