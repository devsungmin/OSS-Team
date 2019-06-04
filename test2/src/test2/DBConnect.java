package test2;
import java.sql.Connection;
import java.sql.DriverManager;


public class DBConnect {
public DBConnect() {}
	
	public Connection getConnection() {
		String url = "jdbc:mysql://localhost:3306/OSS?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC"; // localhost:3306 ��Ʈ�� ��ǻ�ͼ�ġ�� mysql�ּ�
		String id = "root";
		String pass = "admin";
		
		Connection con = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(url,id,pass);
		}catch(Exception e) {
			System.out.println(e);
		}
		return con;
	}
}

