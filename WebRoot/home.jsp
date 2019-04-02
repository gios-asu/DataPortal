<!--
  ~ Copyright 2011-2014 the University of New Mexico.
  ~
  ~ This work was supported by National Science Foundation Cooperative
  ~ Agreements #DEB-0832652 and #DEB-0936498.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~ http://www.apache.org/licenses/LICENSE-2.0.
  ~
  ~ Unless required by applicable law or agreed to in writing,
  ~ software distributed under the License is distributed on an
  ~ "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
  ~ either express or implied. See the License for the specific
  ~ language governing permissions and limitations under the License.
  -->

<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="edu.lternet.pasta.common.CalendarUtility" %>
<%@ page import="edu.lternet.pasta.portal.ConfigurationListener" %>
<%@ page import="edu.lternet.pasta.portal.DataPortalServlet" %>
<%@ page import="edu.lternet.pasta.portal.PastaStatistics"%>
<%@ page import="edu.lternet.pasta.portal.search.LTERTerms"%>
<%@ page import="edu.lternet.pasta.portal.statistics.GrowthStats"%>

<%
	final String pageTitle = "Home";
	final String titleText = DataPortalServlet.getTitleText(pageTitle);
	session.setAttribute("menuid", "home");

	String uid = (String) session.getAttribute("uid");
	if (uid == null || uid.isEmpty()) {
		uid = "public";
	}

	//String jqueryString = LTERTerms.getJQueryString(); // for auto-complete using JQuery

	// Generate PASTA data package statistics and store values in session.

	String numDataPackages = null;
	String numDataPackagesSites = null;
	PastaStatistics pastaStats = new PastaStatistics("public");

	numDataPackages = (String) application.getAttribute("numDataPackages");
	if (numDataPackages == null) {
		numDataPackages = pastaStats.getNumDataPackages().toString();
		application.setAttribute("numDataPackages", numDataPackages);
	}

	numDataPackagesSites = (String) application.getAttribute("numDataPackagesSites");
	if (numDataPackagesSites == null) {
		numDataPackagesSites = pastaStats.getNumDataPackagesSites().toString();
		application.setAttribute("numDataPackagesSites", numDataPackagesSites);
	}

    GregorianCalendar now = new GregorianCalendar();

    String googleChartJson = (String) application.getAttribute("googleChartJson");
    if (googleChartJson == null) {
        GrowthStats gs = new GrowthStats();
        googleChartJson = gs.getGoogleChartJson(now, Calendar.MONTH);
        application.setAttribute("googleChartJson", googleChartJson);
    }

    String hover = "New user registration for non-LTER members coming soon!";

    final String downtime = (String) ConfigurationListener.getOptions().getProperty("dataportal.downtime.dayOfWeek");
    HttpSession httpSession = request.getSession();
    String downtimeHTML = "";
    
    if (downtime != null && !downtime.isEmpty()) {
        String today = CalendarUtility.todaysDayOfWeek();
        if (today != null && today.equalsIgnoreCase(downtime)) {
            StringBuilder sb = new StringBuilder();
            sb.append(String.format("The Data Portal and PASTA+ services will be unavailable on %s evening from 7-9 pm Mountain Time for scheduled weekly maintenance.",
                                    downtime));
            downtimeHTML = String.format("<em>Please Note: </em>%s",
                                         sb.toString());
        }
    }   
%>

<!DOCTYPE html>
<html lang="en">

<head>
<title><%= titleText %></title>

<meta charset="UTF-8" />
<meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">

<link rel="shortcut icon" href="./images/favicon.ico" type="image/x-icon" />

<!-- Google Fonts CSS -->
<link href="https://fonts.googleapis.com/css?family=Open+Sans:400,300,600,300italic" rel="stylesheet" type="text/css">

<!-- Page Layout CSS MUST LOAD BEFORE bootstap.css -->
<link href="css/style_slate.css" media="all" rel="stylesheet" type="text/css">

<!-- JS -->
<script src="js/jqueryba3a.js?ver=1.7.2" type="text/javascript"></script>
<script src="bootstrap/js/bootstrap68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/jquery.easing.1.368b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/jquery.flexslider-min68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/themeple68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/jquery.pixel68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/jquery.mobilemenu68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/isotope68b368b3.js?ver=1" type="text/javascript"></script>
<script src="js/mediaelement-and-player.min68b368b3.js?ver=1" type="text/javascript"></script>

<!-- Mobile Device CSS -->
<link href="bootstrap/css/bootstrap.css" media="screen" rel="stylesheet" type="text/css">
<link href="bootstrap/css/bootstrap-responsive.css" media="screen" rel="stylesheet" type="text/css">

<!-- Google Chart for NIS Data Package and Site Growth -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript">
	google.charts.load('current', {packages: ['corechart', 'line']});
	google.charts.setOnLoadCallback(drawChart);

    function drawChart() {
      var data = new google.visualization.DataTable();
      data.addColumn('string', 'Month');
      data.addColumn('number', 'Site-Contributed Data Packages');

      data.addRows([
          <%=googleChartJson%>
      ]);
        
      var options = {
        'width' :  400,
        'height' : 250,
        hAxis: {
          title: 'Date'
        },
        vAxis: {
          title: 'Data Packages (Cumulative)'
        },
        backgroundColor: '#f7f7f7'
      };

      var chart = new google.visualization.LineChart(document.getElementById('chart_div'));
      chart.draw(data, options);
    }
</script>

</head>

<body>

<jsp:include page="header.jsp" />

<div class="row-fluid">
	<div class="span12">
		<div class="container">
			<div class="row-fluid distance_1">
				<div class="span8 box_shadow box_layout">
					<div class="row-fluid">
						<div class="span12">
                            <p class="nis-warn"><%= downtimeHTML %></p>                               
							<div class="recent_title">
								<h2>Welcome to the EDI Data Portal</h2>
							</div>
							<span class="row-fluid separator_border"></span>
						</div>
						<div class="row-fluid">
<p>Data are one of the most valuable products curated by the 
<a class="searchsubcat" href="https://environmentaldatainitiative.org">Environmental Data Initiative</a>
(EDI). Data and metadata derived from publicly funded research are made available 
through this website with as few restrictions as possible, and on a 
non-discriminatory basis. In return, EDI expects users of data to act ethically 
by contacting the data provider prior to using it in any published research. 
In accordance with professional etiquette, data accessed from this website 
should be cited appropriately when used in a publication. A digital object 
identifier (DOI) is provided for each dataset to facilitate citation.</p>							
 
<p>The EDI Data Portal contains environmental and ecological data packages 
contributed by a number of participating organizations. Data providers make 
every effort to release data in a timely fashion and with attention to accurate, 
well-designed and well-documented data. To understand data fully, please read 
the associated metadata and contact data providers if you have any questions. 
Data may be used in a manner conforming with the license information found in 
the “Intellectual Rights” section of the data package metadata or defaults to the 
<a class="searchsubcat" href="https://environmentaldatainitiative.org/edi-data-policy/">EDI Data Policy</a>. 
The Environmental Data Initiative shall not be liable for any damages resulting 
from misinterpretation or misuse of the data or metadata.</p>
						</div>
					</div>
				</div>
				<div class="span4 box_shadow box_layout">
					<div class="row-fluid">
						<div class="row-fluid">
								    <div id="chart_div"></div>
<p id="nis-growth">Site contributed data packages: <b><%= numDataPackagesSites %></b><br />
Total data packages: <b><%= numDataPackages %></b></p>

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
        
<jsp:include page="footer.jsp" />
		
</div>

</body>

</html>
