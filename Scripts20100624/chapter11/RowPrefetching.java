/**************************************************************************
******************* Troubleshooting Oracle Performance ********************
************************* http://top.antognini.ch *************************
***************************************************************************

File name...: RowPrefetching.java
Author......: Christian Antognini
Date........: August 2008
Description.: These scripts provide examples of implementing row
              prefetching with JDBC.
Notes.......: The table T created with row_prefetching.sql must exist.
Parameters. : <user> <password> <jdbc url>

You can send feedbacks or questions about this script to top@antognini.ch.

Changes:
DD.MM.YYYY Description
---------------------------------------------------------------------------

**************************************************************************/

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import oracle.jdbc.pool.OracleDataSource;


public class RowPrefetching
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
      System.out.println("usage: java " + RowPrefetching.class.getName() + " <user> <password> <jdbc url>");
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
      ConnectionUtil.setModuleName(connection, RowPrefetching.class.getName());

      for (int i=1 ; i<=1 ; i++)
      {
        startTime = System.currentTimeMillis();
        test(connection, i);
        endTime = System.currentTimeMillis();
        System.out.println(Integer.toString(i) + " , " + (endTime-startTime));                
      }
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

  private static void test(Connection connection, int fetchSize) throws Exception
  {
    String sql;
    PreparedStatement statement;
    ResultSet resultset;
    long id;
    String pad;
    
    try
    {
      sql = "SELECT id, pad FROM t";
      statement = connection.prepareStatement(sql);
      statement.setFetchSize(fetchSize);
      resultset = statement.executeQuery();
      while (resultset.next())
      {
        id = resultset.getLong("id");
        pad = resultset.getString("pad"); 
        // process data
      }
      resultset.close();
      statement.close();
    }
    catch (SQLException e)
    {
      throw new Exception("Error during execution of test >>> " + e.getMessage());
    }
  }
}
