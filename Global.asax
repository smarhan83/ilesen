<%@ Application Language="VB" %>
<%@ Import Namespace="System.Web.Optimization" %>
<%@ Import Namespace="System.Web.Routing" %>

<script runat="server">

    Sub Application_Start(sender As Object, e As EventArgs)
        RouteConfig.RegisterRoutes(RouteTable.Routes)
        RegisterRoute(System.Web.Routing.RouteTable.Routes)
        BundleConfig.RegisterBundles(BundleTable.Bundles)
    End Sub

    Public Shared Sub RegisterRoute(ByVal routes As System.Web.Routing.RouteCollection)


        System.Web.Routing.RouteTable.Routes.MapPageRoute("Reset Password", "ResetPassword/{UID}", "~/resetnow.aspx")

    End Sub
</script>