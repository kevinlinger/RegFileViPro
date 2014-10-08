/*
 * The Class sets up the general layout of the User Interface for the VLSI Simulation. All of the actions through running the Unix Command
 * Prompt are run through this class. It uses a helper class "FileChanger" to change the aspects of the .ini file to the inputs of the 
 * Interface.
 */

import java.awt.Toolkit;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.BorderLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.channels.FileChannel;
import java.util.ArrayList;
import java.util.Scanner;


public class InterfaceLayout extends JApplet {
	
	//This is what should be changed accordingly with each user. Make sure that it stays in the same
	//format up to the "TASE/". It is also important that the names of the folders in the TASE Folder
	//remain in their default values.
	final private String pathToTASE = "/var/home/jmb9zw/TASE/";
	
	
	//The Three Colors of the Background for the Simulation
	final private Color FirstColorGroup = Color.orange;
	final private Color SecondColorGroup = Color.gray;
	final private Color ThirdColorGroup = Color.green;
	
	//The Technology Drop Down Menu Options
	String[] technologyDropDown = {"ibm45", "ibm90", "ibm135","ptm22", "ptm32", "ptm45", "ptm65"};
	JComboBox techList = new JComboBox(technologyDropDown);
	
	//The Monte Carlo Drop Down Menu Options
	String[] monteCarloDropDown = {"Process", "Mismatch", "All"};
	JComboBox typeOfMonteCarlo = new JComboBox(monteCarloDropDown);
	
	//The General Options Tab
	JPanel generalOptions = new JPanel();
	JPanel subGeneralOptionsTech = new JPanel(new FlowLayout());
	JPanel subGeneralOptionsMCIte = new JPanel(new FlowLayout());
	JPanel subGeneralOptionsTemp = new JPanel(new FlowLayout());
	JPanel subGeneralOptionsMonteCa = new JPanel(new FlowLayout());
	JPanel subGeneralOptionsGMin = new JPanel(new FlowLayout());
	
	//The Text Fields for the TCRIT Tab
	JTextField mcIte = new JTextField("   [No. of Iterations]   ");
	JTextField temp = new JTextField("   27   ");
	JTextField gMin = new JTextField("   1e-22   ");
	
	//The Text Fields for the TCRIT Tab
	JTextField fallTime = new JTextField("   1e-13   ");
	JTextField runTime = new JTextField("   40e-11   ");
	JTextField startMCIt = new JTextField("    1    ");
	JTextField minWid = new JTextField("   5e-12   ");
	JTextField maxWid = new JTextField("   40e-12   ");
	JTextField finalMCIt = new JTextField("   [Final MC Iteration]   ");
	JTextField accuracy = new JTextField("   1e-13   ");
	
	
	//The TCrit Options Tab
	JPanel TcritOptions = new JPanel();
	JPanel subTcritOptionsFallTime = new JPanel(new FlowLayout());
	JPanel subTcritOptionsRunTime = new JPanel(new FlowLayout());
	JPanel subTcritOptionsStartMCIt = new JPanel(new FlowLayout());
	JPanel subTcritOptionsMinWid = new JPanel(new FlowLayout());
	JPanel subTcritOptionsMaxWid = new JPanel(new FlowLayout());
	JPanel subTcritOptionsFinalMCIt = new JPanel(new FlowLayout());
	JPanel subTcritOptionsAcc = new JPanel(new FlowLayout());
	
	//The Test Options Tab
	JPanel TestOptions = new JPanel();
	JPanel subTestOptionsA = new JPanel(new FlowLayout());
	JPanel subTestOptionsB = new JPanel(new FlowLayout());
	JPanel subTestOptionsC = new JPanel(new FlowLayout());
	JPanel subTestOptionsD = new JPanel(new FlowLayout());
	JPanel subTestOptionsE = new JPanel(new FlowLayout());
	JPanel subTestOptionsF = new JPanel(new FlowLayout());
	
	JPanel RunTase = new JPanel();
	
	JPanel ShowError = new JPanel();
	
