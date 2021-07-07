<h1>MAFractalsRSI EA MT4</h1>
<h2>Credit where credit is due!</h2>
The credit for this trading strategy must go to Arty of <a href="https://www.youtube.com/channel/UCYFQzaZyTUzY-Tiytyv3HhA">The Moving Average YouTube Channel</a>
Please check out his videos, they are really helpful and really well done!
This strategy is implementing 
<a href="https://www.youtube.com/watch?v=MK47z07tGNM&list=PLv-X125JpAa0tPZeAbp3N8iIIIULhIOar&index=30">"Best Scalping Strategy Period"</a>

<h2>Help me maintain and support development of automated trading tools</h2>
Use any of the links below to help contribute to this open source project and all of my other projects too!

[![BuyMeACoffee](https://img.shields.io/badge/buy%20me%20a%20coffee-donate-orange)](https://www.buymeacoffee.com/TomCarrForex) [![Patreon](https://img.shields.io/badge/patreon-donate-orange.svg)](https://www.patreon.com/TomCarrForex) [![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE) [![platform](https://img.shields.io/badge/platform-MT4-blue)](Platform) [![vps](https://img.shields.io/badge/suggested%20vps-time4vps-green)]( 	https://www.time4vps.com/?affid=5737) [![broker](https://img.shields.io/badge/find%20a%20broker-cashback%20forex-green)](https://www.cashbackforex.com#aid_359774) [![testdata](https://img.shields.io/badge/accurate%20test%20data-tickstory-green)](https://tickstory.7eer.net/c/2693658/213763/3725) 

<h2>Why is this free?</h2>
I'm a believer in open source everything where possible. I use all the tools I create myself on live accounts to make some supplementary income. If you find the tools that I have built useful then please feel free to donate above. Although use this software at your own risk, I'm not responsible for any transactions that occur and am providing this software for free under the MIT license.

<h2>Testing Expert Advisors</h2>
To test and validate the EA in as close to market conditions as possible it is essential to use the Dukascopy dataset of historical tick data. I have used TickStory with a great deal of success and the import process into mt4 is easy. There are other tools available but please test all expert advisors with the tick data gained from Dukascopy rather than the MetaTrader supplied data. 

<h2>Expert Advisor Properties</h2>
<table style="width:100%">
  <tr>
    <th>Variable Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <th>TIME_BASE_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>TIME_BASE</th>
    <th>The time frame to be used, this is used to ensure set files are simple drag and drop rather than setting the correct time frame exactly on the chart.</th>
  </tr>
  <tr>
    <th>SESSION_TIME_START</th>
    <th>The start time of the session, time GMT is used currently, again to ensure that the set files produced are as simple as possible.</th>
  </tr>
  <tr>
    <th>SESSION_TIME_STOP</th>
    <th>The stop time of the session, time GMT is used currently, again to ensure that the set files produced are as simple as possible.</th>
  </tr>
  <tr>
    <th>MOVING_AVERAGE_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>MA_PERIOD_SHORT</th>
    <th>The moving average period for the short SMA.</th>
  </tr>
  <tr>
    <th>MA_PERIOD_MEDIUM</th>
    <th>The moving average period for the medium SMA.</th>
  <tr>
    <th>MA_PERIOD_LONG</th>
    <th>The moving average period for the long SMA.</th>
  <tr>
    <th>MIN_MA_DISTANCE_PIPS</th>
    <th>The minimum distance between the long and the short moving average, set to zero if you don't want to filter on this.</th>
  </tr>
  <tr>
    <th>RSI_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>RSI_PERIOD</th>
    <th>The period for the RSI indicator.</th>
  </tr>
  <tr>
    <th>RSI_PROCESS_CROSSOVER</th>
    <th>If true, this will return a zero value as the RSI average if there is a single crossover over the threshold value of 50% and therefore not trade if any instances of the RSI cross over within the RSI_AVERAGED_PERIOD.
    If false, this will return the average of the last RSI values within the RSI_AVERAGED_PERIOD.</th>
  </tr>
  <tr>
    <th>RSI_AVERAGED_PERIOD</th>
    <th>The number of RSI samples to positively identify a trend, set to 1 if you don't want to use an average.</th>
  </tr>
  <tr>
    <th>RANGING_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>RANGING_CHECK</th>
    <th>Check for a cross over of any of the moving averages within the last n(RANGING_NO_SAMPLES) samples.</th>
  </tr>
  <tr>
    <th>RANGING_NO_SAMPLES</th>
    <th>The number of samples to use for the ranging check.</th>
  </tr>
  <tr>
    <th>TRAILING_SL_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>MODIFY_ENABLED</th>
    <th>Enable the modification of the StopLoss if/when the price moves over the profit line. Your broker does set the minimum distance which is used in the first instance, after which the TRADING_TRAILING_STOP value is used.</th>
  </tr>
  <tr>
    <th>TRADING_TRAILING_STOP</th>
    <th>The trailing stop value in Points</th>
  </tr>
  <tr>
    <th>TRADING_REMOVE_TP_ON_TRAILING_STOP</th>
    <th>The removal of the TakeProfit when the StopLoss is moved, set to false if you don't want this.</th>
  </tr>
  <tr>
    <th>TRADING_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>MAX_ORDERS</th>
    <th>The maximum number of orders to be placed by this EA.</th>
  </tr>
  <tr>
    <th>TRADING_TP_MULTIPLIER</th>
    <th>The TakeProfit multiplier, this is a multiplier applied to the StopLoss value to ensure a ratio of risk to reward.</th>
  </tr>
  <tr>
    <th>TRADING_LOT_SIZE_FIXED</th>
    <th>If true, use the TRADING_LOT_SIZE_FIXED_VALUE. If false use the TRADING_PERCENTAGE_FREE_MARGIN to calculate the risk in lots.</th>
  </tr>
  <tr>
    <th>TRADING_LOT_SIZE_FIXED_VALUE</th>
    <th>The fixed lot size to use per trade.</th>
  </tr>
  <tr>
    <th>TRADING_PERCENTAGE_FREE_MARGIN</th>
    <th>The percentage of free margin to risk per trade.</th>
  </tr>
  <tr>
    <th>TRADING_COMMENT</th>
    <th>The comment to add to the trade.</th>
  </tr>
  <tr>
    <th>TRADING_MAGIC_NUMBER</th>
    <th>The magic number to add to the trade.</th>
  </tr>
  <tr>
    <th>STOP_LOSS_MODE</th>
    <th>MA_LOW - Use the slow moving average value as the stop loss.
    MA_MED - Use the medium moving average value as the stop loss.
    MA_HIGH - Use the fast moving average value as the stop loss.</th>
  </tr>
  <tr>
    <th>DEBUG_SEPERATOR</th>
    <th>N/A – Not used by the EA.</th>
  </tr>
  <tr>
    <th>DEBUG_PRINT</th>
    <th>Enable debug printing to see order details, will be printed to the journal.</th>
  </tr>
  