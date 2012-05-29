<cfoutput>
<cfscript>
query	=	request.qryDataOriginal;
qryColumns = ArrayToList( query.getColumnNames() );
qryColumnsSorted = query.getColumnNames();
</cfscript>
qryColumns: #qryColumns# </br>
qryColumnsSorted : #qryColumnsSorted#
</br>
CREATE TABLE StockData
(
<cfloop  list="#qryColumns#" index="x">
#x#  datatype,</br>
</cfloop>
}

</cfoutput>
<!--- 
CREATE TABLE StockData ( 
DateOne date,
[Open] smallmoney,
[High] smallmoney,
[Low] smallmoney,
[Close] smallmoney,
Volume int,
Symbol varchar(5),
linearReg decimal(5,5),
linearReg10 decimal(5,5),
linearRegAngle decimal(5,5),
linearRegSlope decimal(5,5),
linearRegSlope10 decimal(5,5),
linearRegIntercept decimal(5,5),
LRSdelta decimal(5,5),
Momentum decimal(5,5),
FastSlope decimal(5,5),
SlowSlope decimal(5,5),
RSI decimal(5,5),
ADX decimal(5,5),
CCI decimal(5,5),
CCI5 decimal(5,5),
PP decimal(5,5),
R1 decimal(5,5),
R2 decimal(5,5),
S1 decimal(5,5),
S2 decimal(5,5),
R1Break decimal(5,5),
R2Break decimal(5,5),
S1Break decimal(5,5),
S2Break decimal(5,5),
LocalHigh decimal(5,5),
LocalLow decimal(5,5),
LocalHighValue decimal(5,5),
LocalLowValue decimal(5,5),
)

INSERT INTO "StockData" ([DateOne],
                         [Open],
                         [High],
                         [Low],
                         [Close],
                         [Volume],
                         [Symbol],
                         [linearReg],
                         [linearReg10],
                         [linearRegAngle],
                         [linearRegSlope],
                         [linearRegSlope10],
                         [linearRegIntercept],
                         [LRSdelta],
                         [Momentum],
                         [FastSlope],
                         [SlowSlope],
                         [RSI],
                         [ADX],
                         [CCI],
                         [CCI5],
                         [PP],
                         [R1],
                         [R2],
                         [S1],
                         [S2],
                         [R1Break],
                         [R2Break],
                         [S1Break],
                         [S2Break],
                         [LocalHigh],
                         [LocalLow],
                         [LocalHighValue],
                         [LocalLowValue])
VALUES (dateone,
        open,
        high,
        low,
        close,
        volume,
        symbol,
        linearreg,
        linearreg10,
        linearregangle,
        linearregslope,
        linearregslope10,
        linearregintercept,
        lrsdelta,
        momentum,
        fastslope,
        slowslope,
        rsi,
        adx,
        cci,
        cci5,
        pp,
        r1,
        r2,
        s1,
        s2,
        r1break,
        r2break,
        s1break,
        s2break,
        localhigh,
        locallow,
        localhighvalue,
        locallowvalue);

INSERT INTO StockData
(
  [DateOne]
, [OPEN]
, [High]
, [Low]
, [CLOSE]
, [Volume]
, [Symbol]
, [linearReg]
, [linearReg10]
, [linearRegAngle]
, [linearRegSlope]
, [linearRegSlope10]
, [linearRegIntercept]
, [LRSdelta]
, [Momentum]
, [FastSlope]
, [SlowSlope]
, [RSI]
, [ADX]
, [CCI]
, [CCI5]
, [PP]
, [R1]
, [R2]
, [S1]
, [S2]
, [R1Break]
, [R2Break]
, [S1Break]
, [S2Break]
, [LocalHigh]
, [LocalLow]
, [LocalHighValue]
, [LocalLowValue]
)
VALUES
(
  dateone
, OPEN
, high
, low
, CLOSE
, volume
, symbol
, linearreg
, linearreg10
, linearregangle
, linearregslope
, linearregslope10
, linearregintercept
, lrsdelta
, momentum
, fastslope
, slowslope
, rsi
, adx
, cci
, cci5
, pp
, r1
, r2
, s1
, s2
, r1break
, r2break
, s1break
, s2break
, localhigh
, locallow
, localhighvalue
, locallowvalue
);
 --->