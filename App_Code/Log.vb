Imports System
Imports System.IO

Public Class Log
    Public Shared Sub WriteLog(ByVal Ex__1 As Exception, ByVal Page As String, ByVal Method As String)
        Try
            Dim d As DateTime = DateTime.Now
            Dim LogFileName As String = "ErrorLog_" & d.Year.ToString & "_" + d.Month.ToString & "_" + d.Day.ToString & ".txt"
            Dim ApplicationPath As String = AppDomain.CurrentDomain.BaseDirectory.Trim() & "Logs\"

            If Not Directory.Exists(ApplicationPath) Then
                Directory.CreateDirectory(ApplicationPath)
            End If

            If ApplicationPath.Length = 0 Then
                Return
            End If

            Using sw As StreamWriter = New StreamWriter(ApplicationPath & LogFileName, True)
                sw.WriteLine("Exception Message           : " & Ex__1.Message)
                sw.WriteLine("Details                     : " & Ex__1.ToString())
                sw.WriteLine("Exception Source            : " & Ex__1.Source)
                sw.WriteLine("Time of Occurence           : " & d.ToString())
                sw.WriteLine("Page                        : " & Page)
                sw.WriteLine("Method                      : " & Method)
                sw.WriteLine("-------------------------------------------------------------------------------")
            End Using

        Catch ex As Exception
        End Try
    End Sub

    Public Shared Function GetMethodName(<System.Runtime.CompilerServices.CallerMemberName>
    Optional memberName As String = Nothing) As String

        Return memberName

    End Function
End Class
