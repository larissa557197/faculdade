using Microsoft.EntityFrameworkCore;
using TDSPK.API.Infrastructure.Mappings;
using TDSPK.API.Infrastructure.Persistence;

namespace TDSPK.API.Infrastructure.Contexts
{
    public class PhotosContext(DbContextOptions<PhotosContext> options) : DbContext(options)
    {
        public DbSet<Photo> Photos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.ApplyConfiguration(new PhotoMapping());
        }
        public DbSet<TDSPK.API.Infrastructure.Persistence.User> User { get; set; } = default!;
    }
}
