using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace WebApplication3.Pages.UserManagement
{
    public partial class AddRole : System.Web.UI.Page
    {
        private string connString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                // No active session → redirect to login
                Response.Redirect("~/Login.aspx?returnUrl=" + Server.UrlEncode(Request.RawUrl));
                return;
            }

            connString = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;

            if (!IsPostBack)
            {
                // Check if RoleId is passed in query string
                if (Request.QueryString["RoleId"] != null)
                {
                    int roleId;
                    if (int.TryParse(Request.QueryString["RoleId"], out roleId))
                    {
                        LoadRoleDetails(roleId);

                        // Switch button to Update mode
                        BtnSave.Text = "Update";
                    }
                }
                else
                {
                    // New record case → disable Edit/Delete
                    BtnEdit.Enabled = false;
                    BtnDelete.Enabled = false;
                }
            }
        }

        /// <summary>
        /// Loads role details into form fields based on RoleId.
        /// </summary>
        private void LoadRoleDetails(int roleId)
        {
            using (SqlConnection con = new SqlConnection(connString))
            using (SqlCommand cmd = new SqlCommand("SELECT RoleId, RoleName, RoleDescription FROM sSecurity.tRole WHERE RoleId = @RoleId", con))
            {
                cmd.Parameters.AddWithValue("@RoleId", roleId);
                con.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    // Store RoleId in HiddenField
                    txtRole.Value = reader["RoleId"].ToString();
                    rolename.Text = reader["RoleName"].ToString();
                    roledescription.Text = reader["RoleDescription"].ToString();
                }

                BtnSave.Text = "Update";
                BtnSave.Enabled = false;
                BtnEdit.Enabled = true;
                BtnDelete.Enabled = true;
                rolename.Enabled = false;
                roledescription.Enabled = false;
            }
        }

        protected void BtnSave_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(rolename.Text))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "toastr_message",
                    "toastr.error('Role Name is required.');", true);
                return;
            }

            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();
                SqlCommand cmd;

                if (BtnSave.Text == "Save") // INSERT
                {
                    cmd = new SqlCommand("sSecurity.pAddRole", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RoleName", rolename.Text.Trim());
                    cmd.Parameters.AddWithValue("@RoleDescription", roledescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@CreatedBy", Session["Username"].ToString());

                    object newId = cmd.ExecuteScalar();
                    txtRole.Value = newId?.ToString(); // Save new ID in hidden field

                    ClientScript.RegisterStartupScript(GetType(), "toastr_message",
                        "toastr.success('Role added successfully.');", true);
                }
                else if (BtnSave.Text == "Update") // UPDATE
                {
                    cmd = new SqlCommand("sSecurity.pUpdateRole", con);
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RoleId", Convert.ToInt32(txtRole.Value));
                    cmd.Parameters.AddWithValue("@RoleName", rolename.Text.Trim());
                    cmd.Parameters.AddWithValue("@RoleDescription", roledescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@UpdatedBy", Session["Username"].ToString());

                    cmd.ExecuteNonQuery();

                    ClientScript.RegisterStartupScript(GetType(), "toastr_message",
                        "toastr.success('Role updated successfully.');", true);
                }
            }

            // UI adjustments after save
            BtnSave.Enabled = false;
            BtnEdit.Enabled = true;
            BtnDelete.Enabled = true;
            rolename.Enabled = false;
            roledescription.Enabled = false;
        }

        protected void BtnEdit_Click(object sender, EventArgs e)
        {
            BtnSave.Text = "Update";
            BtnSave.Enabled = true;
            BtnEdit.Enabled = false;
            BtnDelete.Enabled = false;
            rolename.Enabled = true;
            roledescription.Enabled = true;
        }

        protected void BtnClear_Click(object sender, EventArgs e)
        {
            Clear();
        }

        protected void BtnDelete_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtRole.Value))
            {
                using (SqlConnection con = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("sSecurity.pDeleteRole", con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@RoleId", Convert.ToInt32(txtRole.Value));
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClientScript.RegisterStartupScript(this.GetType(), "toastr_message",
                    "toastr.success('Role deleted successfully.');", true);

                Clear();
            }
        }

        private void Clear()
        {
            // Reset text fields
            txtRole.Value = string.Empty;
            rolename.Text = string.Empty;
            roledescription.Text = string.Empty;

            // Reset buttons
            BtnDelete.Enabled = false;
            BtnEdit.Enabled = false;
            BtnSave.Enabled = true;
            BtnSave.Text = "Save";

            // Enable fields for new entry
            rolename.Enabled = true;
            roledescription.Enabled = true;
        }

        protected void BtnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("role.aspx");
        }
    }
}
