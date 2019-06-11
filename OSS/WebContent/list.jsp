<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
 <title>게시판</title>


 </head>
 <body>
 
 <%
 request.setCharacterEncoding("UTF-8");

 String cn2=request.getParameter("cnt");
 int cnt=0;
 if(cn2==null)
 {
	  cnt=2;
 }
 else
 {
	 cnt = Integer.parseInt(cn2);
 }

 String id4="";
 String id2="";
 id2 = (String)session.getAttribute("userID"); 
 id4 = (String)request.getParameter("title");
 session.setAttribute("id5",id4);
 if(cnt==2)
 {
 Class.forName("com.mysql.cj.jdbc.Driver");
 String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
	String id = "root";
	String pass = "admin";
	int total = 0;
	
	try {
		Connection conn = DriverManager.getConnection(url,id,pass);
		Statement stmt = conn.createStatement();

		String sqlCount = "SELECT COUNT(*) FROM board2 WHERE shelterName='"+session.getAttribute("id5")+"'";
		ResultSet rs = stmt.executeQuery(sqlCount);
		
		if(rs.next()){
			total = rs.getInt(1);
		}
		rs.close();
		out.print("총 게시물 : " + total + "개");
		
		String sqlList = "SELECT shelterName,id,memo from board2 WHERE shelterName='"+session.getAttribute("id5")+"'";
		rs = stmt.executeQuery(sqlList);
		
%>
<br>아이디: <%=id2 %><br>대피소이름: <%=session.getAttribute("id5") %><br>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr height="5"><td width="5"></td></tr>
 <tr style="background:url('img/table_mid.gif') repeat-x; text-align:center;">
   <td width="5"><img src="img/table_left.gif" width="5" height="30" /></td>
   <td width="">대피소 이름</td>
   <td width="73">ID</td>
   <td width="373">내용</td>
   <td width="7"><img src="img/table_right.gif" width="5" height="30" /></td>
  </tr>
<%
	if(total==0) {
%>
	 		<tr align="center" bgcolor="#FFFFFF" height="30">
	 	   <td colspan="6">등록된 글이 없습니다.</td>
	 	  </tr>
<%
	 	} else {
	 		
		while(rs.next()) {
			String de = rs.getString(1);
			String id1 = rs.getString(2);
			String memo = rs.getString(3);
			
		
%>
<tr height="25" align="center">
	<td>&nbsp;</td>
	<td><%=session.getAttribute("id5")%></td>
	<td align="left"><%=id1 %></td>
	<td align="center"><%=memo %></td>
	
	<td>&nbsp;</td>
</tr>
  <tr height="1" bgcolor="#D2D2D2"><td colspan="6"></td></tr>
<% 
		}
	} 
	rs.close();
	stmt.close();
	conn.close();
} catch(SQLException e) {
	out.println( e.toString() );
}
 }
 else if(cnt==1)
 { 
	
	 String cn1=request.getParameter("re");
	 id4=request.getParameter("re");
	 Class.forName("com.mysql.cj.jdbc.Driver");
 String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
	String id = "root";
	String pass = "admin";
	int total1 = 0;
	
	try {
		Connection conn = DriverManager.getConnection(url,id,pass);
		Statement stmt = conn.createStatement();

		String sqlCount = "SELECT COUNT(*) FROM board2 WHERE shelterName='"+id4+"'";
		ResultSet rs = stmt.executeQuery(sqlCount);
		
		if(rs.next()){
			total1 = rs.getInt(1);
		}
		rs.close();
		out.print("총 게시물 : " + total1 + "개");
		
		String sqlList = "SELECT shelterName,id,memo from board2 WHERE shelterName='"+id4+"'";
		rs = stmt.executeQuery(sqlList);
		
%>
<br>아이디: <%=id2 %><br>대피소이름: <%=id4 %><br>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr height="5"><td width="5"></td></tr>
 <tr style="background:url('img/table_mid.gif') repeat-x; text-align:center;">
   <td width="5"><img src="img/table_left.gif" width="5" height="30" /></td>
   <td width="">대피소 이름</td>
   <td width="73">ID</td>
   <td width="373">내용</td>
   <td width="7"><img src="img/table_right.gif" width="5" height="30" /></td>
  </tr>
<%
	if(total1==0) {
%>
	 		<tr align="center" bgcolor="#FFFFFF" height="30">
	 	   <td colspan="6">등록된 글이 없습니다.</td>
	 	  </tr>
<%
	 	} else {
	 		
		while(rs.next()) {
			String de1 = rs.getString(1);
			String id11 = rs.getString(2);
			String memo1 = rs.getString(3);
			
		
%>
<tr height="25" align="center">
	<td>&nbsp;</td>
	<td><%=de1%></td>
	<td align="left"><%=id11 %></td>
	<td align="center"><%=memo1 %></td>
	
	<td>&nbsp;</td>
</tr>
  <tr height="1" bgcolor="#D2D2D2"><td colspan="6"></td></tr>
<% 
		}
	} 
	rs.close();
	stmt.close();
	conn.close();
} catch(SQLException e) {
	out.println( e.toString() );
}
 }
 %>
 <tr height="1" bgcolor="#82B5DF"><td colspan="6" width="752"></td></tr>
 </table>
 
<table width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr><td colspan="4" height="5"></td></tr>

</table>




<center>
<form name="a" method="post" action="write_ok.jsp">
<input type="hidden" name="re1" value="<%=id4%>">
<input type="text" name="memo" value="" style="text-align:center; width:200px; height:50px;" /><br />
       <input type="submit" value="댓글 달기" />
       </form>
       
       <form name="b" method="post" action="warning.jsp">
      <input type="hidden" name="re1" value="<%=id4%>">
		<input type="submit" value="사용금지">
		</form>
       
</center>
   		

</form>

</body> 
</html>
