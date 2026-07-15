Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System.Data
Imports System.Data.SqlClient
Imports System.Runtime.CompilerServices
Imports System.Collections

Public Module MYConn
    Private cmd As SqlCommand = New SqlCommand()
    Private sqlCon As SqlConnection = New SqlConnection()
    Private ad As SqlDataAdapter = New SqlDataAdapter()
    'Private paramCache As Hashtable = Hashtable.Synchronized(New Hashtable())

    Private Enum SqlConnectionOwnership
        Internal
        External
    End Enum

    Private Sub AttachParameters(ByVal command As SqlCommand, ByVal commandParameters As SqlParameter())
        'For i As Integer = 0 To commandParameters.Length - 1
        '    Dim sqlParameter As SqlParameter = commandParameters(i)

        '    If sqlParameter.Direction = 3 And sqlParameter.Value Is Nothing Then
        '        sqlParameter.Value = Nothing
        '    End If

        '    command.Parameters.Add(sqlParameter)
        'Next

        For Each spp As SqlParameter In commandParameters
            Dim nameParam As SqlParameter = New SqlParameter(spp.ParameterName, spp.SqlValue)
            command.Parameters.Add(nameParam)
        Next
    End Sub

    Private Sub PrepareCommand(ByVal command As SqlCommand, ByVal connection As SqlConnection, ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String, ByVal commandParameters As SqlParameter())
        If connection.State <> 1 Then
            connection.Open()
        End If

        command.Connection = connection
        command.CommandText = commandText

        If transaction IsNot Nothing Then
            command.Transaction = transaction
        End If

        command.CommandType = commandType

        If commandParameters IsNot Nothing Then
            AttachParameters(command, commandParameters)
        End If
    End Sub


