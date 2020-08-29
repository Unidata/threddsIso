package gov.noaa.eds.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FilenameFilter;
import java.io.FileWriter;
import java.io.File;
import java.io.Writer;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class FileUtility {
	private static Logger logger = LoggerFactory.getLogger(FileUtility.class);

	private Writer writer = null;
	private File file = null;
	
	public FileUtility(String fileName) {
	  file = new File(fileName);
	}
	
	public boolean exists() {
		return file.exists();
	}
	
	public boolean mkdirs() {
		return file.mkdirs();
	}
	
	public String[] fileListing(final String strFilter) {
		FilenameFilter filter = new FilenameFilter() { 
			public boolean accept(File file, String name) { 
				return name.contains(strFilter); 
				} 
			}; 
			String[] children = file.list(filter); 
			return children;
	}
	
	public String readFile() throws IOException {
	    BufferedReader reader = new BufferedReader( new FileReader (file));
	    String line  = null;
	    StringBuilder stringBuilder = new StringBuilder();
	    String ls = System.getProperty("line.separator");
	    while( ( line = reader.readLine() ) != null ) {
	        stringBuilder.append( line );
	        stringBuilder.append( ls );
	    }
	    return stringBuilder.toString();
	 }

	 
	public boolean openFileWriter() {
      try {
      	  writer = new BufferedWriter(new FileWriter(file));
       	  return true;
      } catch (IOException ioe) {
          logger.error("Exception opening file writer:", ioe);
          close();
          return false;        	
      }	
	}
	
    public boolean writeln(String text) {
      try {
    	  writer.write(text + "\n");        
    	  return true;
      } catch (IOException ioe) {
    	  logger.error("Error writing to file.", ioe);
          close();
    	  return false;        	
      }	     
    }

    public boolean write(String text) {
      try 
      {
        writer.write(text);        
        return true;
      } catch (IOException e)
      {
        logger.error("Error writing to file.", e);
        close();
      	return false;        	
      }	     
    }
    
    public void close() {
      try
      {
        if (writer != null)
        {
          writer.flush();
          writer.close();
        }
      } catch (IOException e)
      {
    	  logger.error("Error closing file.", e);
      }
    	
    }

	public boolean deleteFile() {		
      	return file.delete();	
	}


}
 

