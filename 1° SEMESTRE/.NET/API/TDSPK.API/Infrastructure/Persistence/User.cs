using TDSPK.API.Domain;
using TDSPK.API.Domain.Enums;

namespace TDSPK.API.Infrastructure.Persistence
{
    public class User : Audit
    {
        public Guid Id { get; private set; }
        public string Name { get; private set; }

        //1..N
        private readonly List<Photo> _photos = new();

        public IReadOnlyCollection<Photo> Photos => _photos.AsReadOnly();

        public User(string name)
        {
            Id = Guid.NewGuid();
            Name = name ?? throw new Exception("Nome nao pode ser vazio") ;
            Status = StatusType.Active;
        }

        public void AddPhoto(string url)
        {
            var photo = Photo.Create(url, Id);

            _photos.Add(photo);
        }
    }
}
