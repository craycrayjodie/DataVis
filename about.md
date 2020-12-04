<h2>Objectives</h2>
This simple app was designed to demonstrate how to create a visualization dashboard/application/storyboard that will tell a compelling story using open data. I achieved this affect through use of various R libraries including leaflet and highcharter for interactive features. 

<h3>The Data</h3>
The data is sourced from the <a href="https://dataforgood.fb.com/tools/movement-range-maps/">Facebook for Good</a> website.
Movement Range Maps inform researchers and public health experts about how populations are responding to physical distancing measures. The Change in Movement metric looks at how much people are moving around and compares it to a baseline period that predates most social distancing measures. 

For Australian data,  we are using four weeks of February, from the 2nd to the 29th, as a baseline period. 

This visualization uses level 2 divisions from the Database of Global Administrative Areas (GADM) from the <a href="https://gadm.org/download_country_v3.html">GADM</a> website. The data are freely available for academic use and other non-commercial use. Redistribution, or commercial use is not allowed without prior permission.

<h3>Methodology</h3>
People who use Facebook on a mobile device have the option of providing their precise location in order to enable products like Nearby Friends and Find Wi-Fi, and get local content and ads. Movement Range Trends are produced by aggregating and de-identifying this data. Only people who opt in to Location History and background location collection are included. People with very few location pings in a day are not informative for these trends, and, therefore, only people whose location is observed for a meaningful period of the day are included in the dataset. 

The metric in this data set is produced for a given administrative region once per day. Some conflict areas, disputed territories, and countries where Facebook does not operate are omitted from the data sets. Each data point corresponds to a full day and night, from 8:00 p.m. one day to 7:59 p.m. the next day in local time. 

To generate a data point for a given region, Facebook aggregates the locations of users who spend evenings there. After mapping people to a region, Facebook ensures that there is enough data to produce meaningful trends and to protect the privacy of individuals. Any region with fewer than 300 qualifying people is omitted from the data sets.

<h4>Calculating the Change in Movement metric</h4>

The idea behind Change in Movement is to understand how much less people are moving around since the onset of the coronavirus epidemic. Facebook quantifies how much people move around by counting the number of level-16 Bing tiles (which are approximately 600 meters by 600 meters in area at the equator) they are seen in within a day. People seen in more tiles are probably moving around more, while people seen in fewer are probably moving around less.

For more information about how the metric is calculated visit the <a href="https://research.fb.com/blog/2020/06/protecting-privacy-in-facebook-mobility-data-during-the-covid-19-response/">Protecting Privacy in Facebook Mobility Data</a> website.  

<h4>Highcharts Non-Commercial License</h4>
Highcharts is free to use for personal projects, school websites, and non-profit organisations.

Highsoft software products are not free for commercial and governmental use. 

This software is released under a <a href="https://creativecommons.org/licenses/by-nc/3.0/us/"> Creative Commons Attribution Non Commercial 3.0</a> license.

<h4>References</h4>

<i>COVID-19 pandemic in Australia</i> 2020, Wikipedia.

Fevre, GL n.d., <i>The Mineral Resource Boom and the Economy of South West Queensland - National Institute of Economic and Industry Research,</i> viewed 3 December 2020, <https://nieir.com.au/the-mineral-resource-boom-and-the-economy-of-south-west-queensland/>.

Newsletter, 2020 Copyright Grattan Institute Facebook | Twitter | Email
n.d.,<i>Coming out of COVIID-19 lockdown: the next steps for Australian health care,</i> Grattan Institute. 

Ting, I & Palmer, A 2020, <i>'Cataclysmic': This data reveals how we dodged a coronavirus catastrophe,</i> ABC News.



