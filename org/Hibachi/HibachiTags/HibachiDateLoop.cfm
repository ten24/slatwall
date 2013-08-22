<!--- Kill extra output. --->
<cfsilent>
 
<!---
Check to see which tag execution mode we are in.
We have acitons that can / should only be done in
one or the other.
--->
<cfswitch expression="#THISTAG.ExecutionMode#">
 
<cfcase value="Start">
 
<!---
In the start mode, we are going to need to
param the tag attributes.
--->
 
<!---
This is the name of the caller-scoped variable
into which we want to store the iteration value.
--->
<cfparam
name="ATTRIBUTES.Index"
type="string"
/>
 
<!---
This is the value at which we will start the
date looping.
--->
<cfparam
name="ATTRIBUTES.From"
type="numeric"
/>
 
<!---
This is the value at which we will end the
date looping (value is inclusive in loop).
--->
<cfparam
name="ATTRIBUTES.To"
type="numeric"
/>
 
<!---
This is the amount by which we will incrememnt
the loop for each iteration. How this actually
translates will be dependent on the DatePart.
--->
<cfparam
name="ATTRIBUTES.Step"
type="numeric"
default="1"
/>
 
<!---
This is how the step increment value is applied
to the iteration. By default, we will add a day
for each increment. This value can be anything
used in DateAdd():
 
yyyy: Year
q: Quarter
m: Month
y: Day of year
d: Day
w: Weekday
ww: Week
h: Hour
n: Minute
s: Second
l: Millisecond
--->
<cfparam
name="ATTRIBUTES.DatePart"
type="string"
default="d"
/>
 
 
<!---
Now that we have paramed all of our attributes,
we have to validate the data.
--->
<cfif (NOT Fix( ATTRIBUTES.Step ))>
 
<!---
The step value must be a non-zero number to
prevent infinite looping.
--->
<cfthrow
type="DateLoop.InvalidAttributeValue"
message="Step must be a non-zero number."
detail="The Step value you provide [#UCase( ATTRIBUTES.Step )#] must be non-zero number to prevent infinite looping."
/>
 
</cfif>
 
 
<!---
ASSERT: If we have made it this far than we have
all the required attributes and valid data.
--->
 
<!--- Initialize the loop sequence. --->
<cfset THISTAG.Day = ATTRIBUTES.From />
 
<!--- Store the current value into the caller. --->
<cfset "CALLER.#ATTRIBUTES.Index#" = ParseDateTime(
DateFormat( THISTAG.Day, "mm/dd/yyyy" ) & " " &
TimeFormat( THISTAG.Day, "HH:mm:ss" )
) />
 
 
<!---
Before we even start looping, let's check to see
if we haven't already met our final condition.
--->
<cfif (
<!--- Incrementing. --->
(
(ATTRIBUTES.Step GT 0) AND
(THISTAG.Day GT ATTRIBUTES.To)
) OR
 
<!--- Decrementing. --->
(
(ATTRIBUTES.Step LT 0) AND
(THISTAG.Day LT ATTRIBUTES.To)
))>
 
<!---
We have already met the final condition.
Exit out before the loop even starts.
--->
<cfexit method="EXITTAG" />
 
</cfif>
 
</cfcase>
 
 
<cfcase value="End">
 
<!---
Increment the index value using the specified
increment and date part.
--->
<cfset THISTAG.Day = DateAdd(
ATTRIBUTES.DatePart,
ATTRIBUTES.Step,
THISTAG.Day
) />
 
 
<!--- Store the current value into the caller. --->
<cfset "CALLER.#ATTRIBUTES.Index#" = THISTAG.Day />
 
 
<!---
Check to see if we should continue to loop this
value. When checking this, it depends on how the
From and To values relate to each other.
--->
<cfif (
<!--- Incrementing. --->
(
(ATTRIBUTES.Step GT 0) AND
(THISTAG.Day LTE ATTRIBUTES.To)
) OR
 
<!--- Decrementing. --->
(
(ATTRIBUTES.Step LT 0) AND
(THISTAG.Day GTE ATTRIBUTES.To)
))>
 
<!---
We are not done looping. Exit out using the
LOOP type so that the EndTag will execute
at least one more time.
--->
<cfexit method="LOOP" />
 
<cfelse>
 
<!---
We are done looping. Exit out of the
tag fully.
--->
<cfexit method="EXITTAG" />
 
</cfif>
 
</cfcase>
 
</cfswitch>
 
</cfsilent>