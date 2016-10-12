/**************************************************************************
******************* Troubleshooting Oracle Performance ********************
************************* http://top.antognini.ch *************************
***************************************************************************

File name...: LoggingPerf.java
Author......: Christian Antognini
Date........: August 2008
Description.: You can use this Java class to compare the average execution
              time of the methods info and isInfoEnabled of the log4j 
              class Logger.
Notes.......: To compile and run this class the log4j JAR must be added to 
              the class path, e.g.:
              javac -cp log4j-1.2.14.jar LoggingPerf.java
              java -cp .;log4j-1.2.14.jar LoggingPerf
Parameters..: -

You can send feedbacks or questions about this script to top@antognini.ch.

Changes:
DD.MM.YYYY Description
---------------------------------------------------------------------------

**************************************************************************/

import org.apache.log4j.BasicConfigurator;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;

public class LoggingPerf
{
	static Logger logger = Logger.getLogger(LoggingPerf.class);
	
	static public void main(String[] args)
	{
		BasicConfigurator.configure();
		
		long iteractions = 50000000;
		long beginTimeMillis;
		long endTimeMillis;

		logger.setLevel(Level.ERROR);
		beginTimeMillis = System.currentTimeMillis();
		for (int i=0 ; i<=iteractions ; i++)
		{		
			logger.info("SearchProducts(" + i + ") response time " + (i-i) + " ms");
		}
		endTimeMillis = System.currentTimeMillis();
		logger.setLevel(Level.INFO);
		logger.info("number of calls per millisecond: " + (iteractions/(endTimeMillis-beginTimeMillis)));
		logger.info("duration per call in nanosecods: " + ((endTimeMillis-beginTimeMillis)*1000000/iteractions));

		logger.setLevel(Level.ERROR);
		beginTimeMillis = System.currentTimeMillis();
		for (int i=0 ; i<=iteractions ; i++)
		{		
			if (logger.isInfoEnabled())
			{
				logger.info("SearchProducts(" + i + ") response time " + (i-i) + " ms");
			}
		}
		endTimeMillis = System.currentTimeMillis();
		logger.setLevel(Level.INFO);
		logger.info("number of calls per millisecond: " + (iteractions/(endTimeMillis-beginTimeMillis)));
		logger.info("duration per call in nanosecods: " + ((endTimeMillis-beginTimeMillis)*1000000/iteractions));
	}
}