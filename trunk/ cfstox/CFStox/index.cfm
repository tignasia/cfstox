<!--- todo: confirm accuracy of technical indicators --->
<!--- todo: generate entry/stop points/profit targets --->
<!--- todo: develop backtesting system --->

<script language="javascript" type="text/javascript" src="niceforms.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="niceforms-default.css" />
<!-- <style type="text/css">
#form1 fieldset {
	height: 20em;
	width: 11em;
	border: 0;
	margin: 0;
	padding: 1em;
	float: left;
	}
</style> -->
<div>
<form action="controllers/controller.cfm" method="post" id="form1">
<fieldset title="historical data"><legend>Historical Data</legend>
<input type="hidden" id="action" name="action" value="historical">
<input type="hidden" id="summary" name="summary" value="false" />
<label for="StartDate" style="width=30%" >Start Date:</label>
<input type="text" name="StartDate" id="StartDate" value="1/1/2010">
<label for="EndDate" style="width=30%">End Date:</label>
<cfoutput><input type="text" name="EndDate" id="EndDate" value="#dateformat(now(),"mm/dd/yyyy")#"></cfoutput>
<label for="Symbol" style="width=30%">Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">
</fieldset>
<!---
<fieldset>
<label for="input1" style="width=30%">PlLaceholder:</label>
<input type="text" name="input1" id="input1" value="">
<label for="input2" style="width=30%">Placeholder:</label>
<input type="text" name="input2" id="input2" value="">
</fieldset>
---->
<input type="submit" name="submit" id="submit" value="Submit" />

</form>
</div>
<br style="clear:both">

<div style ="width:100%">
<!--- this runs a historical backtest of the chosen system  --->
<form action="controllers/controller.cfm" method="post" id="backtest_form">
<fieldset title="Backtest">Backtest
<input type="hidden" id="action" name="action" value="backtest">
<label for="Symbol" style="width=30%">Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">
<label for="StartDate" style="width=30%" >Start Date:</label>
<input type="text" name="StartDate" id="StartDate" value="1/1/2010">
<label for="EndDate" style="width=30%">End Date:</label>
<cfoutput><input type="text" name="EndDate" id="EndDate" value="#dateformat(now(),"mm/dd/yyyy")#"></cfoutput>
<input type="submit" name="submit" id="submit" value="Submit" />
</fieldset>
</form>
</div>
<!--- this runs a summary of trading actions and analysis against the watchlist --->
<form action="controllers/controller.cfm" method="post" id="watchlist_form1">
<fieldset title="Watchlist">Watchlist One
<input type="hidden" id="action" name="action" value="watchlist">
<input type="hidden" id="watchlist" name="watchlist" value="1">
<input type="submit" name="submit" id="submit" value="Run watchlist analysis" />
</fieldset>
</form>

<form action="controllers/controller.cfm" method="post" id="watchlist_form2">
<fieldset title="Watchlist">Watchlist Two
<input type="hidden" id="action" name="action" value="watchlist">
<input type="hidden" id="watchlist" name="watchlist" value="2">
<input type="submit" name="submit" id="submit" value="Run watchlist analysis" />
</fieldset>
</form>

<form action="controllers/controller.cfm" method="post" id="watchlist_form3">
<fieldset title="Watchlist">Watchlist Three
<input type="hidden" id="action" name="action" value="watchlist">
<input type="hidden" id="watchlist" name="watchlist" value="3">
<input type="submit" name="submit" id="submit" value="Run watchlist analysis" />
</fieldset>
</form>

<form action="controllers/controller.cfm" method="post" id="watchlist_form4">
<fieldset title="Watchlist">Watchlist Four
<input type="hidden" id="action" name="action" value="watchlist">
<input type="hidden" id="watchlist" name="watchlist" value="4">
<input type="submit" name="submit" id="submit" value="Run watchlist analysis" />
</fieldset>
</form>

