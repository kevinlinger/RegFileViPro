/*
 * The FileChanger Class becomes very helpful for manipulating the <technology>.ini file to have its proper values. It uses one
 * giant method for this and accesses the results from the Interface Layout (and its fields) through the use of parameters to its
 * one method. This is coordinated through the "order" in which methods are run in the Tase Button Listener.
 */
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class FileChanger {

	//The one method in this class, manipuates the new file to have the correct inputs.
	//Its parameters are the original fields from the Interface Layout Class.
	//The foundation of this class came from a source online.
    public static void changeToInterface(File f, ArrayList<String> results, ArrayList<String> testResults) {

        FileInputStream fs = null;
        InputStreamReader in = null;
        BufferedReader br = null;

        StringBuffer sb = new StringBuffer();

        String textinLine;
        
        //Boolean to "end" the while loop when we reach the "test" portions of the old .ini file (b/c this represents the end
        //of the helpful part of the old file.
        boolean reachedOldTests = false;
        
        //Booleans to add the missing components...
        boolean mcrunNum = false;
        boolean temp = false;
        boolean gmin = false;
        boolean pr = false;
        boolean tp = false;
        boolean startIter = false;
        boolean minpw = false;
        boolean maxpw = false;
        boolean stopIter = false;
        boolean tol = false;
        boolean mcType = false;

        try {
             fs = new FileInputStream(f);
             in = new InputStreamReader(fs);
             br = new BufferedReader(in);

             //Loop that only breaks when we are either at the end of the file or the test part of the old file.
             //This loop runs through the entire file and keeps the original format, only making value changes when a recognized
             // <option> is reached, in which case it is changed accordingly.
            while(true)
            {
                textinLine = br.readLine();
                if(textinLine.contains("<mcrunNum>")) {
                	textinLine = results.get(0) + "\n";
                	mcrunNum = true;
                }
                else if(textinLine.contains("<temp>")) {
                	textinLine = results.get(1) + "\n";
                	temp = true;
                }
                else if(textinLine.contains("<gmin>")) {
                	textinLine = results.get(2) + "\n";
                	gmin = true;
                }
                else if(textinLine.contains("<pr>")) {
                	textinLine = results.get(3) + "\n";
                	pr = true;
                }
                else if(textinLine.contains("<tp>")) {
                	textinLine = results.get(4) + "\n";
                	tp = true;
                }
                else if(textinLine.contains("<startIter>")) {
                	textinLine = results.get(5) + "\n";
                	startIter = true;
                }
                else if(textinLine.contains("<minpw>")) {
                	textinLine = results.get(6) + "\n";
                	minpw = true;
                }
                else if(textinLine.contains("<maxpw>")) {
                	textinLine = results.get(7) + "\n";
                	maxpw = true;
                }
                else if(textinLine.contains("<stopIter>")) {
                	textinLine = results.get(8) + "\n";
                	stopIter = true;
                }
                else if(textinLine.contains("<tol>")) {
                	textinLine = results.get(9) + "\n";
                	tol = true;
                }
                else if(textinLine.contains("<mcType>")) {
                	textinLine = results.get(10) + "\n";
                	mcType = true;
                }
                else if(textinLine.contains("<ocn>") || textinLine.contains("<scs>")) {
                	sb.append("\n");
                	if(!mcrunNum) {
                		sb.append(results.get(0) + "\n");
                	}
                	if(!temp) {
                		sb.append(results.get(1) + "\n");
                	}
                	if(!gmin) {
                		sb.append(results.get(2) + "\n");
                	}
                	if(!pr) {
                		sb.append(results.get(3) + "\n");
                	}
                	if(!tp) {
                		sb.append(results.get(4) + "\n");
                	}
                	if(!startIter) {
                		sb.append(results.get(5) + "\n");
                	}
                	if(!minpw) {
                		sb.append(results.get(6) + "\n");
                	}
                	if(!maxpw) {
                		sb.append(results.get(7) + "\n");
                	}
                	if(!stopIter) {
                		sb.append(results.get(8) + "\n");
                	}
                	if(!tol) {
                		sb.append(results.get(9) + "\n");
                	}
                	if(!mcType) {
                		sb.append(results.get(10) + "\n");
                	}
                	
                	textinLine = "\n" + testResults.get(0) + "\n" + "\n" + testResults.get(1) + "\n";
                	reachedOldTests = true;
//                	break;
                }
                else if(textinLine==null) {
                	break;
                }
                else {
                	textinLine = textinLine + "\n";
                }
                sb.append(textinLine);
                if(reachedOldTests) {
                	break;
                }
            }
            
            

              fs.close();
              in.close();
              br.close();

            } catch (FileNotFoundException e) {
              e.printStackTrace();
            } catch (IOException e) {
              e.printStackTrace();
            }

            try{
                FileWriter fstream = new FileWriter(f);
                BufferedWriter outobj = new BufferedWriter(fstream);
                outobj.write(sb.toString());
                outobj.close();

            }
            catch (Exception e){
              System.err.println("Error: " + e.getMessage());
            }
    }
}