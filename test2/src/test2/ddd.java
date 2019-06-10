package test2;
import java.sql.*;

import com.sun.swing.internal.plaf.synth.resources.synth_es;
public class ddd {
	
	public static void main(String[] args) {
		
	 PreparedStatement pstmt=null;
		    ResultSet rs;
		Connection conn = null;
		String dbURL = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
		String dbID = "root";
		String dbPassword = "admin";
		
int a=0;
int b=1;
		int cnt =0;
		String [][] we = new String [118][2];
		try {
			
			Class.forName("com.mysql.cj.jdbc.Driver");
			Statement state=null;
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			state=conn.createStatement();
			String sqlCount = "SELECT * FROM shelter";
			 rs = state.executeQuery(sqlCount);
			
			while(rs.next()){
				
				
				we[cnt][a]= rs.getString("localLati");
				we[cnt][b] = rs.getString("shelterHard");
				System.out.println(cnt);
				
				cnt+=1;
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
		for(int i=0; i<118;i++) {
			for(int j=0;j<2;j++) {
				System.out.println(we[i][j]);			
				}
			
		}
	
}
	
	
}
