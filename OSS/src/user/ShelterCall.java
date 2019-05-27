package user;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.Charset;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
public class ShelterCall {
				
			
	 	public void ShelterCall() {
	 		List<List<String>> ret = new ArrayList<List<String>>();
			BufferedReader br =null;
			try{
	        	
				
		        
	        	br = Files.newBufferedReader(Paths.get("C:\\Users\\kimsu\\Desktop\\OpenSource\\API\\she1.csv"));


	            Charset.forName("UTF-8");
	            String line = "";
	            
	            while((line = br.readLine()) != null){
	                //CSV 1占쎈뻬占쎌뱽 占쏙옙占쎌삢占쎈릭占쎈뮉 �뵳�딅뮞占쎈뱜
	                List<String> tmpList = new ArrayList<String>();
	                String array[] = line.split(",");
	                //獄쏄퀣肉댐옙肉됵옙苑� �뵳�딅뮞占쎈뱜 獄쏆꼹�넎
	                tmpList = Arrays.asList(array);
	                System.out.println(tmpList);
	                ret.add(tmpList);
	            }
	        }catch(FileNotFoundException e1){
	            e1.printStackTrace();
	        }catch(IOException e1){
	            e1.printStackTrace();
	        }finally{
	            try{
	                if(br != null){
	                    br.close();
	                }
	            }catch(IOException e){
	                e.printStackTrace();
	            }
	        }
}

		}

	

