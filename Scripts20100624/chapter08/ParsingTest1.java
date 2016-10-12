/**************************************************************************
******************* Troubleshooting Oracle Performance ********************
************************* http://top.antognini.ch *************************
***************************************************************************

File name...: ParsingTest1.java
Author......: Christian Antognini
Date........: August 2008
Description.: This file contains an implementation of test case 1.
Notes.......: Run the script ParsingTest.sql to create the required objects.
Parameters. : -

You can send feedbacks or questions about this script to top@antognini.ch.

Changes:
DD.MM.YYYY Description
---------------------------------------------------------------------------

**************************************************************************/

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class ParsingTest1
{

  public static void main(String[] args)
  {
    String user;
    String password;
    String url;
    Connection connection = null;
    
    long startTime;
    long endTime;
    
    if (args.length != 3)
    {
      System.out.println("usage: java " + ParsingTest1.class.getName() + " <user> <password> <jdbc url>");
      return;
    }
    else
    {
      user = args[0];
      password = args[1];
      url = args[2];
    }

    try
    {
      connection = ConnectionUtil.connect(user, password, url);
      
      ConnectionUtil.setCliendId(connection, System.getProperty("user.name"));
      ConnectionUtil.setModuleName(connection, ParsingTest1.class.getName());

      startTime = System.currentTimeMillis();
      test(connection);
      endTime = System.currentTimeMillis();
      System.out.println("response time: " + (endTime-startTime) + "ms");        
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
    finally
    {
      ConnectionUtil.disconnect(connection);
    }
  }
  
  private static void test(Connection connection) throws Exception
  {
    String sql;
    Statement statement;
    ResultSet resultset;
    String pad;
    
    try
    {
      sql = "SELECT pad FROM t WHERE val = ";
      for (int i=0 ; i<10000; i++)
      {
        statement = connection.createStatement();
        resultset = statement.executeQuery(sql + Integer.toString(i));
        if (resultset.next())
        {
          pad = resultset.getString("pad");       
        }
        resultset.close();
        statement.close();
      }
    }
    catch (SQLException e)
    {
      throw new Exception("Error during execution of test >>> " + e.getMessage());
    }
  }
}
