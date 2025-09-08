using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApplication3.Models
{
    public class User
    {
        public int userid { get; set; }
        public string username { get; set; }
        public string passwordHash { get; set; }  // store hash, not plain text
        public string fullname { get; set; }
        public string email { get; set; }
        public string mobileno { get; set; }
        public int? roleId { get; set; }
        public DateTime? createddate { get; set; }
        public DateTime? updateddate { get; set; }
    }
}