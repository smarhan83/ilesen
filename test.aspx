<%@ Page Language="VB" AutoEventWireup="false" CodeFile="test.aspx.vb" Inherits="_test" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <asp:FileUpload ID="FU_Lampiran1" runat="server" CssClass="form-control" accept="application/pdf" />
	<asp:FileUpload ID="FU_Lampiran2" runat="server" CssClass="form-control" accept="image/*" />
    </div>
    </form>
</body>
</html>
