Imports System
Imports System.Data
Imports System.Data.SqlClient

Public Module ModGeneral
#Region " Declarations "
    Public Const MsgAddSuccess As String = "Successfully Added !"
    Public Const MsgAddUnSuccess As String = "Add Failed !"
    Public Const MsgUpdateSuccess As String = "Successfully Updated !"
    Public Const MsgUpdateUnSuccess As String = "Update Failed !"
    Public Const MsgDeleteSuccess As String = "Successfully Deleted !"
    Public Const MsgDeleteUnSuccess As String = "Delete Failed !"
    Public Const MsgProcessSuccess As String = "Successfully Processed !"
    Public Const MsgProcessUnSuccess As String = "Process Failed !"
    Public Const MsgRedLbl As String = "Label(s) in red are compulsory !"
    Public Const MsgWarnDel As String = "Please Update Or Cancel Before Continue Delete !"

    Private _EncryptionKey As String = ">dR!*GN!KC)#"
    Private key() As Byte = {}
    Private IV() As Byte = {&H1, &H23, &H45, &H67, &H89, &HAB, &HCD, &HEF}

    Public gdSysDateTime As DateTime
    Dim lsDate, lsTime As String

    Public lConn As String = ConfigurationManager.ConnectionStrings("webcon_ConnectionStr").ConnectionString
