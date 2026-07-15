
Imports Newtonsoft.Json
Imports System.Net
Imports System.Net.Http
Imports System.Net.WebRequestMethods
Imports System.Security.Policy
Imports System.Threading.Tasks
Imports System.Web.Script.Serialization

Partial Class updatePIP
    Inherits System.Web.UI.Page

    Private Sub updatePIP_Load(sender As Object, e As EventArgs) Handles Me.Load
        ''Dim webClient As New WebClient()
        'Dim resByte As Byte()
        'Dim resString As String
        'Dim reqString() As Byte

        'Dim checkResult As String

        'Dim webClient As WebClient = New WebClient()
        'Dim checkResult As String = webClient.DownloadString("https://api.ipify.org")

        'Try
        '    Dim _httpClient As HttpClient = New HttpClient()
        '    Dim t As Task(Of String) = _httpClient.GetStringAsync("https://api.ipify.org")
        '    checkResult = t.Result

        'Finally
        'End Try

        'Dim _httpClient As HttpClient = New HttpClient()
        'Dim json = _httpClient.GetStringAsync("https://api.ipify.org")

        'Dim jss As New JavaScriptSerializer()
        'jss.MaxJsonLength = Int32.MaxValue
        'Dim dict As Dictionary(Of String, String) = jss.Deserialize(Of Dictionary(Of String, String))(JsonConvert.SerializeObject(json, Formatting.Indented))



        'Try
        '    WebClient.Headers("content-type") = "application/json"
        '    reqString = Encoding.Default.GetBytes(" {""ip"" : """ & checkResult & """} ")
        '    resByte = WebClient.UploadData("https://dsc.johorplantations.com/API/updatePIP.aspx", "post", reqString)
        '    resString = Encoding.Default.GetString(resByte)
        '    lblMsg.Text = resString
        '    WebClient.Dispose()
        'Catch ex As Exception
        '    lblMsg.Text = ex.Message
        'End Try

        If hdnIP.Value <> "" Then

            'updatePIP()
        End If

        If IsPostBack Then
         
        End If
    End Sub

    Private Sub updatePIP()
        Dim resByte As Byte()
        Dim resString As String
        Dim reqString() As Byte
        Dim webClient As WebClient = New WebClient()

        hdnDone.Value = "Y"

        'MsgBox("")

        Try
            webClient.Headers("content-type") = "application/json"
            reqString = Encoding.Default.GetBytes(" {""ip"" : """ & hdnIP.Value & """} ")
            'resByte = WebClient.UploadData("https://dsc.johorplantations.com/API/updatePIP.aspx", "post", reqString)
            resByte = webClient.UploadData("https://103.106.7.170/webpip/default.aspx", "post", reqString)
            resString = Encoding.Default.GetString(resByte)
            lblMsg.Text = resString
            webClient.Dispose()
        Catch ex As Exception
            lblMsg.Text = ex.Message
        End Try

        ClientScript.RegisterStartupScript(GetType(Page), "closePage", "<script type='text/JavaScript'>window.close();</script>")
    End Sub

    'Protected Sub btnIP_Click(sender As Object, e As EventArgs) Handles btnIP.Click

    'End Sub
End Class
