using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using TDSPK.API.Infrastructure.Persistence;

namespace TDSPK.API.Infrastructure.Mappings
{
    public class PhotoMapping : IEntityTypeConfiguration<Photo>
    {
        public void Configure(EntityTypeBuilder<Photo> builder)
        {
            builder
                .ToTable("Photos");

            builder
                .HasKey("Id");

            builder
                .Property(photo => photo.Url)
                .HasMaxLength(200)
                .IsRequired();

            builder
                .Property(photo => photo.Date)
                .IsRequired();
        }
    }
}
