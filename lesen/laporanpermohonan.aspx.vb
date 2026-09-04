
Partial Class laporanpermohonan
    Inherits System.Web.UI.Page

    Private Sub ButtonSubmit_Click(sender As Object, e As EventArgs) Handles ButtonSubmit.Click

        If ddlReport.SelectedValue = "0" Then
            Return
        End If

        Dim sql As String = ""
        Dim sqlwhere As String = ""
        Dim jenisLaporan = {"laporanpermohonan_png", "laporanpermohonan_btl", "laporanpermohonan_ins", "laporanpermohonan_spd", "laporanpermohonan_pl", "laporanpermohonan_anj", "laporanpermohonan_pjj"}

        Try
            If ddlReport.SelectedValue = "1" Then

                sqlwhere = "a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%PERNIAGAAN%' AND"

            ElseIf ddlReport.SelectedValue = "2" Then

                sqlwhere = "a.IsBatal = 0 AND"

            ElseIf ddlReport.SelectedValue = "5" Then

                sqlwhere = "a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%PASAR%' AND"

            ElseIf ddlReport.SelectedValue = "6" Then

                sqlwhere = "a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%ANJING%' AND"

            ElseIf ddlReport.SelectedValue = "7" Then

                sqlwhere = "a.IsBatal = 0 AND a.JenisLesenDescList LIKE '%PENJAJA%' AND"

            End If

            sql = "SELECT a.Permohonan_ID, a.StatusID, a.Is24Jam, a.Rujukan, b.Pemohon_Name, b.Pemohon_MobileNo, ISNULL(a.NamaBaruSyarikat, a.NamaSyarikat) AS NamaSyarikat, 
            ISNULL(a.JenisPerniagaanBaru, a.JenisPerniagaan) AS JenisPerniagaan, a.JenisPerniagaanPasar, a.JenisPerniagaanPenjaja, a.JumlahPetak, 
            b.Pemohon_Address, ISNULL(a.AlamatBaru, a.AlamatPremis) AS AlamatPremis, a.BakaAnjingList, a.AnjingJantanList, a.AnjingBetinaList,
            a.AnjingJantanMandulList, a.AnjingBetinaMandulList, c.name AS AnjingJenisPremis, a.AnjingAlamat, a.AlamatPenjajaan, 
            a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisLesenDescList, a.TarikhMohon, 

            (SELECT TOP(1) a1.CreatedDt FROM LESEN_ApprovalList a1 WHERE a1.Permohonan_ID = a.Permohonan_ID AND (
            ApprStatusID = 10 OR ApprStatusID = 6 OR ApprStatusID = 9) ORDER BY a1.CreatedDt DESC) AS TarikhLulus, 

            ISNULL(kb.KadarLesen, 0) AS KadarLesen, ISNULL(kb.KadarIklan, 0) AS KadarIklan, ISNULL(kb.KadarPatil, 0) AS KadarPatil, ISNULL(kb.KadarLencana, 0) AS KadarLencana, 
            ISNULL(kb.KadarJantan, 0) AS KadarJantan, ISNULL(kb.KadarBetina, 0) AS KadarBetina, ISNULL(kb.KadarMandul, 0) AS KadarMandul

            FROM LESEN_Permohonan a 
            INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID 
            LEFT JOIN TBL_LOOKUPS c ON a.AnjingJenisMohon = c.id 
            LEFT JOIN (
                SELECT 
                    KadarBayaran_PermohonanID,
                    SUM(CASE WHEN KadarBayaran_Desc NOT LIKE '%iklan%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarLesen,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%iklan%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarIklan,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%patil%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarPatil,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%lencana%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarLencana,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%jantan%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarJantan,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%betina%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarBetina,
                    SUM(CASE WHEN KadarBayaran_Desc LIKE '%mandul%' THEN KadarBayaran_Amount ELSE 0 END) AS KadarMandul 
                FROM LESEN_KadarBayaran 
                WHERE IsSelect = 1 
                GROUP BY KadarBayaran_PermohonanID 
            ) kb ON kb.KadarBayaran_PermohonanID = a.Permohonan_ID 
            WHERE " & sqlwhere & " a.TarikhMohon BETWEEN '@entrydatea' AND '@entrydateb' 
            ORDER BY a.TarikhMohon ASC"

            sql = sql.Replace("@entrydatea", TB_Date1.Text)
            sql = sql.Replace("@entrydateb", TB_Date2.Text)

            Label1.Text = ""

            Dim ReportVar As String = jenisLaporan(ddlReport.SelectedValue - 1)

            Dim pobjData(3, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql
            pobjData(1, 0) = "paraType" : pobjData(1, 1) = ddlReport.SelectedItem.Text
            pobjData(2, 0) = "paraDateA" : pobjData(2, 1) = TB_Date1.Text
            pobjData(3, 0) = "paraDateB" : pobjData(3, 1) = TB_Date2.Text

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/extras"

            Session.Item("reportPrintType") = "pdf"
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)

        Catch ex As Exception
            Label1.Text = ex.Message
        End Try

    End Sub

End Class
