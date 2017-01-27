<%@ Page Language="C#" MaintainScrollPositionOnPostBack=true EnableViewStateMac="false" %>
<%@ Import namespace="Newtonsoft.Json.Linq" %>
<%@ Import namespace="System" %>
<%@ Import namespace="System.Net" %>
<%@ Import namespace="System.Web" %>
<%@ Import namespace="System.IO" %>
<%@ Import namespace="System.Collections" %>
<%@ Import namespace="System.Text" %>
<%@ Import namespace="System.Xml" %>
<%@ Import namespace="System.Collections.Generic" %>
<%@ Import namespace="System.Linq" %>
<html>
   <head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="../vendor/node_modules/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

  <link rel="stylesheet" href="../vendor/font-awesome/css/font-awesome.min.css">
  <link rel="stylesheet" href="../css/style.css">


    <title>SenseBot search page</title>
	
<script type="text/javascript">
var i
function glow()
{
    i=0
/*
    if (navigator.appName.indexOf('Microsoft') == -1)
      {// code for all new browsers
        setTimeout('document.images["myAnimatedImage"].src = "moon0.jpg";', 20); 
        //i++;
        interval=setInterval("makeglowFF()",1000)
      }
    else
*/    
      {// code for IE
        //interval=setInterval("makeglow()",1000)
        setTimeout('document.images["myAnimatedImage"].src = "ajax-loader.gif";', 20); 
        interval=setInterval("makeglow()",1000)
      }
}

function makeglowFF()
{
    i++;
    if (i >= 5)
        i = 0;
    document.getElementById('myHiddenDiv').style.display = ""; 
    document.images["myAnimatedImage"].src = "moon" + i + ".jpg";
}

