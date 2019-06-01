package dd;


import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.charset.Charset;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

 
public class main{
	
    public static void main(String[] args){
    	
    	//諛섑솚�슜 由ъ뒪�듃
        List<List<String>> ret = new ArrayList<List<String>>();
        BufferedReader br =null;
        int cnt=0;
        InShelter ins = new InShelter();
        try{
        	
        	br = Files.newBufferedReader(Paths.get("C:\\Users\\kimsu\\Desktop\\OpenSource\\API\\she10.csv"));
        	

            Charset.forName("UTF-8");
            String line = "";
            
            while((line = br.readLine()) != null){
                //CSV 1�뻾�쓣 ���옣�븯�뒗 由ъ뒪�듃
                List<String> tmpList = new ArrayList<String>();
                String array[] = line.split(",");
               
              if(cnt!=0) {
                System.out.println(array[0]);
                System.out.println(array[4]);
                System.out.println(array[5]);
                System.out.println(array[10]);
                ins.InShelter(array[0],array[4],array[5],array[10]);//�삤瑜� �옟�븘�빞�븿.
              }
              	array[0]=null;
              	array[4]=null;
              	array[5]=null;
              	array[10]=null;
                //諛곗뿴�뿉�꽌 由ъ뒪�듃 諛섑솚
                tmpList = Arrays.asList(array);
                
                ret.add(tmpList);
                cnt++;
            }
        }catch(FileNotFoundException e){
            e.printStackTrace();
        }catch(IOException e){
            e.printStackTrace();
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
    public void inShelter() {
    	
    }
}



