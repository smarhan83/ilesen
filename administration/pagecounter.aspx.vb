
Partial Class html_administration_pagecounter
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        idPageSummary.InnerHtml = GlobalClass.getWebCounter()
    End Sub
End Class
