Imports System
Imports System.Web
Imports Syn.Bot.Channels.Testing
Imports Syn.Bot.Channels.Widget
Imports Syn.Bot.Oscova

Partial Class chatbot_BotService
    Inherits System.Web.UI.Page
    Private Shared ReadOnly Property WidgetChannel As WidgetChannel
    Private Shared ReadOnly Property Bot As OscovaBot

    Shared Sub New()
        Bot = New OscovaBot()
        Bot.ImportWorkspace("D:/inetpub/helpDeskKulim/chatbot/botresource/ChatBot_QnA_v0.91.json") 'custom Q&A
        WidgetChannel = New WidgetChannel(Bot)
        'Bot.Dialogs.Add(New ChannelTestDialog(Bot))
        Bot.Trainer.StartTraining()
        Dim websiteUrl = HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority)
        WidgetChannel.ServiceUrl = websiteUrl & "/chatbot/BotService.aspx"
        WidgetChannel.ResourceUrl = websiteUrl & "/chatbot/botresource"
        WidgetChannel.WidgetTitle = "Hana"
        WidgetChannel.LaunchButtonText = "Need Help?"
        WidgetChannel.InputPlaceHolder = "Type -help- to start..."
    End Sub

    Private Sub BotService_Load(sender As Object, e As EventArgs) Handles Me.Load

        WidgetChannel.Process(Request, Response)
    End Sub

End Class
