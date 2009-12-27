<?xml version="1.0" encoding="ISO-8859-1"?>
<configuration>
	<module name="application">
		<parameter>
		<name>DSN</name>
		<value>touchbase</value>
		</parameter>
		<parameter>
		<name>editorbasepath</name>
		<value>/development/FCKEditor_CF/</value>
		</parameter>
		<parameter>
		<name>cfcPath</name>
		<value>development.functions</value>
		</parameter>
	</module>
	<module name="session">
		<parameter>
			<name>organizationid</name>
			<value>1</value>
		</parameter>
		<parameter>
			<name>ReturnOrganizationId</name>
			<value>1</value>
		</parameter>
		<parameter>
			<name>FCKFolder</name>
			<value>1</value>
		</parameter>
		<parameter>
			<name>memberphotopath</name>
			<value>/development/memberphotos/</value>
		</parameter>
	</module>
	<module name="include">
		<parameter>
		<name>file</name>
		<value>functions/UDF_StringEncryption.cfm</value>
		</parameter>
		<parameter>
		<name>file</name>
		<value>functions/UDF_StringFunctions.cfm</value>
		</parameter>
	</module>
</configuration>