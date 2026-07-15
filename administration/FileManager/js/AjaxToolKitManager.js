
function showImgManager(index) {
    $("#divImgManager" + index).html("&nbsp;&nbsp;image url : <input style='width:200px' id='txtImgurl" + index + "' type='text' /> &nbsp;&nbsp; <a onclick='openFileManager(" + index + ");' href='javascript:;'  border='0' >Browse File</a> &nbsp;&nbsp; <a onclick='InsertImage(" + index + ");' href='javascript:;'>insert image</a> <a onclick='hideImgManager(" + index + ");' style='float:right;' border='0' href='javascript:;'><img  border='0' src='FileManager/icons/gtk_close.png' /></a>");
    $("#divImgManager" + index).show();
}

function hideImgManager(index) {
    $("#divImgManager" + index).hide();
}

function showFileManager(index) {
    $("#divImgManager" + index).html("&nbsp;&nbsp;File url : <input style='width:200px' id='txtImgurl" + index + "' type='text' /> &nbsp;&nbsp; Link Title : &nbsp;&nbsp; <input style='width:200px' id='txtlinktitle" + index + "' type='text' /> <a onclick='openFileManager();' border='0' href='javascript:;' >Browse File</a> &nbsp;&nbsp; <a onclick='InsertFile(" + index + ");' href='javascript:;'>insert file</a> <a onclick='hideImgManager(" + index + ");' style='float:right;' border='0' href='javascript:;'><img  border='0' src='FileManager/icons/gtk_close.png' /></a>");
    $("#divImgManager" + index).show();
}



function InsertFile(index) {

    var ImgURL = $("#txtImgurl" + index).val();
    var LinkTitle = $("#txtlinktitle" + index).val();
    var EditFrame = $(".ajax__htmleditor_editor_editpanel div iframe").eq(index*2).attr("id");
    var Selected = "";

    try {

        eval("Selected = " + EditFrame + ".document.selection.createRange().text;");
    }
    catch (e) {
        eval("Selected = " + EditFrame + ".getSelection();");
    }
    eval(EditFrame + ".focus()");
    if (Selected != "") {
        eval(EditFrame + ".document.execCommand('CreateLink', false, '" + ImgURL + "')");
    }
    else {
        try {

            eval(EditFrame + ".document.selection.createRange().pasteHTML('<a href=" + ImgURL + ">" + LinkTitle + "</a>')");
        }
        catch (e) {
            eval("var range = " + EditFrame + ".getSelection().getRangeAt(0); range.deleteContents(); var NewLink = document.createElement('a'); NewLink.href='" + ImgURL + "'; NewLink.innerHTML ='" + LinkTitle + "'; range.insertNode(NewLink);");
        }
    }
    eval(EditFrame + ".focus()");
    hideImgManager();
    SaveUpdate(EditFrame);
}


function InsertImage(index) {
    var ImgURL = $("#txtImgurl" + index).val();    
    
    // every Editor Have 2 Ifram One For Edit and other for view
    var indexAt = index * 2;    
    var EditFrame = $(".ajax__htmleditor_editor_editpanel div iframe").eq(indexAt).attr("id");
    
  
    eval(EditFrame + ".focus()");
    eval(EditFrame + ".document.execCommand('InsertImage', false, '" + ImgURL + "')");
    hideImgManager();
    eval(EditFrame + ".focus()");
    SaveUpdate(EditFrame);
}



function SaveUpdate(framName) {
    var ContentVal = "";
    eval("ContentVal=" + framName + ".document.body.innerHTML");
    framName = framName.substring(0, framName.length - 6);
    framName = "_content_" + framName;
    //alert(framName);
    var hiddenElementsArray = $("[id^=" + framName + "]").val(ContentVal);
    //alert(hiddenElementsArray.val());
}

