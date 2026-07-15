Imports System.Collections.Generic
Imports System.Web
Imports System.Web.Routing
Imports Microsoft.AspNet.FriendlyUrls

Public Module RouteConfig
    Public Sub RegisterRoutes(routes As RouteCollection)



        Dim settings = New FriendlyUrlSettings()
        'settings.AutoRedirectMode = RedirectMode.Permanent

        routes.EnableFriendlyUrls(settings)

        routes.Ignore("{*allaspx}", New With {Key .allaspx = ".*(CrystalImageHandler).*"})


    End Sub
End Module
