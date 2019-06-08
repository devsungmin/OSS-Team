<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.sql.*"%>  
<%
	request.setCharacterEncoding("UTF-8");

		Class.forName("com.mysql.cj.jdbc.Driver");
	
		String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
		String id = "root";
		String pass = "admin";
	
	String memo = request.getParameter("memo");
	int sI = 2;
	String id1="wngh1";
	try {	
		Connection conn = DriverManager.getConnection(url,id,pass);
		
		String sql = "INSERT INTO board2(shelterIndex,id,memo) VALUES(?,?,?)";
		PreparedStatement pstmt = conn.prepareStatement(sql);
		
	
		pstmt.setInt(1, sI);
		pstmt.setString(2, id1);
		pstmt.setString(3, memo);
		
		pstmt.execute();
		pstmt.close();
		
		conn.close();
} catch(SQLException e) {
	out.println( e.toString() );
	}
%>
  <script language=javascript>
   self.window.alert("입력한 글을 저장하였습니다.");
   location.href="list.jsp"; 

</script>


