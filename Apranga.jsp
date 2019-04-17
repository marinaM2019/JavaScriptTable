<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Style.css"/>
<link rel="stylesheet" href="vtikCss.css"/>
<link rel="stylesheet" href="Help.css"/>
<link rel="icon" type="image/png" href="fntt.png" />
<%@ page import="com.mysql.jdbc.Connection"%>
<%@ page import="com.mysql.jdbc.PreparedStatement"%>
<%@ page import="connect.MySqlConnectToApranga"%>
<%@ page import="com.mysql.jdbc.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="ua.service.AprangosVeiksmai"%>
<title>FNTT savitarna</title>



</head>
<body>
<link rel="stylesheet" href="ua2.css" />
<%@include file="Header.jsp" %>
<%@include file="Menu.jsp" %>	

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Progma", "no-cache");
response.setHeader("Expires", "0");
if(session.getAttribute("username")==null){
	response.sendRedirect("Login.jsp");
}



if(!(session.getAttribute("username")==null)&&(!((session.getAttribute("userStatusas").equals("statutinis pareigūnas")) || (session.getAttribute("userStatusas").equals("helpAdmin"))))){
	response.sendRedirect("UaNesuteiktaPrieiga.jsp");
}

AprangosVeiksmai gauti = new AprangosVeiksmai();
double uaMaxSuma=gauti.gautiMaksimaliaSuma();
String lytis=String.valueOf(session.getAttribute("lytis"));
String lytiesId="0";
String irasoId="0";
if (lytis.equals("vyr")){
	lytiesId="2";
} else if (lytis.equals("mot")){
	lytiesId="1";
}

int count=0;
int nr=1;
int aprangosTableRow=0;
String dyd333="-";
%>




<br><br>






<script>
function myFunction(selTag) {
	
	document.getElementById("vnt").innerHTML=0;
	
  
  
  var x = selTag.options[selTag.selectedIndex].value;
  
  document.getElementById("vnt").innerHTML = x;
  
  setTimeout(function(){ 
	  document.getElementById("vnt").innerHTML = "0.0";
  }, 100);
  
  
  
}
</script>



				


	<script>
	var rIndex,index,table,selectedIndex = document.getElementById("uniformosTable");
	

function selectedRowToInput(){
	var kainaViso=0;
	var sumaVi=0;
		for (var i = 1; i<table.rows.length; i++){
			table.rows[i].onclick = function(){
				rIndex = this.rowIndex;
   				var irId =  this.cells[0].innerHTML;
   				
				document.getElementById("pavId").value = irId;
				irId2 = irId;
				var kaina = this.cells[3].innerHTML;
				document.getElementById("kain").value = kaina;
				
				var kainaVisoPradineReiksme = this.cells[6].innerHTML;
				var vienetaiPasirinktaReiksme = document.getElementById("vnt").innerHTML;

				if (vienetaiPasirinktaReiksme==="0.0"){
					kainaViso=kainaVisoPradineReiksme;
				} else {
					kainaViso = kaina*vienetaiPasirinktaReiksme;
					
					sumaVi=sumaVi-kainaVisoPradineReiksme;
					sumaVi = sumaVi+kainaViso;
					var summmm = (Math.round(sumaVi * 100) / 100);
					document.getElementById("sumaa").innerHTML = summmm;
					var maxSuma = '<%= uaMaxSuma%>';
					var likutisV = (maxSuma-summmm);
					var likutisViso = (Math.round(likutisV * 100) / 100);
					document.getElementById("likutis").innerHTML = likutisViso;
					
					

				}
					
				this.cells[6].innerHTML=kainaViso;
				
				
				if(typeof index !== "undefined"){
                    table.rows[index].classList.toggle("selected");
                 }
                 
                 index = this.rowIndex;
                 this.classList.toggle("selected");
	
			};
		}
		
}

selectedRowToInput();

</script>



	<div id="pateiktiGedimai">

		<%@include file="UaAdmin.jsp"%>
		<br>
		

		<div id="helpLentelesTextColor">
		<div id="helpTurto">
