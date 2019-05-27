package dd;
import java.lang.Thread.State;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.*;
public class InShelter {
	 
    PreparedStatement pstmt;
    ResultSet rs;
    
	String dbURL = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
	String dbID = "root";
	String dbPassword = "admin";
	Connection conn=null;
	
	public void InShelter(String SName,String localLati, String localHard,String SNum) {
		
		try {
			System.out.println(SName);
			System.out.println(localLati);
			System.out.println(localHard);
			System.out.println(SNum);
			Class.forName("com.mysql.cj.jdbc.Driver");
			Statement state=null;
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			state=conn.createStatement();
			
			String sql="insert into shelter(shelterName,localLati,shelterHard,shelterNum) values(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, SName); 
			pstmt.setString(2,localLati); 
			pstmt.setString(3, localHard); 
			pstmt.setString(4, SNum);
			int r = pstmt.executeUpdate();
			SName=null;
			localLati=null;
			localHard=null;
			SNum=null;
			if(r==1) {
				System.out.println("성공");
			}
	
			
			  
		} catch (Exception e) {
			e.printStackTrace(); 
		}finally { //사용순서와 반대로 close 함 
			if (pstmt != null) { 
				try { pstmt.close(); 
				} catch (SQLException e) 
				{ e.printStackTrace(); } 
			} 
			if (conn != null) 
			{ try { conn.close(); 
			} catch (SQLException e) { e.printStackTrace();
			} 
			} 
			}
		}

	
}
