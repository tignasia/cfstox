<!--- this generates an excel spreadsheet of historical technical indicators  --->
<script language="javascript" type="text/javascript" src="niceforms.js"></script>
<link rel="stylesheet" type="text/css" media="all" href="niceforms-default.css" />
<style type="text/css">
#form1 fieldset {
	height: 20em;
	width: 11em;
	border: 0;
	margin: 0;
	padding: 1em;
	float: left;
	}
</style>
<div>
<form action="controllers/controller.cfm" method="post" id="form1">
<fieldset title="historical data"  ><legend>Historical Data</legend>
<input type="hidden" id="action" name"action" value="historical">
<label for="StartDate" style="width=30%" >Start Date:</label>
<input type="text" id="StartDate" value="1/1/2010">
<label for="EndDate" style="width=30%">End Date:</label>
<cfoutput><input type="text" id="StartDate" value="#dateformat(now(),"mm/dd/yyyy")#"></cfoutput>
<label for="Symbol" style="width=30%">Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">
</fieldset>

<fieldset>
<label for="input1" style="width=30%">Symbol:</label>
<input type="text" name="input1" id="input1" value="">
<label for="input2" style="width=30%">Symbol:</label>
<input type="text" name="input2" id="input2" value="">
</fieldset>

<input type="submit" name="submit" id="submit" value="Submit" />

</form>
</div>
<br style="clear:both">
<div style ="width:100%">
<!--- this generates a summary and trading action based on the chosen system with entry and stoploss targets --->
<form action="controller/controller.cfm" method="post">
<fieldset title="Summary"  style="float:left" >
<legend>Summary</legend>
<input type="hidden" id="action" name"action" value="summary">
<label for="Symbol" style="width=30%">Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">

<input type="submit" name="submit" id="submit" value="Submit" />
</fieldset>
</form>
<!--- this runs a historical backtest of the chosen system  --->
<form action="controller/controller.cfm" method="post">
<fieldset title="Backtest"  >Backtest
<input type="hidden" id="action" name"action" value="backtest">
<label for="Symbol" style="width=30%">Symbol:</label>
<input type="text" name="Symbol" id="Symbol" value="">

<input type="submit" name="submit" id="submit" value="Submit" />
</fieldset>
</form>
</div>
<!--- this runs a summary of trading actions and analysis against the watchlist --->
<form action="controller/controller.cfm" method="post">
<fieldset title="Watchlist"  >Watchlist
<input type="hidden" id="action" name"action" value="watchlist">
<input type="submit" name="submit" id="submit" value="Run watchlist analysis" />
</fieldset>
</form>
