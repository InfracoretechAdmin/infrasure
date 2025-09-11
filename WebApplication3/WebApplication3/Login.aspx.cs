using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication3
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            Response.Cache.SetNoStore();


            // Bind dropdown only on first load (NOT on postback).
            if (!IsPostBack)
            {
                BindBuildingDropdown();

                if (Session["UserId"] != null)
                    Response.Redirect("~/Pages/Dashboard.aspx");
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["connect"].ToString();

            int userId = 0;
            string username = String.Empty;
            string role = String.Empty;
            int userBuildingId = 0;

            using (SqlConnection con = new SqlConnection(connString))
            {
                con.Open();

                string query = @"SELECT UserId, Username, Roleid, BuildingID 
                                 FROM sSecurity.tUsers 
                                 WHERE Username=@uname AND Password=@pwd";

                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@uname", UserName1.Text.Trim());
                    cmd.Parameters.AddWithValue("@pwd", Password1.Text.Trim());

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (!dr.HasRows)
                        {
                            string script = "toastr.error('Invalid Username or Password', 'Login Failed');";
                            ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                            return;
                        }

                        dr.Read();
                        // safe reads with DBNull check
                        if (dr["UserId"] != DBNull.Value) userId = Convert.ToInt32(dr["UserId"]);
                        if (dr["Username"] != DBNull.Value) username = dr["Username"].ToString();
                        if (dr["Roleid"] != DBNull.Value) role = dr["Roleid"].ToString();
                        if (dr["BuildingID"] != DBNull.Value) userBuildingId = Convert.ToInt32(dr["BuildingID"]);
                    } // reader closed here
                }

                // parse selected building from dropdown
                int selectedBuildingId = 0;
                if (!int.TryParse(ddlSearch.SelectedValue, out selectedBuildingId))
                {
                    selectedBuildingId = 0; // default if parse fails or SelectedValue is empty
                }

                // Superadmin bypasses, others must match their assigned building
                if (userId != 1)
                {
                    if (selectedBuildingId == 0)
                    {
                        string script = "toastr.warning('Please select a building.', 'Access Denied');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                        return; // STOP if no building chosen
                    }

                    if (selectedBuildingId != userBuildingId)
                    {
                        string script = "toastr.warning('You are not enrolled with the selected building. Contact building admin.', 'Access Denied');";
                        ScriptManager.RegisterStartupScript(this, GetType(), "toastr", script, true);
                        return;
                    }
                }

                // Save to Session
                Session["UserId"] = userId;
                Session["Username"] = username;
                Session["Role"] = role;
                Session["BuildingId"] = selectedBuildingId;

                // Save login history (reader already closed, connection still open)
                SaveLoginHistory(userId, username, con);

                // Redirect
                string returnUrl = Request.QueryString["returnUrl"];
                if (!string.IsNullOrEmpty(returnUrl))
                    Response.Redirect(returnUrl);
                else
                    Response.Redirect("~/Pages/Dashboard.aspx");
            }
        }

        private void SaveLoginHistory(int userId, string username, SqlConnection con)
        {
            string historyQuery = @"INSERT INTO sSecurity.tLoginHistory 
                                    (UserId, Username, AttemptTime, IpAddress, IsSuccessful) 
                                    VALUES (@uid, @uname, @ltime, @ip, @isSuccess)";

            using (SqlCommand historyCmd = new SqlCommand(historyQuery, con))
            {
                historyCmd.Parameters.AddWithValue("@uid", userId);
                historyCmd.Parameters.AddWithValue("@uname", username);
                historyCmd.Parameters.AddWithValue("@ltime", DateTime.Now);
                historyCmd.Parameters.AddWithValue("@ip", HttpContext.Current.Request.UserHostAddress);
                historyCmd.Parameters.AddWithValue("@isSuccess", true);
                historyCmd.ExecuteNonQuery();
            }
        }

        private void BindBuildingDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT Id, BuildingName 
                                 FROM sBuilding.tList
                                 WHERE ActiveFlag = 'Y'
                                 ORDER BY BuildingName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        ddlSearch.DataSource = dr;
                        ddlSearch.DataTextField = "BuildingName";
                        ddlSearch.DataValueField = "Id";
                        ddlSearch.DataBind();
                    }
                }
            }

            // use "0" as the default value (easier to parse than empty string)
            ddlSearch.Items.Insert(0, new ListItem("-- Select Building --", "0"));
        }
        private void Clear()
        {
            // Reset text fields
            UserName1.Text = string.Empty;
            Password1.Text = string.Empty;
            Otp.Text = string.Empty;
        }
    }
}
