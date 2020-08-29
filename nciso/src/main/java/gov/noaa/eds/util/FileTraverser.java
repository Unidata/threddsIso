package gov.noaa.eds.util;

import java.io.File;
import java.io.IOException;
import java.util.Collection;

import org.apache.commons.io.DirectoryWalker;
import org.apache.commons.io.FileUtils;

public class FileTraverser extends DirectoryWalker {

    public FileTraverser() {
      super();
    }

    public void walk(File startDirectory) {
      System.out.println("Starting...");
	  walk(startDirectory);
    }

    protected boolean handleDirectory(File directory, int depth, Collection results) {
        System.out.println(directory.getName());
    	return true;

      }


    protected void handleFile(File file, int depth, Collection results) {
      // delete file and add to list of deleted
      File destFile;	
      String fileName = file.getName();
      destFile = new File("c:/temp/oceansites_waf/" + fileName);
      try {
		FileUtils.copyFile(file, destFile);
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
      
    }
    
    public static void main(String[] args) {
    	FileTraverser ft = new FileTraverser();
    	File startDir = new File("C:/temp/oceansties_old");
    	ft.walk(startDir);
    }
  }
 