#Region "ExecuteDataset"
    'Public Function ExecuteDataset(ByVal ConnectionString As String, ByVal commandType As System.Data.CommandType, ByVal commandText As String, ByVal tableName As String) As DataSet
    '    Dim lPass As Boolean = False
    '    Dim ds As DataSet = New DataSet()

    '    Try
    '        Dim querystring As String = Nothing

    '        Using connection As SqlConnection = New SqlConnection(ConnectionString)
    '            cmd.Connection = sqlCon
    '            cmd.CommandType = commandType
    '            cmd.CommandText = commandText
    '            cmd.CommandTimeout = 0
    '            cmd.Connection.Open()
    '            ad.SelectCommand = cmd
    '            If ds.Tables.Contains(tableName) Then ds.Tables.Remove(tableName)
    '            ad.Fill(ds, tableName)
    '            cmd.Connection.Close()
    '            lPass = True
    '        End Using

    '    Catch ex As Exception

    '        If (cmd.Connection.State = ConnectionState.Open) Then
    '            cmd.Connection.Close()
    '        End If

    '        Throw
    '    End Try

    '    Return ds
    'End Function

    'Public Function ExecuteDataset(ByVal ConnectionString As String, ByVal commandType As System.Data.CommandType, ByVal commandText As String) As DataSet
    '    Dim lPass As Boolean = False
    '    Dim ds As DataSet = New DataSet()

    '    Try
    '        Dim querystring As String = Nothing

    '        Using connection As SqlConnection = New SqlConnection(ConnectionString)
    '            cmd.Connection = sqlCon
    '            cmd.CommandType = commandType
    '            cmd.CommandText = commandText
    '            cmd.CommandTimeout = 0
    '            cmd.Connection.Open()
    '            ad.SelectCommand = cmd
    '            ad.Fill(ds)
    '            cmd.Connection.Close()
    '            lPass = True
    '        End Using

    '    Catch ex As Exception

    '        If (cmd.Connection.State = ConnectionState.Open) Then
    '            cmd.Connection.Close()
    '        End If

    '        Throw
    '    End Try

    '    Return ds
    'End Function

    Public Function ExecuteDataset(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String) As DataSet
        Return ExecuteDataset(connectionString, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteDataset(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As DataSet
        Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
        Dim result As DataSet

        Try
            sqlConnection.Open()
            result = ExecuteDataset(sqlConnection, commandType, commandText, commandParameters)
        Finally
            sqlConnection.Dispose()
        End Try

        Return result
    End Function
    Public Function ExecuteDataset(ByVal connection As SqlConnection, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As DataSet
        Dim sqlCommand As SqlCommand = New SqlCommand()
        Dim dataSet As DataSet = New DataSet()
        PrepareCommand(sqlCommand, connection, Nothing, commandType, commandText, commandParameters)
        Dim sqlDataAdapter As SqlDataAdapter = New SqlDataAdapter(sqlCommand)
        sqlDataAdapter.Fill(dataSet)
        sqlCommand.Parameters.Clear()
        Return dataSet
    End Function

    Public Function ExecuteDataset(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String) As DataSet
        Return ExecuteDataset(transaction, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteDataset(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As DataSet
        Dim sqlCommand As SqlCommand = New SqlCommand()
        Dim dataSet As DataSet = New DataSet()
        PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters)
        Dim sqlDataAdapter As SqlDataAdapter = New SqlDataAdapter(sqlCommand)
        sqlDataAdapter.Fill(dataSet)
        sqlCommand.Parameters.Clear()
        Return dataSet
    End Function

    Public Function ExecuteDataset(ByVal connectionString As String, ByVal spName As String, ParamArray parameterValues As Object()) As DataSet
        Dim result As DataSet

        If parameterValues IsNot Nothing And parameterValues.Length > 0 Then
            Dim spParameterSet As SqlParameter() = GetSpParameterSet(connectionString, spName)
            AssignParameterValues(spParameterSet, parameterValues)
            result = ExecuteDataset(connectionString, CommandType.StoredProcedure, spName, spParameterSet)
        Else
            result = ExecuteDataset(connectionString, CommandType.StoredProcedure, spName)
        End If

        Return result
    End Function

    Public Function ExecuteDataset(ByVal transaction As SqlTransaction, ByVal spName As String, ParamArray parameterValues As Object()) As DataSet
        Dim result As DataSet

        If parameterValues IsNot Nothing And parameterValues.Length > 0 Then
            Dim spParameterSet As SqlParameter() = GetSpParameterSet(transaction.Connection.ConnectionString, spName)
            AssignParameterValues(spParameterSet, parameterValues)
            result = ExecuteDataset(transaction, CommandType.StoredProcedure, spName, spParameterSet)
        Else
            result = ExecuteDataset(transaction, CommandType.StoredProcedure, spName)
        End If

        Return result
    End Function
#End Region

#Region "ExecuteScalar"
    Public Function ExecuteScalar(ByVal connection As SqlConnection, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Object
        Dim sqlCommand As SqlCommand = New SqlCommand()
        PrepareCommand(sqlCommand, connection, Nothing, commandType, commandText, commandParameters)
        Dim objectValue As Object = RuntimeHelpers.GetObjectValue(sqlCommand.ExecuteScalar())
        sqlCommand.Parameters.Clear()
        Return objectValue
    End Function

    Public Function ExecuteScalar(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String) As Object
        Return ExecuteScalar(connectionString, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteScalar(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Object
        Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
        Dim result As Object

        Try
            sqlConnection.Open()
            result = ExecuteScalar(sqlConnection, commandType, commandText, commandParameters)
        Finally
            sqlConnection.Dispose()
        End Try

        Return result
    End Function

    Public Function ExecuteScalar(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String) As Object
        Return ExecuteScalar(transaction, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteScalar(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Object
        Dim sqlCommand As SqlCommand = New SqlCommand()
        PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters)
        Dim objectValue As Object = RuntimeHelpers.GetObjectValue(sqlCommand.ExecuteScalar())
        sqlCommand.Parameters.Clear()
        Return objectValue
    End Function

    Public Function ExecuteScalar(ByVal connectionString As String, ByVal spName As String, ParamArray parameterValues As Object()) As Object
        Dim result As Object

        If parameterValues IsNot Nothing And parameterValues.Length > 0 Then
            Dim spParameterSet As SqlParameter() = GetSpParameterSet(connectionString, spName)
            MYConn.AssignParameterValues(spParameterSet, parameterValues)
            result = MYConn.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName, spParameterSet)
        Else
            result = MYConn.ExecuteScalar(connectionString, CommandType.StoredProcedure, spName)
        End If

        Return result
    End Function
#End Region

#Region "ExecuteNonQuery"
    Public Function ExecuteNonQuery(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String) As Integer
        Return ExecuteNonQuery(transaction, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteNonQuery(ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Integer
        Dim sqlCommand As SqlCommand = New SqlCommand()
        PrepareCommand(sqlCommand, transaction.Connection, transaction, commandType, commandText, commandParameters)
        Dim result As Integer = sqlCommand.ExecuteNonQuery()
        sqlCommand.Parameters.Clear()

        Return result
    End Function

    Public Function ExecuteNonQuery(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String) As Integer
        Return ExecuteNonQuery(connectionString, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteNonQuery(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Integer
        Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
        Dim result As Integer

        Try
            sqlConnection.Open()
            result = ExecuteNonQuery(sqlConnection, commandType, commandText, commandParameters)
        Finally
            sqlConnection.Dispose()
        End Try

        Return result
    End Function
    Public Function ExecuteNonQuery(ByVal connection As SqlConnection, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As Integer
        Dim sqlCommand As SqlCommand = New SqlCommand()
        PrepareCommand(sqlCommand, connection, Nothing, commandType, commandText, commandParameters)
        Dim result As Integer = sqlCommand.ExecuteNonQuery()
        sqlCommand.Parameters.Clear()
        Return result
    End Function

    Public Function ExecuteNonQuery(ByVal connectionString As String, ByVal spName As String, ParamArray parameterValues As Object()) As Integer
        Dim result As Integer

        If parameterValues IsNot Nothing And parameterValues.Length > 0 Then
            Dim spParameterSet As SqlParameter() = GetSpParameterSet(connectionString, spName)
            AssignParameterValues(spParameterSet, parameterValues)
            result = ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName, spParameterSet)
        Else
            result = ExecuteNonQuery(connectionString, CommandType.StoredProcedure, spName)
        End If

        Return result
    End Function
    'Public Function GetSpParameterSet(ByVal connectionString As String, ByVal spName As String) As SqlParameter()
    '    Return GetSpParameterSet(connectionString, spName, False)
    'End Function
    'Public Function GetSpParameterSet(ByVal connectionString As String, ByVal spName As String, ByVal includeReturnValueParameter As Boolean) As SqlParameter()
    '    Dim text As String = StringType.FromObject(ObjectType.AddObj(connectionString & ":" & spName, Interaction.IIf(includeReturnValueParameter, ":include ReturnValue Parameter", "")))
    '    Dim array As SqlParameter() = CType(paramCache.Item(text), SqlParameter())

    '    If array Is Nothing Then
    '        'paramCache.Item(text, DiscoverSpParameterSet(connectionString, spName, includeReturnValueParameter, New Object {}))
    '        paramCache.Item(text) = DiscoverSpParameterSet(connectionString, spName, includeReturnValueParameter, New Object())
    '        array = CType(paramCache.Item(text), SqlParameter())
    '    End If

    '    Return CloneParameters(array)
    'End Function
    'Private Function DiscoverSpParameterSet(ByVal connectionString As String, ByVal spName As String, ByVal includeReturnValueParameter As Boolean, ParamArray parameterValues As Object()) As SqlParameter()
    'Private Function DiscoverSpParameterSet(ByVal connectionString As String, ByVal spName As String, ByVal includeReturnValueParameter As Boolean, ParamArray parameterValues As Object()) As SqlParameter()
    '    Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
    '    Dim sqlCommand As SqlCommand = New SqlCommand(spName, sqlConnection)
    '    Dim array() As SqlParameter

    '    Try
    '        sqlConnection.Open()
    '        sqlCommand.CommandType = 4
    '        SqlCommandBuilder.DeriveParameters(sqlCommand)

    '        If Not includeReturnValueParameter Then
    '            sqlCommand.Parameters.RemoveAt(0)
    '        End If

    '        'array = SqlParameter((sqlCommand.Parameters.Count - 1 + 1))
    '        array(sqlCommand.Parameters.Count - 1 + 1) = New SqlParameter
    '        sqlCommand.Parameters.CopyTo(array, 0)
    '    Finally
    '        sqlCommand.Dispose()
    '        sqlConnection.Dispose()
    '    End Try

    '    Return array
    'End Function
    Private Function CloneParameters(ByVal originalParameters As SqlParameter()) As SqlParameter()
        Dim array As SqlParameter()
        Dim arg_18_0 As Short
        Dim num2 As Short

        Dim num As Short = CShort((originalParameters.Length - 1))
        array = New SqlParameter(CInt((num + 1)) - 1) {}
        arg_18_0 = 0
        num2 = num

        For num3 As Short = arg_18_0 To num2
            array(CInt(num3)) = CType(originalParameters(num3), SqlParameter)
        Next

        Return array
    End Function
    Private Sub AssignParameterValues(ByVal commandParameters As SqlParameter(), ByVal parameterValues As Object())
        If Not (commandParameters Is Nothing And parameterValues Is Nothing) Then

            If commandParameters.Length <> parameterValues.Length Then
                Throw New ArgumentException("Parameter count does not match Parameter Value count.")
            End If

            'Short num = checked((Short)(commandParameters.get_Length() - 1));
            Dim num As Short = commandParameters.Length - 1

            Dim arg_37_0 As Short = 0
            Dim num2 As Short = num

            For num3 As Short = arg_37_0 To num2
                commandParameters(CInt(num3)).Value = RuntimeHelpers.GetObjectValue(parameterValues(CInt(num3)))
            Next
        End If
    End Sub

    Public Function ExecuteNonQuery(ByVal transaction As SqlTransaction, ByVal connectionstring As String, ByVal spName As String, ParamArray parameterValues As Object()) As Integer
        Dim result As Integer

        If parameterValues IsNot Nothing And parameterValues.Length > 0 Then
            Dim spParameterSet As SqlParameter() = GetSpParameterSet(connectionstring, spName)
            AssignParameterValues(spParameterSet, parameterValues)
            result = ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName, spParameterSet)
        Else
            result = ExecuteNonQuery(transaction, CommandType.StoredProcedure, spName)
        End If

        Return result
    End Function
    Public Function GetSpParameterSet(ByVal connectionString As String, ByVal spName As String) As SqlParameter()
        Dim array As SqlParameter()
        'Return GetSpParameterSet(connectionString, spName, False)
        Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
        cmd.Connection = sqlConnection
        cmd.CommandText = spName
        cmd.CommandType = Data.CommandType.StoredProcedure
        cmd.Parameters.Clear()
        sqlConnection.Open()
        SqlCommandBuilder.DeriveParameters(cmd)

        Dim j As Integer = 0
        For Each param As SqlParameter In cmd.Parameters
            If param.Direction = Data.ParameterDirection.Input OrElse param.Direction = Data.ParameterDirection.InputOutput Then
                j = j + 1
            End If
        Next

        array = New SqlParameter(j - 1) {}
        Dim i As Integer = 0
        For Each param As SqlParameter In cmd.Parameters
            If param.Direction = Data.ParameterDirection.Input OrElse param.Direction = Data.ParameterDirection.InputOutput Then
                'blInputParameters.Items.Add(param.ParameterName & " - " & param.SqlDbType.ToString())
                array(i) = CType(param, SqlParameter)
                i = i + 1
            Else
                'blOutputParameters.Items.Add(param.ParameterName & " - " & param.SqlDbType.ToString())
            End If
        Next
        sqlConnection.Close()
        Return array
    End Function
#End Region

#Region "ExecuteReader"
    Public Function ExecuteReader(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String) As SqlDataReader
        Return MYConn.ExecuteReader(connectionString, commandType, commandText, Nothing)
    End Function
    Public Function ExecuteReader(ByVal connectionString As String, ByVal commandType As CommandType, ByVal commandText As String, ParamArray commandParameters As SqlParameter()) As SqlDataReader
        Dim sqlConnection As SqlConnection = New SqlConnection(connectionString)
        sqlConnection.Open()
        Dim result As SqlDataReader

        Try
            result = ExecuteReader(sqlConnection, Nothing, commandType, commandText, commandParameters, SqlConnectionOwnership.Internal)
        Catch arg_20_0 As Exception
            ProjectData.SetProjectError(arg_20_0)
            sqlConnection.Dispose()
            ProjectData.ClearProjectError()
        End Try

        Return result
    End Function
    Private Function ExecuteReader(ByVal connection As SqlConnection, ByVal transaction As SqlTransaction, ByVal commandType As CommandType, ByVal commandText As String, ByVal commandParameters As SqlParameter(), ByVal connectionOwnership As SqlConnectionOwnership) As SqlDataReader
        Dim sqlCommand As SqlCommand = New SqlCommand()
        PrepareCommand(sqlCommand, connection, transaction, commandType, commandText, commandParameters)
        Dim result As SqlDataReader

        If connectionOwnership = SqlConnectionOwnership.External Then
            result = sqlCommand.ExecuteReader()
        Else
            result = sqlCommand.ExecuteReader(32)
        End If

        sqlCommand.Parameters.Clear()
        Return result
    End Function
#End Region

    'Public Function ExecuteNonQuery(ByVal connectionString As String, ByVal spName As String, ParamArray parameterValues As Object()) As Integer
    '    Dim result As Integer

    '    Try
    '        Dim querystring As String = Nothing

    '        Using connection As SqlConnection = New SqlConnection(connectionString)
    '            cmd.Connection = sqlCon
    '            cmd.CommandType = CommandType.Text
    '            cmd.Parameters.Clear()
    '            querystring = "EXEC " + spName + " 'tx001-strb,TX000-IFFI','2014-01-01','2014-05-30'"
    '            For i As Integer = 0 To parameterValues.Count - 1
    '                'cmd.Parameters.AddWithValue(String.Format("@F{0}", i), parameterValues(i))
    '                querystring += "'" + parameterValues(i).ToString + "',"
    '            Next
    '            querystring = querystring.Substring(0, querystring.Length - 1)

    '            cmd.CommandText = spName
    '            cmd.CommandTimeout = 0
    '            cmd.Connection.Open()

    '            result = cmd.ExecuteNonQuery()
    '            cmd.Connection.Close()

    '        End Using

    '    Catch ex As Exception

    '        If (cmd.Connection.State = ConnectionState.Open) Then
    '            cmd.Connection.Close()
    '        End If

    '        Throw
    '    End Try

    '    Return result
    'End Function
End Module