	//JPanels for Titles (so that they are centered)
	JPanel GenOpTitle = new JPanel();
	JPanel TcritTitle = new JPanel();
	JPanel TestTitle = new JPanel();
	
	//Run Tase Button
	JButton TaseButton = new JButton("Run TASE");
	
	//Check Boxes
	JCheckBox testA = new JCheckBox();
	JCheckBox testB = new JCheckBox();
	JCheckBox testC = new JCheckBox();
	JCheckBox testD = new JCheckBox();
	JCheckBox testE = new JCheckBox();
	JCheckBox testF = new JCheckBox();
	
	//Placeholders for Spacing
	Box PlaceHolderOne = Box.createHorizontalBox();
	Box PlaceHolderTwo = Box.createHorizontalBox();
	Box PlaceHolderThree = Box.createHorizontalBox();
	Box PlaceHolderFour = Box.createHorizontalBox();
	Box PlaceHolderFive = Box.createHorizontalBox();
	Box PlaceHolderSix = Box.createHorizontalBox();
	Box PlaceHolderSeven = Box.createHorizontalBox();
	Box PlaceHolderEight = Box.createHorizontalBox();
	Box PlaceHolderNine = Box.createHorizontalBox();
	Box PlaceHolderTen = Box.createHorizontalBox();
	Box PlaceHolderEleven = Box.createHorizontalBox();
	Box PlaceHolderTwelve = Box.createHorizontalBox();
	
	//For the Layout of the General Part of the GUI
	Box verticalOneGen = Box.createVerticalBox();
	Box verticalTwoGen = Box.createVerticalBox();
	Box horizontalOneGen = Box.createHorizontalBox();
	
	//The Main LayOut Box
	Box mainBox = Box.createVerticalBox();
	
	//TCrit part of the GUI
	Box verticalOneTC = Box.createVerticalBox();
	Box verticalTwoTC = Box.createVerticalBox();
	Box horizontalOneTC = Box.createHorizontalBox();
	
	//Test Options part of the GUI
	Box verticalOneTe = Box.createVerticalBox();
	Box verticalTwoTe = Box.createVerticalBox();
	Box horizontalOneTe = Box.createHorizontalBox();
	
	//Dimensions of the Screen of the Computer
	Toolkit toolkit =  Toolkit.getDefaultToolkit ();
	Dimension dim = toolkit.getScreenSize();
	
/* *************** Fields for the .ini File that is created ********/
	
	//Representation Holding Values
	String techDropDownValue = "";
	String monteDropDownValue = "";
	String mcIteS;
	String tempS;
	String gMinS;
	String fallTimeS;
	String runTimeS;
	String startMCItS;
	String minWidS;
	String maxWidS;
	String finalMCItS;
	String accuracyS;
	
	//True or False Values for Tests
	boolean testAR = false;
	boolean testBR = false;
	boolean testCR = false;
	boolean testDR = false;
	boolean testER = false;
	boolean testFR = false;
	
	//<technology>.ini file
	File technology;
	
	//The FileWriter
	FileWriter technologyWriter;
	
	//List holding all of the results
	ArrayList<String> results = new ArrayList<String>();
	
	//List holding the test results in String format
	ArrayList<String> testResults = new ArrayList<String>();
	
	//File Changer to add the Interface Results
	FileChanger resultChanger = new FileChanger();
	
	//Unix Command to run the Simulation.
//	RunSystemCommand run = new RunSystemCommand();
	
	ProcessBuilder run;
	
