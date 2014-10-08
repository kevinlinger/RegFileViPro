import java.io.File;
import java.io.BufferedReader;
import java.io.InputStreamReader;

/**
 * @author wharfie 2004-02-27 Run a system command
 */
public class RunSystemCommand {
	
	public static void runCommand(String value) {
		String s = null;
		// system command to run
		String cmd = "perl run.pl –i ../../template/" + value + ".ini";
		// set the working directory for the OS command processor
		File workDir = new File("/dir1/dir2");
		try {
			Process p = Runtime.getRuntime().exec(cmd, null, workDir);
			int i = p.waitFor();
			if (i == 0) {
				BufferedReader stdInput = new BufferedReader(
						new InputStreamReader(p.getInputStream()));
				// read the output from the command
				while ((s = stdInput.readLine()) != null) {
					System.out.println(s);
				}
			} else {
				BufferedReader stdErr = new BufferedReader(
						new InputStreamReader(p.getErrorStream()));
				// read the output from the command
				while ((s = stdErr.readLine()) != null) {
					System.out.println(s);
				}
			}
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}