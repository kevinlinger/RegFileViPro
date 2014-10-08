/*
 * This is just the Driver for the program. It runs the entire simulation from the visual standpoint for user interaction.
 */

import java.awt.Dimension;
import java.awt.Toolkit;

import javax.swing.JFrame;

public class InterfaceDriver {
	
	Toolkit toolkit =  Toolkit.getDefaultToolkit ();
	Dimension dim = toolkit.getScreenSize();
	
	public void start() {
		JFrame frame = new JFrame("TASE Interface");
		frame.setSize(600, 650);
		frame.setLocation(10, 10);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setContentPane(new InterfaceLayout());
		frame.setVisible(true);
	}
	
	public static void main(String args[]) {
		InterfaceDriver run = new InterfaceDriver();
		run.start();
	}

}