	public InterfaceLayout() {
		//Dealing with the PlaceHolders
		PlaceHolderOne.add(new JLabel("  "));
		PlaceHolderTwo.add(new JLabel("  "));
		PlaceHolderThree.add(new JLabel("  "));
		PlaceHolderFour.add(new JLabel("  "));
		PlaceHolderFive.add(new JLabel("  "));
		PlaceHolderSix.add(new JLabel("  "));
		PlaceHolderSeven.add(new JLabel("  "));
		PlaceHolderEight.add(new JLabel("  "));
		PlaceHolderNine.add(new JLabel("  "));
		PlaceHolderTen.add(new JLabel("  "));
		PlaceHolderEleven.add(new JLabel("  "));
		PlaceHolderTwelve.add(new JLabel("  "));
		
		//Dealing with the Listeners of the Drop Down Menus. These are pretty much used to assign the "choice" to a field for 
		//later use.
		
		//The Technology Drop Down List Listener
		techList.addItemListener(
				new ItemListener() {
					public void itemStateChanged(ItemEvent event) {
						if(event.getItem().equals(technologyDropDown[0])) {
							techDropDownValue = technologyDropDown[0];
//							System.out.println("Working 0");
//							System.out.println(technologyDropDown[0]);
						}
						else if(event.getItem().equals(technologyDropDown[1])) {
							techDropDownValue = technologyDropDown[1];
//							System.out.println("Working 1");
//							System.out.println(technologyDropDown[1]);
						}
						else if(event.getItem().equals(technologyDropDown[2])) {
							techDropDownValue = technologyDropDown[2];
//							System.out.println("Working 2");
//							System.out.println(technologyDropDown[2]);
						}
						else if(event.getItem().equals(technologyDropDown[3])) {
							techDropDownValue = technologyDropDown[3];
//							System.out.println("Working 3");
//							System.out.println(technologyDropDown[3]);
						}
					}
				}
				);
		
		//The Monte Carlo Drop Down List Listener
		typeOfMonteCarlo.addItemListener(
				new ItemListener() {
					public void itemStateChanged(ItemEvent event) {
						if(event.getItem().equals(monteCarloDropDown[0])) {
							monteDropDownValue = monteCarloDropDown[0];
//							System.out.println("Working 0");
//							System.out.println(monteCarloDropDown[0]);
							System.out.println(mcIteS);
						}
						else if(event.getItem().equals(monteCarloDropDown[1])) {
							monteDropDownValue = monteCarloDropDown[1];
//							System.out.println("Working 1");
//							System.out.println(monteCarloDropDown[1]);
							System.out.println(finalMCItS);
						}
						else if(event.getItem().equals(monteCarloDropDown[2])) {
							monteDropDownValue = monteCarloDropDown[2];
//							System.out.println("Working 2");
//							System.out.println(monteCarloDropDown[2]);
							System.out.println(runTimeS);
						}
						else if(event.getItem().equals(monteCarloDropDown[3])) {
							monteDropDownValue = monteCarloDropDown[3];
//							System.out.println("Working 3");
//							System.out.println(monteCarloDropDown[3]);
							System.out.println(accuracyS);
						}
					}
				}
				);
		
		/*
		 * Deal with the TASE Button to start the simulation
		 * This is where all of the action happens...
		 * In the first half, all of the values from the user interface are saved as fields.
		 * Then various methods are run that 1) creates a new file and moves it into the template file
		 * 2) Changes the File according to the User Inputs
		 * 3) Adds the aspects of the Test Check Boxes
		 * 4) Finally runs the simulation through the command prompt.
		 */
		
		TaseButton.addActionListener(
				new ActionListener() {
					public void actionPerformed(ActionEvent e) {
						
						//Dealing with the Listeners of the Text Fields
						//All of the results are stored in a ArrayList for the results from the User Interface.
						mcIteS = "<mcrunNum>          " + mcIte.getText();
						results.add(mcIteS);	//Index 0
						tempS = "<temp>          " + temp.getText();
						results.add(tempS);		//Index 1
						gMinS = "<gmin>          " + gMin.getText();	
						results.add(gMinS);		//Index 2
						fallTimeS = "<pr>          " + fallTime.getText();
						results.add(fallTimeS);		//Index 3
						runTimeS = "<tp>          " + runTime.getText();
						results.add(runTimeS);		//Index 4
						startMCItS = "<startIter>          " + startMCIt.getText();
						results.add(startMCItS);	//Index 5
						minWidS = "<minpw>          " + minWid.getText();
						results.add(minWidS);		//Index 6
						maxWidS = "<maxpw>          " + maxWid.getText();
						results.add(minWidS);		//Index 7
						finalMCItS = "<stopIter>          " + finalMCIt.getText();
						results.add(finalMCItS);	//Index 8
						accuracyS = "<tol>          " + accuracy.getText();
						results.add(accuracyS);		//Index 9
						
						//Dealing with the Drop Down Menus
						techDropDownValue = (String) techList.getSelectedItem();
						monteDropDownValue = "<mcType>   " + (String) typeOfMonteCarlo.getSelectedItem();
						results.add(monteDropDownValue);	//Index 10
						
						//Dealing with what Tests are Checked
						testAR = testA.isSelected();
						testBR = testB.isSelected();
						testCR = testC.isSelected();
						testDR = testD.isSelected();
						testER = testE.isSelected();
						testFR = testF.isSelected();
						
						//Makes the .ini file and moves it to the proper place
						createTechnologyFile(techDropDownValue);
						
						//Creats another ArrayList with the results from the checked check blocks in String format
						testResults = addTests();
						
						//Change the results of the original file and put in the new tests.
						FileChanger.changeToInterface(new File(pathToTASE + "template/" + techDropDownValue + ".ini"), results, testResults);

						//Finally, run the Unix Command Line
						//RunSystemCommand.runUnix(techDropDownValue);
						
						
						//Put at the end of the program, right as it is...
						//File toDelete = new File(pathToTASE + "template/" + techDropDownValue + ".ini");
						//toDelete.delete();
					    try {
					        String line;
					        Process p = Runtime.getRuntime().exec("perl run.pl -i " + pathToTASE + "/template/" + techDropDownValue + ".ini");
					        BufferedReader bri = new BufferedReader(new InputStreamReader(p.getInputStream()));
					        BufferedReader bre = new BufferedReader(new InputStreamReader(p.getErrorStream()));
					        while ((line = bri.readLine()) != null) {
					          System.out.println(line);
					        }
					        bri.close();
					        while ((line = bre.readLine()) != null) {
					          System.out.println(line);
					        }
					        bre.close();
					        p.waitFor();
					        System.out.println("Done.");
					      }
					      catch (Exception err) {
					        err.printStackTrace();
					      }
					
						//run = new ProcessBuilder("perl run.pl –i ../../template/" + techDropDownValue + ".ini");
						//try {
						//	run.start();
						//} catch (IOException e1) {
						//	// TODO Auto-generated catch block
						//	e1.printStackTrace();
						//}
						
					}
				}
				);
		/*
		 * The rest of this method has to do with the look of the User Interface and its design.
		 */
		
		//Deal with the Titles
		GenOpTitle.add(new JLabel("General Options:"));
		TcritTitle.add(new JLabel("Tcrit Options:"));
		TestTitle.add(new JLabel("Test Options:"));
		
		verticalOneGen.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoGen.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneGen.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoGen.setAlignmentX(BoxLayout.Y_AXIS);
		verticalOneGen.add(subGeneralOptionsTech);
		verticalOneGen.add(subGeneralOptionsTemp);
		verticalOneGen.add(subGeneralOptionsGMin);
		verticalTwoGen.add(subGeneralOptionsMCIte);
		verticalTwoGen.add(subGeneralOptionsMonteCa);
		verticalOneGen.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoGen.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneGen.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoGen.setAlignmentX(BoxLayout.Y_AXIS);

		//mainBox.add(new JLabel("General Options:"));
		horizontalOneGen.add(verticalOneGen);
		horizontalOneGen.add(verticalTwoGen);
		mainBox.add(PlaceHolderSeven);
		mainBox.add(GenOpTitle);
		mainBox.add(PlaceHolderFive);
		mainBox.add(horizontalOneGen);

		//Adding the elements of the General Options Panel
		subGeneralOptionsTech.add(new JLabel("Technology:"));
		subGeneralOptionsTech.add(techList);
		subGeneralOptionsTech.setBackground(FirstColorGroup);
		subGeneralOptionsMCIte.add(new JLabel("Number of MC Iterations:"), 0);
		subGeneralOptionsMCIte.add(mcIte, 1);
		subGeneralOptionsMCIte.setBackground(FirstColorGroup);
		subGeneralOptionsTemp.add(new JLabel("Temperature:"), 0);
		subGeneralOptionsTemp.add(temp, 1);
		subGeneralOptionsTemp.setBackground(FirstColorGroup);
		subGeneralOptionsMonteCa.add(new JLabel("Type of Monte Carlo:"), 0);
		subGeneralOptionsMonteCa.add(typeOfMonteCarlo, 1);
		subGeneralOptionsMonteCa.setBackground(FirstColorGroup);
		subGeneralOptionsGMin.add(new JLabel("GMin:"), 0);
		subGeneralOptionsGMin.add(gMin, 1);
		subGeneralOptionsGMin.setBackground(FirstColorGroup);
		verticalOneGen.setOpaque(true);
		verticalOneGen.setBackground(FirstColorGroup);
		verticalTwoGen.setOpaque(true);
		verticalTwoGen.setBackground(FirstColorGroup);
		generalOptions.add(mainBox);
		
		//Adding the elements of the Tcrit Options
		verticalOneTC.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoTC.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneTC.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoTC.setAlignmentX(BoxLayout.Y_AXIS);
		verticalOneTC.add(subTcritOptionsFallTime);
		verticalOneTC.add(subTcritOptionsRunTime);
		verticalOneTC.add(subTcritOptionsStartMCIt);
		verticalTwoTC.add(subTcritOptionsMinWid);
		verticalTwoTC.add(subTcritOptionsMaxWid);
		verticalOneTC.add(subTcritOptionsFinalMCIt);
		verticalTwoTC.add(subTcritOptionsAcc);
		verticalOneTC.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoTC.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneTC.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoTC.setAlignmentX(BoxLayout.Y_AXIS);
		
		horizontalOneTC.add(verticalOneTC);
		horizontalOneTC.add(verticalTwoTC);
		mainBox.add(PlaceHolderOne);
		mainBox.add(TcritTitle);
		mainBox.add(PlaceHolderEight);
		mainBox.add(horizontalOneTC);
		mainBox.add(PlaceHolderTwo);
		
		subTcritOptionsFallTime.add(new JLabel("Rise/Fall Time:"), 0);
		subTcritOptionsFallTime.add(fallTime, 1);
		subTcritOptionsFallTime.setBackground(SecondColorGroup);
		subTcritOptionsRunTime.add(new JLabel("Run Time:"), 0);
		subTcritOptionsRunTime.add(runTime, 1);
		subTcritOptionsRunTime.setBackground(SecondColorGroup);
		subTcritOptionsStartMCIt.add(new JLabel("Starting MC Iteration:"), 0);
		subTcritOptionsStartMCIt.add(startMCIt, 1);
		subTcritOptionsStartMCIt.setBackground(SecondColorGroup);
		subTcritOptionsMinWid.add(new JLabel("Minimum Pulse Width"), 0);
		subTcritOptionsMinWid.add(minWid, 1);
		subTcritOptionsMinWid.setBackground(SecondColorGroup);
		subTcritOptionsMaxWid.add(new JLabel("Maximum Pulse Width"), 0);
		subTcritOptionsMaxWid.add(maxWid, 1);
		subTcritOptionsMaxWid.setBackground(SecondColorGroup);
		subTcritOptionsFinalMCIt.add(new JLabel("Final MC Iteration"), 0);
		subTcritOptionsFinalMCIt.add(finalMCIt, 1);
		subTcritOptionsFinalMCIt.setBackground(SecondColorGroup);
		subTcritOptionsAcc.add(new JLabel("Accuracy"), 0);
		subTcritOptionsAcc.add(accuracy, 1);
		subTcritOptionsAcc.setBackground(SecondColorGroup);
		verticalOneTC.setOpaque(true);
		verticalOneTC.setBackground(SecondColorGroup);
		verticalTwoTC.setOpaque(true);
		verticalTwoTC.setBackground(SecondColorGroup);

		//Adding Elements to the Test Options
		verticalOneTe.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoTe.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneTe.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoTe.setAlignmentX(BoxLayout.Y_AXIS);
		verticalOneTe.add(subTestOptionsA);
		verticalOneTe.add(subTestOptionsB);
		verticalOneTe.add(subTestOptionsC);
		verticalTwoTe.add(subTestOptionsD);
		verticalTwoTe.add(subTestOptionsE);
		verticalTwoTe.add(subTestOptionsF);
		verticalOneTe.setAlignmentY(BoxLayout.Y_AXIS);
		verticalTwoTe.setAlignmentY(BoxLayout.Y_AXIS);
		verticalOneTe.setAlignmentX(BoxLayout.Y_AXIS);
		verticalTwoTe.setAlignmentX(BoxLayout.Y_AXIS);
		
		horizontalOneTe.add(verticalOneTe);
		horizontalOneTe.add(verticalTwoTe);
		mainBox.add(TestTitle);
		mainBox.add(PlaceHolderEleven);
		mainBox.add(horizontalOneTe);
		mainBox.add(PlaceHolderThree);
		
		subTestOptionsA.add(new JLabel("Test A:"), 0);

		testA.setSelected(true);
		subTestOptionsA.add(testA, 1);
		subTestOptionsB.add(new JLabel("Test B:"), 0);
		testB.setSelected(true);
		subTestOptionsB.add(testB, 1);
		subTestOptionsC.add(new JLabel("Test C:"), 0);
		testC.setSelected(false);
		subTestOptionsC.add(testC, 1);
		subTestOptionsD.add(new JLabel("Test D:"), 0);
		testD.setSelected(false);
		subTestOptionsD.add(testD, 1);
		subTestOptionsE.add(new JLabel("Test E:"), 0);
		testE.setSelected(false);
		subTestOptionsE.add(testE, 1);
		subTestOptionsF.add(new JLabel("Test F:"), 0);
		testF.setSelected(false);
		subTestOptionsF.add(testF, 1);
		
		subTestOptionsA.setBackground(ThirdColorGroup);
		subTestOptionsB.setBackground(ThirdColorGroup);
		subTestOptionsC.setBackground(ThirdColorGroup);
		subTestOptionsD.setBackground(ThirdColorGroup);
		subTestOptionsE.setBackground(ThirdColorGroup);
		subTestOptionsF.setBackground(ThirdColorGroup);
		
		verticalOneTC.setOpaque(true);
		verticalOneTC.setBackground(ThirdColorGroup);
		verticalTwoTC.setOpaque(true);
		verticalTwoTC.setBackground(ThirdColorGroup);
		
		//Add the Run TASE Button
		RunTase.add(TaseButton);
		mainBox.add(RunTase);
		mainBox.add(PlaceHolderFour);
		
		//Add the updating String value at the bottom.
		ShowError.add(new JLabel("\bPlease Enter the Values that you want. The Default Values are in Place."));
		mainBox.add(ShowError);
		
		//Creates the general main screen and adds the components
		getContentPane().setBackground(Color.WHITE);
		getContentPane().add(generalOptions, BorderLayout.CENTER);
	}
	
