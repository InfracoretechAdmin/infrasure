using System.Collections.Generic;
using System.Net;
using System.Web.Http;
using WebApplication3.Data;
using WebApplication3.Models;

namespace WebApplication3.Controllers
{
    public class UsersController : ApiController
    {
        private readonly UsersRepository _repo = new UsersRepository();

        // GET api/users
        [HttpGet]
        public IEnumerable<User> Get()
        {
            return _repo.GetAll();
        }

        // GET api/users/5
        [HttpGet]
        public IHttpActionResult Get(int id)
        {
            var user = _repo.Get(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        // POST api/users
        [HttpPost]
        public IHttpActionResult Post([FromBody] User user)
        {
            if (user == null) return BadRequest("User data is required.");
            var created = _repo.Create(user);
            if (created == null) return BadRequest("Unable to create user.");
            return Ok(created);
        }

        // PUT api/users/5
        [HttpPut]
        public IHttpActionResult Put(int id, [FromBody] User user)
        {
            if (user == null) return BadRequest("User data is required.");
            var ok = _repo.Update(id, user);
            if (!ok) return StatusCode(HttpStatusCode.InternalServerError);
            return Ok(_repo.Get(id));
        }

        // DELETE api/users/5
        [HttpDelete]
        public IHttpActionResult Delete(int id)
        {
            var ok = _repo.Delete(id);
            if (!ok) return NotFound();
            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}