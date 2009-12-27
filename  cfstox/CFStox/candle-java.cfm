 	 Topic: Candle Bearish Engulfing?  (Read 83 times)
usacoder
Member
**
Posts: 6


View Profile Personal Message (Offline) 	
	
Candle Bearish Engulfing?
« on: March 09, 2009, 08:42:01 AM » 	Reply with quote
I'm using the TA-LIB Java package.  While testing the candle engulfing method I get an bearish indicator for 10th element in my input.  But after graphing the data and using the Yahoo stock graphs with Chart Setting Line Type to Candlestick I don't see the bearish engulfing.  The data I am using is the DJIA from 2009-01-28  through 2009-03-06

The results say that a Bearish Engulfing pattern occurred on 2/10.   But I don't see it.

From my charts and Yahoo charts I see:
2/9 Black spinning top, can't engulf
2/10 Long black, not engulfing because too low and same color
2/11 Plain white, can't engulf previous, too small
2/12 Doji., can't engulf, always too small.

Where's the engulfing pattern?

Directly below is the Java code I use.  This is followed by the System.outs.

Code:

//////
MInteger outNBElement = new MInteger();
startIdx = 0;
endIdx = inOpen.length-1;
outInteger = new int[inOpen.length];
for (int k=0; k<inDate.length; k++)  // display data
        	System.out.println(k+". "+inDate[k]+","+inOpen[k]+","+inHigh[k]+","+inLow[k]+","+inClose[k]);

RetCode ret =
	core.cdlEngulfing(startIdx, endIdx, inOpen, inHigh, inLow, inClose, outBegIdx, outNBElement, outInteger);
System.out.println("ret to string is " +ret.toString());
System.out.println("out beg idx is "+outBegIdx.value);
System.out.println("out NB element is "+outNBElement.value);
System.out.println("out integer length is "+ outInteger.length);
for (int i = 0; i < outInteger.length; i++) {
	if (outInteger[i] != 0) 
		System.out.println(inDate[startIdx+i]+" integer ["+i+"] is "+outInteger[i]);
	}

      

/////////  output results //////
0. 2009-01-28,8175.93,8446.33,8175.93,8375.45
1. 2009-01-29,8373.06,8373.06,8092.14,8149.01
2. 2009-01-30,8149.01,8243.95,7924.88,8000.86
3. 2009-02-02,8000.62,8053.43,7796.17,7936.83
4. 2009-02-03,7936.99,8157.13,7855.19,8078.36
5. 2009-02-04,8070.32,8197.04,7899.79,7956.66
6. 2009-02-05,7954.83,8138.65,7811.7,8063.07
7. 2009-02-06,8056.38,8360.07,8044.03,8280.59
8. 2009-02-09,8281.38,8376.56,8137.7,8270.87
9. 2009-02-10,8269.36,8293.17,7835.83,7888.88
10. 2009-02-11,7887.05,8042.36,7820.14,7939.53
11. 2009-02-12,7931.97,7956.02,7662.04,7932.76
12. 2009-02-13,7933.0,8005.96,7811.38,7850.41
13. 2009-02-17,7845.63,7845.63,7502.59,7552.6
14. 2009-02-18,7546.35,7661.56,7451.37,7555.63
15. 2009-02-19,7555.23,7679.01,7420.63,7465.95
16. 2009-02-20,7461.49,7500.44,7226.29,7365.67
17. 2009-02-23,7365.99,7477.1,7092.64,7114.78
18. 2009-02-24,7115.34,7396.34,7077.35,7350.94
19. 2009-02-25,7349.58,7442.13,7123.94,7270.89
20. 2009-02-26,7269.06,7451.13,7135.25,7182.08
21. 2009-02-27,7180.97,7244.61,6952.06,7062.93
22. 2009-03-02,7056.48,7056.48,6736.69,6763.29
23. 2009-03-03,6764.81,6922.59,6661.74,6726.02
24. 2009-03-04,6726.5,7012.19,6715.11,6875.84
25. 2009-03-05,6874.01,6874.01,6531.28,6594.44
26. 2009-03-06,6595.16,6776.44,6443.27,6626.94
ret to string is Success
out beg idx is 2
out NB element is 25
out integer length is 27
2009-02-11 integer [10] is -100
« Last Edit: March 10, 2009, 07:24:50 AM by mfortier » 	Report to moderator   Logged
mfortier
Administrator
Member
**
Posts: 1193



View Profile WWW Email Personal Message (Offline) 	
	
Re: Candle Bearish Engulfing?
« Reply #1 on: March 10, 2009, 07:23:49 AM » 	Reply with quote
Your interpretation of the output is off by two bars.

Output logic should be something like:

Code:

for (int i = 0; i < outNBElement.value; i++) {
   if (outInteger[i] != 0)
      System.out.println(inDate[startIdx+outBegIdx.value+i]+" integer ["+i+"] is "+outInteger[i]);
   }
}


The important change is that the output is offset relative to the input by as much as indicated by outBegIdx.

Also, the number of elements written in the output is indicated by outNBElement.

Thanks for providing the code.

\Mario
« Last Edit: March 10, 2009, 07:26:00 AM by mfortier » 