<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<meta charset="UTF-8">
<title>Insert title here</title>
<%
request.setCharacterEncoding("UTF-8");
String cn1=request.getParameter("warcnt");
String cn2=request.getParameter("re1");
String id2 = (String)session.getAttribute("userID");
String war="1";
Class.forName("com.mysql.cj.jdbc.Driver");

String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
String id = "root";
String pass = "admin";

try {	
Connection conn = DriverManager.getConnection(url,id,pass);

String sql = "UPDATE shelter set warning=? WHERE shelterName='"+cn2+"'";
		
PreparedStatement pstmt = conn.prepareStatement(sql);

pstmt.setString(1, war);



pstmt.execute();
pstmt.close();

conn.close();
	}catch(SQLException e) {
out.println( e.toString() );
}

%>

<body>
<%=cn2%>
 <form name="a" method="post" action="NewFile2.jsp">

<center>

<input type="submit" value="작성 완료" />

</center>
</form>
</body>

</html>