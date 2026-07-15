Public Class PPSBSecurity

    Private maxTime As Integer = 1440 '60

    Public Function validateKey(EstateID As Integer, sKey As String) As Boolean
        Dim Result As Boolean = False

        Try
            '## Hari Raya exception ##
            'If Now.Date.ToString("yyyy/MM/dd").Equals("2014/07/27") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/07/28") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/07/29") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/07/30") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/07/31") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/08/01") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/08/02") Or _
            '    Now.Date.ToString("yyyy/MM/dd").Equals("2014/08/03") Then
            '    Return True
            'End If

            Dim keyMinute As Double = extractKey2Minute(EstateID, sKey)
            Dim curMinute As Double = getMinutes(Date.Now)

            If (curMinute - keyMinute > maxTime) Then
                Result = False
            Else
                Result = True
            End If
        Catch ex As Exception
            Return Result
        End Try

        Return Result
    End Function

    Public Function generateKey(EstateID As Integer) As String
        Dim sKey As String
        Dim sKeyMinute As String
        Dim sKeyEstateID As String

        Dim curDate As Date
        Dim curMinutes As Double
        curDate = Date.Now
        curMinutes = getMinutes(curDate)

        sKeyMinute = Hex(curMinutes)
        sKeyEstateID = Hex(EstateID)

        sKey = sKeyEstateID & sKeyMinute

        Return sKey
    End Function

    Private Function extractKey2Minute(EstateID As Integer, sKey As String) As Double
        Dim valMinute As Double
        Dim sKeyMinute As String
        Dim sKeyEstateID As String
        Dim lenHexEstateID As Integer

        Try
            sKeyEstateID = Hex(EstateID)
            lenHexEstateID = sKeyEstateID.Length

            If (sKey.Substring(0, lenHexEstateID) <> sKeyEstateID) Then
                Throw New Exception
            End If
            sKeyMinute = sKey.Substring(lenHexEstateID)
            valMinute = CDbl("&H" & sKeyMinute)
        Catch ex As Exception
            Throw
        End Try

        Return valMinute
    End Function

    Private Function getMinutes(dt As Date) As Double
        Dim noOfMinutes As Integer
        Dim startDate As New DateTime(2013, 1, 1)

        noOfMinutes = DateDiff("n", startDate, dt)
        Return noOfMinutes
    End Function
End Class
