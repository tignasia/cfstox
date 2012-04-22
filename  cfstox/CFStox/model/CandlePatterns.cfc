<cfcomponent output="false">
<!--- todo run these and the ones in TA and see if there is a significant difference   --->
	<cffunction name="BearishDarkCloudCover" description="" access="public" displayname="" output="false" returntype="Struct">
		<!---
		BEARISH DARK CLOUD COVER
		Type: 	Reversal
		Relevance: 	Bearish
		Prior Trend: 	Bullish
		Reliability: 	High
		Confirmation: 	Suggested
		No. of Sticks: 	2 
		Definition: Bearish Dark Cloud Cover Pattern is a two-candlestick pattern signaling a 
		top reversal after an uptrend or, at times, at the top of a congestion band. 
		We see a strong white real body in the first day. 
		The second day opens strongly above the previous day high 
		(it is above the top of the upper shadow). 
		However, market closes near the low of the day and well within 
		the prior day’s white body at the end of the day.
		
		Recognition Criteria:
		1. Market is characterized by an uptrend.
		2. We see a long white candlestick in the first day.
		3. Then we see a black body characterized by an open above the high of the previous day on the second day.
		4. The second black candlestick closes within and below the midpoint of the previous white body.
		 --->
		<!----
		<cfif trend EQ "UP">
			<cfset flag = true />
		</cfif>
		<cfif day two close GT day two open>
			<cfset flag = true />
		</cfif>
		<cfif day one open GT day two high>
			<cfset flag = true /> 
		</cfif>
		<cfif day one close LT day two pivot point>
			<cfset flag = true />
		</cfif>
		<cfif flag>
			<cfset struct.flag = flag />
			<cfset struct.CandleType = "BEARISH DARK CLOUD COVER" />		
			<cfset struct.reliablity = "High">
		</cfif>
		--->
	<cfreturn />
	</cffunction>
	
	<cffunction name="BearishKicking" description="" access= displayname="" output= returntype=>
		<!--- 
		BEARISH KICKING
		Type: 	Reversal
		Relevance: 	Bearish
		Prior Trend: 	N/A
		Reliability: 	High
		Confirmation: 	Recommended
		No. of Sticks: 	2
		Definition: 
		A White Marubozu is followed by a sharply lower gap when it opens during the second day. 
		The second day opening is even below the prior session’s opening (forming a Black Marubozu). 
		Such a pattern is called a Bearish Kicking Pattern.
		
		Recognition Criteria:
		1. Market direction is not important.
		2. We see a White Marubozu in the first day.
		3. Then we see Black Marubozu day that gaps downward on the second day.
		
		Explanation:
		Bearish Kicking Pattern sends a strong signal suggesting that the market is now heading downward. 
		The previous market direction is not important in this pattern 
		unlike most other candlestick patterns. The market has been in a trend when prices gap 
		down the next day in case of Bearish Kicking Pattern. The prices on the second day never 
		enter into the previous day's range and we have a close with another gap.
		
		Important Factors:
		Both of the candlesticks do not have shadows (or very small shadows if any). 
		In other words both are Marubozu.
		The Bearish Kicking Pattern is similar to the Bearish Separating Lines Pattern except that 
		instead of the open prices being equal, in the Bearish Kicking Pattern a gap occurs.
		The Bearish Kicking Pattern is highly reliable but still a confirmation may be necessary, 
		and this confirmation may be in the form of a black candlestick, a large gap down or a 
		lower close on the next trading day.  --->

	<cfreturn />
	</cffunction>

	<cffunction name="BearishAbandonedBaby" description="" access= displayname="" output= returntype=>
		<!---  
		BEARISH ABANDONED BABY
		Type: 	Reversal
		Relevance: 	Bearish
		Prior Trend: 	Bullish
		Reliability: 	High
		Confirmation: 	Suggested
		No. of Sticks: 	3
		Definition:            
		The Bearish Abandoned Baby Pattern is a very rare top reversal signal. 
		It is basically composed of a Doji Star, which shows gaps (including shadows) 
		from the prior and following sessions’ candlesticks.
		
		Recognition Criteria:
		1. Market is characterized by uptrend.
		2. We see a long white candlestick in the first day.
		3. Then we see a doji on the second day whose shadows characteristically gap above 
		the previous day's upper shadow and also gaps in the direction of the previous uptrend.
		4. Finally we see a black candlestick characterized with a gap in the opposite direction, 
		with no overlapping shadows.
		
		Explanation:
		Most of the three-day star patterns have similar scenarios. In an uptrend, 
		the market seems still strong displaying a long white candlestick and opening with a 
		gap on the second day. The trading in second day is within a small range and its closing price 
		is equal or very near to its opening price. Now there is a sign of sale-off potential with 
		reversal of positions. The trend reversal is confirmed by the black candlestick on the third day. 
		Downward gap also supports the reversal.
		
		Important Factors:
		The Bearish Abandoned Baby Pattern is quite rare.
		The reliability of this pattern is very high, but still a confirmation in the 
		form of a black candlestick with a lower close or a gap-down is suggested. 
		--->
	<cfreturn />
	</cffunction>
	
	<cffunction name="BearishEveningStar" description="" access= displayname="" output= returntype=>
		<!---  
		BEARISH EVENING STAR
		Type: 			Reversal
		Relevance: 		Bearish
		Prior Trend: 	Bullish
		Reliability: 	High
		Confirmation: 	Suggested
		No. of Sticks: 	3

		Definition:             
		This is a major top reversal pattern formed by three candlesticks. 
		The first candlestick is a long white body; the second one is a small real 
		body that may be white. It is characteristically marked with a gap in higher 
		direction thus forming a star. In fact, the first two candlesticks form a basic star pattern. 
		Finally we see the black candlestick with a closing price well within first session’s 
		white real body. This pattern clearly shows that the market now turned bearish.
		
		Recognition Criteria:
		1. Market is characterized by uptrend.
		2. We see a long white candlestick in the first day.
		3. Then we see a small candlestick on the second day with a gap in the direction of the previous uptrend.
		4. Finally we see a black candlestick on the third day.
		
		Explanation:
		The market is already in an uptrend when the white body appears which further suggests the 
		bullish nature of the market. Then a small body appears showing the diminishing capacity of the longs. 
		The strong black real body of the third day is a proof that the bears have taken over. 
		An ideal Bearish Evening Star Pattern has a gap before and after the middle real body. 
		The second gap is rare, but lack of it does not take away from the power of this formation.
		
		Important Factors:
		The stars may be more than one, two or even three.
		The color of the star and its gaps are not important.
		The reliability of this pattern is very high, but still a confirmation in the 
		form of a black candlestick with a lower close or a gap-down is suggested. 
				--->
		<cfreturn />
	</cffunction>
		
	<cffunction name="BearishThreeBlackCrows" description="" access= displayname="" output= returntype=>
		<!---  
		BEARISH THREE BLACK CROWS
		Type: 	Reversal
		Relevance: 	Bearish
		Prior Trend: 	Bullish
		Reliability: 	High
		Confirmation: 	Suggested
		No. of Sticks: 	3

		Definition:            
		The Bearish Three Black Crows Pattern is indicative of a strong reversal during an uptrend. 
		It consists of three long black candlesticks, which look like a stair stepping downward. 
		The opening price of each day is higher than the previous day's closing price suggesting 
		a move to a new short term low.

		Recognition Criteria:
		1. Market is characterized by uptrend.
		2. Three consecutive long black candlesticks appear.
		3. Each day closes at a new low.
		4. Each day opens within the body of the previous day.
		5. Each day closes near or at its lows.
		
		Explanation:
		The Bearish Three Black Crows Pattern is indicative of the fact that the market has been at a high price for too long and the market may be approaching a top or is already at the top. A decisive downward move is reflected by the first black candlestick. The next two days show further decline in prices due to profit taking. Bullish mood of the market cannot be sustained anymore.
		
		Important Factors:
		The opening prices of the second and third days can be anywhere within the previous day's body. 
		However, it is better to see the opening prices below the middle of the previous day's body.
		If the black candlesticks are very extended, one should be cautious about an oversold market.
		The reliability of this pattern is very high, but still a confirmation in the form of a black 
		candlestick with a lower close or a gap-down is suggested. 
		--->		
		<cfreturn />
	</cffunction>

	<cffunction name="Function" description="" access= displayname="" output= returntype=>
		<!--- BEARISH EVENING DOJI STAR
	Type: 	Reversal
	Relevance: 	Bearish
	Prior Trend: 	Bullish
	Reliability: 	High
	Confirmation: 	Suggested
	No. of Sticks: 	3

	Definition:             Get the highest rated stock from Americanbulls for this pattern >>>
	
	This is a major top reversal pattern formed by three candlesticks. The first candlestick is a long white body; the second is a doji characterized by a higher gap thus forming a doji star. The third one is a black candlestick with a closing price, which is within the first day’s white real body. It is a meaningful top pattern.
	
	Recognition Criteria:
	1. Market is characterized by uptrend.
	2. We see a white candlestick in the first day.
	3. Then we see a Doji that gaps in the direction of the previous uptrend on the second day.
	4. Finally the third day is a black candlestick.
	
	Explanation:
	
	The first white body, while the market is in an uptrend, shows the continuing bullish nature of the market. Then a Doji appears showing the diminishing power of the longs. The strong black real body on the third day proves that bears have taken over. An ideal Bearish Evening Doji Star Pattern has a gap before and after the middle real body. The second gap is rare, but lack of it does not take away from the power of this formation.
	
	Important Factors:
	
	The Doji may be more than one, two or even three.
	
	Doji’s gaps are not important.
	
	The reliability of this pattern is very high, but still a confirmation in the form of a black candlestick with a lower close or a gap-down is suggested. 	
		 --->	<cfreturn />
	</cffunction>

	<cffunction name="Function" description="" access= displayname="" output= returntype=>
