<%@ Page Language="VB" Inherits="DotNetNuke.Framework.PageBase" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Text" %>

<%@ Import Namespace="DotNetNuke.Common.Utilities" %>
<%@ Import Namespace="DotNetNuke.Entities.Portals" %>
<%@ Import Namespace="DotNetNuke.Entities.Users" %>
<%@ Import Namespace="DotNetNuke.Security.Roles" %>
<script runat="server">
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If IsPostBack = False Then
            Dim strUserName As String = Request.QueryString("username")

            If strUserName <> "" Then
                Dim strPortalID As String = Request.QueryString("portalid")
                Dim intPortalID As Integer = Null.NullInteger

                If strPortalID <> "" Then
                    intPortalID = CInt(strPortalID)
                Else
                    intPortalID = PortalSettings.PortalId
                End If

                Dim objUser As UserInfo = UserController.GetUserByName(intPortalID, strUserName)

                If Null.IsNull(objUser) = False Then
                    Dim strPassword As String = UserPassword(objUser)
                    divUser.Visible = True
                    lblUser.Text = "User: " & strUserName & " - Password: " & strPassword
                End If
            End If

            lblPortal.Text = String.Format("Current portal: {0} - PortalID: {1}<br /><br />", PortalSettings.PortalName, PortalSettings.PortalId)
            ' Get SuperUser accounts
            Dim arSuperUsers As ArrayList = UserController.GetUsers(False, True, Null.NullInteger)
            gvSuperUsers.DataSource = arSuperUsers
            gvSuperUsers.DataBind()
            ' Get Portals
            Dim objPortalController As New PortalController
            ddlPortals.DataTextField = "PortalName"
            ddlPortals.DataValueField = "PortalID"
            ddlPortals.DataSource = objPortalController.GetPortals()
            ddlPortals.DataBind()
            ' Display Portal Alias for the first portal
            ddlPortals.SelectedIndex = 0
            PortalChanged(CInt(ddlPortals.SelectedValue))
        End If
    End Sub

    Protected Sub ddlPortals_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddlPortals.SelectedIndexChanged
        Dim intPortalId As Integer = CInt(ddlPortals.SelectedValue)
        ' Display Portal Alias for the selected portal
        PortalChanged(intPortalId)
    End Sub

    Protected Sub btnGetRoles_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGetRoles.Click
        Dim intPortalId As Integer = CInt(ddlPortals.SelectedValue)
        Dim objRoleController As New RoleController
        Dim arPortalRoles As IList(Of RoleInfo) = objRoleController.GetRoles(intPortalId)

        ' Display Portal's Roles if any
        If arPortalRoles.Count > 0 Then
            lbRoles.DataTextField = "RoleName"
            lbRoles.DataValueField = "RoleID"
            lbRoles.DataSource = arPortalRoles
            lbRoles.DataBind()
            lbRoles.SelectedIndex = 0
            divRoles.Visible = True
        End If
        divUsers.Visible = False
    End Sub

    Protected Sub lbRoles_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbRoles.SelectedIndexChanged
        divUsers.Visible = False
    End Sub

    Protected Sub btnGetUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnGetUsers.Click
        Dim objRoleController As New RoleController
        Dim intPortalId As Integer = CInt(ddlPortals.SelectedValue)
        Dim intRoleId As Integer = CInt(lbRoles.SelectedValue)
        Dim strRole As String = objRoleController.GetRoleById(intPortalId, intRoleId).RoleName
        Dim arUsersRole As IList(Of UserInfo) = objRoleController.GetUsersByRole(intPortalId, strRole)

        ' Display User Accounts for the selected role
        If arUsersRole.Count > 0 Then
            gvUsers.Caption = String.Format("{0} Accounts", strRole)
            gvUsers.DataSource = arUsersRole
            gvUsers.DataBind()
            divUsers.Visible = True
        End If
    End Sub

    Protected Function UserPassword(ByVal User As UserInfo) As String
        ' Decrypt Password
        Try
            UserController.GetPassword(User, User.Membership.PasswordAnswer)
        Catch ex As Exception
            User.Membership.Password = "Error: " & ex.Message
        End Try
        Return User.Membership.Password
    End Function

    Private Sub PortalChanged(ByVal PortalId As Integer)
        Dim objPortalAliasController As New PortalAliasController

        ' Display Portal Alias for the selected portal
        lblAlias.Text = GetAlias("PortalID: " & PortalId.ToString() & " - Portal Alias List<br /><br />", PortalAliasController.Instance.GetPortalAliasesByPortalId(PortalId))
        divAlias.Visible = True
        divRoles.Visible = False
    End Sub

    Private Function GetAlias(ByVal Title As String, ByVal PortalAlias As IEnumerable(Of PortalAliasInfo)) As String
        Dim strList As String = ""

        For Each objPortalAlias As PortalAliasInfo In PortalAlias
            strList &= String.Format("Alias: {0}<br />", objPortalAlias.HTTPAlias)
        Next
        Return Title & strList
    End Function
</script>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
    <head>
        <title>SuperUsers and Admins Instantly Decrypted</title>
    </head>
    <body>
        <form id="frmSAID" runat="server">
            <div style="margin:20px 5px">
                <asp:Label ID="lblPortal" runat="server"></asp:Label>
                <asp:GridView ID="gvSuperUsers" runat="server" AutoGenerateColumns="False" Caption="Super Users Accounts">
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="UserID" />
                        <asp:BoundField DataField="UserName" HeaderText="UserName" />
                        <asp:TemplateField>
                            <HeaderTemplate>Password</HeaderTemplate>
                            <ItemTemplate>
                                <%#UserPassword(CType(Container.DataItem, UserInfo))%>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="FirstName" HeaderText="FirstName" />
                        <asp:BoundField DataField="LastName" HeaderText="LastName" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                    </Columns>
                </asp:GridView>
            </div>
            <div id="divUser" runat="server" visible="false" style="margin:20px 5px">
                <asp:Label ID="lblUser" runat="server"></asp:Label>
            </div>
            <div style="margin:20px 5px">
                Portals:&nbsp;<asp:DropDownList ID="ddlPortals" runat="server" AutoPostBack="True"></asp:DropDownList>
            </div>
            <div id="divAlias" runat="server" visible="false" style="margin:20px 5px">
                <asp:Label ID="lblAlias" runat="server"></asp:Label>
            </div>
            <asp:Button ID="btnGetRoles" runat="server" Text="Get Roles" />
            <div id="divRoles" runat="server" visible="false" style="margin:20px 5px">
                <asp:ListBox ID="lbRoles" runat="server" AutoPostBack="True"></asp:ListBox>
                <asp:Button ID="btnGetUsers" runat="server" Text="Get Users" />
                <br />
                <div id="divUsers" runat="server" visible="false" style="margin:20px 5px">
                    <asp:Label ID="lblUsers" runat="server"></asp:Label>
                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="UserID" HeaderText="UserID" />
                            <asp:BoundField DataField="UserName" HeaderText="UserName" />
                            <asp:TemplateField>
                                <HeaderTemplate>Password</HeaderTemplate>
                                <ItemTemplate>
                                    <%#UserPassword(CType(Container.DataItem, UserInfo))%>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="FirstName" HeaderText="FirstName" />
                            <asp:BoundField DataField="LastName" HeaderText="LastName" />
                            <asp:BoundField DataField="Email" HeaderText="Email" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </form>
    </body>
</html>
