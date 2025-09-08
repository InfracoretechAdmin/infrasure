using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using WebApplication3.Models;

namespace WebApplication3.Data
{
    public class UsersRepository
    {
        private readonly string _connStr;

        public UsersRepository()
        {
            _connStr = ConfigurationManager.ConnectionStrings["connect"].ConnectionString;
        }

        public IEnumerable<User> GetAll()
        {
            var list = new List<User>();

            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(@"SELECT userid, username, fullname, email, mobileno, roleId, createddate, updateddate FROM sSecurity.tUsers", conn))
            {
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    while (rdr.Read())
                    {
                        list.Add(MapReader(rdr));
                    }
                }
            }

            return list;
        }

        public User Get(int id)
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(@"SELECT userid, username, fullname, email, mobileno, roleId, createddate, updateddate 
                                             FROM sSecurity.tUsers WHERE userid = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                using (var rdr = cmd.ExecuteReader())
                {
                    if (rdr.Read()) return MapReader(rdr);
                }
            }

            return null;
        }

        public User Create(User user)
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(@"
                INSERT INTO sSecurity.tUsers (username, passwordHash, fullname, email, mobileno, roleId)
                VALUES (@username, @passwordHash, @fullname, @email, @mobileno, @roleId);
                SELECT SCOPE_IDENTITY();", conn))
            {
                cmd.Parameters.AddWithValue("@username", (object)user.username ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@passwordHash", (object)user.passwordHash ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@fullname", (object)user.fullname ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@email", (object)user.email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@mobileno", (object)user.mobileno ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@roleId", (object)user.roleId ?? DBNull.Value);

                conn.Open();
                var obj = cmd.ExecuteScalar();
                if (obj != null)
                {
                    user.userid = Convert.ToInt32(obj);
                    // Optionally reload to get createddate/updateddate
                    return Get(user.userid);
                }
            }

            return null;
        }

        public bool Update(int id, User user)
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand(@"
                UPDATE sSecurity.tUsers
                SET username=@username,
                    fullname=@fullname,
                    email=@email,
                    mobileno=@mobileno,
                    roleId=@roleId,
                    updateddate = GETDATE()
                WHERE userid = @id", conn))
            {
                cmd.Parameters.AddWithValue("@username", (object)user.username ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@fullname", (object)user.fullname ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@email", (object)user.email ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@mobileno", (object)user.mobileno ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@roleId", (object)user.roleId ?? DBNull.Value);
                cmd.Parameters.AddWithValue("@id", id);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                return rows > 0;
            }
        }

        public bool Delete(int id)
        {
            using (var conn = new SqlConnection(_connStr))
            using (var cmd = new SqlCommand("DELETE FROM sSecurity.tUsers WHERE userid = @id", conn))
            {
                cmd.Parameters.AddWithValue("@id", id);
                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                return rows > 0;
            }
        }

        private User MapReader(SqlDataReader rdr)
        {
            return new User
            {
                userid = rdr["userid"] != DBNull.Value ? Convert.ToInt32(rdr["userid"]) : 0,
                username = rdr["username"] as string,
                fullname = rdr["fullname"] as string,
                email = rdr["email"] as string,
                mobileno = rdr["mobileno"] as string,
                roleId = rdr["roleId"] != DBNull.Value ? (int?)Convert.ToInt32(rdr["roleId"]) : null,
                createddate = rdr["createddate"] != DBNull.Value ? (DateTime?)Convert.ToDateTime(rdr["createddate"]) : null,
                updateddate = rdr["updateddate"] != DBNull.Value ? (DateTime?)Convert.ToDateTime(rdr["updateddate"]) : null
            };
        }
    }
}