function makeglow()
{
    if (i == 0)
    {
        document.getElementById('myHiddenDiv').style.display = ""; 
        document.images["myAnimatedImage"].src = "ajax-loader.gif";
        i++;
    }
    else
    {
        document.getElementById('myHiddenDiv').style.display = "none"; 
        document.images["myAnimatedImage"].src = "ajax-loader.gif";
        i--;
    }
}
</script>
   </head>
	<script language="Javascript" type="text/javascript">

	function RecordData()
	{
		var URLs = "";
		var Titles = "";
		var SelCount = 0;
			
		var Tab1 = document.getElementById("TableResult");
		var Rows = Tab1.rows;
		var Cnt = Rows.length;
		for (var j = 0; j < Cnt; j++)
		{
			var CurRow = Rows[j];
			var Cells = Rows[j].cells;
			var CurrCell = Cells[0];
			var chkbox = CurrCell.firstChild;
			var indstart = 0;
			var indend = 0;
			var indnext = 0;
			if (chkbox.checked)
			{
				var lb = Cells[1].firstChild;
				var strsource = lb.innerHTML;
				indstart = strsource.indexOf('href');
				if (indstart == -1)
					return;
				indend = strsource.indexOf('\">', indstart);
				if (indend == -1)
					return;
				var strurl = strsource.substring(indstart+6, indend);

	        strurl = strurl.replace(/<b>/gi, '');
	        strurl = strurl.replace(/<\/b>/gi, '');

				indstart = strsource.indexOf('</', indend);
				if (indstart == -1)
					return;
				var strtitle = strsource.substring(indend+2, indstart);

	        strtitle = strtitle.replace(/<b>/gi, '');
	        strtitle = strtitle.replace(/<\/b>/gi, '');

				var strurlesc = escape(strurl);
				var strtitleesc = escape(strtitle);

				// check cookie size:
				if ((URLs.length + strurlesc.length >= 4096)  ||  (Titles.length + strtitleesc.length >= 4096))
					break;
				if (URLs == "")
					URLs += strurlesc;
				else
					URLs += " " + strurlesc;

				if (Titles == "")
					Titles += strtitleesc;
				else
					Titles += " " + strtitleesc;

				SelCount++;
			}
		}

		document.cookie = "selection=" + URLs;
		document.cookie = "titles=" + Titles;
		document.cookie = "selcount=" + SelCount;
		document.cookie = "name=";
		document.cookie = "count=" + "0";
		document.cookie = "sources=";
		document.cookie = "folder=";
		document.cookie = "provider=";
//alert(Titles);
		//var requery = document.getElementById("tbQuery");
		//document.cookie = "requery=" + requery.value;

	}
	
	function SumBtn_Click()
	{
		RecordData();

		//var sentences = document.getElementById("tbSentences");

		var redirect = "content3front.aspx?sentences=20";
        glow();
		window.location.replace(redirect);

		//var redirect = "content3front.aspx?sentences=" + sentences.value;
		//window.location = redirect;	
	}

	// NOT USED!
	function CheckBtn_Click()
	{
		var bUncheck = false;
		var btn = document.getElementById("btnCheck");

		if (btn.value == "Uncheck all")
		{
			bUncheck = true;
			btn.value = "Check all";
			btn.innerHTML = "Check all";
		}
		else if (btn.value == "Check all")
		{
			bUncheck = false;
			btn.value = "Uncheck all";
			btn.innerHTML = "Uncheck all";
		}
		var Tab1 = document.getElementById("TableResult");
		var Rows = Tab1.rows;
		var Cnt = Rows.length;
		for (var j = 0; j < Cnt; j++)
		{
			var CurRow = Rows[j];
			var Cells = Rows[j].cells;
			var CurrCell = Cells[0];
			var chkbox = CurrCell.firstChild;
			chkbox.checked = bUncheck ? false : true;
		}

		RecordData();
	}


    function readCookie(name)
    {
		var nameEQ = name + "=";
		var ca = document.cookie.split(';');
		for(var i=0;i < ca.length;i++)
		{
			var c = ca[i];
			while (c.charAt(0)==' ') c = c.substring(1,c.length);
			if (c.indexOf(nameEQ) == 0)
			{
				return c.substring(nameEQ.length,c.length);
			}
		}

	return null;
	}		

	var searchterm;
	var	researchterm;

        // NOT USED!
        function SearchDone(results) {
	
//?		document.cookie = "requery=" + searchstring;
//alert(results);
return;

		var TabRes = document.getElementById("TableResult");
		Rows = TabRes.rows;
		if (Rows != null)
		{
			Cnt = Rows.length;
			for (j=Cnt-1; j >= 0; j--)
				TabRes.deleteRow(j);
		}	

		var URLs = "";
		var Titles = "";
		var SelCount = 0;

        if (results == null)
            return;
        var Root = results.ysearchresponse;
        if (Root == null)
            Root = results.asearchresponse;
        if (Root == null)
        {
            alert("No results found - please go Back and choose another engine, or uncheck the News box.")
            var progSpan = document.getElementById("progress");
            progSpan.innerHTML = "<i>Press the Back button</i>";
            return;
        }

        var ResultSet;
	    if (NEWS != null  &&  NEWS == "news")
            ResultSet = Root.resultset_news;
        else
            ResultSet = Root.resultset_web;

        var returnedLinkCount = ResultSet.length;

        for (var i=0; i < returnedLinkCount; i++) {
            var result = ResultSet[i];
	        var titleLine = result.title;
	        var clickUrl = result.clickurl;

			if (clickUrl.indexOf('http://') != 0)
			    clickUrl = 'http://' + clickUrl;

			var visibleUrl;
			if (NEWS != null  &&  NEWS == "news")
		        visibleUrl = result.sourceurl;
		    else
		        visibleUrl = result.dispurl;

	        clickUrl = clickUrl.replace(/<b>/gi, '');
	        clickUrl = clickUrl.replace(/<\/b>/gi, '');
	        visibleUrl = visibleUrl.replace(/<b>/gi, '');
	        visibleUrl = visibleUrl.replace(/<\/b>/gi, '');
	        titleLine = titleLine.replace(/<b>/gi, '');
	        titleLine = titleLine.replace(/<\/b>/gi, '');

			var contentLine = result.abstract;
    
			var row = TabRes.insertRow(TabRes.rows.length);
			var CurrCell = row.insertCell(0);
			CurrCell.innerHTML = "<input type=\"checkbox\" name=\"include\" checked=\"yes\" onclick = \"RecordData();\" >&nbsp;include</input>";

			CurrCell = row.insertCell(1);
			var Heading = "<span style=\"font-size: 16;\"><a href=\"" + clickUrl + "\"> " + titleLine + "</a></span><br>" + 
			contentLine + "<br><div style=\"color: green;\">" + visibleUrl + "</div>";
			CurrCell.innerHTML = "<label>" + Heading;
		}
	}

    function OnLoad()
    {
	  NEWScookie = readCookie("news");
	  if (NEWScookie != null  &&  NEWScookie != "")
		  NEWS = "news";

      searchterm = readCookie("query");
	  researchterm = readCookie("requery");
	  if (researchterm != null  &&  researchterm != "")
		    searchterm = researchterm;

        var querystr = window.location.search.substring(1);
        if (querystr != '')
            searchterm = unescape(querystr);
	    
//	    dynamicSearch();
SumBtn_Click();
    }