<!--- 
		BEARISH THREE INSIDE DOWN
Type: 	Reversal
Relevance: 	Bearish
Prior Trend: 	Bullish
Reliability: 	High
Confirmation: 	Suggested
No. of Sticks: 	3

 

Definition:             Get the highest rated stock from Americanbulls for this pattern >>>

The Bearish Three Inside Down Pattern is another name for the Confirmed Bearish Harami Pattern. The third day confirms the bearish trend reversal.

Recognition Criteria:
1. Market is characterized by uptrend.
2. We see a Bearish Harami Pattern in the first two days.
3. We then see a black candlestick on the third day with a lower close than the second day.

Explanation:

The first two days of this three-day pattern is a Bearish Harami Pattern, and the third day confirms the reversal suggested by Bearish Harami Pattern since it is a black candlestick closing with a new low for the three days.

Important Factors:
The reliability of this pattern is very high, but still a confirmation in the form of a black candlestick with a lower close or a gap-down is suggested. 
 --->
		<cfreturn />
	</cffunction>

	<cffunction name="Function" description="" access= displayname="" output= returntype=>
		<!--- 
BEARISH THREE OUTSIDE DOWN
Type: 	Reversal
Relevance: 	Bearish
Prior Trend: 	Bullish
Reliability: 	High
Confirmation: 	Suggested
No. of Sticks: 	3

 