Pateikti naują aprangos užsakymą
</div>
			<br>
			
			
			
			<form method="post" action="UaPateikimas.jsp">
			
			
			<table id="uniformosTable" onload="selectedRowToInput();">
				<colgroup>
				
					<col style="width: 3%">
					<col style="width: 35%">
					<col style="width: 8%">
					<col style="width: 20%">
					<col style="width: 10%">
					<col style="width: 5%">


				</colgroup>
				<thead>
					<tr>
						<th>ID</th>
						<th>Nr.</th>
						<th>Pavadinimas</th>
						<th>Kaina</th>
						<th>Dydis</th>
						<th>Kiekis</th>
						<th>Suma</th>
						
						



					</tr>


				</thead>

<%
try {
	Connection connection = (Connection) MySqlConnectToApranga.getConnection();
	String sql = "SELECT id, pavadinimas, lyties_id, kaina, statusas, dydziai FROM apranga WHERE lyties_id='"+lytiesId+"' AND statusas=1 ORDER BY lyties_id, pavadinimas";
	
	
	PreparedStatement pst = (PreparedStatement) connection.prepareStatement(sql);
    ResultSet rs=pst.executeQuery();
    
    int i=1;
    while (rs.next()) {
            %>

				<tbody>
					<tr class="item">
						
						<%
						
						%>
					
						<td name="irasoId"<%=aprangosTableRow%> id="irasoId"<%=aprangosTableRow%>><%=rs.getString("id")%></td>
						<td><%=nr++%></td>
						
						
						
						<td><%=rs.getString("pavadinimas")%></td>
						<td><%=rs.getString("kaina")%></td>
						
						
						<td><center><select name="aprangosDydziai" id="aprangosDydziai" >
						
						<%
						String dyd=rs.getString("dydziai");
						if (dyd.equals("-;")) {
							%>
							<option value="">-</option>
							<%
						} else {
							%>
							<option value="">pasirinkite</option>
							<%
						
						String [] dydis = dyd.split(";");
						for (int ii=0; ii<dydis.length; ii++){
							%>
							<option value="<%=dydis[ii]%>"><%=dydis[ii]%></option>
							<%
						}
						}
						aprangosTableRow=nr-1;
						 %>
						
						</select></center></td>
						
						
						
						
						<td>
						
						<center>
						<select id="aprangosVien" onchange="myFunction(this)" data-action="expand">
						<option value="0">0</option>
						<option value="1">1</option>
						<option value="2">2</option>
						<option value="3">3</option>
						<option value="4">4</option>
						<option value="5">5</option>
						</select>
						</center>			
						</td>
					
						
						
						
						
							<td id="tarpineSuma" name="tarpineSuma">
0
							</td>
							
						
					
					
					</tr>
				</tbody>


				<%
                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                }
            %>
			</table>
			<br>
			<div id="helpTurto">
			<font color="green">Maksimali užsakymo suma: <br>
			<%= uaMaxSuma%></font>
			
			<br>
			<br><u>Jūsų užsakymo suma: <div name="sumaa" id="sumaa">0</u></div>
			
			<br>
			<font color="red">Likutis:
			<br>
			<div name="likutis" id="likutis"><%= uaMaxSuma%></div>
			</font>
			</div>






<input type="text" name="pavId" id="pavId" style="visibility: hidden"><br>


<br>

<b><div name="vnt" id="vnt" style="visibility: hidden">0</div></b>

<br>
<input type="text" name="kain" id="kain" style="visibility: hidden">

<input type="submit" class="pateiktiAtaskaita" value="Pateikti užsakymą" id="pateiktiAprParaiska" >


<%
for (int i=0; i<aprangosTableRow; i++){
	%>
	<input type="text" id="irId"<%=i%> name="irId"<%=i%> style="visibility: hidden">
	<%
}
%>





	</form>
			
			<script>

var table = document.getElementById('uniformosTable'),rIndex;

for (var i=0; i<table.rows.length; i++) {
	table.rows[i].onclick = function(){
		rIndex = this.rowIndex;
		alert(rIndex);
	}
}
selectedRowToInput();
</script>
</div>
</div>


<br><br><br><br>


<%@include file="fntt.jsp" %>	
</body>
</html>