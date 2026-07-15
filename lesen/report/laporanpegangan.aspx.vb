
Partial Class laporanpegangan
	Inherits System.Web.UI.Page

	Private Sub ButtonSubmit_Click(sender As Object, e As EventArgs) Handles ButtonSubmit.Click

		If DropDownListFieldStatus.SelectedValue = "0" Then
			Return
		End If

		Dim sql As String = ""
		Dim ReportVar As String = "laporanpegangan"

		Try
			sql = "SELECT a.Permohonan_ID, a.Is24Jam, a.Rujukan, b.Pemohon_Name, b.Pemohon_MobileNo, ISNULL(c.NamaBaruSyarikat, c.NamaSyarikat) AS NamaSyarikat, c.NoPendaftaran, b.Pemohon_Address, ISNULL(c.AlamatBaru, c.AlamatPremis) AS AlamatPremis, 
c.AnjingAlamat, c.AlamatPenjajaan, c.LokasiPasar1, c.LokasiPasar2, c.LokasiPasar3, e.name AS Bangsa, d.JenisLesen_Description, a.TarikhMohon, 

(SELECT a1.CreatedDt FROM LESEN_ApprovalList a1 WHERE a1.Permohonan_ID = a.Permohonan_ID AND ApprStatusID = 10) AS TarikhLulus,

(SELECT ISNULL(SUM(KadarBayaran_Amount),0) FROM LESEN_KadarBayaran a1 WHERE a1.KadarBayaran_PermohonanID = a.Permohonan_ID AND a1.IsSelect = 1 AND a1.KadarBayaran_Desc NOT LIKE '%iklan%') AS KadarLesen, 
(SELECT ISNULL(SUM(KadarBayaran_Amount),0) FROM LESEN_KadarBayaran a1 WHERE a1.KadarBayaran_PermohonanID = a.Permohonan_ID AND a1.IsSelect = 1 AND a1.KadarBayaran_Desc LIKE '%iklan%') AS KadarIklan

FROM LESEN_Permohonan a 
INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID
INNER JOIN LESEN_PermohonanPembetulan c ON a.Permohonan_ID = c.Permohonan_ID 
INNER JOIN LESEN_JenisLesen d ON a.JenisLesen_ID = d.JenisLesen_ID
INNER JOIN TBL_LOOKUPS e ON e.id = b.Pemohon_Race
WHERE a.IsBatal = 0 AND a.TarikhMohon BETWEEN '@entrydatea' AND '@entrydateb' 
ORDER BY a.TarikhMohon ASC"

			sql = sql.Replace("@entrydatea", TB_Date1.Text)
			sql = sql.Replace("@entrydateb", TB_Date2.Text)

			Label1.Text = ""

			Dim pobjData(3, 1)
			Dim lStrReportName = ReportVar + ".rpt"

			pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
			pobjData(1, 0) = "paraType" : pobjData(1, 1) = DropDownListFieldStatus.SelectedItem.Text
			pobjData(2, 0) = "paraDateA" : pobjData(2, 1) = TB_Date1.Text
			pobjData(3, 0) = "paraDateB" : pobjData(3, 1) = TB_Date2.Text

			Session.Item("ReportName" + ReportVar) = lStrReportName
			Session.Item("pobjData" + ReportVar) = pobjData
			Session.Item("pathUrl" + ReportVar) = "~/lesen/report/extras"

			Session.Item("reportPrintType") = "pdf"
			ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('/ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)

		Catch ex As Exception
			Label1.Text = ex.Message
		End Try

	End Sub

End Class
