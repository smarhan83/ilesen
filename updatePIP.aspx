<%@ Page Language="VB" AutoEventWireup="false" CodeFile="updatePIP.aspx.vb" Inherits="updatePIP" %>

<!DOCTYPE html>
<meta http-equiv="refresh" content="300" />
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Label ID="lblMsg" runat="server" Text=""></asp:Label>
            <asp:HiddenField ID="hdnIP" runat="server" />
            <asp:HiddenField ID="hdnDone" runat="server" />
            <%--<asp:Button ID="btnIP" runat="server" Text="Button" />--%>

        </div>
    </form>

    <script type="application/javascript">
    function getIP(json) {
    //document.write("My public IP address is: ", json.ip);

        document.getElementById('hdnIP').value = json.ip;

        if (document.getElementById('hdnDone').value == "")
        document.forms[0].submit(); 

        //__doPostBack('btnIP', '');

        //alert(json.ip);

        //var button = document.getElementById('btnIP');

        //if(document.getElementById('hdnDone').value == "")
        //    button.click();

        //exit;

        //var xhr = new XMLHttpRequest();
        //var url = "https://dsc.johorplantations.com/API/updatePIP.aspx";
        //xhr.open("POST", url, true);
        //xhr.setRequestHeader("Content-Type", "application/json");
        //xhr.onreadystatechange = function () {
        //    if (xhr.readyState === 4 && xhr.status === 200) {
        //        var json = JSON.parse(xhr.responseText);
        //        //console.log(json.email + ", " + json.password);
        //    }
        //};
        //var data = JSON.stringify({ "ip": json.ip });
        //xhr.send(data);

        

        }

        function CloseWindow() {
            window.close();
        }
    </script>

    <script type="application/javascript" src="https://api.ipify.org?format=jsonp&callback=getIP"></script>
</body>
</html>
