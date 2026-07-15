<%@ Page Language="VB" AutoEventWireup="false" CodeFile="wvchatbot.aspx.vb" Inherits="wvchatbot" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/Scripts/jquery-3.6.0.min.js" type="text/javascript"></script>
    <style>


        #bot-input-grid {
            /*display : none !important;*/
        }
        #bot-message-grid {
            overflow-y: scroll !important;
            overflow-x: hidden !important;
            
        }

        .message.user {
        background: #F79219 !important;
        }
		
		.message {
			font-size: 13px !important;
		}

        #bot-container{
	        z-index : 9999;
            width: 99% !important;
            right : 2px !important;
            bottom : 0px !important;
            height : 95% !important;
	    }

        #bot-launch-button{
            display : none !important;
        }

        .bot-frame-hidden{
            display : inline-block !important;
            opacity : inherit !important;
        }

        .bot-title-close-button {
            z-index : 2;
        }
		
		.bot-title-avatar{
		    background-size: 75px 70px !important;
			width: 75px !important;
			height: 70px !important;
		}

        .message.bot .message-avatar {
            width: 50px;
            height: 50px;
        }
		
		.quick-reply {
			border: 1px solid #f79219 !important;
			background: #f79219 !important;
		}

        #bot-launch-button {
            background: #f79219 !important;
            border: 2px #f79219 solid !important;
        }

        #bot-launch-button:hover {
            color: #fff !important;
            background: #faa834 !important;
        }

        #overlay {
            position: fixed;
            z-index: 99;
            top: 0px;
            left: 0px;
            background-color: #f8f8f8;
            width: 100%;
            height: 100%;
            filter: Alpha(Opacity=90);
            opacity: 0.95;
        }

        </style>

</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    </div>

                <!-- Chatbot Widget -->
        <script type="text/javascript">
                (function () {
                    var scriptElement = document.createElement('script');
                    scriptElement.type = 'text/javascript';
                    scriptElement.async = false;
                    scriptElement.src = '/chatbot/BotService.aspx?Get=Script';
                    (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(scriptElement);

 
                    


                })(
                    
            );


            window.onload = function () {
                document.getElementById("bot-launch-button").innerHTML = "Start";

                //document.getElementById('bot-launch-button').onclick = function () {
                //    alert(document.getElementById('bot-input-grid').style.display);
                //    if (document.getElementById('bot-input-grid').style.display == "none")
                //    document.getElementById('bot-input-grid').style.display = "";
                //}
                $("#bot-launch-button").click();

               
            };



            

            
        </script>

    </form>
</body>
</html>
