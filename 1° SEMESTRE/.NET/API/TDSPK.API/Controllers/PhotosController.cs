using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Net;
using TDSPK.API.DTO;
using TDSPK.API.Infrastructure.Contexts;
using TDSPK.API.Infrastructure.Persistence;

namespace TDSPK.API.Controllers
{
    [Route("api/[controller]")]
    [Tags("Fotos")]
    [ApiController]
    public class PhotosController : ControllerBase
    {
        private readonly PhotosContext _context;

        public PhotosController(PhotosContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Retorna uma lista de fotos
        /// </summary>
        /// <remarks>
        /// Exemplo de Solicitação:
        /// 
        ///     GET api/photos
        /// 
        /// </remarks>
        /// <response code = "200"> Retorna uma lista de fotos</response>
        /// <response code = "500"> Erro interno do servidor</response>
        /// <response code = "503"> Serviço indisponivel</response>
        [HttpGet]
        [ProducesResponseType((int)HttpStatusCode.OK)]
        [ProducesResponseType((int)HttpStatusCode.ServiceUnavailable)]
        [ProducesResponseType((int)HttpStatusCode.InternalServerError)]
        

        public async Task<ActionResult<IEnumerable<Photo>>> GetPhotos()
        {
            return await _context.Photos.ToListAsync();
        }

        // GET: api/Photos/5
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public async Task<ActionResult<Photo>> GetPhoto(Guid id)
        {
            var photo = await _context.Photos.FindAsync(id);

            if (photo == null)
            {
                return NotFound();
            }

            return photo;
        }

        // POST: api/Photos
        // To protect from overposting attacks, see https://go.microsoft.com/fwlink/?linkid=2123754
        /// <summary>
        /// 
        /// </summary>
        /// <param name="photo"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<ActionResult<Photo>> PostPhoto(PhotoRequest photoRequest)
        {

            var user = _context.User.SingleOrDefault(x => x.Id == photoRequest.UserId);

            if (user is null) throw new Exception("Usuario nao existe");


            var photo = new Photo(photoRequest.Url, user.Id);

            _context.Photos.Add(photo);
            await _context.SaveChangesAsync();

            return CreatedAtAction("GetPhoto", new { id = photo.Id }, photo);
        }

        // DELETE: api/Photos/5
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeletePhoto(Guid id)
        {
            var photo = await _context.Photos.FindAsync(id);
            if (photo == null)
            {
                return NotFound();
            }

            _context.Photos.Remove(photo);
            await _context.SaveChangesAsync();

            return NoContent();
        }
    }
}
