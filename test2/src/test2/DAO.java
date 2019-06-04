package test2;
import java.sql.Connection;
import java.sql.PreparedStatement; 
import java.sql.ResultSet; 
import java.text.SimpleDateFormat; 
import java.util.ArrayList; 
import java.util.Date; 
public class DAO { 
	DBConnect dbconnect = null; 
	String sql=""; 
	public DAO() {
		dbconnect = new DBConnect(); 
		} 
	public int count() { 
		Connection con = dbconnect.getConnection(); 
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		int cnt = 0; 
		try { 
			sql = "SELECT COUNT(*) FROM board1"; 
			pstmt = con.prepareStatement(sql); 
			rs = pstmt.executeQuery(); 
			if(rs.next()) { 
				cnt=rs.getInt(1); 
				} }catch(Exception e) {
					
				}finally { 
					DBClose.close(con,pstmt,rs); 
					} 
		return cnt; 
		} 
	public String pasing(String data) { 
		try { 
			data = new String(data.getBytes("8859_1"), "euc-kr"); 
			}catch (Exception e){ } 
		return data; } 
	public ArrayList<VO> getMemberList() { 
		Connection con = dbconnect.getConnection(); 
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		ArrayList<VO> alist = new ArrayList<VO>(); 
		try { sql = "SELECT NUM, USERNAME, TITLE, TIME, HIT, INDENT from board1 order by ref desc, step asc"; 
		pstmt = con.prepareStatement(sql); 
		rs = pstmt.executeQuery(); 
		while(rs.next()) { 
			VO vo = new VO();
			boolean dayNew = false; 
			vo.setNum(rs.getInt(1)); 
			vo.setName(rs.getString(2)); 
			vo.setTitle(rs.getString(3)); 
			Date date = new Date(); 
			SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd"); 
			String year = (String)simpleDate.format(date); 
			String yea = rs.getString(4).substring(0,10); 
			if(year.equals(yea)){ 
				dayNew = true; 
				} 
			vo.setTime(yea); 
			vo.setHit(rs.getInt(5)); 
			vo.setIndent(rs.getInt(6)); 
			vo.setDayNew(dayNew); alist.add(vo); 
			} 
		}catch(Exception e) {
			
		}finally { 
			DBClose.close(con,pstmt,rs); 
			} 
		return alist; 
		} 
	public int getMax() { 
		Connection con = dbconnect.getConnection(); 
		PreparedStatement pstmt = null; 
		ResultSet rs = null; 
		int max = 0; 
		try { 
			sql = "SELECT MAX(NUM) FROM board1";
		pstmt = con.prepareStatement(sql); 
		rs = pstmt.executeQuery(); 
		if(rs.next()) { 
			max=rs.getInt(1);
			} 
		}catch(Exception e) {
			
		}finally { 
			DBClose.close(con,pstmt,rs);
			} return max; 
			} 
	public void insertWrite(VO vo, int max) { 
		Connection con = dbconnect.getConnection();
		PreparedStatement pstmt = null; 
		try { 
			sql = "INSERT INTO board1(USERNAME,PASSWORD,TITLE,MEMO,REF) VALUES(?,?,?,?,?)";
			pstmt = con.prepareStatement(sql); 
			pstmt.setString(1, pasing(vo.getName())); 
			pstmt.setString(2, pasing(vo.getPassword())); 
			pstmt.setString(3, pasing(vo.getTitle())); 
			pstmt.setString(4, pasing(vo.getMemo()));
			pstmt.setInt(5, max+1); 
			pstmt.execute(); 
			}catch(Exception e) { 
				
			}finally { 
				DBClose.close(con,pstmt); 
				}
		} public VO getView(int idx) {
			Connection con = dbconnect.getConnection(); 
			PreparedStatement pstmt = null; 
			ResultSet rs = null; 
			VO vo = null;
			try { 
				sql = "SELECT USERNAME, TITLE, MEMO, TIME, HIT, PASSWORD, REF, INDENT, STEP FROM board1 WHERE NUM=?"; 
				pstmt = con.prepareStatement(sql); 
				pstmt.setInt(1, idx); 
				rs = pstmt.executeQuery(); 
				if(rs.next()) {
					vo = new VO(); 
					vo.setName(rs.getString(1)); 
					vo.setTitle(rs.getString(2)); 
					vo.setMemo(rs.getString(3)); 
					vo.setTime(rs.getString(4)); 
					vo.setHit(rs.getInt(5)+1);
					vo.setPassword(rs.getString(6));
					vo.setRef(rs.getInt(7));
					vo.setIndent(rs.getInt(8)); 
					vo.setStep(rs.getInt(9)); } 
				}catch(Exception e) {
					
				}finally {
					DBClose.close(con,pstmt,rs);
					} 
			return vo; 
			
		} 
		public void UpdateHit(int idx) {
			Connection con = dbconnect.getConnection();
			PreparedStatement pstmt = null; try {
				sql = "UPDATE board1 SET HIT=HIT+1 where NUM=?"; 
				pstmt = con.prepareStatement(sql); 
				pstmt.setInt(1, idx); 
				pstmt.executeUpdate(); 
				}catch(Exception e) {
					
				}finally {
					DBClose.close(con,pstmt); 
					} 
			} 
		public boolean checkPassword(VO vo, int idx) { 
			Connection con = dbconnect.getConnection();
			PreparedStatement pstmt = null; 
			ResultSet rs = null;
			boolean ch = false; 
			try { 
				sql = "SELECT NUM FROM board1 where NUM=? and PASSWORD=?"; 
				pstmt = con.prepareStatement(sql); 
				pstmt.setInt(1, idx); 
				pstmt.setString(2, vo.getPassword()); 
				rs = pstmt.executeQuery(); 
				if(rs.next()) {
					ch = true; 
					} 
				else {
					ch = false;
					}
				}catch(Exception e) {
					
				}finally {
					DBClose.close(con,pstmt,rs);
					}
			return ch; 
			}
		public void delete(int idx) { Connection con = dbconnect.getConnection();
		PreparedStatement pstmt = null; 
		try { 
			sql = "DELETE FROM board1 WHERE NUM=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, idx);
			pstmt.executeUpdate(); 
			}catch(Exception e) {
				
			}finally { 
				DBClose.close(con,pstmt);
				} 
		} 
		public void modify(VO vo, int idx) { Connection con = dbconnect.getConnection(); 
		PreparedStatement pstmt = null; 
		try { 
			sql = "UPDATE board1 SET TITLE=?, MEMO=? where NUM=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, pasing(vo.getTitle()));
			pstmt.setString(2, pasing(vo.getMemo()));
			pstmt.setInt(3, idx); pstmt.executeUpdate();
			}catch(Exception e) { 
				
			}finally { 
				DBClose.close(con,pstmt);
				} 
		} 
		public void UpdateStep(int ref, int step) { 
			Connection con = dbconnect.getConnection(); 
			PreparedStatement pstmt = null;
			try {
				sql = "UPDATE board1 SET STEP=STEP+1 where REF=? and STEP>?";
				pstmt = con.prepareStatement(sql);
				pstmt.setInt(1, ref); 
				pstmt.setInt(2, step);
				pstmt.executeUpdate(); 
				}catch(Exception e) {
					
				}finally {
					DBClose.close(con,pstmt); 
					} 
			}
		public void insertReply(VO vo, int ref, int indent, int step) { Connection con = dbconnect.getConnection();
		PreparedStatement pstmt = null;
		try { 
			sql = "INSERT INTO board1(USERNAME, PASSWORD, TITLE, MEMO, REF, INDENT, STEP) "+ "VALUES(?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, pasing(vo.getName())); 
			pstmt.setString(2, pasing(vo.getPassword()));
			pstmt.setString(3, pasing(vo.getTitle()));
			pstmt.setString(4, pasing(vo.getMemo())); 
			pstmt.setInt(5, ref); 
			pstmt.setInt(6, indent+1);
			pstmt.setInt(7, step+1);
			pstmt.execute(); 
			}catch(Exception e) { 
				
			}finally { 
				DBClose.close(con,pstmt); 
				} 
		} 
		}



