using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace WebApplication3.Pages.UserManagement
{
    public partial class Role : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                
            }
            if (Session["UserId"] == null)
            {
                // No active session → send to login
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }
        }

        /// <summary>
        /// Binds sample data to the GridView.
        /// Replace with DB logic in production.
        /// </summary>
        private void BindGrid()
        {
            string connStr = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT RoleId, RoleName, RoleDescription, CreatedBy FROM sSecurity.tRole", con))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        gvRoles.DataSource = dt;
                        gvRoles.DataBind();
                    }
                }
            }
        }
        protected void gvRoles_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewRole")
            {
                string roleId = e.CommandArgument.ToString();

                // Example: Redirect to a Role details page
                Response.Redirect("AddRole.aspx?RoleId=" + roleId);
            }
        }


        /// <summary>
        /// Filter logic for Search button.
        /// Currently just reloads grid.
        /// </summary>

        protected void Add_Click(object sender, EventArgs e)
        {
            // TODO: Add filter logic here (SQL WHERE, LINQ, etc.)
            Response.Redirect("AddRole.aspx");
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // TODO: Add filter logic here (SQL WHERE, LINQ, etc.)
            BindGrid();
            gvRoles.Visible = true;   // Show Grid
            imgDefault.Visible = false; // Hide GIF
        }

        /// <summary>
        /// Clears all search fields and reloads grid.
        /// </summary>
        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtRole.Text = "";
            txtRemark.Text = "";
            imgDefault.Visible = true; // Hide GIF
            gvRoles.Visible = false;   // HIde Grid
        }
        protected void btnPrint_Click(object sender, EventArgs e)
        {
            string url = ResolveUrl("~/Pages/UserManagement/RoleReport.aspx");
            string script = $"window.open('{url}', 'RoleReport', 'width=900,height=700,scrollbars=1,resizable=1');";
            ClientScript.RegisterStartupScript(this.GetType(), "OpenReport", script, true);
        }
    }
}