	//Based on the input, this method creates a new file with the <test>.ini name with the original values from the corresponding
	//<test>_sram.ini values.
	//Then the <test>.ini file is moved to the template folder (its correct location).
	public boolean createTechnologyFile(String test) {
		
		//Creates the .ini file
		technology = new File(test + ".ini");
		try {
			technologyWriter = new FileWriter(technology);
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
			return false;
		}
		
		if(technology.exists()) {
			technology.delete();
		}
		
		try {
			technology.createNewFile();
		} 
		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Could not create the Technology File");
			return false;
		}
		
		System.out.println("Created the file.");
		
		//Moves the file to the Template Folder
		File dir = new File(pathToTASE + "template");
		 
//		 Move file to new directory
		boolean success = technology.renameTo(new File(dir, technology.getName()));
		if (!success) {
		    System.out.println("Could not move File to template folder");
		}
		
		System.out.println("Moved to Template File");
		
		//Copying the File Contents...
		File originalCopy = new File(pathToTASE + "template/" + test + "_sram.ini");
		File techCopy = new File(pathToTASE + "template/" + test + ".ini");
		try {
			InterfaceLayout.copyFile(originalCopy, techCopy);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("Nope");
			return false;
		}
		
		return true;
	}
	
	//For copying the contents of a file into another, found online...
	public static void copyFile(File sourceFile, File destFile) throws IOException {
	    if(!destFile.exists()) {
	        destFile.createNewFile();
	    }

	    FileChannel source = null;
	    FileChannel destination = null;

	    try {
	        source = new FileInputStream(sourceFile).getChannel();
	        destination = new FileOutputStream(destFile).getChannel();
	        destination.transferFrom(source, 0, source.size());
	    }
	    finally {
	        if(source != null) {
	            source.close();
	        }
	        if(destination != null) {
	            destination.close();
	        }
	    }
	}
	
	//Command that deals with adding the tests (deals with the tests separately by accessing the boolean fields for each test).
		//Returned ArrayList has the Spectre results first and then the ocean results in String format.
	public ArrayList<String> addTests() {
		Scanner scanning = null;
		boolean ocean = false;
		boolean spectre = false;
		String oceanString = "<ocn>";
		String spectreString = "<scs>";
		ArrayList<String> returnList = new ArrayList<String>();
		try {
			if(testAR) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testA.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test A Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test A Text File");
				}
			}
			if(testBR) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testB.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test B Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test B Text File");
				}
			}
			if(testCR) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testC.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test C Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test C Text File");
				}
				
			}
			if(testDR) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testD.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test D Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test D Text File");
				}
				
			}
			if(testER) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testE.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test E Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test E Text File");
				}
			}
			if(testFR) {
				ocean = false;
				spectre = false;
				try {
					scanning = new Scanner(new File(pathToTASE + "device/BIN/testF.txt"));
				}
				catch(Exception e) {
					System.out.println("Could not find Test F Text File");
				}
				try {
					String temp;
					while(scanning.hasNext()) {
						temp = scanning.next();
						if(ocean && !temp.contains("</ocn>")) {
							oceanString = oceanString + "\n" + temp;
						}
						else if(spectre && !temp.contains("</scs>")) {
							spectreString = spectreString + "\n" + temp;
						}
						else if(temp.contains("<scs>")) {
							spectre = true;
						}
						else if(temp.contains("<ocn>")) {
							ocean = true;
						}
						else if(temp.contains("</scs>")) {
							spectre = false;
						}
						else if(temp.contains("</ocn>")) {
							ocean = false;
						}
					}
				}
				catch (Exception e) {
					System.out.println("Error when accessing the Test F Text File");
				}
			}
			
			spectreString = spectreString + "\n" + "</scs>";
			oceanString = oceanString + "\n" + "</ocn>";
			
			returnList.add(spectreString);
			returnList.add(oceanString);
		}
		catch (Exception e) {
			System.out.println("There was an Error");
			return null;
		}
		return returnList;
	}
	
	//The Final Command that runs 
	public boolean runProgram() {
		try {
			Process p1 = Runtime.getRuntime().exec("perl run.pl –i ../../template/" + techDropDownValue + ".ini");
//            BufferedReader stdInput = new BufferedReader(new 
//                    InputStreamReader(p1.getInputStream()));
//            System.out.println("Here is the standard output of the command:\n");
//            String s;
//            while ((s = stdInput.readLine()) != null) {
//                System.out.println(s);
//            }
		}
		catch (Exception e) {
			System.out.println("Could not run the Unix Command");
			return false;
		}
		
		return true;
	}
}