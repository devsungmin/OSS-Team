<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>  
<%
	request.setCharacterEncoding("UTF-8");
 	String c="1";

		Class.forName("com.mysql.cj.jdbc.Driver");
	
		String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
		String id = "root";
		String pass = "admin";
	String id2="";
	 String irum = (String)request.getParameter("re1");
	id2 = (String)session.getAttribute("userID");
	String memo = request.getParameter("memo");
	
	
	try {	
		Connection conn = DriverManager.getConnection(url,id,pass);
		
		String sql = "INSERT INTO board2(shelterName,id,memo) VALUES(?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
	
		pstmt.setString(1,irum);
		pstmt.setString(2, id2);
		pstmt.setString(3, memo);
		
		
		pstmt.execute();
		pstmt.close();
		
		conn.close();
} catch(SQLException e) {
	out.println( e.toString() );
	}
%>
<body>
<%=irum %>
<%=c %>
  <form name="a" method="post" action="list.jsp">
<input type="hidden" name="re" value="<%=irum %>">
<input type="hidden" name="cnt" value="<%=c%>">
<center>
<input type="submit" value="작성 완료" />
</center>
</form>
</body>

   		