Definition:             Get the highest rated stock from Americanbulls for this pattern >>>

The Bearish Three Outside Down Pattern is another name for the Confirmed Bearish Engulfing Pattern. The third day confirms the bearish trend reversal.

Recognition Criteria:

1. Market is characterized by uptrend.
2. We see a Bearish Engulfing Pattern in the first two days.
3. Then we see a black candlestick on the third day with a lower close than the second day.
Explanation:

The first two days forms a Bearish Engulfing Pattern, and the third day confirms the reversal suggested by the Bearish Engulfing Pattern since it is a black candlestick closing with a new low for the three days.

Important Factors:
The reliability of this pattern is very high, but still a confirmation in the form of a black candlestick with a lower close or a gap-down is suggested. 
 --->
		<cfreturn />
	</cffunction>

	<cffunction name="Function" description="" access= displayname="" output= returntype=>
		<!--- 
BEARISH UPSIDE GAP TWO CROWS
Type: 	Reversal
Relevance: 	Bearish
Prior Trend: 	Bullish
Reliability: 	High
Confirmation: 	Suggested
No. of Sticks: 	3

 

Definition:             Get the highest rated stock from Americanbulls for this pattern >>>

The Bearish Upside Gap Two Crows Pattern is a three-candlestick pattern and it signals a top reversal. The first candlestick is a long white candlestick followed by a real body that gaps higher. Then another black real body appears, which opens above the second day’s open and closes under the second day’s close, completing the pattern

Recognition Criteria:
1. Market is characterized by uptrend.
2. We see a long white candlestick in the first day that signals the continuation of uptrend.
3. Then we see a black body with a gap up on second day.
4. The third day is characterized by another black candlestick having an opening above the first black day and also closing below the body of the first black day. The body of third day engulfs the body of the first day.
5. The close of the second black candlestick is still above the close of the first long white candlestick.

Explanation:

The market is in an uptrend and it displays a higher opening with a gap. However the new highs of the day cannot hold and the market forms a black candlestick. However the bulls still comfort themselves by the fact that the close on this black candlestick day is still above the prior day’s close. The third day however increases the bearish sentiment displaying another new high but failing to hold these highs until the close. Also the day closes below the prior day’s close, which is another bearish sign. . So the following question becomes relevant. If the market is so strong, why the new highs fail to hold and why market closes lower? The answer is clear. Market is not now as strong as the bulls would like to believe.

Important Factors:

The two black candlesticks of the pattern are the crows reminding ominous looking black crows atop a tree branch.

Confirmation for the Bearish Upside Gap Two Crows Pattern may be mildly suggested. If in the fourth session prices fail to regain high ground, lower prices should be expected.
 --->
		<cfreturn />
	</cffunction>


</cfcomponent>