#End Region

    Public Function GetLastDayOfMonth(ByVal TheDate As Object) As Integer
        GetLastDayOfMonth = DatePart("d", DateAdd("d", -1, DateAdd("m", 1, DateAdd("d", -DatePart("d", TheDate) + 1, TheDate))))
    End Function

    Public Function IsMill(ByVal EstateId As Long) As Boolean
        Dim dr As System.Data.SqlClient.SqlDataReader
        Dim lstr As String
        Dim lflag As Boolean

        lstr = "select Mill from Estate where EstateId=" & EstateId

        dr = MYConn.ExecuteReader(lConn, CommandType.Text, lstr)

        If dr.Read Then
            If Not IsDBNull(dr("Mill")) Then
                If CType(dr.Item("Mill"), String).Trim = "Y" Then
                    lflag = True
                End If
            End If
        End If

        If Not dr.IsClosed Then dr.Close()

        Return lflag
    End Function

    Public Function DTF(ByVal sDate As String) As Date
        If sDate = "" Then
            Return Nothing
        End If

        Dim d As Date = Date.ParseExact(sDate, "dd/MM/yyyy", New Globalization.CultureInfo("en-US"))
        Return d
    End Function

    Public Sub pBackUPDB(ByVal sModule As String, ByVal EstateID As Integer)
        'Dim rs As Integer = MYConn.ExecuteNonQuery(lConn, "AutoBackUp", sModule)
        Dim rs As Integer = 0
        Using myConnection As New SqlConnection(lConn)
            Dim myCommand As New SqlCommand("AutoBackUp", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.Clear()
            myCommand.Parameters.AddWithValue("@pModule", sModule)
            myCommand.Parameters.AddWithValue("@pEstateID", EstateID)
            myCommand.CommandTimeout = 600
            myConnection.Open()

            rs = myCommand.ExecuteNonQuery()

            myConnection.Close()
        End Using

        If rs >= 0 Then
            Dim i As Integer
            i = i + 1
        End If

    End Sub

    Public Sub pATTENDANCE_UL(ByVal EstateID As Integer)
        'Dim rs As Integer = MYConn.ExecuteNonQuery(lConn, "SP_ATTENDANCE_UL")
        Dim rs As Integer = 0
        Using myConnection As New SqlConnection(lConn)
            Dim myCommand As New SqlCommand("SP_ATTENDANCE_UL", myConnection)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.Clear()
            myCommand.Parameters.AddWithValue("@pEstateID", EstateID)
            myConnection.Open()

            rs = myCommand.ExecuteNonQuery()

            myConnection.Close()
        End Using

        If rs >= 0 Then
            Dim i As Integer
            i = i + 1
        End If

    End Sub

#Region "add by Eizzuddin"

    'Public Sub MessageBox(ByVal Msg As String, ByVal obj As System.Web.UI.Page)
    '    Dim jscript As String
    '    Dim x = "OURServices"

    '    jscript = ("<script language=""JavaScript"">alert(""" & Msg & """);</script>")

    '    obj.RegisterClientScriptBlock(x, jscript)
    'End Sub

    Public Function fnGetEmpName(ByVal pId As String, ByVal pEstateID As Long) As DataSet
        Dim lstrSql As String
        If Trim(pId) = "" Then
            lstrSql = " SELECT CREmployee.EmpCode + ' ' +  CREmployee.FirstName as CREmployeeCodeName, " &
            " CREmployee.EmpID ,  CREmployee.EmpCode,  CREmployee.FirstName from CREmployee " &
            " WHERE  crEmployee.EstateID = " & pEstateID & " AND crEmployee.Active='Y' " &
            " order by CREmployee.EmpCode"
        Else
            lstrSql = " SELECT CREmployee.EmpCode + ' ' +  CREmployee.FirstName as CREmployeeCodeName, " &
            " CREmployee.EmpID ,  CREmployee.EmpCode,  CREmployee.FirstName from CREmployee " &
            " WHERE (CREmployee.EmpCode = '" & pId & "' )  AND   " &
            " crEmployee.EstateID = " & pEstateID & " AND crEmployee.Active='Y' " &
            " order by CREmployee.EmpCode"

        End If
        fnGetEmpName = MYConn.ExecuteDataset(lConn, CommandType.Text, lstrSql)
    End Function

    Public Function GetWorkTypeJobType(ByVal pID As String, ByVal pEstateID As Long) As DataSet
        ' Used  by Aru - Checkroll
        Dim lstrSql As String
        If pID = "" Then
            lstrSql = " SELECT     CREmployee.EmpID, CREmployee.FirstName, CREmployee.*, " &
            " WorkType.WorkTypeID, WorkType.WorkTypeCode, " &
            " WorkType.WorkTypeDesc " &
            " FROM  CREmployee INNER JOIN " &
            " WorkType ON CREmployee.WorkTypeID = WorkType.WorkTypeID AND " &
            " crEmployee.EstateID = " & pEstateID
        Else
            lstrSql = " SELECT     CREmployee.EmpID, CREmployee.FirstName, CREmployee.*, " &
           " WorkType.WorkTypeID, WorkType.WorkTypeCode, " &
           " WorkType.WorkTypeDesc " &
           " FROM  CREmployee INNER JOIN " &
           " WorkType ON CREmployee.WorkTypeID = WorkType.WorkTypeID " &
           " WHERE CREmployee.EmpCode = '" & pID & "'   AND " &
           " crEmployee.EstateID = " & pEstateID
        End If
        GetWorkTypeJobType = MYConn.ExecuteDataset(lConn, CommandType.Text, lstrSql)

    End Function

    Public Function IsExpenditureValid(ByVal pYear As Integer, ByVal pEstateID As Long, ByVal pAGMainstatus As String, ByVal pBlockId As String, ByRef Msg As String) As Boolean
        Dim dr As SqlClient.SqlDataReader
        Dim lsql As String
        Dim ldrAG As DataRow
        Dim lObjBM As Object
        Dim BMS As String
        Dim FReturn As Boolean = False
        lsql = "select isnull(status,'N') as blockstatus from blockmasterdetails where EstateId = " & pEstateID & "  and Blockid='" & pBlockId & "'"

        dr = MYConn.ExecuteReader(lConn, CommandType.Text, lsql)

        ' lsql = " select isnull(agm.NewPlanted,'N') as NewPlanted, isnull(agm.RePlanted,'N') as RePlanted, isnull(agm.Nursery,'N') as Nursery ,isnull(agm.RevExpAG,'N') as Revenew " & _
        ' " from AccAGMain agm " & _
        ' " inner join AccAGSub ags on agm.AGMainID=ags.AGMainID " & _
        ' " inner join COA ca on ags.AGSubID=ca.AGSubID " & _
        ' " where ca.EstateID=" & pEstateID & " and ca.AGGL ='" & pAGGL & "'"

        ' ldrAG = THConn.ExecuteDataset(lConn, CommandType.Text, lsql).Tables(0).Rows(0)

        ' lsql = " Select bmd.Status " & _
        '" from BlockMaster bm " & _
        '" inner join BlockMasterDetails bmd on bmd.BlockID=bm.BlockID " & _
        '" AND Year(BMD.EffectiveFrom)<=" & pYear & _
        '" AND Year(BMD.EffectiveTo)>=" & pYear & _
        '" inner join FieldMaster fm on bm.FieldID=fm.FieldID " & _
        '" where fm.EstateID=" & pEstateID & " and fm.FieldName='" & pFieldName & "' and bm.BlockName='" & pBlockName & "'"

        'lsql = " Select bm.Status " & _
        '" from BlockMaster bm " & _
        '" inner join FieldMaster fm on bm.FieldID=fm.FieldID " & _
        '" where fm.EstateID=" & pEstateID & " and fm.FieldName='" & pFieldName & "' and bm.BlockName='" & pBlockName & "'"


        If dr.Read Then


            If Not IsDBNull(dr("blockstatus")) Then
                If dr.Item("blockstatus") = pAGMainstatus Then
                    FReturn = True
                Else
                    FReturn = False
                End If
            End If
        End If
        'lObjBM = THConn.ExecuteScalar(lConn, CommandType.Text, lsql)

        'If Not IsDBNull(lObjBM) Then
        '    BMS = CStr(lObjBM)
        'Else
        '    Msg = "Error while retrieving block status!"
        '    Return False
        'End If

        'If ldrAG("NewPlanted") = "Y" And BMS = "P" Then
        '    FReturn = True
        'End If

        'If ldrAG("RePlanted") = "Y" And BMS = "R" Then
        '    FReturn = True
        'End If

        'If ldrAG("Nursery") = "Y" And BMS = "Y" Then
        '    FReturn = True
        'End If

        'If ldrAG("Revenew") = "Y" And BMS = "M" Then
        '    FReturn = True
        'End If

        If Not FReturn Then Msg = "An expenditure type charge code does not match the block status!"

        Return FReturn

    End Function

    Public Function GetCoaSubTypeInd(ByVal EstateId As Long, ByVal AGGL As String, Optional ByRef strSubType As String = "N") As Boolean

        Dim dr As System.Data.SqlClient.SqlDataReader
        Dim dr1 As System.Data.SqlClient.SqlDataReader
        Dim lstr As String
        Dim lfRtn As Boolean
        'lenny change 02-10-2009
        ' lstr = "Select * from coa where EstateId = " & EstateId & " and AGGL='" & pbSetQuoteMarks(AGGL) & "'"

        'lstr = " Select m.status,isnull(c.subtype,'N')as subtype  from coa c " &
        '" inner join accagsub s on c.agsubid=s.agsubid " &
        '" inner join accagmain m on m.agmainid=s.agmainid " &
        '" where c.EstateId = " & EstateId & "  and c.AGGL='" & pbSetQuoteMarks(AGGL) & "'"

        lstr = " Select m.status,isnull(c.subtype,'N')as subtype  from coa c " &
        " inner join accagsub s on c.agsubid=s.agsubid " &
        " inner join accagmain m on m.agmainid=s.agmainid " &
        " where c.AGGL='" & pbSetQuoteMarks(AGGL) & "'"

        dr = MYConn.ExecuteReader(lConn, CommandType.Text, lstr)

        ' lstr = "select isnull(status,'N') as blockstatus from blockdetails where EstateId = " & EstateId & "  and Blockid='" & strBlockId & "'"

        ' dr1 = THConn.ExecuteReader(lConn, CommandType.Text, lstr)
        If (dr.HasRows = True) Then


            If dr.Read Then
                If Not IsDBNull(dr("Status")) Then
                    If (dr.Item("subtype") = "F") Then
                        'If (strBlockId = String.Empty) Then
                        '    lfRtn = False
                        '    Exit Function
                        'End If

                        If CType(dr.Item("Status"), String).Trim <> "A" Then
                            'If CType(dr1.Item("blockstatus"), String).Trim = CType(dr.Item("Status"), String).Trim Then
                            '    lfRtn = True
                            'Else
                            '    lfRtn = False
                            'End If
                            strSubType = CType(dr.Item("Status"), String).Trim
                            lfRtn = True
                        Else
                            lfRtn = False
                        End If
                    Else
                        lfRtn = False
                    End If

                Else
                    lfRtn = False
                End If
            Else
                lfRtn = False
            End If

        End If

        If Not dr.IsClosed Then dr.Close()
        Return lfRtn

    End Function

    Public Function pbSetQuoteMarks(ByVal asName As String) As String
        Dim I As Integer
        Dim sTemp As String
        Dim iLoop As Integer
        Dim sName As String
        sName = asName

        Do Until Len(Trim$(sName)) = 0
            If InStr(1, sName, "'") >= 1 Then
                sTemp = sTemp & (Mid$(sName, 1, InStr(1, sName, "'"))) & "'"
                sName = (Mid$(sName, InStr(1, sName, "'") + 1))
            Else
                sTemp = sTemp & sName
                sName = ""
            End If

        Loop

        pbSetQuoteMarks = sTemp



        'pbSetQuoteMarks = sTemp
    End Function

    'Public Overloads Function GetMonthYear(ByVal EstateID As Long, ByVal ActMyID As String, ByRef Amonth As String, ByRef Ayear As String, Optional ByRef Month As String = "") As Boolean
    Public Function GetMonthYear(ByVal EstateID As Long, ByVal ActMyID As String, ByRef Amonth As String, ByRef Ayear As String, Optional ByRef Month As String = "") As Boolean

        Dim lstr As String
        Dim sdr As System.Data.SqlClient.SqlDataReader
        Dim lflag As Boolean

        lstr = "select Amonth , Ayear from ActiveMonthYear where EstateID=" & EstateID & " and ActMthYearID='" & ActMyID & "'"

        sdr = MYConn.ExecuteReader(lConn, CommandType.Text, lstr)

        If sdr.Read Then

            If Not sdr.IsDBNull(0) And Not sdr.IsDBNull(1) Then

                Ayear = sdr("Ayear")

                If sdr("Amonth") = 1 Then
                    Amonth = "January"
                    Month = "01"
                ElseIf sdr("Amonth") = 2 Then
                    Amonth = "February"
                    Month = "02"
                ElseIf sdr("Amonth") = 3 Then
                    Amonth = "March"
                    Month = "03"
                ElseIf sdr("Amonth") = 4 Then
                    Amonth = "April"
                    Month = "04"
                ElseIf sdr("Amonth") = 5 Then
                    Amonth = "May"
                    Month = "05"
                ElseIf sdr("Amonth") = 6 Then
                    Amonth = "June"
                    Month = "06"
                ElseIf sdr("Amonth") = 7 Then
                    Amonth = "July"
                    Month = "07"
                ElseIf sdr("Amonth") = 8 Then
                    Amonth = "August"
                    Month = "08"
                ElseIf sdr("Amonth") = 9 Then
                    Amonth = "September"
                    Month = "09"
                ElseIf sdr("Amonth") = 10 Then
                    Amonth = "October"
                    Month = "10"
                ElseIf sdr("Amonth") = 11 Then
                    Amonth = "November"
                    Month = "11"
                ElseIf sdr("Amonth") = 12 Then
                    Amonth = "December"
                    Month = "12"
                End If

                lflag = True

            End If

        End If

        If Not sdr.IsClosed Then sdr.Close()

        Return lflag

    End Function
#End Region
End Module
