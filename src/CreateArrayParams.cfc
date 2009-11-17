<cfcomponent>

	<cffunction name="init" access="public" output="false">
		<cfset this.version = "1.0">
		<cfreturn this />
	</cffunction>

	<cffunction name="$createParams" returntype="struct" access="public" output="false" mixin="dispatch">
		<cfargument name="route" type="string" required="true">
		<cfargument name="foundRoute" type="struct" required="true">
		<cfargument name="formScope" type="struct" required="false" default="#form#">
		<cfargument name="urlScope" type="struct" required="false" default="#url#">
		<cfscript>
			var loc = {};
			
			loc.returnValue = core.$createParams(arguments.route, arguments.foundRoute, arguments.formScope, arguments.urlScope);
			
 			// add form variables to the params struct
 			for (loc.key in arguments.formScope)
 			{
				// check to see if we have an array of objects coming from our form
				loc.match = REFindNoCase('(.*?)\[(\d{1,4})\]\[(.*?)\]', loc.key, 1, true);
				
				if (ArrayLen(loc.match.pos) == 4)
 				{
 					loc.objectName = LCase(Mid(loc.key, loc.match.pos[2], loc.match.len[2]));
					loc.position = LCase(Mid(loc.key, loc.match.pos[3], loc.match.len[3]));
					loc.fieldName = LCase(Mid(loc.key, loc.match.pos[4], loc.match.len[4]));
 					if (!StructKeyExists(loc.returnValue, loc.objectName) or IsStruct(loc.returnValue[loc.objectName]))
					{
						loc.returnValue[loc.objectName] = ArrayNew(1);
					}
					loc.returnValue[loc.objectName][loc.position][loc.fieldName] = arguments.formScope[loc.key];
 				}
			}
		</cfscript>
		<cfreturn loc.returnValue>
	</cffunction>
	
	<cffunction name="$tagName" returntype="string" access="public" output="false" mixin="controller">
		<cfargument name="objectName" type="any" required="true">
		<cfargument name="property" type="string" required="true">
		<cfscript>
			var returnValue = "";
			if (IsSimpleValue(arguments.objectName))
				returnValue = ListLast(arguments.objectName, ".") & "[" & arguments.property & "]";
			else
				returnValue = arguments.property;
		</cfscript>
		<cfreturn returnValue>
	</cffunction>
	
	<cffunction name="$tagId" returntype="string" access="public" output="false" mixin="controller">
		<cfargument name="objectName" type="any" required="true">
		<cfargument name="property" type="string" required="true">
		<cfscript>
			var returnValue = "";
			if(IsSimpleValue(arguments.objectName))
				returnValue = ReplaceList(ListLast(arguments.objectName, "."), "[,]", "-,") & "-" & arguments.property;
			else
				returnValue = ReplaceList(arguments.property, "[,]", "-,");
		</cfscript>
		<cfreturn returnValue>
	</cffunction>

</cfcomponent>
