/**************************************************************************
******************* Troubleshooting Oracle Performance ********************
************************* http://top.antognini.ch *************************
***************************************************************************

File name...: ArrayInterface.java
Author......: Christian Antognini
Date........: August 2008
Description.: These scripts provide examples of implementing the array
              interface with JDBC.
Notes.......: The table T created with array_interface.sql must exist.
Parameters. : <user> <password> <jdbc url>

You can send feedbacks or questions about this script to top@antognini.ch.

Changes:
DD.MM.YYYY Description
---------------------------------------------------------------------------
24.06.2010 Added check for the return value of the executeBatch method
**************************************************************************/

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import oracle.jdbc.pool.OracleDataSource;


public class ArrayInterface
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
      System.out.println("usage: java " + ArrayInterface.class.getName() + " <user> <password> <jdbc url>");
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
      ConnectionUtil.setModuleName(connection, ArrayInterface.class.getName());

      startTime = System.currentTimeMillis();
      test(connection, 100000);
      endTime = System.currentTimeMillis();
      System.out.println(endTime-startTime);         
      connection.commit();

      startTime = System.currentTimeMillis();
      testBatch(connection, 100000);
      endTime = System.currentTimeMillis();
      System.out.println(endTime-startTime);                
      connection.commit();
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

  private static void test(Connection connection, int rows) throws Exception
  {
    String sql;
    PreparedStatement statement;
    
    try
    {
      sql = "INSERT INTO t VALUES (?, ?)";
      statement = connection.prepareStatement(sql);
      for (int i=1 ; i<=rows ; i++)
      {
        statement.setInt(1, i);
        statement.setString(2, "****************************************************************************************************");
        statement.executeUpdate();
      }
      statement.close();
    }
    catch (SQLException e)
    {
      throw new Exception("Error during execution of test >>> " + e.getMessage());
    }
  }

  private static void testBatch(Connection connection, int rows) throws Exception
  {
    String sql;
    PreparedStatement statement;
    int[] counts;
    
    try
    {
      sql = "INSERT INTO t VALUES (?, ?)";
      statement = connection.prepareStatement(sql);
      for (int i=1 ; i<=rows ; i++)
      {
        statement.setInt(1, i);
        statement.setString(2, "****************************************************************************************************");
        statement.addBatch();
      }
      counts = statement.executeBatch();
      statement.close();

      // if the execution is successful, SUCCESS_NO_INFO is returned for every statement 
      // (this is a limitation of the Oracle JDBC driver)
      // otherwise, an SQLExection exeception is raised
      for (int i=0 ; i<rows ; i++)
      {
        if (counts[i] != statement.SUCCESS_NO_INFO)
        {
          throw new Exception("Return value of execution nr. " + Integer.toString(i+1) + " is not SUCCESS_NO_INFO");
        }
      }
    }
    catch (SQLException e)
    {
      throw new Exception("Error during execution of testBatch >>> " + e.getMessage());
    }
  }
}
