package test;

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
    	
    	//반환용 리스트
        List<List<String>> ret = new ArrayList<List<String>>();
        BufferedReader br =null;
        int cnt=0;
        InShelter ins = new InShelter();
        ins.Delete();//테이블 초기화
        try{
        	
        	br = Files.newBufferedReader(Paths.get("C:\\Users\\joo\\Desktop\\she10.csv"));
        	

            Charset.forName("UTF-8");
            String line = "";
            
            while((line = br.readLine()) != null){
                //CSV 1행을 저장하는 리스트
                List<String> tmpList = new ArrayList<String>();
                String array[] = line.split(",");
               
              if(cnt!=0) {
                System.out.println(array[0]);
                System.out.println(array[4]);
                System.out.println(array[5]);
                System.out.println(array[10]);
                ins.InShelter(array[0],array[4],array[5],array[10]);//오류 잡아야함.
              }
              	array[0]=null;
              	array[4]=null;
              	array[5]=null;
              	array[10]=null;
                //배열에서 리스트 반환
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