window.onload = OnLoad; 

	</script>

   <script language="C#" runat=server>

       bool bNews = false;
       
       void Page_Load(Object sender, EventArgs e)
	    {
			//Response.Cookies["name"].Value = null;
			//Response.Cookies["count"].Value = "0";
            		//Response.Cookies["sources"].Value = null;
            		//Response.Cookies["folder"].Value = null;
 			if (!IsPostBack)	// first visit
			{
				//tbSentences.Text = "20";

                if (Request.Cookies["news"] != null)
                {
                    string strnews = Request.Cookies["news"].Value;
                    if (strnews.Length > 0)
                        bNews = true;
                }
                    
                string searchterm1 = "";
                if (Request.Cookies["query"] != null)
                {
                    searchterm1 = Request.Cookies["query"].Value;
                    tbQuery.Text = searchterm1;
                    DoSearch(searchterm1, bNews);
                }
            }
			//string searchterm2 = Request.Cookies["requery"].Value;
			//Message.Text = "query: " + searchterm1 + " requery: " + searchterm2;
		}

	        void SearchBtn_Click(Object sender, EventArgs e) 
        	{
			tbQuery.Text = tbQuery.Text.Trim();
			if (tbQuery.Text != "")
       				DoSearch(tbQuery.Text, bNews);
		}
		
