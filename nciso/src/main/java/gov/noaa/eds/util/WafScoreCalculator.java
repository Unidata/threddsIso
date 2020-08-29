package gov.noaa.eds.util;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WafScoreCalculator {
	
  public static void getSummary(String dir) {
      // Get list of report files in waf directory _REPORT.html
      
      FileUtility fu = new FileUtility(dir);
      String[] wafFiles = fu.fileListing(".html");
      fu.close();
      
      // Open each file and grab summary score
      int total = 0;
      int fileCnt = 0;

      for (String wafFile : wafFiles) {
	      System.out.println(wafFile);  
	      fu = new FileUtility(dir + wafFile);
	      int score = getScore(fu);
	      if (score>-1) {
	        total += score;
	        fileCnt++;
	      }
	      fu.close();
      }
      
      float avgScore = total/fileCnt;
      // Add score to total score
      System.out.println("Number of Files: " + fileCnt + " Mean: " + avgScore);

  }
  
  private static int getScore(FileUtility fu) {
	  int score = -1;
	  try {
	    String searchString = fu.readFile();
	    //System.out.println(responseBody);
		String expr = "<h2>Total Score: ([^/]+)"; // first piece of data goes up to the start of the next tag
		Pattern patt = Pattern.compile(expr,
		Pattern.DOTALL | Pattern.UNIX_LINES);
								
		Matcher m = patt.matcher(searchString);
		while (m.find()) {
			System.out.println("Score: " + m.group(1));
			 score = Integer.parseInt(m.group(1));
		}
	  } catch(IOException ioe) {
		  // log error file found
	  }
	  return score;
  }
  
  public static void main(String[] args) {
	  String dir = "c:/temp/waf/";
	  WafScoreCalculator.getSummary(dir);
  }

}
