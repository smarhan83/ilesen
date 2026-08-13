
Imports System

Partial Class laporanpermohonan
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

    End Sub

    Protected Sub Page_PreRenderComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.PreRenderComplete

    End Sub

    Private Sub initPageName()
        '// get page name
        Dim menuName As String = GlobalClass.writeTitlePage(Request.QueryString("m_Id"), "")

        Dim idWindowTitle2 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle2"), HtmlGenericControl)
        Dim idWindowTitle3 As HtmlGenericControl = DirectCast(FormView1.FindControl("idWindowTitle3"), HtmlGenericControl)

        If menuName = "" Then
            menuName = "Laporan Permohonan"
        End If

        idWindowTitle.InnerText = menuName
        Try
            idWindowTitle2.InnerText = idWindowTitle2.InnerText & " " & menuName
        Catch ex As Exception

        End Try
        Try
            idWindowTitle3.InnerText = idWindowTitle3.InnerText & " " & menuName
        Catch ex As Exception

        End Try

    End Sub

    Private Sub btnReport_Click(sender As Object, e As EventArgs) Handles btnReport.Click

        Dim sql As String = ""
        Dim jenisLaporan = {"mpk_laporan_png", "mpk_laporan_btl", "mpk_laporan_ins", "mpk_laporan_spd", "mpk_laporan_pl", "mpk_laporan_anj", "mpk_laporan_pjj"}

        Try
            sql = "SELECT a.Permohonan_ID, a.TarikhMohon, a.CreatedDt, CAST(a.NamaSyarikat AS varchar(200)) AS NamaSyarikat, a.NoPendaftaran, a.NoAkaun, a.AlamatPremis, a.JenisPerniagaan, a.PemilikBaru, " &
            "a.AlamatBaru, a.JenisPerniagaanBaru, a.NamaBaruSyarikat, a.BillboardLokasi, a.LokasiPasar1, a.LokasiPasar2, a.LokasiPasar3, a.JenisPasar, a.JenisPerniagaanPasar, a.JumlahPetak, a.AnjingAlamat, " &
            "a.AnjingJenisMohon, a.AnjingJenisPremis, a.AlamatPenjajaan, a.JenisPerniagaanPenjaja, a.TarikhBatal, a.PenganjurEkspo, a.NamaEkspo, a.LokasiEkspo, a.NoTelEkspo, a.TarikhEkspo1, a.TarikhEkspo2, " &
            "a.KontraktorIklan, a.NoTelKontraktor, a.UkuranBanting, a.BilBanting, a.TarikhBanting1, a.TarikhBanting2, a.NoResitBanting, a.NoSiriStiker, a.TarikhBanting3, " &
            "a.MasaEkspo1, a.MasaEkspo2, a.Rujukan, a.NoAkaunCukai, a.IsBatal, a.JenisLesenDescList, a.JenisLesenIdList, a.SaizIklanList, a.CahayaIklanList, a.UnitIklanList, a.LokasiList, a.BakaAnjingList, a.AnjingJantanList, " &
            "a.AnjingBetinaList, a.AnjingJantanMandulList, a.AnjingBetinaMandulList, e.JabatanAgensi_Address, e.JabatanAgensi_Kepada, b.Pemohon_Name, b.Pemohon_ICNo, b.Pemohon_PassportNo, b.Pemohon_Address, " &
            "b.Pemohon_Email, b.Pemohon_MobileNo, b.Pemohon_TelNo, g.Users_Fullname, g.Users_Signature " &
            "FROM LESEN_Permohonan a INNER JOIN LESEN_Pemohon b ON a.Permohonan_PemohonID = b.Pemohon_ID INNER JOIN LESEN_PermohonanAgensi d ON a.Permohonan_ID = d.Permohonan_ID " &
            "INNER JOIN LESEN_JabatanAgensi e ON d.JabatanAgensi_ID = e.JabatanAgensi_ID " &
            "LEFT JOIN TBL_USERS g ON g.Users_Id = (case when e.JabatanAgensi_Type = 'J' then a.TandatanganMohonUlasanId when e.JabatanAgensi_Type = 'L' then a.TandatanganMohonUlasanLuarId end) " &
            "WHERE a.Permohonan_ID=" & 0 & " AND e.JabatanAgensi_ID = " & 0

            Dim ReportVar As String = jenisLaporan(ddlReport.SelectedValue - 1)

            Dim pobjData(0, 1)
            Dim lStrReportName = ReportVar + ".rpt"

            'Dim sessionActiveMonthYearID As String = GlobalClass.getIDActiveMonthByEstateID(Session.Item("sessionEstateCode"), DirectCast(FormView1.FindControl("cmbYear"), DropDownList).SelectedValue, DirectCast(FormView1.FindControl("cmbMonth"), DropDownList).SelectedValue)

            pobjData(0, 0) = "paraSQL" : pobjData(0, 1) = sql

            Session.Item("ReportName" + ReportVar) = lStrReportName
            Session.Item("pobjData" + ReportVar) = pobjData
            Session.Item("pathUrl" + ReportVar) = "~/lesen/report/laporan"

            Session.Item("reportPrintType") = "pdf"
            ScriptManager.RegisterClientScriptBlock(Me.Page, Me.[GetType](), ReportVar, "window.open('../ReportViewer.aspx?name=" + ReportVar + "', '_blank', '');", True)

        Catch ex As Exception

            MessageBox(ex.Message, Me)

        End Try

    End Sub

End Class