private static string NewsSearchEndPoint = "https://api.cognitive.microsoft.com/bing/v5.0/news/search";
private static string WebSearchEndPoint = "https://api.cognitive.microsoft.com/bing/v5.0/search";

		private void DoSearch(string QueryTerm, bool useNews)
		{
			string QueryLanguage;
			string QueryLanguageShort;
			if (Request.Cookies["senselang"] == null)
{	// 5/27/2015
				QueryLanguage = "en-US";
				QueryLanguageShort = "en";
}
			else if (Request.Cookies["senselang"].Value == "English")
{	// 5/27/2015
				QueryLanguage = "en-US";
				QueryLanguageShort = "en";
}
			else if (Request.Cookies["senselang"].Value == "French")
{	// 5/27/2015
				QueryLanguage = "fr-FR";
				QueryLanguageShort = "fr";
}
			else if (Request.Cookies["senselang"].Value == "German")
{	// 5/27/2015
				QueryLanguage = "de-DE";
				QueryLanguageShort = "de";
}
			else if (Request.Cookies["senselang"].Value == "Spanish")
{	// 5/27/2015
				QueryLanguage = "es-ES";
				QueryLanguageShort = "en";
}
			else
{	// 5/27/2015
				QueryLanguage = "en-US";
				QueryLanguageShort = "en";
}

            Response.Cookies["requery"].Value = QueryTerm;
            string result = "";
            try
            {
                const string SearchApiKey = "00a6022abf6c4b3da17c41e6404b7160";

                HttpWebRequest myRequest;
                if (useNews)
                    myRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/?q={1}&count={2}&offset={3}&mkt={4}",
                    NewsSearchEndPoint, HttpUtility.UrlEncode(QueryTerm), 10, 0, QueryLanguage));
                else
                    myRequest = (HttpWebRequest)WebRequest.Create(string.Format("{0}/?q={1}&count={2}&offset={3}&mkt={4}&responseFilter=Webpages",
                    WebSearchEndPoint, HttpUtility.UrlEncode(QueryTerm), 10, 0, QueryLanguage));

                myRequest.Method = "GET";
                //myRequest.Timeout = bLite? WEB_TIMEOUT_LITE : WEB_TIMEOUT;
                myRequest.Headers.Add("Ocp-Apim-Subscription-Key", SearchApiKey);

                using (StreamReader responseReader = new StreamReader(myRequest.GetResponse().GetResponseStream()))
                {
                    result = responseReader.ReadToEnd();
                }

                JObject data = JObject.Parse(result);
                JToken webresult = null;
                JArray arrdata = null;
                if (!useNews)
                {
                    webresult = data["webPages"];
                    arrdata = (JArray)(webresult["value"]);
                }
                else
                    arrdata = (JArray)(data.GetValue("value"));

                //           Message.Text = data.ToString();

                int i = 0;
                string title = "";
                string source = "";
                string content = "";
                for (int b = 0; b < Math.Min(10, arrdata.Count); b++)
                {
                    if (useNews)
                    {
                        JToken aritem = arrdata[b];

                        string url = "";
                        string realurl = "";
                        url = aritem["url"].ToString();
                        int m1 = -1;
                        int m2 = -1;
                        m1 = url.IndexOf("http%3a%2f%2f");
                        if (m1 < 0)
                            m1 = url.IndexOf("https%3a%2f%2f");
                        if (m1 >= 0)
                            m2 = url.IndexOf('&', m1);
                        if (m1 >= 0 && m2 >= 0)
                            realurl = url.Substring(m1, m2 - m1);
                        else if (m1 >= 0)
                            realurl = url.Substring(m1);
                        else
                            realurl = url;
                        string unescurl = Server.UrlDecode(realurl);
                        //Message.Text += unescurl + "<br>";

                        title = aritem["name"].ToString();
                        content = aritem["description"].ToString();
                        JArray arsrc = (JArray)aritem["provider"];
                        source = arsrc[0]["name"].ToString();
                        //                   Message.Text += source + "<br>";

                        StringWriter sw = new StringWriter();
                        sw.WriteLine("<span style=\"font-size: 16;\"><a href=\"{0}\"> {1}</a></span><br>",
                            unescurl, title);

                        sw.WriteLine("{0}<br>", content);
                        sw.WriteLine("<div style=\"color: green;\">{0}</div>", source);
                        AddRow(i, sw.ToString(), unescurl, title);
                        i++;
                    }
                    else   // web results
                    {
                        JToken aritem = arrdata[b];

                        string url = "";
                        string realurl = "";
                        string displayUrl = aritem["displayUrl"].ToString();
                        url = aritem["url"].ToString();
                        int m1 = -1;
                        int m2 = -1;
                        m1 = url.IndexOf("http%3a%2f%2f");
                        if (m1 < 0)
                            m1 = url.IndexOf("https%3a%2f%2f");
                        if (m1 >= 0)
                            m2 = url.IndexOf('&', m1);
                        if (m1 >= 0 && m2 >= 0)
                            realurl = url.Substring(m1, m2 - m1);
                        else if (m1 >= 0)
                            realurl = url.Substring(m1);
                        else
                            realurl = url;
                        string unescurl = Server.UrlDecode(realurl);
                        //Message.Text += unescurl + "<br>";

                        title = aritem["name"].ToString();
                        content = aritem["snippet"].ToString();

                        StringWriter sw = new StringWriter();
                        sw.WriteLine("<span style=\"font-size: 16;\"><a href=\"{0}\"> {1}</a></span><br>",
                            unescurl, title);

                        sw.WriteLine("{0}<br>", content);
                        sw.WriteLine("<div style=\"color: green;\">{0}</div>", displayUrl);
                        AddRow(i, sw.ToString(), unescurl, title);
                        i++;
                    }
                    for (int j = i; j < TableResult.Rows.Count; j++)
                        TableResult.Rows[j].Visible = false;

                }
            }
            catch (Exception ex)
            {
                Message.Text += ex.Message + " INNER: " + ex.InnerException;
                for (int j = 0; j < TableResult.Rows.Count; j++)
                    TableResult.Rows[j].Visible = false;
                return;
            }
		}
		
	void AddRow(int rowind, string Heading, string Url, string Title)
	{

		TableRow r = new TableRow();

		TableCell c1 = new TableCell();
		CheckBox NewCheckBox = new CheckBox();
		//NewCheckBox.ID="chkSource" + j.ToString();
		NewCheckBox.AutoPostBack = false;
		NewCheckBox.Checked = true;
		NewCheckBox.Text = "include";
					//NewCheckBox.CheckedChanged += new System.EventHandler(RecordSources);
					//NewCheckBox.CheckedChanged += sourcesHandler;
		NewCheckBox.Attributes["onclick"] = "RecordData();";
		c1.Controls.Add(NewCheckBox);
		r.Cells.Add(c1);

		TableCell c2 = new TableCell();
		/*
		TextBox NewTB2 = new TextBox();
		//NewTB.ID = "tbSource" + j.ToString();
		NewTB2.TextMode = TextBoxMode.MultiLine;
		NewTB2.Text = Heading;
		NewTB2.AutoPostBack = false;
		NewTB2.BorderStyle = BorderStyle.None;
		NewTB2.BackColor = TableResult.BackColor;
		NewTB2.ReadOnly = true;
		c2.Controls.Add(NewTB2);
		*/

		Label NewLabel2 = new Label();
		//NewLabel2.ID = "srclabel" + rowind.ToString();
		NewLabel2.Text = Heading;
		c2.Controls.Add(NewLabel2);
		r.Cells.Add(c2);
		TableResult.Rows.Add(r);
	}
		
      </script>


  <div class="container-fluid">
    <header>
      <div class="row">
        <div class="col-lg-12">
          <h1><span class="orange">Sense</span><span class="green">Bot</span></h1>
        </div>
        <div class="col-lg-12">
          <p> Search Engine that finds sense in a heap of Web pages</p>
        </div>
      </div>
<div class="topMargin">
        <span id="progress">
            <i class="fa fa-spinner fa-spin fa-3x fa-fw"></i>
            <span class="sr-only">Loading...</span>
        </span>

        <h3 class="loading">Loading</h3>
</div>
    </header>
  </div><!--/.container-->

   

        <span id='myHiddenDiv' style='display:none'> 
            <img src='' id='myAnimatedImage' align="middle"> 
          </span> 
</center>

			<form action="custom1.aspx" method="post" runat="server">
			
			<div style="text-align: left; ">
<asp:textbox id="tbQuery" runat="server" style="display: none;" />

						<p>

						<asp:label id="Message" runat="server"/>
<p>

           </div>

         <asp:Table id="TableResult" 
          Width="95%"
          GridLines="None" 
          HorizontalAlign="Center" 
          CellPadding=15 
          CellSpacing=0 
          style="display: none;"
          Runat="server">
		  </asp:Table>
			<asp:label id="Results" runat="server"></asp:label>

<br>
</form>
           <p>


<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-4328447-1");
pageTracker._initData();
pageTracker._trackPageview();
</script>
</body>
</html>