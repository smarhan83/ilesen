Imports Microsoft.VisualBasic
Imports System.Data
Imports System.Data.SqlClient
Imports System.IO
Imports System.Web.SessionState.HttpSessionState
Imports System.Net
Imports System.Text
Imports System.Security.Cryptography
Imports System.Net.Mail


Public Class SysCon

    Public Shared Function ExecuteReader(ByVal sql As String, ByVal Optional parameters As SqlParameter() = Nothing) As SqlDataReader
        Dim conn As SqlConnection = New SqlConnection()
        conn.ConnectionString = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
        conn.Open()
        Dim cmd As SqlCommand = New SqlCommand()
        cmd.Connection = conn
        cmd.CommandText = sql

        If parameters IsNot Nothing Then
            cmd.CommandType = CommandType.Text

            For Each p As SqlParameter In parameters
                cmd.Parameters.Add(p)
            Next
        Else
            cmd.CommandType = CommandType.Text
        End If

        Dim reader As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
        Return reader
    End Function

    Public Shared Function ExecuteDataset(lSql As String) As DataSet
        Dim ds As DataSet = New DataSet()

        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim cmd As New SqlCommand(lSql, myConnection)

            myConnection.Open()

            Dim dr As SqlDataReader = cmd.ExecuteReader(CommandBehavior.CloseConnection)
            Dim dt As DataTable = New DataTable()
            dt.Load(dr)

            ds.Tables.Add(dt)

            myConnection.Close()

        End Using

        Return ds
    End Function

    Public Shared Function ExecuteScalar(lSql As String) As Integer
        Dim retval As Integer = 0
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim myCommand As New SqlCommand(lSql, myConnection)

            myConnection.Open()

            retval = Convert.ToInt32(myCommand.ExecuteScalar())

            myConnection.Close()

        End Using

        Return retval
    End Function

    Public Shared Function ExecuteNonQuery(lSql As String) As Integer
        Dim retval As Integer = 0
        Using myConnection As New SqlConnection(ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString)

            Dim myCommand As New SqlCommand(lSql, myConnection)

            myConnection.Open()

            myCommand.ExecuteNonQuery()

            myConnection.Close()

        End Using

        Return retval
    End Function


End Class




